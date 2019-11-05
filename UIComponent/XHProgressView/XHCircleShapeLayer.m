//
//  XHCircleShapeLayer.m
//  GrowthCompass
//
//  Created by 向洪 on 2017/5/3.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHCircleShapeLayer.h"

@interface XHCircleShapeLayer ()

@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) CATextLayer *textLayer;

@end

@implementation XHCircleShapeLayer

- (instancetype)init {
    
    if ((self = [super init])) {
        [self setupLayer];
    }
    return self;
}

- (void)layoutSublayers {

    if (_attributedString) {
        [self setAttributedString:_attributedString];
    }
    
    self.path = [self drawPathWithArcCenter];
    self.backgroundLayer.path = [self drawPathWithArcCenter];
    [super layoutSublayers];
}


- (void)setupLayer {
    
    _startAngle = -M_PI_2;
    _endAngle = 3*M_PI_2;
    _clockwise = YES;
    _progressColor = [UIColor colorWithRed:184/255.0 green:233/255.0 blue:134/255.0 alpha:1.0];
    
    self.path = [self drawPathWithArcCenter];
    self.lineJoin = kCALineJoinRound;
    self.lineCap = kCALineCapRound;
    self.lineWidth = 20;
    self.strokeEnd = 0;
    self.fillColor = [UIColor clearColor].CGColor;
    self.strokeColor = self.progressColor.CGColor;
    
    self.backgroundLayer = [CAShapeLayer layer];
    self.backgroundLayer.path = [self drawPathWithArcCenter];
    self.backgroundLayer.fillColor = [UIColor clearColor].CGColor;
    self.backgroundLayer.strokeColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:0.4f].CGColor;
    self.backgroundLayer.lineWidth = self.lineWidth;
    [self addSublayer:self.backgroundLayer];
}

#pragma mark - priavte Methods

// 获取圆形路径
- (CGPathRef)drawPathWithArcCenter {
    
    CGFloat positionX = self.frame.size.width/2;
    CGFloat positionY = self.frame.size.height/2;
    
    CGFloat radius = MIN(positionX, positionY)-self.lineWidth*0.5;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(positionX, positionY) radius:radius startAngle:self.startAngle endAngle:self.endAngle clockwise:self.clockwise];
    return path.CGPath;
}

// 更新
- (void)updateProgressLayer {
    self.path = [self drawPathWithArcCenter];
    self.backgroundLayer.path = [self drawPathWithArcCenter];
}


#pragma mark - setter

- (void)setValue:(CGFloat)value {

    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.5;
    pathAnimation.fromValue = @(_value);
    pathAnimation.toValue = @(value);
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self addAnimation:pathAnimation forKey:nil];

    _value = value;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    [super setLineWidth:lineWidth];
    [self.backgroundLayer setLineWidth:lineWidth];
    [self updateProgressLayer];
}

- (void)setStartAngle:(CGFloat)startAngle {
    _startAngle = startAngle;
    [self updateProgressLayer];
}

- (void)setEndAngle:(CGFloat)endAngle {
    _endAngle = endAngle;
    [self updateProgressLayer];
}

- (void)setClockwise:(BOOL)clockwise {
    _clockwise = clockwise;
    [self updateProgressLayer];
}

- (void)setProgressColor:(UIColor *)progressColor {

    _progressColor = progressColor;
    self.strokeColor = progressColor.CGColor;
}

- (void)setProgressShadowColor:(UIColor *)progressShadowColor {

    _progressShadowColor = progressShadowColor;
    self.shadowColor = progressShadowColor.CGColor;
    self.shadowOpacity = 0.2;
    self.shadowOffset = CGSizeMake(0, 0);
}

- (void)setString:(NSString *)string {
    
    _string = string;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.4 alpha:1]}];
    [self setAttributedString:attributedString];
}

- (void)setAttributedString:(NSAttributedString *)attributedString {
 
    _attributedString = attributedString;

    CGFloat positionX = self.frame.size.width/2;
    CGFloat positionY = self.frame.size.height/2;
    CGFloat width = sqrt(2*pow(MIN(positionX, positionY), 2))-self.lineWidth*0.5;
    
    if (width>0) {
        
        CGRect bounds = [attributedString boundingRectWithSize:CGSizeMake(width, width) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
        
        self.textLayer.string = attributedString;
        // 这个高度计算之后，在CATextLayer中显示有误差，暂未找到原因。设置高度加2，在行数少的情况下减少误差导致的文本显示不全
        self.textLayer.bounds = CGRectMake(0, 0, ceil(CGRectGetWidth(bounds)), ceil(CGRectGetHeight(bounds))+2);
        self.textLayer.position = CGPointMake(positionX, positionY);
    }
}

#pragma mark - Getter Methods

- (CATextLayer *)textLayer {
    if (!_textLayer) {
    
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.foregroundColor = [UIColor colorWithWhite:0.4 alpha:1].CGColor;;
        textLayer.wrapped = YES;
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        [self addSublayer:textLayer];
        
        _textLayer = textLayer;
    }
    return _textLayer;
}

@end
