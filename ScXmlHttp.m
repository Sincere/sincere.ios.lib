//
//  FcnApi.m
//  fotocase_note
//
//  Created by Miyata Keizo on 2012/08/18.
//  Copyright (c) 2012年 Miyata Keizo. All rights reserved.
//

#import "ScXmlHttp.h"



@implementation ScXmlHttp

- (id) initWithUri: (NSString *) uri delegate: (id<ScXmlHttpDelegate>) delegate
{
    self = [super init];
    if (self != nil)
    {
        _receivedData = [[NSMutableData alloc] init];
        _request = [NSURLRequest requestWithURL:[NSURL URLWithString:uri]];
        _delegate = delegate;
    }
    
    return self;
}

- (void) load
{
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
    if (theConnection) {
        NSLog(@"start loading");
        
    }
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

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(_progressView)
    {
        [_progressView setProgress:1.0];
    }
        
    NSString *xmlString = [[NSString alloc]initWithData:_receivedData encoding:NSUTF8StringEncoding];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil];
    [_delegate xmlDidFinishLoading: [doc rootElement]];
}

- (void) setProgressBar: (UIProgressView *) progress
{
    _progressView = progress;
}

@end
