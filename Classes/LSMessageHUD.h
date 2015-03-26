//
//  LSMessageHUD.h
//  LSMessageHudDemo
//
//  Created by lslin on 15/3/26.
//  Copyright (c) 2015年 lessfun.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSMessageHUD : NSObject

@property (strong, nonatomic) UIFont *defaultTitleFont;              /**< default is systemFont with 16.0 */
@property (strong, nonatomic) UIFont *defaultMessageFont;            /**< default is systemFont with 14.0 */
@property (strong, nonatomic) UIColor *defaultTitleTextColor;        /**< default is white color */
@property (strong, nonatomic) UIColor *defaultMessageTextColor;      /**< default is white color */
@property (strong, nonatomic) UIColor *backgroundColor;              /**< default is RGBA(0, 0, 0, 0.8) */

@property (assign, nonatomic) UIEdgeInsets messageContentInsets;     /**< default is (10, 10, 10, 10) */
@property (assign, nonatomic) CGFloat messageCornerRadius;           /**< default is 6.0 */

@property (assign, nonatomic) CGFloat messageViewVerticalOffsetRate; /**< default is 0.5, vertical center */
@property (assign, nonatomic) NSTimeInterval defaultDuration;        /**< default is 2.0 */


/**
 *  shared instance.
 *
 *  @return LSMessageHUD
 */
+ (instancetype)sharedMessage;

/**
 *  Shows a simple message, without title
 *
 *  @param message The message content
 */
+ (void)showWithMessage:(NSString *)message;

/**
 *  Shows a simple message with title
 *
 *  @param message The message content
 *  @param title   The message title
 */
+ (void)showWithMessage:(NSString *)message title:(NSString *)title;

/**
 *  Shows a simple message with title and duration
 *
 *  @param message  The message content
 *  @param title    The message title
 *  @param duration The duration of the notification being displayed
 */
+ (void)showWithMessage:(NSString *)message title:(NSString *)title duration:(NSTimeInterval)duration;

/**
 *  Shows a simple message with title and duration, can be tapped to dismiss
 *
 *  @param message  The message content
 *  @param title    The message title
 *  @param duration The duration of the notification being displayed
 *  @param canBeDismissed YES to dismiss the message view by tapped
 */
+ (void)showWithMessage:(NSString *)message title:(NSString *)title duration:(NSTimeInterval)duration  canBeDismissed:(BOOL)canBeDismissed;

/**
 *  Shows a attributed message, without title
 *
 *  @param message The message content
 */
+ (void)showWithAttributedMessage:(NSAttributedString *)message;

/**
 *  Shows a attributed message with title
 *
 *  @param message The message content
 *  @param title   The message title
 */
+ (void)showWithAttributedMessage:(NSAttributedString *)message title:(NSAttributedString *)title;

/**
 *  Shows a attributed message with title and duration
 *
 *  @param message  The message content
 *  @param title    The message title
 *  @param duration The duration of the notification being displayed
 */
+ (void)showWithAttributedMessage:(NSAttributedString *)message title:(NSAttributedString *)title duration:(NSTimeInterval)duration;

/**
 *  Shows a attributed message with title and duration, can be tapped to dismiss
 *
 *  @param message  The message content
 *  @param title    The message title
 *  @param duration The duration of the notification being displayed
 *  @param canBeDismissed YES to dismiss the message view by tapped
 */
+ (void)showWithAttributedMessage:(NSAttributedString *)message title:(NSAttributedString *)title duration:(NSTimeInterval)duration canBeDismissed:(BOOL)canBeDismissed;

/**
 *  Dismiss current active message view.
 */
+ (void)dismissActiveMessageView;

@end
