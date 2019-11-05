//
//  XHCircleProgressView.m
//  GrowthCompass
//
//  Created by 向洪 on 2017/5/3.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHCircleProgressView.h"
#import "XHCircleShapeLayer.h"

@interface XHCircleProgressView ()

@property (nonatomic, strong) XHCircleShapeLayer *progressLayer;

@end

@implementation XHCircleProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self setupViews];
}

- (void)setupViews {
    
    _tintColor = [UIColor colorWithRed:184/255.0 green:233/255.0 blue:134/255.0 alpha:1.0];
    _lineWidth = 20;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    
    // add Progress layer
    self.progressLayer = [[XHCircleShapeLayer alloc] init];
    self.progressLayer.frame = self.bounds;
    self.progressLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.progressLayer.progressColor = _tintColor;
    self.progressLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:self.progressLayer];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.progressLayer.frame = self.bounds;
}

#pragma mark - Setter Methods

- (void)setString:(NSString *)string {

    _string = string;
    self.progressLayer.string = string;
}

- (void)setAttributedString:(NSAttributedString *)attributedString {

    _attributedString = attributedString;
    self.progressLayer.attributedString = attributedString;
}

- (void)setTintColor:(UIColor *)tintColor {

    _tintColor = tintColor;
    self.progressLayer.progressColor = tintColor;
}

- (void)setProgress:(CGFloat)progress {
    
    _progress = progress;
    self.progressLayer.value = progress;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    self.progressLayer.lineWidth  = lineWidth;
}


@end
