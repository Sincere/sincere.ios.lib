//
//  FcApiHander.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/11/09.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScXmlApiHandler.h"

@implementation ScXmlApiHandler

@synthesize pagePath = _pagePath;
@synthesize connection = _connection;

-(NSError *)createErrorWithCode:(NSString*)code message:(NSString *)message
{
    return [NSError errorWithDomain:@"ScXmlApiError" code:[code intValue] userInfo: @{NSLocalizedDescriptionKey: message}];
}

#pragma mark - ScHttpDelegate
- (void)http:(ScHttp *)http connection:(NSURLConnection *)connection didFinishLoading:(id)response
{
    NSError *error = [self errorInXmlElement:response http:http];
    if(error)
    {
        [self didFailWithCode:[NSString stringWithFormat:@"%d", error.code] message:[error localizedDescription]];
    }
    else
    {
        _pagePath = [self createPagePathWithXmlElement:response http:http];
        
        [self.delegate handler:self didLoadWithPagePath:_pagePath];
        [self performSelectorInBackground:@selector(handleData:) withObject:@{@"document":response, @"pagePath":_pagePath, @"http":http}];
    }
}

- (void)http:(ScHttp *)http connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self didFailWithCode:@"9999" message:[NSString stringWithFormat:@"%d : %@", [error code], [error localizedDescription]]];
}

- (void)http:(ScHttp *)http connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _connection = connection;
}

#pragma mark - abstract - protected

-(void)handleXmlElement:(DDXMLDocument *)rootElement pagePath:(DDXMLElement *)pagePath http:(ScHttp *)http 
{
    NSAssert(NO, @"This is an abstract method and should be overridden");
}

-(ScPagePath *)createPagePathWithXmlElement:(DDXMLElement *)rootElement http:(ScHttp *)http
{
    NSAssert(NO, @"This is an abstract method and should be overridden");
    return nil;
}

-(NSError *)errorInXmlElement:(DDXMLElement *)rootElement http:(ScHttp *)http
{
    return nil;
}

#pragma mark - pivate
- (void)didFailWithCode:(NSString *)code message:(NSString *)message;
{
    [self.delegate handler:self didFailWithCode:code message:message];
}

-(void)handleData:(NSDictionary *)data;
{
    [self handleXmlElement:[data objectForKey:@"document"] pagePath:[data objectForKey:@"pagePath"] http:[data objectForKey:@"http"]];
    [self.delegate handlerDidFinish:self];
}




@end
