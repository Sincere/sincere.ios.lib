//
//  FcFileUtil.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/11/27.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScFileUtil.h"

@implementation ScFileUtil

+ (BOOL)createDirectoryIfNeed:(NSString *)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *dir = [path stringByDeletingLastPathComponent];
    if(![fm fileExistsAtPath:dir])
    {
        return [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    
    BOOL __unused res = [[NSFileManager defaultManager] fileExistsAtPath: [URL path]];
    NSAssert1(res, @"%@ is not exists.", URL);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    
    NSAssert2(success, @"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    
    return success;
}

@end