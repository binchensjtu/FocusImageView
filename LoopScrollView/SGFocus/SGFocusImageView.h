//
//  SGFocusImageView.h
//  LoopScrollView
//
//  Created by Alan on 14-10-9.
//  Copyright (c) 2014年 Px. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGFocusImageView : UIView <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property(nonatomic,assign) int focusInterval;

- (id)initWithFrame:(CGRect)frame imageItems:(NSArray *)items isAuto:(BOOL)isAuto;

- (void)scrollToIndex:(int)idx;

@end


@interface SGFocusImageItem : NSObject

@property (nonatomic, strong) NSString *image;
@property (nonatomic, assign) int      tag;
@property (nonatomic, copy)   void(^onCurrentItemPressed)(SGFocusImageItem *item);

@end