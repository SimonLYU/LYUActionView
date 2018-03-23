//
//  LYUActionView.m
//  TTFoundation
//
//  Created by 吕旭明 on 2017/11/16.
//  Copyright © 2017年 yiyou. All rights reserved.
//

#import "LYUActionView.h"
//#import "Log.h"

#pragma mark - EnumButtonStyle
typedef enum : NSUInteger
{
    kButtonStyleNormal,
    kButtonStyleCancel,
    kButtonStyleDestructive
} ButtonStyle;
typedef enum : NSUInteger
{
    kButtonRadiusPositionNone,
    kButtonRadiusPositionTop,
    kButtonRadiusPositionBottom,
    kButtonRadiusPositionBoth
} ButtonRadiusPosition;

#pragma mark - LYUActionViewButton
@interface LYUActionViewButton : NSObject
@property (nonatomic, strong) dispatch_block_t block;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) ButtonStyle style;
@end
@implementation LYUActionViewButton
+ (LYUActionViewButton *)block:(dispatch_block_t)block withTitle:(NSString *)title style:(ButtonStyle)style{
    LYUActionViewButton * button = [[LYUActionViewButton alloc] init];
    button.block = block;
    button.title = title;
    button.style = style;
    return button;
}
@end

#pragma mark - LYUActionViewCell
@interface LYUActionViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, assign) BOOL showSLine;
@property (nonatomic, strong) UIView *sLine;
@property (nonatomic, strong) UIColor *sLineColor;
@property (nonatomic, assign) ButtonRadiusPosition radiusPosition;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@end
@implementation LYUActionViewCell
#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor= self.textColor;
    self.titleLabel.font = self.textFont;
    [self addSubview:self.titleLabel];
    
    self.sLine = [[UIView alloc] init];
    self.sLine.hidden = YES;
    self.sLine.backgroundColor = self.sLineColor;
    [self addSubview:self.sLine];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
    self.sLine.frame = CGRectMake(0.5, self.bounds.size.height - 0.5, self.bounds.size.width - 0.5 * 2, 0.5);
    
    //corner radius
    if (self.radius <= 0) return;
    if (self.maskLayer) {
        [self.maskLayer removeFromSuperlayer];
    }
    switch (self.radiusPosition) {
        case kButtonRadiusPositionTop:
        {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(self.radius, self.radius)];
            CAShapeLayer *maskLayer= [[CAShapeLayer alloc] init];
            maskLayer.frame = self.bounds;
            maskLayer.path = maskPath.CGPath;
            self.layer.mask = maskLayer;
            self.maskLayer = maskLayer;
        }
            break;
        case kButtonRadiusPositionBottom:
        {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(self.radius, self.radius)];
            CAShapeLayer *maskLayer= [[CAShapeLayer alloc] init];
            maskLayer.frame = self.bounds;
            maskLayer.path = maskPath.CGPath;
            self.layer.mask = maskLayer;
            self.maskLayer = maskLayer;
        }
            break;
        case kButtonRadiusPositionBoth:
        {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerBottomLeft | UIRectCornerTopRight |UIRectCornerTopLeft cornerRadii:CGSizeMake(self.radius, self.radius)];
            CAShapeLayer *maskLayer= [[CAShapeLayer alloc] init];
            maskLayer.frame = self.bounds;
            maskLayer.path = maskPath.CGPath;
            self.layer.mask = maskLayer;
            self.maskLayer = maskLayer;
        }
            break;
        default:
            break;
    }
}
#pragma mark - setter and getter
- (void)setSLineColor:(UIColor *)sLineColor
{
    _sLineColor = sLineColor;
    self.sLine.backgroundColor = sLineColor;
}
- (void)setShowSLine:(BOOL)showSLine{
    _showSLine = showSLine;
    self.sLine.hidden = !showSLine;
}
- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.titleLabel.textColor = textColor;
}
- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    self.titleLabel.font = textFont;
}
@end

#pragma mark - LYUActionView
static NSString * actionViewCellId = @"actionViewCellIdentifier";
@interface LYUActionView()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic, strong) UIView *forwardView;
@property (nonatomic, strong) UIView *sourceView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UITableView *buttonsTableView;

@property (nonatomic, strong) NSMutableDictionary *blocksDictionary;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *cancelbuttonArray;
@property (nonatomic, strong) NSMutableArray *sectionIdArray;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CAShapeLayer *titleMaskLayer;

@end

@implementation LYUActionView
{
    UIFont * _titleFont;
    UIFont * _normalButtonFont;
    UIFont * _cancelButtonFont;
    UIFont * _destructiveButtonFont;
    UIColor * _titleColor;
    UIColor * _normalButtonColor;
    UIColor * _cancelButtonColor;
    UIColor * _destructiveButtonColor;
    UIColor * _titleBackgroundColor;
    UIColor * _normalButtonBackgroundColor;
    UIColor * _cancelButtonBackgroundColor;
    UIColor * _destructiveButtonBackgroundColor;
    CGFloat _leftPadding;
    CGFloat _buttonHeight;
    CGFloat _cancelButtonTopSpace;
}
@dynamic titleFont;
@dynamic normalButtonFont;
@dynamic cancelButtonFont;
@dynamic destructiveButtonFont;
@dynamic titleColor;
@dynamic normalButtonColor;
@dynamic cancelButtonColor;
@dynamic destructiveButtonColor;
@dynamic titleBackgroundColor;
@dynamic normalButtonBackgroundColor;
@dynamic cancelButtonBackgroundColor;
@dynamic destructiveButtonBackgroundColor;
@dynamic leftPadding;
@dynamic buttonHeight;
@dynamic cancelButtonTopSpace;

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.blocksDictionary = [NSMutableDictionary dictionary];
        self.buttonArray = [NSMutableArray array];
        self.cancelbuttonArray = [NSMutableArray array];
        self.sectionIdArray = [NSMutableArray array];
        self.cancelButtonTopAlpha = 1.0;
        self.cornerRadius = 0.f;
        self.bottomPadding = 0.f;
        self.coverAlpha = 0.3;
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *)title{
    if (self = [super init]) {
        self.title = title;
    }
    return self;
}

#pragma mark - show
static CGFloat titleLabelLeftPadding = 10;//titleLabel左侧右侧距离tableView的边距
static CGFloat titleLabelTopPadding = 20;//titleLabel上侧下侧距离tableView的边距
static NSString * normalButtonId = @"normalButtonIdentifier";
static NSString * cancelButtonId = @"cancelButtonIdentifier";
- (void)showInKeyWindow{
    [self showInView:[UIApplication sharedApplication].keyWindow];
}
- (void)showInView:(UIView*)sourceView{
    if (self.buttonArray.count > 0) [self.sectionIdArray addObject:normalButtonId];
    if (self.cancelbuttonArray.count > 0) [self.sectionIdArray addObject:cancelButtonId];
    //No button no show
    if (self.sectionIdArray <= 0) {
        return;
    }
    CGRect sourceFrame = sourceView.frame;
    CGFloat containerViewHeight = 0.f;
    
    //container height
    if (self.title && ![self.title isEqualToString:@""]) {
        //has title
        CGFloat titleLabelWidth = sourceFrame.size.width - self.leftPadding * 2 - titleLabelLeftPadding * 2;
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.font = self.titleFont;
        titleLabel.textColor = self.titleColor;
        titleLabel.numberOfLines = 0;
        titleLabel.text = self.title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        CGSize titleLabelSize = [titleLabel sizeThatFits:CGSizeMake(titleLabelWidth, MAXFLOAT)];
        titleLabel.frame = CGRectMake(titleLabelLeftPadding, titleLabelTopPadding, titleLabelWidth, titleLabelSize.height);
        self.titleLabel = titleLabel;
        containerViewHeight = containerViewHeight + titleLabelTopPadding * 2 + titleLabelSize.height;
    }
    if (self.buttonArray.count > 0) {
        containerViewHeight += self.buttonHeight * self.buttonArray.count;
    }
    if (self.cancelbuttonArray.count > 0) {
        containerViewHeight += self.buttonHeight * self.cancelbuttonArray.count;
    }
    if (self.buttonArray.count > 0 && self.cancelbuttonArray.count > 0) {
        containerViewHeight += self.cancelButtonTopSpace;
    }
    //bottom padding
    containerViewHeight += self.bottomPadding;
    
    //containerView
    self.forwardView = [[UIView alloc] initWithFrame:CGRectMake(0, sourceFrame.size.height - containerViewHeight, sourceFrame.size.width, containerViewHeight)];
    
    //buttons tableView
    UITableView * buttonsTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.leftPadding, 0, sourceFrame.size.width - self.leftPadding * 2, containerViewHeight)];
    buttonsTableView.delegate = self;
    buttonsTableView.dataSource = self;
    buttonsTableView.scrollEnabled = NO;
    buttonsTableView.backgroundColor = [UIColor clearColor];
    buttonsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [buttonsTableView registerClass:[LYUActionViewCell class] forCellReuseIdentifier:actionViewCellId];
    [self.forwardView addSubview:buttonsTableView];
    self.buttonsTableView = buttonsTableView;
    
    // self view is overlay view
    self.frame = sourceFrame;
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.backgroundColor = [UIColor clearColor];
    
    // backgroud view
    UIView *backgroundView = [[UIView alloc] initWithFrame:sourceFrame];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    backgroundView.backgroundColor = self.coverColor;
    backgroundView.alpha = 0;
    self.backgroundView = backgroundView;
    [self addSubview:backgroundView];
    
    // dismiss button view
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    dismissButton.backgroundColor = [UIColor clearColor];
    dismissButton.frame = sourceFrame;
    [dismissButton addTarget:self action:@selector(_onDismissButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dismissButton];
    
    // self view
    self.forwardView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:self.forwardView];
    
    // source view
    [sourceView addSubview:self];
    
    self.sourceView = sourceView;
    [self _slideViewIn];
    
}
#pragma mark - normal button
- (void)addButtonWithTitle:(NSString *)title block:(dispatch_block_t)block{
    LYUActionViewButton * ttActionButton = [LYUActionViewButton block:block withTitle:title style:kButtonStyleNormal];
    [self.blocksDictionary setObject:ttActionButton forKey:title];
    [self.buttonArray addObject:title];
}
#pragma mark - cancel button
- (void)addCancelButtonWithTitle:(NSString *)title{
    LYUActionViewButton * ttActionButton = [LYUActionViewButton block:nil withTitle:title style:kButtonStyleCancel];
    [self.blocksDictionary setObject:ttActionButton forKey:title];
    [self.cancelbuttonArray addObject:title];
}
- (void)addCancelButtonWithTitle:(NSString *)title block:(dispatch_block_t)block{
    LYUActionViewButton * ttActionButton = [LYUActionViewButton block:block withTitle:title style:kButtonStyleCancel];
    [self.blocksDictionary setObject:ttActionButton forKey:title];
    [self.cancelbuttonArray addObject:title];
}
#pragma mark - destructive button
- (void)addDestructiveButtonWithTitle:(NSString *)title block:(dispatch_block_t)block{
    LYUActionViewButton * ttActionButton = [LYUActionViewButton block:block withTitle:title style:kButtonStyleDestructive];
    [self.blocksDictionary setObject:ttActionButton forKey:title];
    [self.buttonArray addObject:title];
}
#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionIdArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * sectionId = [self.sectionIdArray objectAtIndex:section];
    if ([sectionId isEqualToString:normalButtonId]) {
        return self.buttonArray.count;
    }
    if ([sectionId isEqualToString:cancelButtonId]) {
        return self.cancelbuttonArray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * sectionId = [self.sectionIdArray objectAtIndex:indexPath.section];
    NSString * title = nil;
    UIFont * textFont = nil;
    UIColor * textColor = nil;
    UIColor * backgroundColor = nil;
    ButtonRadiusPosition radiusPosition = kButtonRadiusPositionNone;
    BOOL showSLine = NO;
    if ([sectionId isEqualToString:normalButtonId]) {
        title = [self.buttonArray objectAtIndex:indexPath.row];
        if (indexPath.row >= self.buttonArray.count - 1) {
            showSLine = NO;
        }else{
            showSLine = YES;
        }
    }
    if ([sectionId isEqualToString:cancelButtonId]) {
        title = [self.cancelbuttonArray objectAtIndex:indexPath.row];
        if (indexPath.row >= self.cancelbuttonArray.count - 1) {
            showSLine = NO;
        }else{
            showSLine = YES;
        }
    }
    
    LYUActionViewButton * actionButton = [self.blocksDictionary objectForKey:title];
    switch (actionButton.style) {
        case kButtonStyleNormal:
        {
            textFont = self.normalButtonFont;
            textColor = self.normalButtonColor;
            backgroundColor = self.normalButtonBackgroundColor;
            if (self.buttonArray.count == 1) {
                radiusPosition = kButtonRadiusPositionBoth;
            }else if(indexPath.row == 0){
                radiusPosition = self.titleLabel ? kButtonRadiusPositionNone : kButtonRadiusPositionTop;
            }else if(indexPath.row >= self.cancelbuttonArray.count - 1){
                radiusPosition = kButtonRadiusPositionBottom;
            }
        }
            break;
        case kButtonStyleCancel:
        {
            textFont = self.cancelButtonFont;
            textColor = self.cancelButtonColor;
            backgroundColor = self.cancelButtonBackgroundColor;
            if (self.cancelbuttonArray.count == 1) {
                radiusPosition = kButtonRadiusPositionBoth;
            }else if(indexPath.row == 0){
                radiusPosition = self.titleLabel ? kButtonRadiusPositionNone : kButtonRadiusPositionTop;
            }else if(indexPath.row >= self.cancelbuttonArray.count - 1){
                radiusPosition = kButtonRadiusPositionBottom;
            }
        }
            break;
        case kButtonStyleDestructive:
        {
            textFont = self.destructiveButtonFont;
            textColor = self.destructiveButtonColor;
            backgroundColor = self.destructiveButtonBackgroundColor;
            if (self.buttonArray.count == 1) {
                radiusPosition = kButtonRadiusPositionBoth;
            }else if(indexPath.row == 0){
                radiusPosition = self.titleLabel ? kButtonRadiusPositionNone : kButtonRadiusPositionTop;
            }else if(indexPath.row >= self.cancelbuttonArray.count - 1){
                radiusPosition = kButtonRadiusPositionBottom;
            }
        }
            break;
        default:
            break;
    }

    LYUActionViewCell * cell = [tableView dequeueReusableCellWithIdentifier:actionViewCellId];
    cell.titleLabel.text = title;
    cell.textColor = textColor;
    cell.textFont = textFont;
    cell.showSLine = showSLine;
    cell.backgroundColor = backgroundColor;
    cell.radius = self.cornerRadius > self.buttonHeight * 0.5 ? self.buttonHeight * 0.5 : self.cornerRadius;
    cell.radiusPosition = radiusPosition;
    cell.sLineColor = self.sLineColor;
    return cell;
}
#pragma mark - tableview delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0://first header
        {
            if (self.titleLabel) {
                UIView * titleContainerView = [[UIView alloc] init];
                //title mask
                UIView * titleMaskView = [[UIView alloc] init];
                titleMaskView.frame = CGRectMake(0, 0, tableView.bounds.size.width, self.titleLabel.frame.size.height + titleLabelTopPadding * 2);
                titleMaskView.backgroundColor = self.titleBackgroundColor;
                [titleContainerView addSubview:titleMaskView];
                [titleMaskView addSubview:self.titleLabel];
                if (self.titleMaskLayer) {
                    [self.titleMaskLayer removeFromSuperlayer];
                }
                CGFloat radius = self.cornerRadius;
                if (radius > self.buttonHeight * 0.5) {
                    radius = self.buttonHeight * 0.5;
                }
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:titleMaskView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(radius,radius)];
                CAShapeLayer *maskLayer= [[CAShapeLayer alloc] init];
                maskLayer.frame = self.bounds;
                maskLayer.path = maskPath.CGPath;
                titleMaskView.layer.mask = maskLayer;
                self.titleMaskLayer = maskLayer;
                //sline
                UIView * sLine = [[UIView alloc] init];
                sLine.backgroundColor = self.sLineColor;
                sLine.frame = CGRectMake(0.5, titleMaskView.bounds.size.height - 0.5, titleMaskView.bounds.size.width - 0.5 * 2, 0.5);
                [titleMaskView addSubview:sLine];
                
                return titleContainerView;
            }
        }
            break;
        default:
            break;
    }
    UIView * spaceView = [[UIView alloc] init];
    spaceView.alpha = self.cancelButtonTopAlpha;
    return spaceView;//others header
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0://first header height
        {
            return self.titleLabel ? self.titleLabel.frame.size.height + titleLabelTopPadding * 2 : 0.f;
        }
            break;
        default:
            break;
    }
    return self.sectionIdArray.count > 1 ? self.cancelButtonTopSpace : 0.f;//others header height
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.buttonHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * sectionId = [self.sectionIdArray objectAtIndex:indexPath.section];
    NSString * buttonKey = nil;
    if ([sectionId isEqualToString:normalButtonId]) {
        buttonKey = [self.buttonArray objectAtIndex:indexPath.row];
    }
    if ([sectionId isEqualToString:cancelButtonId]) {
        buttonKey = [self.cancelbuttonArray objectAtIndex:indexPath.row];
    }
    LYUActionViewButton * actionButton = [self.blocksDictionary objectForKey:buttonKey];
    if (actionButton.block) {
        actionButton.block();
    }else{
        //actionButton.block is nil ,may be click cancel button!
    }
    [self _slideViewOut];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - getter and setter
#pragma mark font
- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
}
- (UIFont *)titleFont{
    return _titleFont ?: [UIFont systemFontOfSize:12];
}
- (void)setNormalButtonFont:(UIFont *)normalButtonFont
{
    _normalButtonFont = normalButtonFont;
}
- (UIFont *)normalButtonFont
{
    return _normalButtonFont ?: [UIFont systemFontOfSize:15];
}
- (void)setCancelButtonFont:(UIFont *)cancelButtonFont
{
    _cancelButtonFont = cancelButtonFont;
}
- (UIFont *)cancelButtonFont
{
    return _cancelButtonFont ?: [UIFont boldSystemFontOfSize:15];
}
- (void)setDestructiveButtonFont:(UIFont *)destructiveButtonFont
{
    _destructiveButtonFont = destructiveButtonFont;
}
- (UIFont *)destructiveButtonFont
{
    return _destructiveButtonFont ?: [UIFont boldSystemFontOfSize:15];
}
#pragma mark color
- (void)setTitleBackgroundColor:(UIColor *)titleBackgroundColor
{
    _titleBackgroundColor = titleBackgroundColor;
}
- (UIColor *)titleBackgroundColor
{
    return _titleBackgroundColor ?: [UIColor whiteColor];
}
- (void)setNormalButtonBackgroundColor:(UIColor *)normalButtonBackgroundColor
{
    _normalButtonBackgroundColor = normalButtonBackgroundColor;
}
- (UIColor *)normalButtonBackgroundColor
{
    return _normalButtonBackgroundColor ?: [UIColor whiteColor];
}
- (void)setCancelButtonBackgroundColor:(UIColor *)cancelButtonBackgroundColor
{
    _cancelButtonBackgroundColor = cancelButtonBackgroundColor;
}
- (UIColor *)cancelButtonBackgroundColor
{
    return _cancelButtonBackgroundColor ?: [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.f];
}
- (void)setDestructiveButtonBackgroundColor:(UIColor *)destructiveButtonBackgroundColor
{
    _destructiveButtonBackgroundColor = destructiveButtonBackgroundColor;
}
- (UIColor *)destructiveButtonBackgroundColor
{
    return _destructiveButtonBackgroundColor ?: [UIColor whiteColor];
}
- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
}
- (UIColor *)titleColor
{
    return _titleColor ?: [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:1];
}
- (void)setNormalButtonColor:(UIColor *)normalButtonColor
{
    _normalButtonColor = normalButtonColor;
}
- (UIColor *)normalButtonColor
{
    return _normalButtonColor ?: [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:1];
}
- (void)setCancelButtonColor:(UIColor *)cancelButtonColor
{
    _cancelButtonColor = cancelButtonColor;
}
- (UIColor *)cancelButtonColor
{
    return _cancelButtonColor ?: [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:1];
}
- (void)setDestructiveButtonColor:(UIColor *)destructiveButtonColor
{
    _destructiveButtonColor = destructiveButtonColor;
}
- (UIColor *)destructiveButtonColor
{
    return _destructiveButtonColor ?: [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:1];
}
- (UIColor *)sLineColor
{
    return _sLineColor ?: [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
}
- (UIColor *)coverColor
{
    return _coverColor ?: [UIColor blackColor];
}
#pragma mark space and padding
- (void)setCancelButtonTopSpace:(CGFloat)cancelButtonTopSpace
{
    _cancelButtonTopSpace = cancelButtonTopSpace;
}
- (CGFloat)cancelButtonTopSpace
{
    return _cancelButtonTopSpace ?: 0;
}
- (void)setButtonHeight:(CGFloat)buttonHeight
{
    _buttonHeight = buttonHeight;
}
- (CGFloat)buttonHeight
{
    return _buttonHeight ?: 48;
}
- (void)setLeftPadding:(CGFloat)leftPadding
{
    _leftPadding = leftPadding;
}
- (CGFloat)leftPadding
{
    return _leftPadding ?: 0;
}
#pragma mark - private
- (void)_slideViewIn
{
    if (!self.backgroundView) {
        return;
    }
    
    CGSize sourceViewSize = self.sourceView.bounds.size;
    CGSize forwardViewSize = self.forwardView.bounds.size;
    CGRect presentStartRect = CGRectMake(0, sourceViewSize.height, sourceViewSize.width, forwardViewSize.height);
    CGRect presentEndRect = CGRectMake(0, sourceViewSize.height - forwardViewSize.height, sourceViewSize.width, forwardViewSize.height);
    
    self.forwardView.frame = presentStartRect;
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundView.alpha = self.coverAlpha;
        self.forwardView.frame = presentEndRect;
    } completion:^(BOOL finished) {
    }];
}

- (void)_slideViewOut
{
    if (!self.backgroundView) {
        return;
    }
    
    CGSize sourceViewSize = self.sourceView.bounds.size;
    CGSize forwardViewSize = self.forwardView.bounds.size;
    CGRect presentEndRect = CGRectMake(0, sourceViewSize.height, sourceViewSize.width, forwardViewSize.height);
    
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.backgroundView.alpha = 0.0f;
        self.forwardView.frame = presentEndRect;
    } completion:^(BOOL finished) {
        [self.forwardView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)_onDismissButtonTapped:(id)sender
{
    [self _slideViewOut];
}

@end
