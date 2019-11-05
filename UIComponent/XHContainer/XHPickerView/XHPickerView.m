//
//  XHPickerView.m
//  BSGrowthViewing
//
//  Created by 向洪 on 2017/8/16.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHPickerView.h"

#define ContentPickerView_Height 216.f
#define DetermineButton_Height 46.f
#define WGrayColor [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.000]
#define IsDataSource(a) self.dataSource && [self.dataSource conformsToProtocol:@protocol(XHPickerViewDataSource)] && [self.dataSource respondsToSelector:@selector(a)]

@interface XHPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *contentPickerView;

@property (nonatomic, strong) UIButton *determineButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIView *line2;

@property (nonatomic, strong) NSMutableArray *textLabelConstraintsCache;
@property (nonatomic, strong) NSMutableArray *contentPickerViewConstraintsCache;
@property (nonatomic, strong) NSMutableArray *determineButtonConstraintsCache;

@end

@implementation XHPickerView


- (instancetype)initWithSize:(CGSize)size style:(XHContainerStyle)style {

    self = [super initWithSize:CGSizeMake(size.width, ContentPickerView_Height + DetermineButton_Height + 50) style:style];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {

    self.clipsToBounds = YES;
    _tintColor = WGrayColor;
    _determineButtonConstraintsCache = [NSMutableArray array];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _textLabel.font = [UIFont boldSystemFontOfSize:17];
    _textLabel.text = @"请选择";
    _textLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:_textLabel];
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *textLabelConstraints = [NSMutableArray array];
    [textLabelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[_textLabel]-16-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textLabel)]];
    [textLabelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_textLabel(20)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textLabel)]];
    [self addConstraints:textLabelConstraints];
    
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = WGrayColor;
    [self addSubview:line1];
    line1.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *lineConstraints = [NSMutableArray array];
    [lineConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[line1]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line1)]];
    [lineConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%lf-[line1(0.5)]", 49.5] options:0 metrics:nil views:NSDictionaryOfVariableBindings(line1)]];
    [self addConstraints:lineConstraints];
    
    _contentPickerView = [[UIPickerView alloc] init];
    _contentPickerView.delegate = self;
    _contentPickerView.dataSource = self;
    [self addSubview:_contentPickerView];
    _contentPickerView.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *contentDatePickerConstraints = [NSMutableArray array];
    [contentDatePickerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentPickerView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentPickerView)]];
    [contentDatePickerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%lf-[_contentPickerView]-%lf-|", 50.f, DetermineButton_Height] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentPickerView)]];
    [self addConstraints:contentDatePickerConstraints];
    
    _determineButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _determineButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_determineButton setTitle:@"完成" forState:UIControlStateNormal];
    [_determineButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_determineButton addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_determineButton];
    _determineButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *determineButtonConstraints = [NSMutableArray array];
    [determineButtonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_determineButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_determineButton)]];
    [determineButtonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[_determineButton(%lf)]|", DetermineButton_Height] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_determineButton)]];
    [self addConstraints:determineButtonConstraints];
    [self.determineButtonConstraintsCache addObjectsFromArray:determineButtonConstraints];
    __weak __typeof(self)weakSelf = self;
    [_contentPickerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx != 0) {
            obj.backgroundColor = weakSelf.tintColor;
        }
    }];
    [self updateForStyle];
}

- (void)updateForStyle {
    
    switch (self.style) {
        case XHContainerCenter:
        {
            self.layer.cornerRadius = 5;
            self.line2.hidden = NO;
            _cancelButton.hidden = YES;
            _textLabel.textAlignment = NSTextAlignmentLeft;
            
            NSLayoutConstraint *textConstraint1 = self.textLabelConstraintsCache[0];
            NSLayoutConstraint *textConstraint2 = self.textLabelConstraintsCache[1];
            NSLayoutConstraint *textConstraint3 = self.textLabelConstraintsCache[2];
            
            textConstraint1.constant = 16;
            textConstraint2.constant = 16;
            textConstraint3.constant = 15;

            
            NSLayoutConstraint *contentPickerViewConstraint1 = self.contentPickerViewConstraintsCache[3];
            contentPickerViewConstraint1.constant = DetermineButton_Height;
            
            [self removeConstraints:self.determineButtonConstraintsCache];
            [self.determineButtonConstraintsCache removeAllObjects];
            NSMutableArray *determineButtonConstraints = [NSMutableArray array];
            [determineButtonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_determineButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_determineButton)]];
            [determineButtonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[_determineButton(%lf)]|", DetermineButton_Height] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_determineButton)]];
            [self addConstraints:determineButtonConstraints];
            [self.determineButtonConstraintsCache addObjectsFromArray:determineButtonConstraints];
            [_determineButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

        }
            break;
        case XHContainerBottom:
        {
            self.layer.cornerRadius = 0;
            _line2.hidden = YES;
            self.cancelButton.hidden = NO;
            _textLabel.textAlignment = NSTextAlignmentCenter;
            
            NSLayoutConstraint *textConstraint1 = self.textLabelConstraintsCache[0];
            NSLayoutConstraint *textConstraint2 = self.textLabelConstraintsCache[1];
            NSLayoutConstraint *textConstraint3 = self.textLabelConstraintsCache[2];
            
            textConstraint1.constant = 100;
            textConstraint2.constant = 100;
            textConstraint3.constant = 15;
            
            NSLayoutConstraint *contentPickerViewConstraint1 = self.contentPickerViewConstraintsCache[3];
            contentPickerViewConstraint1.constant = 0;
            
            [self removeConstraints:self.determineButtonConstraintsCache];
            [self.determineButtonConstraintsCache removeAllObjects];
            NSMutableArray *determineButtonConstraints = [NSMutableArray array];
            [determineButtonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_determineButton(60)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_determineButton)]];
            [determineButtonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[_determineButton(%lf)]", 50.f] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_determineButton)]];
            [self addConstraints:determineButtonConstraints];
            [self.determineButtonConstraintsCache addObjectsFromArray:determineButtonConstraints];
            [_determineButton setTitleColor:_tintColor forState:UIControlStateNormal];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - delegate <UIPickerViewDelegate, UIPickerViewDataSource>

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    if (IsDataSource(xh_numberOfComponentsInPickerView:)) {
        return [self.dataSource xh_numberOfComponentsInPickerView:self];
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (IsDataSource(xh_pickerView:numberOfRowsInComponent:)) {
        return [self.dataSource xh_pickerView:self numberOfRowsInComponent:component];
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.font = [UIFont systemFontOfSize:18];
        pickerLabel.textColor = [UIColor darkGrayColor];
    }
    
    NSString *string = [self.dataSource xh_pickerView:self titleForRow:row forComponent:component];
    if (string) {
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:string attributes:self.textAttributes];
        pickerLabel.attributedText = attStr;
    } else {
        pickerLabel.attributedText = nil;
    }
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (IsDataSource(xh_pickerView:didSelectRow:inComponent:)) {
        [self.dataSource xh_pickerView:self didSelectRow:row inComponent:component];
    }
}

- (void)setTitle:(NSString *)title {

    _title = title;
    _textLabel.text = title;
}

#pragma mark - Ovrri Methods

- (void)show:(UIView *)displayView {
    
    [super show:displayView];
    __weak __typeof(self)weakSelf = self;
    [_contentPickerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            obj.backgroundColor = weakSelf.tintColor;
        }
    }];
    
}

- (void)hide {
    
    [super hide];
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(XHPickerViewDelegate)] && [self.delegate respondsToSelector:@selector(xh_pickerView:didConfirmDisappear:)]) {
        [self.delegate xh_pickerView:self didConfirmDisappear:NO];
    }
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(XHPickerViewDelegate)] && [self.delegate respondsToSelector:@selector(xh_pickerViewDisappearInUnConfirmation:)]) {
        [self.delegate xh_pickerViewDisappearInUnConfirmation:self];
    }

}

- (void)setStyle:(XHContainerStyle)style {
    
    switch (style) {
        case XHContainerCenter:
        {
            CGRect frame = self.frame;
            frame.size.height = ContentPickerView_Height + 50 + DetermineButton_Height;
            self.frame = frame;
        }
            break;
        case XHContainerBottom:
        {
            CGRect frame = self.frame;
            frame.size.height = ContentPickerView_Height + 50;
            self.frame = frame;
        }
            break;
            
        default:
            break;
    }
    [super setStyle:style];
    [self updateForStyle];
}


#pragma mark - Action Methods

- (void)handleEvent:(UIButton *)sender {
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(XHPickerViewDelegate)] && [self.delegate respondsToSelector:@selector(xh_pickerView:didConfirmDisappear:)]) {
        
        [self.delegate xh_pickerView:self didConfirmDisappear:YES];
    }
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(XHPickerViewDelegate)] && [self.delegate respondsToSelector:@selector(xh_pickerViewDisappearInConfirmation:)]) {
        [self.delegate xh_pickerViewDisappearInConfirmation:self];
    }
    [super hide];
}

- (void)cancelEvent:(UIButton *)sender {
    [self hide];
}

#pragma mark - Getter Methods

- (NSDictionary<NSString *,id> *)textAttributes {
    
    if (!_textAttributes) {
        _textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18], NSFontAttributeName, nil];
    }
    return _textAttributes;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = WGrayColor;
        [self addSubview:_line2];
        
        _line2.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableArray *line2Constraints = [NSMutableArray array];
        [line2Constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_line2]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_line2)]];
        [line2Constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[_line2(0.5)]-%lf-|", DetermineButton_Height] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_line2)]];
        [self addConstraints:line2Constraints];

    }
    return _line2;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableArray *cancelButtonConstraints = [NSMutableArray array];
        [cancelButtonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cancelButton(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cancelButton)]];
        [cancelButtonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[_cancelButton(%lf)]", 50.f] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cancelButton)]];
        [self addConstraints:cancelButtonConstraints];
    }
    return _cancelButton;
}

@end
