//
//  ScHorizontalScrollController.h
//  fotocase
//
//  Created by Masamoto Miyata on 2012/12/28.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScLog.h"

@class ScHorizontalPageController;
@protocol ScHorizontalPageControllerDataSource

- (NSInteger)horizontalPageControllerNumberOfPages:(ScHorizontalPageController *)controller;
- (NSInteger)horizontalPageControllerStartPageIndex:(ScHorizontalPageController *)controller;
- (UIView *)horizontalPageController:(ScHorizontalPageController *)controller pageForIndex:(NSInteger)page;

@end

@protocol ScHorizontalPageControllerDelegate

- (void)horizontalPageController:(ScHorizontalPageController *)controller didDisplayPageIndex:(NSInteger)page;

@end

@interface ScHorizontalPageController : UIViewController<UIScrollViewDelegate>
{
    @private
    UIScrollView *_scrollView;
    NSMutableDictionary *_pages;
    NSInteger _numberOfPages;
    NSInteger _currentPage;
    BOOL _bouncing;
}

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, strong) id<ScHorizontalPageControllerDelegate>delegate;
@property (nonatomic, strong) id<ScHorizontalPageControllerDataSource>dataSource;

- (void)reloadPages;

@end
