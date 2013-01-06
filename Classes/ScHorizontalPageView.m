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

@synthesize currentPageIndex = _currentPageIndex;
@synthesize numberOfPages = _numberOfPages;

static NSInteger PRE_LOAD_COUNT = 3;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pages = [[NSMutableDictionary alloc]initWithCapacity:PRE_LOAD_COUNT];
        _reusablePages = [[NSMutableArray alloc]init];
        self.delegate = self;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.scrollsToTop = NO;
        
        
        _currentPageIndex = 0;
        
        _scrollStarted = NO;
        self.scrollNextEnabled = YES;
        self.scrollPrevEnabled = YES;
    }
    return self;
}

- (void)reloadPages
{
    _numberOfPages = [self.pageViewDataSource pageViewNumberOfPages:self];
    self.contentSize = CGSizeMake(self.frame.size.width * _numberOfPages, self.frame.size.height);
    NSInteger startPage = [self.pageViewDataSource pageViewStartPageIndex:self];
    
    [self loadPageWithPreLoadPage:startPage];
    _currentPageIndex = startPage;
    
    [self scrollToPage:startPage animated:NO];
    
    [self.pageViewDelegate pageView:self didDisplayPage:[_pages objectForKey:[NSNumber numberWithInteger:startPage]] previousPage:nil];
}

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated
{
    [self setContentOffset:CGPointMake(page * self.frame.size.width, 0) animated:animated];
}

- (void)scrollToFirstPageAnimated:(BOOL)animated
{
    [self scrollToPage:0 animated:animated];
}

- (void)scrollToLastPageAnimated:(BOOL)animated
{
    [self scrollToPage:_numberOfPages - 1 animated:animated];
}

- (UIView *)dequeueReusablePage
{
    if(_reusablePages.count == 0)
    {
        return nil;
    }
    
    
    ScHorizontalPageViewPage *view = [_reusablePages objectAtIndex:0];
    view.pageIndex = 0;
    [_reusablePages removeObjectAtIndex:0];
    
    return view;
}

- (ScHorizontalPageViewPage *)previousPage
{
    return [self viewAtPage:_currentPageIndex - 1];
}

- (ScHorizontalPageViewPage *)nextPage
{
    return [self viewAtPage:_currentPageIndex + 1];
}

- (ScHorizontalPageViewPage *)currentPage
{
    return [self viewAtPage:_currentPageIndex];
}

- (BOOL)isFirstPage
{
    return self.currentPageIndex == 0;
}

- (BOOL)isLastPage
{
    return self.currentPageIndex == self.numberOfPages - 1;
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
    [self removePreLoadCache: page + eachPreloadCount + 1];
    
    
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
    [self removePreLoadCache: page - eachPreloadCount - 1];
}

- (void)removePreLoadCache:(NSInteger)page
{
    
    if(page < 0 || page >= _numberOfPages)
    {
        return;
    }
    
    NSNumber *targetIndex = [NSNumber numberWithInteger:page];
    ScHorizontalPageViewPage *view = [_pages objectForKey:targetIndex];
    
    if(view != nil)
    {
        [_pages removeObjectForKey:targetIndex];
        [view removeFromSuperview];
        [view prepareForReuse];
        
        [_reusablePages addObject:view];
    }
}

- (void)loadPage:(NSInteger)page;
{
    if(page < 0 || page >= _numberOfPages)
    {
        return;
    }
    
    ScHorizontalPageViewPage *view = [self.pageViewDataSource pageView:self pageForIndex:page];
    view.pageIndex = page;
    NSNumber *targetIndex = [NSNumber numberWithInteger:page];
    
    CGRect rect = self.frame;
    view.frame = CGRectMake(rect.size.width * page, rect.origin.y, rect.size.width, rect.size.height);
    [self addSubview:view];
    
    [_pages setObject:view forKey:targetIndex];
}

- (ScHorizontalPageViewPage *)viewAtPage:(NSInteger)page
{
    return [_pages objectForKey:[NSNumber numberWithInteger:page]];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    
    if(_currentPageIndex != fractionalPage)
    {
        NSInteger newPage;
        if(fractionalPage > _currentPageIndex)
        {
            if(!self.scrollNextEnabled)
            {
                [self scrollToPage:_currentPageIndex animated:NO];
                return;
            }
            newPage = floorf(fractionalPage);
        }
        else if(fractionalPage < _currentPageIndex)
        {
            if(!self.scrollPrevEnabled)
            {
                [self scrollToPage:_currentPageIndex animated:NO];
                return;
            }
            newPage = ceilf(fractionalPage);
        }
        
        if(newPage != _currentPageIndex)
        {
            ScHorizontalPageViewPage *previousPage = [self viewAtPage:_currentPageIndex];
            _currentPageIndex = newPage;
            [self loadPageWithPreLoadPage:_currentPageIndex];
            [self.pageViewDelegate pageView:self didDisplayPage:[self viewAtPage:_currentPageIndex] previousPage:previousPage];
        }
    }
    
    if(_currentPageIndex == fractionalPage)
    {
        _scrollStarted = NO;
    }
    
    if(!_scrollStarted)
    {
        if(fractionalPage > _currentPageIndex)
        {
            _scrollStarted = YES;
            [self.pageViewDelegate pageView:self startDragFrom:[self viewAtPage:_currentPageIndex] toView:[self viewAtPage:_currentPageIndex + 1]];
        }
        else if(fractionalPage < _currentPageIndex)
        {
            _scrollStarted = YES;
            [self.pageViewDelegate pageView:self startDragFrom:[self viewAtPage:_currentPageIndex] toView:[self viewAtPage:_currentPageIndex - 1]];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"end");
}
@end
