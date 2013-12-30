//
//  RefreshHeaderAndFooterView.m
//  hardy
//
//  Created by hardy on 13-1-8.
//  Copyright (c) 2013年 hardy. All rights reserved.
//

#import "RefreshHeaderAndFooterView.h"
#import <QuartzCore/QuartzCore.h>

#define RefreshViewHeight 65.0f
#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

/**************************************************************************************************
 *********************************RefreshHeaderView************************************************
 *************************************************************************************************/
@interface RefreshHeaderView()
@end

@implementation RefreshHeaderView
@synthesize state = _state;
- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        self.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[self addSubview:view];
		_activityView = view;
		[view release];
        _showHeadMsg = [[UILabel alloc] init];
        _showHeadMsg.alpha = 0;
        _showHeadMsg.textColor = textColor;
        _showHeadMsg.font = [UIFont boldSystemFontOfSize:13.0f];
        _showHeadMsg.backgroundColor = [UIColor clearColor];
        _showHeadMsg.textAlignment = NSTextAlignmentCenter;
        _showHeadMsg.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_showHeadMsg];
		[self setState:PullRefreshNormal];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame  {
    return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
}
-(void)layoutSubviews
{
    _statusLabel.frame = CGRectMake(self.frame.size.width / 2 - 40, self.frame.size.height - 48.0f, 120, 20.0f);
    _activityView.frame = CGRectMake(self.frame.size.width / 2 - 60, self.frame.size.height - 48.0f, 20.0f, 20.0f);
    _showHeadMsg.frame = CGRectMake(self.frame.size.width / 2 - 40, self.frame.size.height, 80, 20);
}
- (void)showHeaderMsg:(NSInteger)rows
{
    if (rows == 0) {
        _showHeadMsg.text = @"没有新的数据";
    } else {
        _showHeadMsg.text = [NSString stringWithFormat:@"加载了%d条数据", rows];
    }
    [UIView animateWithDuration:1.0 animations:^(){
        _showHeadMsg.alpha = 1.0;
    } completion:^(BOOL finished){
        _showHeadMsg.alpha = 0.0;
    }];
}
#pragma mark -
#pragma mark Setters
- (void)setState:(PullRefreshState)state{
	if (_state != state) {
        _state = state;
        switch (state) {
            case PullRefreshPulling:
                _statusLabel.text = NSLocalizedString(@"松开手指刷新...", @"松开手指刷新...");
                break;
            case PullRefreshNormal:
                _statusLabel.text = NSLocalizedString(@"下拉刷新...", @"下拉刷新...");
                [_activityView stopAnimating];                
                break;
            case PullRefreshLoading:
                _statusLabel.text = NSLocalizedString(@"努力加载中...", @"努力加载中...");
                [_activityView startAnimating];                
                break;
            default:
                break;
        }
    }
}
#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	_activityView = nil;
	_statusLabel = nil;
    [_showHeadMsg release];
    [super dealloc];
}
@end

/**************************************************************************************************
 *********************************RefreshFooterView************************************************
 *************************************************************************************************/
@interface RefreshFooterView ()

@end

@implementation RefreshFooterView
@synthesize state =_state;
- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[self addSubview:view];
		_activityView = view;
		[view release];
        _showFootMsg = [[UILabel alloc] init];
        _showFootMsg.alpha = 0;
        _showFootMsg.textColor = textColor;
        _showFootMsg.font = [UIFont boldSystemFontOfSize:13.0f];
        _showFootMsg.backgroundColor = [UIColor clearColor];
        _showFootMsg.textAlignment = NSTextAlignmentCenter;
        _showFootMsg.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_showFootMsg];
		[self setState:PullRefreshNormal];
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame  {
    return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
}
-(void)layoutSubviews
{
    _statusLabel.frame = CGRectMake(self.frame.size.width / 2 - 40, RefreshViewHeight - 38.0f, 120, 20.0f);
    _activityView.frame = CGRectMake(self.frame.size.width / 2 - 70, RefreshViewHeight - 38.0f, 20.0f, 20.0f);
    _showFootMsg.frame = CGRectMake(self.frame.size.width / 2 - 40, - 40, 80, 20);
}
- (void)showFooterMsg:(NSInteger)rows
{
    if (rows == 0) {
        _showFootMsg.text = @"没有新的数据";
    } else {
        _showFootMsg.text = [NSString stringWithFormat:@"加载了%d条数据", rows];
    }
    [UIView animateWithDuration:1.0 animations:^(){
        _showFootMsg.alpha = 1.0;
    } completion:^(BOOL finished){
        _showFootMsg.alpha = 0.0;
    }];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
- (void)setState:(PullRefreshState)state{
	if (_state != state) {
        _state = state;
        switch (state) {
            case PullRefreshPulling:
                _statusLabel.text = NSLocalizedString(@"松开手指加载更多内容...", @"松开手指加载更多内容...");                
                break;
            case PullRefreshNormal:
                _statusLabel.text = NSLocalizedString(@"上拉加载更多内容...", @"上拉加载更多内容...");
                [_activityView stopAnimating];
                break;
            case PullRefreshLoading:
                _statusLabel.text = NSLocalizedString(@"努力加载更多内容...", @"努力加载更多内容...");
                [_activityView startAnimating];
                break;
            default:
                break;
        }
	}
}
#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	_activityView = nil;
	_statusLabel = nil;
    [_showFootMsg release];
    [super dealloc];
}

@end

/**************************************************************************************************
 *********************************RefreshHeaderAndFooterView***************************************
 *************************************************************************************************/
@interface RefreshHeaderAndFooterView ()
@end

@implementation RefreshHeaderAndFooterView
@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize refreshFooterView = _refreshFooterView;
@synthesize delegate =_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        RefreshHeaderView * headerView  = [[RefreshHeaderView alloc] initWithFrame:CGRectZero];
        [self addSubview:headerView];
        self.refreshHeaderView = headerView;
        [headerView release];
        
        RefreshFooterView * footerView = [[RefreshFooterView alloc] initWithFrame:CGRectZero];
        [self addSubview:footerView];
        self.refreshFooterView = footerView;
        [footerView release];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
-(void)layoutSubviews{
    self.refreshHeaderView.frame = CGRectMake(0, 0 - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    self.refreshFooterView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

#pragma mark -
#pragma mark ScrollView Methods
//手指屏幕上不断拖动调用此方法
- (void)RefreshScrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (self.refreshHeaderView.state == PullRefreshLoading || self.refreshFooterView.state == PullRefreshLoading) {
		return;
	}
    if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(RefreshHeaderAndFooterDataSourceIsLoading:)]) {
			_loading = [self.delegate RefreshHeaderAndFooterDataSourceIsLoading:self];
		}
		if (self.refreshHeaderView.state == PullRefreshPulling&&scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			self.refreshHeaderView.state = PullRefreshNormal;
		} else if (self.refreshHeaderView.state == PullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
			self.refreshHeaderView.state = PullRefreshPulling;
		}
        if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		if (self.refreshFooterView.state == PullRefreshPulling && scrollView.contentOffset.y + (scrollView.frame.size.height) < scrollView.contentSize.height + RefreshViewHeight && scrollView.contentOffset.y > 0.0f && !_loading) {
			self.refreshFooterView.state = PullRefreshNormal;
		} else if (self.refreshFooterView.state == PullRefreshNormal &&  scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + RefreshViewHeight  && !_loading) {
			self.refreshFooterView.state = PullRefreshPulling;
		}
		
		if (scrollView.contentInset.bottom != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}
//当用户停止拖动，并且手指从屏幕中拿开的的时候调用此方法
- (void)RefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	if (self.refreshHeaderView.state == PullRefreshLoading || self.refreshFooterView.state == PullRefreshLoading) {
		return;
	}
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(RefreshHeaderAndFooterDataSourceIsLoading:)]) {
		_loading = [_delegate RefreshHeaderAndFooterDataSourceIsLoading:self];
	}
	
    if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		self.refreshHeaderView.state = PullRefreshLoading;
		if ([_delegate respondsToSelector:@selector(RefreshHeaderAndFooterDidTriggerRefresh:)]) {
			[_delegate RefreshHeaderAndFooterDidTriggerRefresh:self];
		}
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		
	}
	if (scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + RefreshViewHeight && !_loading) {
		self.refreshFooterView.state = PullRefreshLoading;
		if ([_delegate respondsToSelector:@selector(RefreshHeaderAndFooterDidTriggerRefresh:)]) {
			[_delegate RefreshHeaderAndFooterDidTriggerRefresh:self];
		}
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, RefreshViewHeight, 0.0f);
		[UIView commitAnimations];
	}
	
}
//当开发者页面页面刷新完毕调用此方法，[delegate RefreshScrollViewDataSourceDidFinishedLoading: scrollView];
- (void)RefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    if (self.refreshHeaderView.state ==PullRefreshLoading) {
        self.refreshHeaderView.state = PullRefreshNormal;
    }
    else if (self.refreshFooterView.state ==PullRefreshLoading) {
        self.refreshFooterView.state = PullRefreshNormal;
    }
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
}
#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    self.delegate = nil;
	self.refreshHeaderView = nil;
	self.refreshFooterView = nil;
    [super dealloc];
}
@end
