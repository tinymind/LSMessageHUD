//
//  LSMessageHUD.m
//  LSMessageHudDemo
//
//  Created by lslin on 15/3/26.
//  Copyright (c) 2015年 lessfun.com. All rights reserved.
//

#import "LSMessageHUD.h"
#import "LSMessageView.h"

static const CGFloat kLSMessageAnimationDuration = 0.4;

@interface LSMessageHUD ()

@property (strong, nonatomic) NSMutableArray *messages;
@property (assign, nonatomic) BOOL isShowingMessageView;

@end

@implementation LSMessageHUD

#pragma mark - Static

+ (instancetype)sharedMessage {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void)showWithMessage:(NSString *)message {
    [self showWithMessage:message title:nil];
}

+ (void)showWithMessage:(NSString *)message title:(NSString *)title {
    [self showWithMessage:message title:title duration:[LSMessageHUD sharedMessage].defaultDuration];
}

+ (void)showWithMessage:(NSString *)message title:(NSString *)title duration:(NSTimeInterval)duration {
    [self showWithMessage:message title:title duration:duration canBeDismissed:NO];
}

+ (void)showWithMessage:(NSString *)message title:(NSString *)title duration:(NSTimeInterval)duration canBeDismissed:(BOOL)canDismiss {
    [[LSMessageHUD sharedMessage] addMessage:message title:title duration:duration canBeDismissed:canDismiss];
}


+ (void)showWithAttributedMessage:(NSAttributedString *)message {
    [self showWithAttributedMessage:message title:nil];
}

+ (void)showWithAttributedMessage:(NSAttributedString *)message title:(NSAttributedString *)title {
    [self showWithAttributedMessage:message title:title duration:[LSMessageHUD sharedMessage].defaultDuration];
}

+ (void)showWithAttributedMessage:(NSAttributedString *)message title:(NSAttributedString *)title duration:(NSTimeInterval)duration {
    [self showWithAttributedMessage:message title:title duration:duration canBeDismissed:NO];
}

+ (void)showWithAttributedMessage:(NSAttributedString *)message title:(NSAttributedString *)title duration:(NSTimeInterval)duration canBeDismissed:(BOOL)canDismiss {
    [[LSMessageHUD sharedMessage] addAttributedMessage:message title:title duration:duration canBeDismissed:canDismiss];
}

+ (void)dismissActiveMessageView {
    [[LSMessageHUD sharedMessage] dismissCurrentMessageView];
}

#pragma mark - Lifecycle

- (id)init {
    if ((self = [super init])) {
        _messages = [NSMutableArray array];
        
        _defaultTitleFont = [UIFont systemFontOfSize:16.0];
        _defaultMessageFont = [UIFont systemFontOfSize:14.0];
        _defaultTitleTextColor = [UIColor whiteColor];
        _defaultMessageTextColor = [UIColor whiteColor];
        _backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        _messageContentInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
        _messageViewVerticalOffsetRate = 1 / 2.0;
        _messageCornerRadius = 6.0;
        _defaultDuration = 2.0;
    }
    return self;
}

#pragma mark - Public

- (void)addMessage:(NSString *)message title:(NSString *)title duration:(NSTimeInterval)duration canBeDismissed:(BOOL)canDissmiss {
    NSMutableAttributedString *messageStr = message ? [[NSMutableAttributedString alloc] initWithString:message] : nil;
    if (messageStr) {
        [messageStr addAttributes: @{NSForegroundColorAttributeName: self.defaultMessageTextColor,
                                     NSFontAttributeName: self.defaultMessageFont}
                            range: NSMakeRange(0, message.length)];
    }
    
    NSMutableAttributedString *titleStr = title ? [[NSMutableAttributedString alloc] initWithString:title] : nil;
    if (titleStr) {
        [titleStr addAttributes: @{NSForegroundColorAttributeName: self.defaultTitleTextColor,
                                     NSFontAttributeName: self.defaultTitleFont}
                            range: NSMakeRange(0, title.length)];
    }
    
    [self addAttributedMessage:messageStr title:titleStr duration:duration canBeDismissed:canDissmiss];
}

- (void)addAttributedMessage:(NSAttributedString *)message title:(NSAttributedString *)title duration:(NSTimeInterval)duration canBeDismissed:(BOOL)canBeDismissed {
    
    if (message.length == 0 && title.length == 0) {
        return;
    }
    
    LSMessageView *messageView = [[LSMessageView alloc] initWithAttributedMessage:message
                                                                            title:title
                                                                         duration:duration
                                                                   canBeDismissed:canBeDismissed
                                                                        titleFont:self.defaultTitleFont
                                                                   titleTextColor:self.defaultTitleTextColor
                                                                      messageFont:self.defaultMessageFont
                                                                 messageTextColor:self.defaultMessageTextColor
                                                                    contentInsets:self.messageContentInsets
                                                                     cornerRadius:self.messageCornerRadius
                                                               verticalOffsetRate:self.messageViewVerticalOffsetRate];
    messageView.backgroundColor = self.backgroundColor;
    
    [self.messages addObject:messageView];
    [self fadeInMessageView];
}

#pragma mark - Private

- (void)fadeInMessageView {
    if (![self.messages count]) {
        return;
    }

    if (self.isShowingMessageView) {
        return;
    }
    self.isShowingMessageView = YES;
    
    LSMessageView *currentView = self.messages[0];
    [currentView prepareToShow];

    dispatch_block_t animationBlock = ^{
        currentView.alpha = 1.0;
    };
    void(^completionBlock)(BOOL) = ^(BOOL finished) {
        currentView.isFullyDisplayed = YES;
    };
    
    [UIView animateWithDuration:kLSMessageAnimationDuration
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:animationBlock
                     completion:completionBlock];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       [self performSelector:@selector(fadeOutMessageView:)
                  withObject:currentView
                  afterDelay:currentView.duration];
    });
}

- (void)fadeOutMessageView:(LSMessageView *)messageView {
    messageView.isFullyDisplayed = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(fadeOutMessageView:)
                                               object:messageView];
    
    [UIView animateWithDuration:kLSMessageAnimationDuration animations:^{
         messageView.alpha = 0.0f;
     } completion:^(BOOL finished) {
         [messageView removeFromSuperview];
         
         if ([self.messages count] > 0) {
             [self.messages removeObjectAtIndex:0];
         }
         
         self.isShowingMessageView = NO;
         if ([self.messages count] > 0) {
             [self fadeInMessageView];
         }
     }];
}

- (void)dismissCurrentMessageView {
    if ([self.messages count] == 0) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.messages count] == 0) {
            return;
        }
        LSMessageView *currentMessage = self.messages[0];
        if (currentMessage.isFullyDisplayed) {
            [self fadeOutMessageView:currentMessage];
        }
    });
}

@end
