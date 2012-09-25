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

- (void) setHttpMethod: (NSString *) method
{
    _httpMethod = method;
}

- (void) load
{
    @synchronized(self)
    {
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
            NSData *httpBody = [[self _buildParameters] dataUsingEncoding:NSUTF8StringEncoding];
            
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
            [request setValue:[NSString stringWithFormat:@"%d", [httpBody length]] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody: httpBody];
        }
        else
        {
            request.URL = [request.URL URLByAppendingQueryString:[self _buildParameters]];
        }
        
        //リクエストスタート
        _currentConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (!_currentConnection)
        {
            [NSException raise:@"ScFailRequestException" format:@"Fail to request for %@.", request];
        }
    }
}

- (NSString*)_buildParameters
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

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    _totalBytes = [response expectedContentLength];
    _loadedBytes = 0.0;
    
    if(_progressView)
    {
        [_progressView setProgress:_loadedBytes];
    }
    
    [_receivedData setLength:_loadedBytes];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
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
    [self.delegate connection:connection didFailWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(_progressView)
    {
        [_progressView setProgress:1.0];
    }
    
    [self.delegate connection: connection didFinishLoading:_receivedData];
}

- (void) setProgressBar: (UIProgressView *) progress
{
    _progressView = progress;
}

- (void) setParam: (id)params forKey: (NSString *)key
{
    [_params setObject:params forKey:key];
}

- (NSArray *) arrayForKey: (NSString *) key
{
    id value = [_params objectForKey:key];
    if([value isKindOfClass:[NSArray class]])
    {
        return (NSArray *) value;
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

@end
