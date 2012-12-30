//
//  ScHorizontalScrollController.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/12/28.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScHorizontalPageController.h"

@interface ScHorizontalPageController ()

@end

@implementation ScHorizontalPageController

static NSInteger PRE_LOAD_COUNT = 3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _pages = [[NSMutableDictionary alloc]initWithCapacity:PRE_LOAD_COUNT];
        
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_scrollView];
        
        
        _currentPage = 0;
        _bouncing = NO;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self reloadPages];
}

- (void)reloadPages
{
    _scrollView.frame = self.view.frame;
    
    _numberOfPages = [self.dataSource horizontalPageControllerNumberOfPages:self];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * _numberOfPages, self.view.frame.size.height);
    
    NSInteger startPage = [self.dataSource horizontalPageControllerStartPageIndex:self];
    
    [self loadPageWithPreLoadPage:startPage];
    
    [self.scrollView setContentOffset: CGPointMake(startPage * self.view.frame.size.width, 0)];
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
    
    [self.delegate horizontalPageController:self didDisplayPageIndex:page];
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
    
    UIView *view = [self.dataSource horizontalPageController:self pageForIndex:page];
    NSNumber *targetIndex = [NSNumber numberWithInteger:page];
    
    CGRect rect = self.view.frame;
    view.frame = CGRectMake(rect.size.width * page, rect.origin.y, rect.size.width, rect.size.height);
    [_scrollView addSubview:view];
    
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
