//
//  XHTextView.m
//  BSGrowthViewing
//
//  Created by 向洪 on 2017/8/18.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHTextView.h"

CGFloat const XHTextViewPaddingTop = 8;
CGFloat const XHTextViewPaddingLeft = 5;
CGFloat const XHTextViewPaddingRight = 5;
CGFloat const XHTextViewPaddingBottom = 8;

@interface XHTextView ()

@property (nonatomic, strong) UILabel *placeHolderLabel;

@end

@implementation XHTextView

-(void)initialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPlaceholder) name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPlaceholder) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPlaceholder) name:UITextViewTextDidEndEditingNotification object:self];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

-(void)refreshPlaceholder
{
    if([[self text] length] || self.isFirstResponder)
    {
        [_placeHolderLabel setAlpha:0];
    }
    else
    {
        [_placeHolderLabel setAlpha:1];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self refreshPlaceholder];
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    _placeHolderLabel.font = self.font;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_placeHolderLabel sizeToFit];
    
    if (UIEdgeInsetsEqualToEdgeInsets(self.placeholderMargins, UIEdgeInsetsZero)) {
        _placeHolderLabel.frame = CGRectMake(self.textContainerInset.left+self.textContainer.lineFragmentPadding, self.textContainerInset.top+self.textContainer.lineFragmentPadding, CGRectGetWidth(_placeHolderLabel.frame), CGRectGetHeight(_placeHolderLabel.frame));
    } else {
        _placeHolderLabel.frame = CGRectMake(self.placeholderMargins.left+self.textContainer.lineFragmentPadding, self.placeholderMargins.top+self.textContainer.lineFragmentPadding, CGRectGetWidth(_placeHolderLabel.frame), CGRectGetHeight(_placeHolderLabel.frame));
    }
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    if (!_placeHolderLabel)
    {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.font = self.font;
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
        _placeHolderLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        _placeHolderLabel.alpha = 0;
        [self addSubview:_placeHolderLabel];
    }
    _placeHolderLabel.text = self.placeholder;
    [self refreshPlaceholder];
}

//When any text changes on textField, the delegate getter is called. At this time we refresh the textView's placeholder
-(id<UITextViewDelegate>)delegate
{
    [self refreshPlaceholder];
    return [super delegate];
}

@end
