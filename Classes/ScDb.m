//
//  ScDb.m
//  sincere.ios.lib
//
//  Created by Masamoto Miyata on 2012/11/20.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScDb.h"

@implementation ScDb

-(id)initWithPath:(NSString *)path fromTemplatePath:(NSString *)templatePath
{
    self = [super init];
	if (self != nil)
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        
        _databasePath = path;
        _templatePath = templatePath;
        BOOL __unused res;
        
        //dbが存在してなかったらここが呼ばれて、作成したDBをコピー
        if(![fm fileExistsAtPath:_databasePath])
        {
            //templateDb存在チェック
            res = [fm fileExistsAtPath:_templatePath];
            NSAssert1(res, @"TemplateDatabase %@ is not exists.", _templatePath);
            
            NSError *error;
            res = [fm copyItemAtPath:_templatePath toPath:_databasePath error:&error];
            NSAssert3(res, @"Fail to create database %@ from %@ by [%@]",  _databasePath, _templatePath, [error localizedDescription]);
            
            ScLog(@"Create database %@ from %@", _databasePath, _templatePath);
        }
        
        _db = [FMDatabase databaseWithPath:_databasePath];
        res = [_db open];
        NSAssert1(res, @"Fail to open database %@", _databasePath);
        
        ScLog(@"Open database %@", _databasePath);
	}
	return self;
}

-(void)close
{
    BOOL __unused res = [_db close];
    NSAssert1(res, @"You can't close connection %@", [self description]);
}

-(void)drop
{
    [self close];
    
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL __unused res = [fm removeItemAtPath:_databasePath error:&error];
    NSAssert2(res, @"Fail to drop database %@ by %@", _databasePath, [error localizedDescription]);
    
    ScLog(@"Drop database %@", _databasePath);
}

- (BOOL)exists:(NSString*)sql withArgumentsInArray:(NSArray *)arguments
{
    ScLog(@"%@ %@", sql, arguments);
    ScDbResultSet *rs = [[ScDbResultSet alloc]init];
    [self executeQuery:sql withArgumentsInArray:arguments resultSet:rs];
    
    BOOL exists = [rs next];
    
    [rs close];
    
    return exists;
}

- (void)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments
{
    ScLog(@"%@ %@", sql, arguments);
    BOOL __unused res = [_db executeUpdate:sql withArgumentsInArray:arguments];
    NSAssert(res, [[_db lastError] localizedDescription]);
}

- (void)executeQuery:(NSString*)sql resultSet:(ScDbResultSet *)resultSet
{
    ScLog(@"%@", sql);
    [resultSet setResultSet:[_db executeQuery:sql]];
}

- (void)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)arguments resultSet:(ScDbResultSet *)resultSet
{
    ScLog(@"%@ %@", sql, arguments);
    [resultSet setResultSet:[_db executeQuery:sql withArgumentsInArray:arguments]];
}


- (void)rollback
{
    BOOL __unused res = [_db rollback];
    NSAssert(res, [[_db lastError] localizedDescription]);
}

- (void)commit
{
    BOOL __unused res = [_db commit];
    NSAssert(res, [[_db lastError] localizedDescription]);
}

- (void)beginTransaction
{
    BOOL __unused res = [_db beginTransaction];
    NSAssert(res, [[_db lastError] localizedDescription]);
}


@end
