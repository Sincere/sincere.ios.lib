//
//  FcnApi.h
//  fotocase_note
//
//  Created by Miyata Keizo on 2012/08/18.
//  Copyright (c) 2012年 Miyata Keizo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FcnApiDelegate

//- (void)willStartLoading;

@end

@interface ScXmlHttp : NSObject
{
    @private
    id<FcnApiDelegate> delegate;
    NSString *uri;
}

- (id) initWithUri: (NSString *) uri delegate: (id<FcnApiDelegate>) delegate;
- (void) load;

@end
