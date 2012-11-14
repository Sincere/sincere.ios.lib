//
//  ScHttp.m
//  fotocase_note
//
//  Created by Masamoto Miyata on 2012/09/22.
//  Copyright (c) 2012年 Miyata Keizo. All rights reserved.
//

#import "ScHttp.h"

@implementation ScHttp

- (id) initWithUri: (NSString *) uri;
{
    self = [super init];
    if (self != nil)
    {
        _autoloadWaiting = NO;
        _receivedData = [[NSMutableData alloc] init];
        _baseUri = uri;
        _params = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (id) initWithUri: (NSString *) uri delegate: (id<ScHttpDelegate>) delegate
{
    self = [self initWithUri:uri];
    if (self != nil)
    {
        self.delegate = delegate;
    }
    
    return self;
}

- (void) enableAutoLoad: (NSTimeInterval) sec
{
    _autoloadSec = sec;
}

- (void) setHttpMethod: (NSString *) method
{
    _httpMethod = [method uppercaseString];
}

- (void) load
{
    @synchronized(self)
    {
        if(_autoloadWaiting)
        {
            if([(NSObject *)self.delegate respondsToSelector:@selector(endAutoLoadWait)])
            {
                [self.delegate endAutoLoadWait];
            }
            
            _autoloadWaiting = NO;
        }
        
        //クエリに変更がなければアクセスの必要なし
        //クエリの並び替えは下のisEqualAsQueryStringでやってる・・微妙かも
        NSString *query = [self buildParameters];
        if(_prevQuery != nil)
        {
            if ([query isEqualAsQueryString:_prevQuery])
            {
                _prevQuery = query;
                return;
            }
        }
        
        _prevQuery = query;
        
        //リセット
        [_currentConnection cancel];
        
        //リクエスト初期化
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: _baseUri]];
        if(_httpMethod)
        {
            [request setHTTPMethod:_httpMethod];
        }
        
        if([request.HTTPMethod isEqualToString:@"POST"])
        {
            NSData *httpBody = [query dataUsingEncoding:NSUTF8StringEncoding];
            
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
            [request setValue:[NSString stringWithFormat:@"%d", [httpBody length]] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody: httpBody];
        }
        else
        {
            request.URL = [request.URL URLByAppendingQueryString:query];
        }
        
        //リクエストスタート
        _currentConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (!_currentConnection)
        {
            [NSException raise:@"ScFailRequestException" format:@"Fail to request for %@.", request];
        }
    }
}

- (NSString*)buildParameters
{
    NSMutableString *strParams = [NSMutableString string];
    
    NSString *key;
    for ( key in _params ) {
        id value = [_params objectForKey:key];
        if([value isKindOfClass:[NSArray class]])
        {
            for (id val in value)
            {
                [strParams appendFormat:@"%@[]=%@&", key, [val stringUrlEncoded]];
            }
        }
        else if(value)
        {
            [strParams appendFormat:@"%@=%@&", key, [value stringUrlEncoded]];
        }
    }
    
    //最後の&を消す
    if ( [strParams length] > 0 )
    {
        [strParams deleteCharactersInRange:NSMakeRange([strParams length]-1, 1)];
    }
    
    return strParams;
}

- (id) paramForKey:(NSString *)key
{
    return [_params objectForKey:key];
}



- (void) setProgressBar: (UIProgressView *) progress
{
    _progressView = progress;
}

- (void) setParam: (id)params forKey: (NSString *)key
{
    bool change = NO;
    id cParams = [params copy];
    
    id currentValue = [_params objectForKey: key];
    
    if(currentValue == nil)
    {
        if(cParams != nil && ![cParams isEqual:@""])
        {
            change = YES;
        }
    }
    else if([currentValue isKindOfClass:[NSArray class]])
    {
        if(![cParams isKindOfClass:[NSArray class]])
        {
            change = YES;
        }
        else if([currentValue count] != [cParams count])
        {
            change = YES;
        }
        else
        {
            currentValue = [currentValue sortedArrayUsingSelector:@selector(compare:)];
            cParams = [cParams sortedArrayUsingSelector:@selector(compare:)];
            for (int i = 0; i < [currentValue count]; i++)
            {
                if(![[currentValue objectAtIndex:i] isEqual:[cParams objectAtIndex:i]])
                {
                    change = YES;
                    break;
                }
            }
        }
    }
    else
    {
        change = ![currentValue isEqual:cParams];
    }
    
    if(change)
    {
        if(cParams != nil)
        {
            [_params setObject:cParams forKey:key];
        }
        else
        {
            [_params removeObjectForKey:key];
        }
        
        [self onChangeParameterFrom:currentValue to: cParams on: key];
    }
}

- (void) removeParam:(NSString *)key
{
    id currentValue = [_params objectForKey:key];
    if(currentValue != nil)
    {
        [_params removeObjectForKey:key];
        [self onChangeParameterFrom:currentValue to: nil on: key];
    }
}

- (NSArray *) arrayForKey: (NSString *) key
{
    id value = [_params objectForKey:key];
    if([value isKindOfClass:[NSArray class]])
    {
        return (NSArray *)value;
    }
    
    NSArray *array = [[NSArray alloc] initWithObjects:value, nil];
    return array;
}

- (NSString *) stringForKey: (NSString *) key
{
    id value = [_params objectForKey:key];
    if([value isKindOfClass:[NSArray class]])
    {
        [NSException raise:@"ScHasMultipleValueException" format:@"[%@] has multiple values.", key];
    }
    
    return (NSString *) value;
}

- (void) onChangeParameterFrom:(id) currentValue to:(id) newValue on:(id) key
{
    if(_autoloadSec > 0)
    {
        if(_autoloadWaiting == NO)
        {
            if([(NSObject *)self.delegate respondsToSelector:@selector(startAutoLoadWait)])
            {
                [self.delegate startAutoLoadWait];
            }
            
            _autoloadWaiting = YES;
        }
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(load) object:nil];
        [self performSelector:@selector(load) withObject:nil afterDelay: _autoloadSec];
    }
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _totalBytes = [response expectedContentLength];
    _loadedBytes = 0.0;
    
    if(_progressView)
    {
        [_progressView setProgress:_loadedBytes];
    }
    
    [_receivedData setLength:_loadedBytes];
    [self.delegate http:self connection:connection didReceiveResponse:response];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(_progressView)
    {
        _loadedBytes += [data length];
        [_progressView setProgress:(_loadedBytes/_totalBytes)];
    }
    
    [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.delegate http:self connection:connection didFailWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(_progressView)
    {
        [_progressView setProgress:1.0];
    }
    
    [self.delegate http:self connection: connection didFinishLoading:_receivedData];
}

@end
