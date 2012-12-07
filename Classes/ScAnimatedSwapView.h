//
//  ScScrollingLabelView.h
//  fotocase
//
//  Created by Masamoto Miyata on 2012/12/07.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScLog.h"

@interface ScAnimatedSwapView : UIScrollView<UIScrollViewDelegate>
{
    @private
    UIView *_currentView;
    UIView *_addingView;
    NSMutableArray *_views;
    CGRect _stageFrame;
    CGRect _nextFrame;
}

- (void)setNextView:(UIView *)view;

@end
