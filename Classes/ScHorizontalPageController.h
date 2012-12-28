//
//  ScHorizontalScrollController.h
//  fotocase
//
//  Created by Masamoto Miyata on 2012/12/28.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScLog.h"

typedef enum {
    ScHorizontalPageChangeDirectionForward,
    ScHorizontalPageChangeDirectionBackward,
} ScHorizontalPageChangeDirection;

@class ScHorizontalPageController;
@protocol ScHorizontalPageControllerDataSource

- (NSInteger)horizontalPageControllerStartPageIndex:(ScHorizontalPageController *)controller;
- (NSInteger)horizontalPageControllerNumberOfPages:(ScHorizontalPageController *)controller;
- (UIView *)horizontalPageController:(ScHorizontalPageController *)controller pageForIndex:(NSInteger)index;

@end

@protocol ScHorizontalPageControllerDelegate

- (void)horizontalPageController:(ScHorizontalPageController *)controller didDisplayPageIndex:(NSInteger)index;

@end

@interface ScHorizontalPageController : UIViewController<UIScrollViewDelegate, ScHorizontalPageControllerDataSource>
{
    @private
    UIScrollView *_scrollView;
    NSMutableArray *_pageIndexes;
    NSMutableDictionary *_pages;
    NSInteger _totalPageCount;
    NSInteger _currentPage;
    ScHorizontalPageChangeDirection _direction;
    BOOL _bouncing;
}

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, strong) id<ScHorizontalPageControllerDelegate>delegate;

@end
