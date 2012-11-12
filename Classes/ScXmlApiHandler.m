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

- (id)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

-(NSError *)createErrorWithCode:(NSString*)code message:(NSString *)message
{
    return [NSError errorWithDomain:@"ScXmlApiError" code:[code intValue] userInfo: @{NSLocalizedDescriptionKey: message}];
}


#pragma mark - ScHttpDelegate
- (void)connection:(NSURLConnection *)connection didFinishLoading:(id)response
{
    NSError *error = [self hasErrorInXmlElement:response];
    if(error)
    {
        //[self didFailWithCode:responseCode message:[[[status elementsForName:@"message"]objectAtIndex:0] stringValue]];
        [self didFailWithCode:[NSString stringWithFormat:@"%d", error.code] message:[error localizedDescription]];
    }
    else
    {
        _pagePath = [self createPagePathWithXmlElement:response];
        
        [self.delegate handler:self didLoadWithPagePath:_pagePath];
        
        [self performSelectorInBackground:@selector(handleData:) withObject:@{@"document":response, @"pagePath":_pagePath}];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self didFailWithCode:@"9999" message:[NSString stringWithFormat:@"%d : %@", [error code], [error localizedDescription]]];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _connection = connection;
}

#pragma mark - abstract - protected

-(void)handleXmlElement:(DDXMLDocument *)rootElement pagePath:(DDXMLElement *)pagePath
{
    NSAssert(NO, @"This is an abstract method and should be overridden");
}

-(ScPagePath *)createPagePathWithXmlElement:(DDXMLElement *)rootElement
{
    NSAssert(NO, @"This is an abstract method and should be overridden");
    return nil;
}

-(NSError *)hasErrorInXmlElement:(DDXMLElement *)rootElement
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
    [self handleXmlElement:[data objectForKey:@"document"] pagePath:[data objectForKey:@"pagePath"]];
    [self.delegate handlerDidFinish:self];
}




@end
