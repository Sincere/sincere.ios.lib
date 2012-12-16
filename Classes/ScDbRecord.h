//
//  ScDbRecord.h
//  fotocase
//
//  Created by Masamoto Miyata on 2012/11/24.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScLog.h"

@interface ScDbRecord : NSObject<NSCoding>
{
    NSMutableDictionary *_values;
}

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSString *)get:(NSString *)name;
- (void)set:(NSString *)value forKey:(NSString *)key;
//- (BOOL)is:(NSString *)key;
//- (void)setBool:(BOOL)value forKey:(NSString *)key;

@end
