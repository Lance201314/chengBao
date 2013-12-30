//
//  MenuList.h
//  test
//
//  Created by Beyondsoft on 13-12-4.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FinishData)(id);
@interface MenuList : NSObject

+ (void)getMenuList:(NSString *)fontType block:(FinishData)block;
+ (void)getMenuImageList:(NSString *)fontType imagePath:(NSString *)imagePath block:(FinishData)block;
@end
