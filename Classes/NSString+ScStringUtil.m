//
//  NSString+ScStringUtil.m
//  fotocase_note
//
//  Created by Masamoto Miyata on 2012/09/25.
//  Copyright (c) 2012年 Miyata Keizo. All rights reserved.
//

#import "NSString+ScStringUtil.h"

@implementation NSString (ScStringUtil)

- (NSString*)stringUrlEncoded
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8 ));
}

@end
