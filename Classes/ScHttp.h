//
//  ScHttp.h
//  fotocase_note
//
//  Created by Masamoto Miyata on 2012/09/22.
//  Copyright (c) 2012年 Miyata Keizo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURL+ScURLUtil.h"
#import "NSString+ScStringUtil.h"
#import "ScLog.h"

@class ScHttp;
@protocol ScHttpDelegate

- (void)http:(ScHttp *)http connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)http:(ScHttp *)http connection:(NSURLConnection *)connection didFinishLoading:(id)response;
- (void)http:(ScHttp *)http connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)http:(ScHttp *)http connection:(NSURLConnection *)connection progress:(double)progress;

@optional
- (void)startAutoLoadWait;
- (void)endAutoLoadWait;

@end

@interface ScHttp : NSObject<NSURLConnectionDelegate>
{
    @private
    float _totalBytes;
    float _loadedBytes;
    NSMutableDictionary *_params;
    NSURLConnection *_currentConnection;
    NSString *_baseUri;
    NSString *_httpMethod;
    NSString *_prevQuery;
    NSTimeInterval _autoloadSec;
    BOOL _autoloadWaiting;
    NSTimer *_timeoutChecker;
    NSInteger _timeoutCheckCount;
    
    
    @protected
    NSMutableData *_receivedData;
    UIProgressView *_progressView;
    id<ScHttpDelegate> _delegate;
    
}

@property (nonatomic, assign) NSInteger timeout;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, readonly) NSString *uri;
- (id) initWithUri: (NSString *) uri;
- (id) initWithUri: (NSString *) uri delegate: (id<ScHttpDelegate>) delegate;
- (void) load;
- (void) setProgressBar: (UIProgressView *) progress;
- (void) setParam: (id)params forKey: (NSString *)key;
- (id) paramForKey:(NSString *)key;
- (void) removeParam:(NSString *)key;
- (void) setHttpMethod: (NSString *) method;
- (void) enableAutoLoad: (NSTimeInterval) sec;
- (NSArray *) arrayForKey: (NSString *) key;
- (NSString *) stringForKey: (NSString *) key;
@end
