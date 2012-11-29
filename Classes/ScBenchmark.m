//
//  ScBenchmark.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/11/28.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScBenchmark.h"

@implementation ScBenchmark

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _statTime = [NSDate date];
    }
    return self;
}

- (NSString *)formatedSec;
{
    NSDate *now = [NSDate date];
    return [NSString stringWithFormat:@"%1.5fsec", [now timeIntervalSinceDate:_statTime]];
}

- (void)logSec
{
    ScLog(@"%@", [self formatedSec]);
}

@end
