//
//  XHInstrumentChartView.m
//  BSGrowthViewing
//
//  Created by 向洪 on 2018/1/10.
//  Copyright © 2018年 向洪. All rights reserved.
//

#import "XHMeterChartView.h"
/**
 仪表图
 */
@interface XHMeterChartView ()

@property (nonatomic, strong) XHPieChart *pieChart;   // 饼图
@property (nonatomic, strong) CAShapeLayer *valueShapeLayer;
@property (nonatomic, strong) CALayer *endRadioLayer;

@end

@implementation XHMeterChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    _pieChart = [[XHPieChart alloc] initWithFrame:CGRectZero];
    _pieChart.sliceSpace = 3;
    _pieChart.drawInstructionLine = NO;
    _pieChart.startPieAngle = - M_PI_2 * 2.5;
    _pieChart.endPieAngle = M_PI_2 * 0.5;
    _pieChart.pieHollowRadiusPercentage = 0.8;
    _pieChart.animationDuring = 1.f;
//    [_pieChart reloadData];
    [self addSubview:_pieChart];
    
    _valueShapeLayer = [CAShapeLayer layer];
    _valueShapeLayer.strokeColor = self.tintColor.CGColor;
    _valueShapeLayer.lineWidth = 1;
    _valueShapeLayer.lineJoin = kCALineJoinRound;
    _valueShapeLayer.lineCap = kCALineCapRound;
    _valueShapeLayer.strokeStart = 0;
    _valueShapeLayer.strokeEnd = 0;
    _valueShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _valueShapeLayer.contentsScale = [UIScreen mainScreen].scale;

    [self.layer addSublayer:_valueShapeLayer];
    
    _endRadioLayer = [CALayer layer];
    _endRadioLayer.backgroundColor = self.tintColor.CGColor;
    _endRadioLayer.contentsScale = [UIScreen mainScreen].scale;
    _endRadioLayer.bounds = CGRectMake(0, 0, 4, 4);
    _endRadioLayer.cornerRadius = 2;
//
    [self.layer addSublayer:_endRadioLayer];
//    _valueShapeLayer.path = path.CGPath;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
 
    CGFloat width = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    _pieChart.frame = CGRectMake((CGRectGetWidth(self.frame)-width)*0.5, (CGRectGetHeight(self.frame)-width)*0.5, width, width);

    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:_pieChart.center radius:_pieChart.pieRadius*_pieChart.pieHollowRadiusPercentage startAngle:_pieChart.startPieAngle endAngle:_pieChart.endPieAngle clockwise:1];
    _valueShapeLayer.path = path.CGPath;
    
    CGFloat x = _pieChart.center.x;
    CGFloat y = _pieChart.center.y;
    CGFloat angle = (_pieChart.endPieAngle - _pieChart.startPieAngle) * _valueShapeLayer.strokeEnd + _pieChart.startPieAngle;
    CGFloat a_x = cos(angle) * _pieChart.pieRadius*_pieChart.pieHollowRadiusPercentage;
    CGFloat a_y = sin(angle) * _pieChart.pieRadius*_pieChart.pieHollowRadiusPercentage;
    //
    _endRadioLayer.position = CGPointMake(x + a_x, y+ a_y);
    
    [self reloadData];
    
}

- (void)reloadData {
    
    if (CGRectGetWidth(self.frame)!=0) {
        [_pieChart reloadData];
        _pieChart.pieCenterAttributedString = self.pieCenterAttributedString;
        
        CGFloat count = 0;
        for (NSNumber *number in self.values) {
            count += [number doubleValue];
        }
        CGFloat progress = MIN(count?self.value/count:0, 1);
        
        // 线条动画
        CGFloat from = _valueShapeLayer.strokeEnd;
        CGFloat to = progress;
        CABasicAnimation *arcAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        [arcAnimation setFromValue:@(from)];
        [arcAnimation setToValue:@(to)];
        [arcAnimation setDuration:2.f];
        [arcAnimation setFillMode:kCAFillModeForwards];
        [arcAnimation setRemovedOnCompletion:NO];
        [arcAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [_valueShapeLayer addAnimation:arcAnimation forKey:nil];
        
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:_pieChart.center radius:_pieChart.pieRadius*_pieChart.pieHollowRadiusPercentage startAngle:M_PI_2 * 3 * from + _pieChart.startPieAngle endAngle:M_PI_2 * 3 * to + _pieChart.startPieAngle clockwise:YES];
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.path = path.CGPath;
        animation.duration = 2.f;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.calculationMode = kCAAnimationPaced;
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [_endRadioLayer addAnimation:animation forKey:nil];
    }
    
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    _valueShapeLayer.strokeColor = self.tintColor.CGColor;
    _endRadioLayer.backgroundColor = self.tintColor.CGColor;
}

#pragma mark - Setter Methods

- (void)setValues:(NSArray<NSNumber *> *)values {
    _values = [values copy];
    _pieChart.values = values;
}

- (void)setColors:(NSArray<UIColor *> *)colors {
    _colors = [colors copy];
    _pieChart.colors = colors;
}

- (void)setInstructions:(NSArray<NSString *> *)instructions {
    _instructions = [instructions copy];
    _pieChart.instructions = instructions;
}

- (void)setInstructionColors:(NSArray<UIColor *> *)instructionColors {
    _instructionColors = [instructionColors mutableCopy];
    _pieChart.instructionColors = instructionColors;
}

- (void)setPieCenterAttributedString:(NSAttributedString *)pieCenterAttributedString {
    _pieCenterAttributedString = [pieCenterAttributedString copy];
    _pieChart.pieCenterAttributedString = pieCenterAttributedString;
}

@end
