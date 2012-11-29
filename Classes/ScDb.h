//
//  ScDb.h
//  sincere.ios.lib
//
//  Created by Masamoto Miyata on 2012/11/20.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "ScLog.h"
#import "ScDbResultSet.h"
#import "NSData+ScDataShortDescription.h"

@class ScDbResultSet;
@interface ScDb : NSObject
{
    @private
    NSString *_templatePath;
    NSString *_databasePath;
    FMDatabase *_db;
}


- (id)initWithPath:(NSString *)path fromTemplatePath:(NSString *)templatePath;
- (void)close;
- (void)drop;

- (BOOL)exists:(NSString*)sql withArgumentsInArray:(NSArray *)arguments;

- (void)executeQuery:(NSString*)sql resultSet:(ScDbResultSet *)resultSet;
- (void)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)arguments resultSet:(ScDbResultSet *)resultSet;

- (void)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments;

- (void)rollback;
- (void)commit;
- (void)beginTransaction;
@end
