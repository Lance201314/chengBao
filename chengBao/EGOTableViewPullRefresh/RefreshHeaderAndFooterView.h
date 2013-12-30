//
//  RefreshHeaderAndFooterView.h
//  hardy
//
//  Created by hardy on 13-1-8.
//  Copyright (c) 2013年 hardy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	PullRefreshPulling = 0,
	PullRefreshNormal,
	PullRefreshLoading,
} PullRefreshState;

//RefreshHeaderView
@interface RefreshHeaderView : UIView {
	UILabel *_statusLabel;
	UIActivityIndicatorView *_activityView;
    UILabel *_showHeadMsg;
}
@property(nonatomic)PullRefreshState state;
- (void)showHeaderMsg:(NSInteger)rows;
- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor;
@end

//RefreshFooterView
@interface RefreshFooterView : UIView{
	UILabel *_statusLabel;
	UIActivityIndicatorView *_activityView;
    UILabel *_showFootMsg;
}
@property(nonatomic)PullRefreshState state;
- (void)showFooterMsg:(NSInteger)rows;
- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor;
@end

//RefreshHeaderAndFooterView
@protocol RefreshHeaderAndFooterViewDelegate;
@interface RefreshHeaderAndFooterView : UIView{
    RefreshHeaderView   *refreshHeaderView;
    RefreshFooterView   *refreshFooterView;
    id _delegate;
}
@property(nonatomic,assign) id <RefreshHeaderAndFooterViewDelegate> delegate;
@property(nonatomic,strong)RefreshHeaderView   *refreshHeaderView;
@property(nonatomic,strong)RefreshFooterView   *refreshFooterView;

- (void)RefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)RefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)RefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
@end
@protocol RefreshHeaderAndFooterViewDelegate
- (void)RefreshHeaderAndFooterDidTriggerRefresh:(RefreshHeaderAndFooterView*)view;
- (BOOL)RefreshHeaderAndFooterDataSourceIsLoading:(RefreshHeaderAndFooterView*)view;
@end