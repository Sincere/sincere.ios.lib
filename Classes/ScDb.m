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
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0];
        
        _databasePath = [docDir stringByAppendingPathComponent:path];
        _templatePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:templatePath];
        
        //dbが存在してなかったらここが呼ばれて、作成したDBをコピー
        if(![fm fileExistsAtPath:_databasePath])
        {
            //templateDb存在チェック
            if(![fm fileExistsAtPath:_templatePath])
            {
                [ScDb throwException:[NSString stringWithFormat:@"TemplateDatabase %@ is not exists.", _templatePath]];
            }
            
            NSError *error;
            if(![fm copyItemAtPath:_templatePath toPath:_databasePath error:&error])
            {
                [ScDb throwException:[NSString stringWithFormat:@"Fail to create database %@ from %@ by [%@]", _databasePath, _templatePath, [error localizedDescription]]];
            }
            
            ScLog(@"Create database %@ from %@", _databasePath, _templatePath);
        }
        
        _db = [FMDatabase databaseWithPath:_databasePath];
        if (![_db open])
        {
            [ScDb throwException:[NSString stringWithFormat:@"Fail to open database %@", _databasePath]];
        }
        
        ScLog(@"Open database %@", _databasePath);
	}
	return self;
}

-(void)close
{
    if(![_db close])
    {
        [ScDb throwException:[NSString stringWithFormat:@"You can't close connection %@", [self description]]];
    }
}

-(void)drop
{
    [self close];
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm removeItemAtPath:_databasePath error:&error])
    {
        [ScDb throwException:[NSString stringWithFormat:@"Fail to drop database %@", _databasePath]];
    }
}

- (void)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments
{
    if(![_db executeUpdate:sql withArgumentsInArray:arguments])
    {
        [self throwLastErrorException];
    }
}

- (void)executeQuery:(NSString*)sql resultSet:(ScDbResultSet *)resultSet
{
    [resultSet setResultSet:[_db executeQuery:sql]];
}

- (void)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)arguments resultSet:(ScDbResultSet *)resultSet
{
    [resultSet setResultSet:[_db executeQuery:sql withArgumentsInArray:arguments]];
}


- (void)rollback
{
    if(![_db rollback])
    {
        [self throwLastErrorException];
    }
}

- (void)commit
{
    if(![_db commit])
    {
        [self throwLastErrorException];
    }
}

- (void)beginTransaction
{
    if(![_db beginTransaction])
    {
        [self throwLastErrorException];
    }
}

+ (void)throwException:(NSString *)message
{
    NSException *exception = [NSException exceptionWithName: @"ScDbException" reason: message userInfo: nil];
    @throw exception;
}

#pragma mark - private
- (void)throwLastErrorException
{
    [ScDb throwException:[[_db lastError] localizedDescription]];
}


@end
