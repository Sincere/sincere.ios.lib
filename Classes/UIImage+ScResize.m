//
//  UIImage+ScResize.m
//  ScrollView
//
//  Created by Masamoto Miyata on 2012/10/19.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "UIImage+ScResize.h"

@implementation UIImage (ScResize)

-(UIImage *)imageResizedByWidth:(NSInteger) width
{
    CGSize size = CGSizeMake(width, self.size.height * (width / self.size.width));
    
    return [self imageResized:size];
}

-(UIImage *)imageResizedByHeight:(NSInteger) height
{
    CGSize size = CGSizeMake(self.size.width * (height / self.size.height), height);
    
    return [self imageResized:size];
}

-(UIImage *)imageResized:(CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
