//
//  ViewController.m
//  LYUActionViewDemo
//
//  Created by 吕旭明 on 2018/3/23.
//  Copyright © 2018年 吕旭明. All rights reserved.
//

#import "ViewController.h"
#import "LYUActionView.h"

@interface ViewController ()
@property (nonatomic, strong) LYUActionView *actionView;
@property (nonatomic, strong) LYUActionView *sysActionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)onTestClicked:(id)sender {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.actionView =  [[LYUActionView alloc] initWithTitle:@""];
        [self.actionView addButtonWithTitle:@"第一个选项" block:^{
            NSLog(@"选择:第一个选项");
        }];
        [self.actionView addButtonWithTitle:@"第一个选项" block:^{
            NSLog(@"选择:第二个选项");
        }];
        [self.actionView addCancelButtonWithTitle:@"取消选项"];
        //        //硬适配iphoneX
        //        self.actionView.bottomPadding = 44;
    });
    
    [self.actionView showInView:self.view];
}
- (IBAction)onSystemTestClicked:(id)sender {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.sysActionView =  [[LYUActionView alloc] initWithTitle:@"ACTION标题,当然,这个标题的名字可以起的很长很长很长,标题控件的高度会被标题文字的高度撑起来"];
        [self.sysActionView addButtonWithTitle:@"第一个选项" block:^{
            NSLog(@"选择:第一个选项");
        }];
        [self.sysActionView addButtonWithTitle:@"第一个选项" block:^{
            NSLog(@"选择:第二个选项");
        }];
        [self.sysActionView addCancelButtonWithTitle:@"取消选项"];
        self.sysActionView.titleBackgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        self.sysActionView.titleColor = [UIColor grayColor];
        self.sysActionView.leftPadding = 10;
        self.sysActionView.buttonHeight = 44;
        self.sysActionView.cancelButtonTopSpace = 10;
        self.sysActionView.cancelButtonTopAlpha = 0.6;
        self.sysActionView.cornerRadius = MAXFLOAT;
        self.sysActionView.bottomPadding = 10;
    });
    
    [self.sysActionView showInView:self.view];
}

@end
