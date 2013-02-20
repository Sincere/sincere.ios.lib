//
//  FcCustomXivCell.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/12/04.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScNibCustomCell.h"

@implementation ScNibCustomCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
{
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self options:nil];
        [self.contentView addSubview:self.view];
    }
    return self;
}


//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    self.view.frame = self.contentView.bounds;
//}

- (NSString *)nibName
{
    NSAssert(NO, @"This is an abstract method and should be overridden");
    return nil;
}

@end
