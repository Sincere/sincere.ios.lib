//
//  ScDbTest.m
//  sincere.ios.lib
//
//  Created by Masamoto Miyata on 2012/11/20.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScDbTest.h"

@implementation TagRecordSet
@end

@implementation ScDbTest

-(void)testCreateDb
{
    //dbの作成とドロップ
    ScDb *db = [[ScDb alloc]initWithPath:@"test.db" fromTemplatePath:@"template.db"];
    
    GHAssertTrue([self fileExistsInDocDir:@"test.db"], @"test.db file in not exists");
    
    [db drop];
    
    GHAssertFalse([self fileExistsInDocDir:@"test.db"], @"You can't drop database test.db");
    
    //executeUpdate
    ScDb *db2 = [[ScDb alloc]initWithPath:@"test.db" fromTemplatePath:@"template.db"];
    [db2 beginTransaction];
    [db2 executeUpdate:@"INSERT OR REPLACE INTO tag (id, seq, parent_tag_id) VALUES (?, ?, ?)" withArgumentsInArray:@[@"1", @"2", @"3"]];
    [db2 commit];
    
    TagRecordSet *rs = [[TagRecordSet alloc]init];
    [db2 executeQuery:@"SELECT * FROM tag" resultSet:rs];
    while ([rs next])
    {
        GHAssertEqualStrings(@"1", [rs stringForColumn:@"id"], @"wrong id value.");
        GHAssertEqualStrings(@"2", [rs stringForColumn:@"seq"], @"wrong seq value.");
        GHAssertEqualStrings(@"3", [rs stringForColumn:@"parent_tag_id"], @"wrong parent_tag_id value.");
    }
    
    
    
    [db2 executeUpdate:@"INSERT OR REPLACE INTO tag (id, seq, parent_tag_id) VALUES (?, ?, ?)" withArgumentsInArray:@[@"2", @"3", @"4"]];
    TagRecordSet *rs2 = [[TagRecordSet alloc]init];
    [db2 executeQuery:@"SELECT * FROM tag ORDER BY seq" resultSet:rs2];
    NSArray *tagIds = [rs2 arrayOfStringForColumn:@"id"];
    GHAssertTrue(2 == tagIds.count, @"Not equals tag id count.");
    
    GHAssertThrowsSpecific([rs2 next], NSException, @"Did not throw exception.");
}

-(BOOL)fileExistsInDocDir:(NSString *)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0];
    
    NSString *fullPath = [documentsDir stringByAppendingPathComponent:path];
    return [fm fileExistsAtPath:fullPath];
    
}

@end
