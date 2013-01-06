//
//  ScHorizontalScrollController.h
//  fotocase
//
//  Created by Masamoto Miyata on 2012/12/28.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScLog.h"
#import "ScHorizontalPageViewPage.h"

@class ScHorizontalPageView;
@protocol ScHorizontalPageViewDataSource

- (NSInteger)pageViewNumberOfPages:(ScHorizontalPageView *)pageView;
- (NSInteger)pageViewStartPageIndex:(ScHorizontalPageView *)pageView;
- (ScHorizontalPageViewPage *)pageView:(ScHorizontalPageView *)pageView pageForIndex:(NSInteger)page;

@end



@protocol ScHorizontalPageViewDelegate

- (void)pageView:(ScHorizontalPageView *)pageView startDragFrom:(ScHorizontalPageViewPage *)fromView toView:(ScHorizontalPageViewPage *)toView;
- (void)pageView:(ScHorizontalPageView *)pageView didDisplayPage:(ScHorizontalPageViewPage *)displayView previousPage:(ScHorizontalPageViewPage *)previousPage;

@end

@interface ScHorizontalPageView : UIScrollView<UIScrollViewDelegate>
{
    @private
    NSMutableDictionary *_pages;
    NSInteger _numberOfPages;
    NSInteger _currentPageIndex;
    NSMutableArray *_reusablePages;
    BOOL _scrollStarted;
}

@property (nonatomic, weak) id<ScHorizontalPageViewDelegate>pageViewDelegate;
@property (nonatomic, weak) id<ScHorizontalPageViewDataSource>pageViewDataSource;
@property (nonatomic, readonly) NSInteger numberOfPages;
@property (nonatomic, readonly) NSInteger currentPageIndex;
@property (nonatomic, readonly, getter = currentPage) ScHorizontalPageViewPage *currentPage;
@property (nonatomic, readonly, getter = previousPage) ScHorizontalPageViewPage *previousPage;
@property (nonatomic, readonly, getter = nextPage) ScHorizontalPageViewPage *nextPage;
@property (nonatomic, readonly, getter = isFirstPage) BOOL isFirstPage;
@property (nonatomic, readonly, getter = isLastPage) BOOL isLastPage;
@property (nonatomic, assign) BOOL scrollNextEnabled;
@property (nonatomic, assign) BOOL scrollPrevEnabled;

- (void)reloadPages;
- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated;
- (void)scrollToFirstPageAnimated:(BOOL)animated;
- (void)scrollToLastPageAnimated:(BOOL)animated;
- (ScHorizontalPageViewPage *)dequeueReusablePage;
- (ScHorizontalPageViewPage *)previousPage;
- (ScHorizontalPageViewPage *)nextPage;
- (ScHorizontalPageViewPage *)currentPage;
- (BOOL)isFirstPage;
- (BOOL)isLastPage;

@end
