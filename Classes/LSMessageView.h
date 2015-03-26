//
//  LSMessageView.h
//  LSMessageHudDemo
//
//  Created by lslin on 15/3/26.
//  Copyright (c) 2015年 lessfun.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSMessageView : UIView

@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic) BOOL isFullyDisplayed;

- (id)initWithAttributedMessage:(NSAttributedString *)message
                          title:(NSAttributedString *)title
                       duration:(NSTimeInterval)duration
                 canBeDismissed:(BOOL)canBeDismissed
                      titleFont:(UIFont *)titleFont
                 titleTextColor:(UIColor *)titleTextColor
                    messageFont:(UIFont *)messageFont
               messageTextColor:(UIColor *)messageTextColor
                  contentInsets:(UIEdgeInsets)contentInsets
                   cornerRadius:(CGFloat)cornerRadius
             verticalOffsetRate:(CGFloat)verticalOffsetRate;

- (void)prepareToShow;

@end
