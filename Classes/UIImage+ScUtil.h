//
//  UIImage+ScResize.h
//  ScrollView
//
//  Created by Masamoto Miyata on 2012/10/19.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ScResize)

-(UIImage *)imageResizedByWidth:(NSInteger) width;

-(UIImage *)imageResizedByHeight:(NSInteger) height;

-(UIImage *)imageResized:(CGSize) size;

@end
