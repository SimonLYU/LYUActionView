//
//  LYUActionView.h
//  TTFoundation
//
//  Created by 吕旭明 on 2017/11/16.
//  Copyright © 2017年 yiyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYUActionView : UIView
//font
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *normalButtonFont;
@property (nonatomic, strong) UIFont *cancelButtonFont;
@property (nonatomic, strong) UIFont *destructiveButtonFont;
//text color
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *normalButtonColor;
@property (nonatomic, strong) UIColor *cancelButtonColor;
@property (nonatomic, strong) UIColor *destructiveButtonColor;
//background color
@property (nonatomic, strong) UIColor *titleBackgroundColor;
@property (nonatomic, strong) UIColor *normalButtonBackgroundColor;
@property (nonatomic, strong) UIColor *cancelButtonBackgroundColor;
@property (nonatomic, strong) UIColor *destructiveButtonBackgroundColor;
//sLine color
@property (nonatomic, strong) UIColor *sLineColor;
//cover color
@property (nonatomic, strong) UIColor *coverColor;
@property (nonatomic, assign) CGFloat coverAlpha;
//space and radius
@property (nonatomic, assign) CGFloat leftPadding;//控件两端的边距
@property (nonatomic, assign) CGFloat bottomPadding;//控件底部的边距
@property (nonatomic, assign) CGFloat buttonHeight;//每个按钮的高度
@property (nonatomic, assign) CGFloat cancelButtonTopSpace;//取消类型的按钮去普通按钮之间的间距
@property (nonatomic, assign) CGFloat cancelButtonTopAlpha;//取消类型的按钮去普通按钮之间间距的透明度
@property (nonatomic, assign) CGFloat cornerRadius;//圆角

- (instancetype)initWithTitle:(NSString *)title;

- (void)showInKeyWindow;
- (void)showInView:(UIView*)sourceView;
- (void)addButtonWithTitle:(NSString *)title block:(dispatch_block_t)block;
- (void)addCancelButtonWithTitle:(NSString *)title;
- (void)addCancelButtonWithTitle:(NSString *)title block:(dispatch_block_t)block;
- (void)addDestructiveButtonWithTitle:(NSString *)title block:(dispatch_block_t)block;

@end
