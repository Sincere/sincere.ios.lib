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

- (BOOL)isEqualAsQueryString:(NSString *)queryString
{
    NSArray *selfArray = [self componentsSeparatedByString: @"&"];
    NSArray *targetArray = [queryString componentsSeparatedByString:@"&"];
    
    if([selfArray count] != [targetArray count])
    {
        return NO;
    }
    
    selfArray = [selfArray sortedArrayUsingSelector:@selector(compare:)];
    targetArray = [targetArray sortedArrayUsingSelector:@selector(compare:)];
    
    for (int i=0; i < [selfArray count]; i++)
    {
        if(![[selfArray objectAtIndex:i] isEqual:[targetArray objectAtIndex:i]])
        {
            return NO;
        }
    }
    
    return YES;
}
    
@end