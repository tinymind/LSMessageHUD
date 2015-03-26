//
//  LSMessageView.m
//  LSMessageHudDemo
//
//  Created by lslin on 15/3/26.
//  Copyright (c) 2015年 lessfun.com. All rights reserved.
//

#import "LSMessageView.h"
#import "LSMessageHUD.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat kLSMessageLabelMaxWidth = 160.0;
static const CGFloat kLSMessageLabelSpacing = 6.0;

@interface LSMessageView ()

@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIFont *messageFont;
@property (strong, nonatomic) UIColor *titleTextColor;
@property (strong, nonatomic) UIColor *messageTextColor;

@property (assign, nonatomic) UIEdgeInsets contentInsets;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (assign, nonatomic) CGFloat verticalOffsetRate;
@property (assign, nonatomic) BOOL canBeDismissed;

@property (strong, nonatomic) NSAttributedString *message;
@property (strong, nonatomic) NSAttributedString *title;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation LSMessageView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
             verticalOffsetRate:(CGFloat)verticalOffsetRate {
    if (self = [super init]) {
        _message = message;
        _title = title;
        _duration = duration;
        _canBeDismissed = canBeDismissed;
        
        _titleFont = titleFont;
        _titleTextColor = titleTextColor;
        _messageFont = messageFont;
        _messageTextColor = messageTextColor;
        _contentInsets = contentInsets;
        _cornerRadius = cornerRadius;
        if (0 < verticalOffsetRate && verticalOffsetRate < 1) {
            _verticalOffsetRate = verticalOffsetRate;
        } else {
            _verticalOffsetRate = 0.5;
        }
        
        [self commonSetup];
    }
    return self;
}

- (void)prepareToShow {
    UIWindow *topWindow = [self topWinow];
    [topWindow addSubview:self];
    [self positionView:nil];
}

#pragma mark - Action

- (void)onDissmissTap:(id)sender {
    [self fadeMeOut];
}

#pragma mark - Notification

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionView:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionView:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionView:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionView:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionView:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

#pragma mark - Private

- (void)commonSetup {
    self.alpha = 0.0f;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.cornerRadius;
    
    self.titleLabel = [self createLabelWithFont:self.titleFont color:self.titleTextColor attributedText:self.title];
    self.messageLabel = [self createLabelWithFont:self.messageFont color:self.messageTextColor attributedText:self.message];
    [self addSubview:self.titleLabel];
    [self addSubview:self.messageLabel];
    
    if (self.canBeDismissed) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDissmissTap:)];
        [self addGestureRecognizer:tap];
    }

    [self updateMessageView];
    [self registerNotifications];
}

- (UILabel *)createLabelWithFont:(UIFont *)font color:(UIColor *)color attributedText:(NSAttributedString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    
    if (font) {
        label.font = font;
    }
    if (color) {
        label.textColor = color;
    }
    if (text.length) {
        label.attributedText = text;
    }
    return label;
}

- (void)updateMessageView {
    CGFloat spacing = 0;
    if (self.title.length) {
        self.titleLabel.frame = CGRectMake(self.contentInsets.left,
                                           self.contentInsets.top,
                                           kLSMessageLabelMaxWidth,
                                           0.0);
        [self.titleLabel sizeToFit];
        
        spacing = kLSMessageLabelSpacing;
    }
    
    if (self.message.length) {
        self.messageLabel.frame = CGRectMake(self.contentInsets.left,
                                             self.contentInsets.top,
                                             kLSMessageLabelMaxWidth,
                                             0.0);
        [self.messageLabel sizeToFit];
    }
    
    CGFloat actualWidth = MAX(CGRectGetWidth(self.titleLabel.frame), CGRectGetWidth(self.messageLabel.frame)) + self.contentInsets.left + self.contentInsets.right;
    CGFloat actualHeight = CGRectGetHeight(self.titleLabel.frame) + CGRectGetHeight(self.messageLabel.frame) + self.contentInsets.top + self.contentInsets.bottom + spacing;
    
    CGRect labelFrame = self.titleLabel.frame;
    if (self.title.length) {
        labelFrame.origin.x = (actualWidth - CGRectGetWidth(labelFrame)) / 2.0;
        self.titleLabel.frame = labelFrame;
    }
    
    if (self.message.length) {
        labelFrame = self.messageLabel.frame;
        labelFrame.origin.x = (actualWidth - CGRectGetWidth(labelFrame)) / 2.0;
        labelFrame.origin.y = self.contentInsets.top + CGRectGetHeight(self.titleLabel.frame) + spacing;
        self.messageLabel.frame = labelFrame;
    }
    
    self.frame = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
}

- (UIWindow *)topWinow {
    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        if (window.windowLevel == UIWindowLevelNormal) {
            return window;
        }
    }
    return nil;
}

- (CGFloat)visibleKeyboardHeight {
    
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if(![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    for (__strong UIView *possibleKeyboard in [keyboardWindow subviews]) {
        // iOS 8
        if([possibleKeyboard isKindOfClass:NSClassFromString(@"UIInputSetContainerView")]) {
            for (__strong UIView *keyboard in [possibleKeyboard subviews]) {
                if([keyboard isKindOfClass:NSClassFromString(@"UIInputSetHostView")]) {
                    return keyboard.bounds.size.height;
                }
            }
        }
        // iOS 7
        else if([possibleKeyboard isKindOfClass:NSClassFromString(@"UIPeripheralHostView")] || [possibleKeyboard isKindOfClass:NSClassFromString(@"UIKeyboard")]) {
            return possibleKeyboard.bounds.size.height;
        }
    }
    
    return 0;
}

- (void)positionView:(NSNotification*)notification {
    CGFloat keyboardHeight = 0;
    CGFloat animationDuration = 0.4;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL ignoreOrientation = NO;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[NSProcessInfo processInfo] respondsToSelector:@selector(operatingSystemVersion)]) {
        ignoreOrientation = YES;
    }
#endif
    
    if(notification) {
        NSDictionary* keyboardInfo = [notification userInfo];
        CGRect keyboardFrame = [[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        animationDuration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        if(notification.name == UIKeyboardWillShowNotification || notification.name == UIKeyboardDidShowNotification) {
            if(ignoreOrientation || UIInterfaceOrientationIsPortrait(orientation)) {
                keyboardHeight = keyboardFrame.size.height;
            } else {
                keyboardHeight = keyboardFrame.size.width;
            }
        } else {
            keyboardHeight = 0;
        }
    } else {
        keyboardHeight = [self visibleKeyboardHeight];
    }
    
    CGRect orientationFrame = self.window.bounds;
    
    if(!ignoreOrientation && UIInterfaceOrientationIsLandscape(orientation)) {
        float temp = orientationFrame.size.width;
        orientationFrame.size.width = orientationFrame.size.height;
        orientationFrame.size.height = temp;
    }
    
    CGFloat activeHeight = orientationFrame.size.height - keyboardHeight;
    
    CGFloat posY = floor(activeHeight * self.verticalOffsetRate);
    CGFloat posX = orientationFrame.size.width / 2;
    
    CGPoint newCenter;
    CGFloat rotateAngle;
    
    if (ignoreOrientation) {
        rotateAngle = 0.0;
        newCenter = CGPointMake(posX, posY);
    } else {
        switch (orientation) {
            case UIInterfaceOrientationPortraitUpsideDown:
                rotateAngle = M_PI;
                newCenter = CGPointMake(posX, orientationFrame.size.height-posY);
                break;
            case UIInterfaceOrientationLandscapeLeft:
                rotateAngle = -M_PI/2.0f;
                newCenter = CGPointMake(posY, posX);
                break;
            case UIInterfaceOrientationLandscapeRight:
                rotateAngle = M_PI/2.0f;
                newCenter = CGPointMake(orientationFrame.size.height-posY, posX);
                break;
            default: // as UIInterfaceOrientationPortrait
                rotateAngle = 0.0;
                newCenter = CGPointMake(posX, posY);
                break;
        }
    }
    
    if(notification) {
        [UIView animateWithDuration:animationDuration
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             [self moveToPoint:newCenter rotateAngle:rotateAngle];
                         } completion:NULL];
    } else {
        [self moveToPoint:newCenter rotateAngle:rotateAngle];
    }
}

- (void)moveToPoint:(CGPoint)newCenter rotateAngle:(CGFloat)angle {
    self.transform = CGAffineTransformMakeRotation(angle);
    self.center = newCenter;
}

- (void)fadeMeOut {
    [LSMessageHUD dismissActiveMessageView];
}

@end
