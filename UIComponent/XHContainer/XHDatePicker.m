//
//  XHDatePicker.m
//  BSGrowthViewing
//
//  Created by 向洪 on 2017/8/15.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHDatePicker.h"
#import "UIImage+XHColor.h"

#define ContentDatePicker_Height 216.f
#define TitleLabel_Height 46.f
#define DetermineButton_Height 46.f
#define WGrayColor [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.000]

@interface XHDatePicker ()

@property (nonatomic, strong) UIDatePicker *contentDatePicker;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *determineButton;

@end

@implementation XHDatePicker

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithSize:(CGSize)size style:(XHContainerStyle)style {

    self = [super initWithSize:CGSizeMake(size.width, ContentDatePicker_Height + TitleLabel_Height + DetermineButton_Height) style:style];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    self.clipsToBounds = YES;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.alpha = 0.6;
    _titleLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:_titleLabel];
    
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *titleLabelConstraints = [NSMutableArray array];
    [titleLabelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_titleLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    [titleLabelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[_titleLabel(%lf)]", TitleLabel_Height] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    [self addConstraints:titleLabelConstraints];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = WGrayColor;
    [self addSubview:line1];
    line1.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *lineConstraints = [NSMutableArray array];
    [lineConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[line1]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line1)]];
    [lineConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%lf-[line1(0.5)]", TitleLabel_Height] options:0 metrics:nil views:NSDictionaryOfVariableBindings(line1)]];
    [self addConstraints:lineConstraints];
 
    
    _contentDatePicker = [[UIDatePicker alloc] init];
    //    _contentDatePicker.backgroundColor = [UIColor clearColor];
    [_contentDatePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [_contentDatePicker setDatePickerMode:UIDatePickerModeDate];
    NSTimeZone * zone = [NSTimeZone defaultTimeZone];
    [_contentDatePicker setTimeZone:zone];
    [_contentDatePicker addTarget:self action:@selector(datePickerHandelEvent:) forControlEvents:UIControlEventValueChanged];
//    NSDate *date = [NSDate date];
//    NSInteger interval = [zone secondsFromGMTForDate:date];
//    _contentDatePicker.maximumDate = [date dateByAddingTimeInterval:interval];
    [self addSubview:_contentDatePicker];
    _contentDatePicker.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *contentDatePickerConstraints = [NSMutableArray array];
    [contentDatePickerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentDatePicker]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentDatePicker)]];
    [contentDatePickerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%lf-[_contentDatePicker]-%lf-|", TitleLabel_Height, DetermineButton_Height] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentDatePicker)]];
    [self addConstraints:contentDatePickerConstraints];

    
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = WGrayColor;
    [self addSubview:line2];
    line2.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *line2Constraints = [NSMutableArray array];
    [line2Constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[line2]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line2)]];
    [line2Constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[line2(0.5)]-%lf-|", DetermineButton_Height] options:0 metrics:nil views:NSDictionaryOfVariableBindings(line2)]];
    [self addConstraints:line2Constraints];
    
    
    _determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _determineButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_determineButton setTitle:@"完成" forState:UIControlStateNormal];
    [_determineButton setTitleColor:[UIColor colorWithWhite:0 alpha:1] forState:UIControlStateNormal];
    [_determineButton setTitleColor:[UIColor colorWithWhite:0 alpha:0.8] forState:UIControlStateHighlighted];
    [_determineButton setBackgroundImage:[UIImage xh_imageWithColor:[UIColor colorWithWhite:0.9 alpha:1]] forState:UIControlStateHighlighted];
    [_determineButton addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_determineButton];
    _determineButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *determineButtonConstraints = [NSMutableArray array];
    [determineButtonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_determineButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_determineButton)]];
    [determineButtonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[_determineButton(%lf)]|", DetermineButton_Height] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_determineButton)]];
    [self addConstraints:determineButtonConstraints];
    
}

#pragma mark - Ovrri Methods

- (void)show:(UIView *)displayView {

    [super show:displayView];
    _titleLabel.text = [self stringDateForDate:self.contentDatePicker.date];
    __weak __typeof(self)weakSelf = self;
    [_contentDatePicker.subviews[0].subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx != 0) {
            
            obj.backgroundColor = weakSelf.tintColor;
        }
        
    }];

}

- (void)hide {
    
    [super hide];
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(XHDatePickerDelegate)] && [self.delegate respondsToSelector:@selector(xh_datePicker:didConfirmDisappear:)]) {
        
        [self.delegate xh_datePicker:self didConfirmDisappear:NO];
    }
    
}

#pragma mark - Action Methods

- (void)datePickerHandelEvent:(UIDatePicker *)contentDatePicker {

    _titleLabel.text = [self stringDateForDate:contentDatePicker.date];
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(XHDatePickerDelegate)] && [self.delegate respondsToSelector:@selector(xh_datePicker:didSelectedAtDate:)]) {
        
        [self.delegate xh_datePicker:self didSelectedAtDate:contentDatePicker.date];
    }
}

- (void)handleEvent:(UIButton *)sender {

    if (self.delegate && [self.delegate conformsToProtocol:@protocol(XHDatePickerDelegate)] && [self.delegate respondsToSelector:@selector(xh_datePicker:didConfirmDisappear:)]) {
        
        [self.delegate xh_datePicker:self didConfirmDisappear:YES];
    }
    [super hide];
}


#pragma mark  - Private Methods

- (NSString *)stringDateForDate:(NSDate *)date {
    
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];
    NSUInteger currentWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:date];
    NSArray * array = @[@"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", @"星期日"];
    return [NSString stringWithFormat:@"  %@ %@",[formater stringFromDate:date], array[currentWeekday - 1]];
}

#pragma mark - getter
- (void)setTintColor:(UIColor *)tintColor {

    _tintColor = tintColor;
    __weak __typeof(self)weakSelf = self;
    [_contentDatePicker.subviews[0].subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            obj.backgroundColor = weakSelf.tintColor;
        }
    }];
}

- (NSDate *)currentDate {
    return _contentDatePicker.date;
}

- (void)setCurrentDate:(NSDate *)currentDate {
    if (currentDate) {
        self.contentDatePicker.date = currentDate;
    }
}

- (void)setStyle:(XHContainerStyle)style {
    [super setStyle:style];
    if (style == XHContainerBottom) {
        self.layer.cornerRadius = 0;
    } else {
        self.layer.cornerRadius = 5;
    }
}


@end
