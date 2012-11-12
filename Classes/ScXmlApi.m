//
//  FcApi.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/11/07.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScXmlApi.h"



#pragma mark - FcApi

@implementation ScXmlApi

- (id)initWithUri:(NSString *)uri handlerName:(NSString *)handlerName
{
    self = [super init];
    
    if (self)
    {
        _uri = uri;
        _params = [[NSMutableDictionary alloc]init];
        _handlerName = handlerName;
        self.maxThreadCount = 1;
    }
    
    return self;
}

- (void)start
{
    _progress = 0;
    _endCount = 0;
    _runningThread = 0;
    [self loadStart:nil];
}

- (void) setParam: (id)params forKey: (NSString *)key
{
    [_params setObject:params forKey:key];
}

- (void)handlerDidFinish:(ScXmlApiHandler *)handler
{
    @synchronized(self)
    {
        ++_endCount;
        --_runningThread;
    }
    
    if(_endCount == handler.pagePath.length)
    {
        [self.delegate apiDidFinish:self];
    }
}
- (void)handler:(ScXmlApiHandler *)handler didFailWithCode:(NSString *)code message:(NSString *)message
{
    [self.delegate api:self didFailWithCode:code message:message];
}
- (void)handler:(ScXmlApiHandler *)handler incrementProgress:(double)progress
{
    @synchronized(self)
    {
        _progress += progress;
    }
    
    [self.delegate api:self progress:_progress];
}

- (void)handler:(ScXmlApiHandler *)handler didLoadWithPagePath:(ScPagePath *)pagePath
{
    ScLog(@"Page loaded[%@]", [handler.connection currentRequest]);
    if([pagePath hasMore])
    {
        while (_runningThread > self.maxThreadCount)
        {
            [NSThread sleepForTimeInterval:0.1];
        }
        
        [self loadStart:[NSString stringWithFormat:@"%d", pagePath.index + 1]];
    }
}

#pragma mark - private
- (void)loadStart:(NSString *)pid
{
    @synchronized(self)
    {
        ++_runningThread;
    }
    
    ScXmlApiHandler *handler = [[NSClassFromString(_handlerName) alloc] init];
    handler.delegate = self;
    ScHttpXml *request = [[ScHttpXml alloc]initWithUri:_uri delegate:handler];
    for (NSString *key in _params)
    {
        [request setParam:[_params objectForKey:key] forKey:key];
    }
    
    if(pid)
    {
        [request setParam:pid forKey:@"pid"];
    }
    
    ScLog(@"Page request %@", request);
    
    [request load];
}
@end
