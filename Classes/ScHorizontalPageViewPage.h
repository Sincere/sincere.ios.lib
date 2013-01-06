//
//  ScHorizontalPageViewPage.h
//  fotocase
//
//  Created by Masamoto Miyata on 2013/01/06.
//  Copyright (c) 2013年 Masamoto Miyata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScHorizontalPageViewPage : UIView

@property (nonatomic, assign)NSInteger pageIndex;
- (void)prepareForReuse;
@end
