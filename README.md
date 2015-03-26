# LSMessageHUD
Easy to use and customizable messages/notifications HUD for iOS, supports simple strings or attributed strings.

## Example

![LSMessageHUD Example1](https://github.com/tinymind/LSMessageHUD/raw/master/Example.gif)  

## Features

- Keyboard height adjust.
- Portait/Landscape orientation adjust.
- Easy to custom.

## Installation

LSMessageHUD is available through [CocoaPods](http://cocoapods.org/), add the following line to your Podfile:

```
pod 'LSMessageHUD'
```

## Requirements

Requires iOS 7.0 and above, ARC.

## Usage

### Simple message

``` objective-c

  #import "LSMessageHUD.h"

  - (void)onMessageTapped:(id)sender {
  
    //show without title
    [LSMessageHUD showWithMessage:@"Hello, LSMessageHUD"];

    //show with title    
    [LSMessageHUD showWithMessage:@"Hello, LSMessageHUD" title:@"Test"];
  }
  
```

### Attributed message

``` objective-c

  #import "LSMessageHUD.h"

  - (void)onMessageTapped:(id)sender {
  
    NSMutableAttributedString *attrMsg = [[NSMutableAttributedString alloc] initWithString:@"Do any additional setup after loading the view, typically from a nib."];
    [attrMsg addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(0, 6)];
    [attrMsg addAttributes:@{NSForegroundColorAttributeName : [UIColor greenColor]} range:NSMakeRange(24, 13)];
    
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:@"Note"];
    [attrTitle addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20.0]} range:NSMakeRange(0, attrTitle.length)];

    [LSMessageHUD showWithAttributedMessage:attrMsg title:nil duration:1.5 canBeDismissed:YES];
    
    [LSMessageHUD showWithAttributedMessage:attrMsg title:attrTitle duration:1.5 canBeDismissed:YES];
  }
  
```

## Customizable

``` objective-c

@property (strong, nonatomic) UIFont *defaultTitleFont;              /**< default is systemFont with 16.0 */
@property (strong, nonatomic) UIFont *defaultMessageFont;            /**< default is systemFont with 14.0 */
@property (strong, nonatomic) UIColor *defaultTitleTextColor;        /**< default is white color */
@property (strong, nonatomic) UIColor *defaultMessageTextColor;      /**< default is white color */
@property (strong, nonatomic) UIColor *backgroundColor;              /**< default is RGBA(0, 0, 0, 0.8) */

@property (assign, nonatomic) UIEdgeInsets messageContentInsets;     /**< default is (10, 10, 10, 10) */
@property (assign, nonatomic) CGFloat messageCornerRadius;           /**< default is 6.0 */

@property (assign, nonatomic) CGFloat messageViewVerticalOffsetRate; /**< default is 0.5, vertical center */
@property (assign, nonatomic) NSTimeInterval defaultDuration;        /**< default is 2.0 */

```
