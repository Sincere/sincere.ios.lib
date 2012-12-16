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

//- (BOOL)is:(NSString *)key
//{
//    return [(NSNumber *)[_values objectForKey:key] boolValue];
//}
//
//- (void)setBool:(BOOL)value forKey:(NSString *)key
//{
//    [_values setObject:[[NSNumber alloc]initWithBool:value] forKey:key];
//}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_values forKey:@"values"];
}

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        _values = [coder decodeObjectForKey:@"values"];
    }
    return self;
}

@end
