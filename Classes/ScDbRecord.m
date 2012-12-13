//
//  ScDbRecord.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/11/24.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScDbRecord.h"

@implementation ScDbRecord

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self != nil)
    {
        _values = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    }
    return self;
}

- (NSString *)get:(NSString *)name
{
    id value = [_values objectForKey:name];
    
    if([value respondsToSelector:@selector(stringValue)])
    {
        return [value stringValue];
    }
    
    return value;
}

- (void)set:(NSString *)value forKey:(NSString *)key
{
    [_values setObject:value forKey:key];
}

- (NSString *)description
{
    return [_values description];
}

@end
