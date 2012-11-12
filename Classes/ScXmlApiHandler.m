//
//  FcApiHander.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/11/09.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScXmlApiHandler.h"



#pragma mark - FcApiHandler
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


#pragma mark - ScHttpDelegate
- (void)connection:(NSURLConnection *)connection didFinishLoading:(id)response
{
    DDXMLElement *status = [[response elementsForName:@"status"] objectAtIndex:0];
    NSString *responseCode = [[[status elementsForName:@"code"]objectAtIndex:0] stringValue];
    
    if(![responseCode isEqualToString:@"1"])
    {
        [self didFailWithCode:responseCode message:[[[status elementsForName:@"message"]objectAtIndex:0] stringValue]];
    }
    else
    {
        DDXMLElement *body = [[response elementsForName:_bodyTag] objectAtIndex:0];
        NSInteger max = [[[body attributeForName:@"max"]stringValue]intValue];
        max = max == 0 ? 1 : max;
        NSInteger next = [[[body attributeForName:@"next"]stringValue]intValue];
        NSInteger current = next == 0 ? max : next - 1;
        _pagePath = [[ScPagePath alloc]initWithIndex:current length:max];
        
        [self.delegate handler:self didLoadWithPagePath:_pagePath];
        
        [self performSelectorInBackground:@selector(handleData:) withObject:@{@"body":body, @"pagePath":_pagePath}];
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

#pragma mark - abstract

-(void)handleXmlElement:(DDXMLElement *)body pagePath:(ScPagePath *)pagePath
{
    NSAssert(NO, @"This is an abstract method and should be overridden");
}


#pragma mark - pivate
- (void)didFailWithCode:(NSString *)code message:(NSString *)message;
{
    [self.delegate handler:self didFailWithCode:code message:message];
}


-(void)handleData:(NSDictionary *)data;
{
    [self handleXmlElement:[data objectForKey:@"body"] pagePath:[data objectForKey:@"pagePath"]];
    [self.delegate handlerDidFinish:self];
}




@end
