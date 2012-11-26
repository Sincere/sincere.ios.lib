//
//  NSData+ScDataShortDescription.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/11/26.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "NSData+ScDataShortDescription.h"

@implementation NSData (ScDataShortDescription)

- (NSString *)description
{
    NSUInteger length = self.length;
    
    if(length > 1000)
    {
        return [NSString stringWithFormat:@"#NSData %dKB(%d)", length / 1000, length];
    }
    else if(length > 1000 * 1000)
    {
        return [NSString stringWithFormat:@"#NSData %dMB(%d)", length / (1000 * 1000), length];
    }
    else
    {
        return [NSString stringWithFormat:@"#NSData %dB", [self length]];
    }
}

@end
