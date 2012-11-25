//
//  ScDbResultSet.m
//  sincere.ios.lib
//
//  Created by Masamoto Miyata on 2012/11/20.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScDbResultSet.h"

@implementation ScDbResultSet

- (void)setResultSet:(FMResultSet *)resultSet
{
    if(_resultSet && !_closed)
    {
        [self close];
    }
    
    _closed = NO;
    _resultSet = resultSet;
}

- (BOOL)next
{
    if(_closed)
    {
        [ScDb throwException:@"This set is already closed."];
    }
    
    return [_resultSet next];
}

- (void)close
{
    _closed = YES;
    [_resultSet close];
}

- (int)intForColumn:(NSString*)columnName
{
    return [_resultSet intForColumn:columnName];
}

- (NSString*)stringForColumn:(NSString*)columnName
{
    return [_resultSet stringForColumn:columnName];
}

- (NSDictionary*)resultDictionary
{
    return [_resultSet resultDictionary];
}

- (NSMutableArray*)arrayOfStringForColumn:(NSString*)columnName
{
    NSMutableArray *values = [[NSMutableArray alloc]init];
    while ([self next])
    {
        [values addObject:[self stringForColumn:columnName]];
    }
    
    [self close];
    
    return values;
}

@end
