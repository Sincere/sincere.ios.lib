//
//  ScHorizontalScrollController.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/12/28.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScHorizontalPageView.h"

@interface ScHorizontalPageView ()

@end

@implementation ScHorizontalPageView

static NSInteger PRE_LOAD_COUNT = 3;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pages = [[NSMutableDictionary alloc]initWithCapacity:PRE_LOAD_COUNT];
        
        self.delegate = self;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        
        _currentPage = 0;
        _bouncing = NO;
    }
    return self;
}

- (void)reloadPages
{
    _numberOfPages = [self.pageViewDataSource pageViewNumberOfPages:self];
    self.contentSize = CGSizeMake(self.frame.size.width * _numberOfPages, self.frame.size.height);
    
    NSInteger startPage = [self.pageViewDataSource pageViewStartPageIndex:self];
    
    [self loadPageWithPreLoadPage:startPage];
    
    [self setContentOffset: CGPointMake(startPage * self.frame.size.width, 0)];
}

#pragma mark - private
- (void)loadPageWithPreLoadPage:(NSInteger)page
{
    NSArray *cachedPages = [_pages allKeys];
    if([cachedPages indexOfObject:[NSNumber numberWithInteger:page]] == NSNotFound)
    {
        [self loadPage:page];
    }
    
    NSInteger eachPreloadCount = (PRE_LOAD_COUNT - 1) / 2;
    //前方のpreload
    for (int key = 1; key <= eachPreloadCount; key++)
    {
        NSInteger targetPage = page + key;
        if([cachedPages indexOfObject:[NSNumber numberWithInteger:targetPage]] == NSNotFound)
        {
            [self loadPage:targetPage];
        }
    }
    
    //もう一個先のpreloadがあったら削除
    [self removePreLoadCach: page + eachPreloadCount + 1];
    
    
    //後方のpreload
    for (int key = 1; key <= eachPreloadCount; key++)
    {
        NSInteger targetPage = page - key;
        if(targetPage >= 0 && [cachedPages indexOfObject:[NSNumber numberWithInteger:targetPage]] == NSNotFound)
        {
            [self loadPage:targetPage];
        }
    }
    
    //もう一個手前のpreloadがあったら削除
    [self removePreLoadCach: page - eachPreloadCount - 1];
    
    [self.pageViewDelegate pageView:self didDisplayPageIndex:page];
}

- (void)removePreLoadCach:(NSInteger)page
{
    
    if(page < 0 || page >= _numberOfPages)
    {
        return;
    }
    
    NSNumber *targetIndex = [NSNumber numberWithInteger:page];
    UIView *view = [_pages objectForKey:targetIndex];
    
    if(view != nil)
    {
        [_pages removeObjectForKey:targetIndex];
        [view removeFromSuperview];
    }
    
}

- (void)loadPage:(NSInteger)page;
{
    if(page < 0 || page >= _numberOfPages)
    {
        return;
    }
    
    UIView *view = [self.pageViewDataSource pageView:self pageForIndex:page];
    NSNumber *targetIndex = [NSNumber numberWithInteger:page];
    
    CGRect rect = self.frame;
    view.frame = CGRectMake(rect.size.width * page, rect.origin.y, rect.size.width, rect.size.height);
    [self addSubview:view];
    
    [_pages setObject:view forKey:targetIndex];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    
    //半分を過ぎたらページが変わる（bounds）
    NSInteger newPage = lround(fractionalPage);
    if (_currentPage != newPage)
    {
        _currentPage = newPage;
        
        [self loadPageWithPreLoadPage:_currentPage];
    }
}
@end
