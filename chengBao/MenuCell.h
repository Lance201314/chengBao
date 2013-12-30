//
//  MenuCell.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-5.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EGOImageView;
@interface MenuCell : UITableViewCell{
@private
    EGOImageView *imageView;
}
@property (nonatomic, retain) UILabel *titleName;
@property (nonatomic, retain) UILabel *subName;
- (void)setImageView:(NSString *)url;
@end
