//
//  FcApiHander.h
//  fotocase
//
//  Created by Masamoto Miyata on 2012/11/09.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScHttpXml.h"
#import "ScLog.h"
#import "ScPagePath.h"


#pragma mark - FcApiHandlerDelegate
@class ScXmlApiHandler;
@protocol ScXmlApiHandlerDelegate

- (void)http:(ScHttp *)http handler:(ScXmlApiHandler *)handler didLoadWithPagePath:(ScPagePath *)pagePath;
- (void)http:(ScHttp *)http handlerDidFinish:(ScXmlApiHandler *)handler;
- (void)handler:(ScXmlApiHandler *)handler didFailWithCode:(NSString *)code message:(NSString *)message;
- (void)handler:(ScXmlApiHandler *)handler incrementProgress:(double)progress;
- (void)handlerWillStart:(ScXmlApiHandler *)handler;

@end

#pragma mark - ScXmlApiHandler

@interface ScXmlApiHandler : NSObject<ScHttpDelegate>
{
//    ScPagePath *_pagePath;
//    NSURLConnection *_connection;
}

@property(nonatomic, strong) id<ScXmlApiHandlerDelegate>delegate;
//@property(nonatomic, readonly) ScPagePath *pagePath;
//@property(nonatomic, readonly) NSURLConnection *connection;

-(NSError *)createErrorWithCode:(NSString*)code message:(NSString *)message;


#pragma mark - abstract and protected
-(NSError *)errorInXmlElement:(DDXMLElement *)rootElement http:(ScHttp *)http;
-(ScPagePath *)createPagePathWithXmlElement:(DDXMLElement *)rootElement http:(ScHttp *)http;
-(void)handleXmlElement:(DDXMLElement *)rootElement pagePath:(ScPagePath *)pagePath http:(ScHttp *)http;



@end