//
//  LxImagesCell.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-5.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AriticleModel;
typedef void (^DidSelectedPicture)(AriticleModel *);
@interface ReCurrentSelectionImagesCell : UITableViewCell <UIScrollViewDelegate> {
    NSString *_menuId;
    NSTimer *_timer;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuId:(NSString *)menuId lxurl:(NSString *)lxurl;
@property (nonatomic, retain) NSMutableArray *lxInfo;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, copy) DidSelectedPicture block;
- (void)refreshCell;
@end
