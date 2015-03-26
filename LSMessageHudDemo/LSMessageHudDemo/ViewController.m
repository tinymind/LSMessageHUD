//
//  ViewController.m
//  LSMessageHudDemo
//
//  Created by lslin on 15/3/26.
//  Copyright (c) 2015年 lessfun.com. All rights reserved.
//

#import "ViewController.h"
#import "LSMessageHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onShowMessage1Pressed:(id)sender {
    [LSMessageHUD showWithMessage:@"Hello, LSMessageHUD"];
    
    [LSMessageHUD showWithMessage:@"Hello, LSMessageHUD" title:@"Test"];
}

- (IBAction)onShowMessage2Pressed:(id)sender {
    NSMutableAttributedString *attrMsg = [[NSMutableAttributedString alloc] initWithString:@"Do any additional setup after loading the view, typically from a nib."];
    [attrMsg addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(0, 6)];
    [attrMsg addAttributes:@{NSForegroundColorAttributeName : [UIColor greenColor]} range:NSMakeRange(24, 13)];
    
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:@"Note"];
    [attrTitle addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20.0]} range:NSMakeRange(0, attrTitle.length)];

    [LSMessageHUD showWithAttributedMessage:attrMsg title:nil duration:1.5 canBeDismissed:YES];
    
    [LSMessageHUD showWithAttributedMessage:attrMsg title:attrTitle duration:1.5 canBeDismissed:YES];
}

@end
