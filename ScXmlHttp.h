//
//  FcnApi.h
//  fotocase_note
//
//  Created by Miyata Keizo on 2012/08/18.
//  Copyright (c) 2012年 Miyata Keizo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXML.h"

@protocol ScXmlHttpDelegate

- (void)xmlDidFinishLoading:(DDXMLElement *) rootElement;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

@end

@interface ScXmlHttp : NSObject <NSURLConnectionDelegate>
{
    @private
    id<ScXmlHttpDelegate> _delegate;
    NSURLRequest *_request;
    NSMutableData *_receivedData;
    UIProgressView *_progressView;
    float _totalBytes;
    float _loadedBytes;
    //DDXMLElement *_rootElement;
}

- (id) initWithUri: (NSString *) uri delegate: (id<ScXmlHttpDelegate>) delegate;
- (void) load;
- (void) setProgressBar: (UIProgressView *) progress;

@end
