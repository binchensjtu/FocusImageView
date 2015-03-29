//
//  SGFocusImageView.m
//  LoopScrollView
//
//  Created by Alan on 14-10-9.
//  Copyright (c) 2014年 Px. All rights reserved.
//

#import "SGFocusImageView.h"

#define ITEM_WIDTH 320.0
#define FOCUS_WIDTH 320.0
#define FOCUS_HEIGHT 115.0

@interface SGFocusImageView () {
    
    BOOL _isAutoPlay;
    
    UIScrollView *_scrollView;
    
    UIPageControl *_pageControl;
}

@property (nonatomic, strong) NSMutableArray *imageItems;

@end

@implementation SGFocusImageView

- (id)initWithFrame:(CGRect)frame imageItems:(NSArray *)items isAuto:(BOOL)isAuto
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageItems = [NSMutableArray arrayWithArray:items];
        _isAutoPlay = isAuto;
        /*!
         *  defautl timeInterval is 2s.
         */
        _focusInterval = 2.0f;
        
        [self setupViews];
        
    }
    return self;
}

-(void)setFocusInterval:(int)focusInterval{
    
    _focusInterval = focusInterval;
    
}

#pragma mark - private methods
- (void)setupViews
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.scrollsToTop = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height -20, 320, 20)];
    _pageControl.backgroundColor = [UIColor lightGrayColor];
    _pageControl.alpha = 0.7;
    _pageControl.userInteractionEnabled = NO;
    _pageControl.numberOfPages =  _imageItems.count -2;
    _pageControl.currentPage = 0;
    
    if ([_pageControl respondsToSelector:@selector(pageIndicatorTintColor)]) {
        
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        
    }
    [self addSubview:_pageControl];

    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tapGestureRecognize];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _imageItems.count, _scrollView.frame.size.height);
   
    for (int i = 0; i < _imageItems.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * _scrollView.frame.size.width, 0, FOCUS_WIDTH, FOCUS_HEIGHT)];

        /*!
         *  set focus image
         */
        imageView.image = [UIImage imageNamed:[[_imageItems objectAtIndex:i] valueForKey:@"image"]];
        
        [_scrollView addSubview:imageView];
    }
    
    
    if ([_imageItems count]>1)
    {
        [_scrollView setContentOffset:CGPointMake(ITEM_WIDTH, 0) animated:NO] ;
        if (_isAutoPlay)
        {
            [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:_focusInterval];
        }
    }
    
}

- (void)switchFocusImageItems
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    
    CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;

    targetX = (int)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
    
    [self moveToTargetPosition:targetX];
    
    if ([_imageItems count]>1 && _isAutoPlay)
    {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:_focusInterval];
    }
    
}

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    int page = (int)(_scrollView.contentOffset.x / _scrollView.frame.size.width);
    if (page > -1 && page < _imageItems.count) {
        SGFocusImageItem *item = [_imageItems objectAtIndex:page];
        if (item.onCurrentItemPressed) {
            
            item.onCurrentItemPressed(item);
            
        }
    }
}

- (void)moveToTargetPosition:(CGFloat)targetX
{

    [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
    
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float targetX = scrollView.contentOffset.x;
    
    if ([_imageItems count]>=3)
    {
        if (targetX >= ITEM_WIDTH * ([_imageItems count] -1)) {
            targetX = ITEM_WIDTH;
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
        else if(targetX <= 0)
        {
            targetX = ITEM_WIDTH *([_imageItems count]-2);
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
    }
    int page = (_scrollView.contentOffset.x+ITEM_WIDTH/2.0) / ITEM_WIDTH;
    if ([_imageItems count] > 1)
    {
        page --;
        if (page >= _pageControl.numberOfPages)
        {
            page = 0;
        }else if(page <0)
        {
            page = (int)_pageControl.numberOfPages -1;
        }
    }
    _pageControl.currentPage = page;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
        targetX = (int)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
        [self moveToTargetPosition:targetX];
    }
}

- (void)scrollToIndex:(int)idx
{
    if ([_imageItems count]>1)
    {
        if (idx >= ([_imageItems count]-2))
        {
            idx = (int)[_imageItems count]-3;
        }
        [self moveToTargetPosition:ITEM_WIDTH*(idx+1)];
    }else
    {
        [self moveToTargetPosition:0];
    }
    [self scrollViewDidScroll:_scrollView];
    
}
@end


@implementation SGFocusImageItem

@end