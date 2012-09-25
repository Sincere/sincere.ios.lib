//
//  ScHttp.h
//  fotocase_note
//
//  Created by Masamoto Miyata on 2012/09/22.
//  Copyright (c) 2012年 Miyata Keizo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURL+ScURLUtil.h"

@protocol ScHttpDelegate

- (void)connection:(NSURLConnection *)connection didFinishLoading:(id)response;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

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
    
    @protected
    NSMutableData *_receivedData;
    UIProgressView *_progressView;
    
}

@property (nonatomic, strong) id<ScHttpDelegate> delegate;
- (id) initWithUri: (NSString *) uri;
- (id) initWithUri: (NSString *) uri delegate: (id<ScHttpDelegate>) delegate;
- (void) load;
- (void) setProgressBar: (UIProgressView *) progress;
- (void) setParam: (id)params forKey: (NSString *)key;
- (void) setHttpMethod: (NSString *) method;
- (NSArray *) arrayForKey: (NSString *) key;
- (NSString *) stringForKey: (NSString *) key;
@end
