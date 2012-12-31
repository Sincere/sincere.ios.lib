//
//  ScHorizontalScrollController.h
//  fotocase
//
//  Created by Masamoto Miyata on 2012/12/28.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScLog.h"

@protocol ScHorizontalPageViewPage
- (void)prepareForReuse;
@end

@class ScHorizontalPageView;
@protocol ScHorizontalPageViewDataSource

- (NSInteger)pageViewNumberOfPages:(ScHorizontalPageView *)pageView;
- (NSInteger)pageViewStartPageIndex:(ScHorizontalPageView *)pageView;
- (UIView<ScHorizontalPageViewPage> *)pageView:(ScHorizontalPageView *)pageView pageForIndex:(NSInteger)page;

@end



@protocol ScHorizontalPageViewDelegate

- (void)pageView:(ScHorizontalPageView *)controller didDisplayPageIndex:(NSInteger)page;

@end

@interface ScHorizontalPageView : UIScrollView<UIScrollViewDelegate>
{
    @private
    NSMutableDictionary *_pages;
    NSInteger _numberOfPages;
    NSInteger _currentPage;
    BOOL _bouncing;
    NSMutableArray *_reusablePages;
}

@property (nonatomic, strong) id<ScHorizontalPageViewDelegate>pageViewDelegate;
@property (nonatomic, strong) id<ScHorizontalPageViewDataSource>pageViewDataSource;

- (void)reloadPages;
- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated;
- (UIView *)dequeueReusablePage;

@end
