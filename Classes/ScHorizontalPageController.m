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
        _pageIndexes = [[NSMutableArray alloc]initWithCapacity:PRE_LOAD_COUNT];
        _pages = [[NSMutableDictionary alloc]initWithCapacity:PRE_LOAD_COUNT];
        
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        [self.view addSubview:_scrollView];
        
        
        _currentPage = 0;
        _bouncing = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    _totalPageCount = [self horizontalPageControllerNumberOfPages:self];
    _scrollView.frame = self.view.frame;
    NSInteger preLoadCount = _totalPageCount < PRE_LOAD_COUNT ? _totalPageCount : PRE_LOAD_COUNT;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * _totalPageCount, self.view.frame.size.height);
    
    NSInteger startPage = [self horizontalPageControllerStartPageIndex:self];
    int start = startPage - 1 < 0 ? 0 : startPage - ((preLoadCount - 1) / 2);
    for (int i = start; i < start + preLoadCount; i++)
    {
        [self loadPageForIndex:i];
    }
    
    [self.scrollView setContentOffset: CGPointMake(startPage * self.view.frame.size.width, 0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
- (void)loadPageForIndex:(NSInteger)index;
{
    
    
    NSNumber *targetIndex = [NSNumber numberWithInteger:index];
    if(_pageIndexes.count == PRE_LOAD_COUNT)
    {
        NSNumber *removeIndex;
        if(_direction == ScHorizontalPageChangeDirectionForward)
        {
            
            removeIndex = [_pageIndexes objectAtIndex:0];
            [_pageIndexes removeObjectAtIndex:0];
            [_pageIndexes addObject:targetIndex];
        }
        else
        {
            
            NSInteger key = PRE_LOAD_COUNT - 1;
            removeIndex = [_pageIndexes objectAtIndex: key];
            [_pageIndexes removeObjectAtIndex:key];
            [_pageIndexes insertObject:targetIndex atIndex:0];
        }

        UIView *removeView = [_pages objectForKey:removeIndex];
        [_pages removeObjectForKey:removeIndex];
        [removeView removeFromSuperview];
    }
    else
    {
        [_pageIndexes addObject:targetIndex];
    }
    
    UIView *view = [self horizontalPageController:self pageForIndex:index];
    CGRect rect = self.view.frame;
    view.frame = CGRectMake(rect.size.width * index, rect.origin.y, rect.size.width, rect.size.height);
    //NSLog(@"LOAD %d %@ %@", index, NSStringFromCGRect(view.frame), _pageIndexes);
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
        
        
        if(_currentPage < newPage)
        {
            NSLog(@"Forward");
            _direction = ScHorizontalPageChangeDirectionForward;
        }
        else
        {
            NSLog(@"Backword");
            _direction = ScHorizontalPageChangeDirectionBackward;
        }
        
        _currentPage = newPage;
        
        NSInteger nextPage = newPage + 1;
        if(nextPage <= _totalPageCount)
        {
            if([_pageIndexes indexOfObject:[NSNumber numberWithInteger:nextPage]] == NSNotFound)
            {
                [self loadPageForIndex:nextPage];
            }
        }
        
        NSInteger prevPage = newPage - 1;
        if(prevPage >= 0)
        {
            if([_pageIndexes indexOfObject:[NSNumber numberWithInteger:prevPage]] == NSNotFound)
            {
                [self loadPageForIndex:prevPage];
            }
        }
        
        [self.delegate horizontalPageController:self didDisplayPageIndex:_currentPage];
    }
}

#pragma mark - ScHorizontalPageControllerDataSource
- (NSInteger)horizontalPageControllerStartPageIndex:(ScHorizontalPageController *)controller
{
    NSAssert(NO, @"This is an abstract method and should be overridden");
    return 0;
}

- (NSInteger)horizontalPageControllerNumberOfPages:(ScHorizontalPageController *)controller
{
    NSAssert(NO, @"This is an abstract method and should be overridden");
    return 0;
}

- (UIView *)horizontalPageController:(ScHorizontalPageController *)controller pageForIndex:(NSInteger)index
{
    NSAssert(NO, @"This is an abstract method and should be overridden");
    return nil;
}

@end
