//
//  ScDbRecord.h
//  fotocase
//
//  Created by Masamoto Miyata on 2012/11/24.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScLog.h"

@interface ScDbRecord : NSObject
{
    NSDictionary *_values;
}

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSString *)get:(NSString *)name;

@end
