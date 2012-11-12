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

- (void)handler:(ScXmlApiHandler *)handler didLoadWithPagePath:(ScPagePath *)pagePath;
- (void)handlerDidFinish:(ScXmlApiHandler *)handler;
- (void)handler:(ScXmlApiHandler *)handler didFailWithCode:(NSString *)code message:(NSString *)message;
- (void)handler:(ScXmlApiHandler *)handler incrementProgress:(double)progress;

@end

#pragma mark - ScXmlApiHandler

@interface ScXmlApiHandler : NSObject<ScHttpDelegate>
{
    NSString *_bodyTag;
    ScPagePath *_pagePath;
    NSURLConnection *_connection;
}

@property(nonatomic, strong) id<ScXmlApiHandlerDelegate>delegate;
@property(nonatomic, readonly) ScPagePath *pagePath;
@property(nonatomic, readonly) NSURLConnection *connection;


#pragma mark - abstract
-(void)handleXmlElement:(DDXMLElement *)body pagePath:(ScPagePath *)pagePath;

@end