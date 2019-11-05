//
//  XHSliceLayer.m
//  图表
//
//  Created by 向洪 on 2017/10/12.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHPieChartSliceLayer.h"
#import "XHChartHelper.h"
#import <UIKit/UIKit.h>

@interface XHPieChartSliceLayer ()

@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) CATextLayer *textLayer;

@end

@implementation XHPieChartSliceLayer

- (void)createArcAnimationForKey:(NSString *)key fromValue:(NSNumber *)from toValue:(NSNumber *)to duration:(CGFloat)duration delegate:(id)delegate
{
    CABasicAnimation *arcAnimation = [CABasicAnimation animationWithKeyPath:key];
    NSNumber *currentAngle = [[self presentationLayer] valueForKey:key];
    if(currentAngle == nil){
        currentAngle = from;
    }
    [arcAnimation setFromValue:currentAngle];
    [arcAnimation setToValue:to];
    [arcAnimation setDelegate:delegate];
    [arcAnimation setDuration:duration];
    [arcAnimation setFillMode:kCAFillModeForwards];
    [arcAnimation setRemovedOnCompletion:NO];
    [arcAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self addAnimation:arcAnimation forKey:key];
//    [self setValue:to forKey:key];
}


- (CAShapeLayer *)lineLayer {
    
    if (!_lineLayer) {
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.strokeColor = self.strokeColor;
        _lineLayer.lineWidth = 0.3;
        _lineLayer.hidden = YES;
        _lineLayer.backgroundColor = self.strokeColor;
        _lineLayer.lineJoin = kCALineJoinMiter;
        _lineLayer.lineCap = kCALineCapRound;
        [self addSublayer:_lineLayer];
    }
    return _lineLayer;
}

- (void)updateSubLayerWithAnimationDuring:(CGFloat)during {
    _lineLayer.hidden = YES;
    _textLayer.hidden = YES;
    if (_string) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(during * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateTextLayer];
        });
    }
}

- (void)updateTextLayer {
    
    NSInteger pieRadiusAdd = _pieRadius + 12;
    //        CGFloat angel_s = _startAngle - M_PI_2 + _offsetAngle;
    //        CGFloat angel_e = _endAngle - M_PI_2 + _offsetAngle;
    //        CGFloat cosy_s = cos(angel_s);
    //        CGFloat cosy_e = cos(angel_e);
    //        CGFloat y_s = pieRadiusAdd * cosy_s;
    //        CGFloat y_e = pieRadiusAdd * cosy_e;
    //        if (fabs(y_s - y_e) < 15) {
    //            _lineLayer.hidden = YES;
    //            _textLayer.hidden = YES;
    //            return;
    //        }
    // 不做显示
    if (_angle == 0) {
        return;
    }
    
    CGFloat angel = _startAngle + _angle * 0.5 + M_PI_2 + _offsetAngle;
    CGFloat sinx = sin(angel);
    CGFloat cosy = cos(angel);
    CGFloat x = _pieRadius * sinx;
    CGFloat y = _pieRadius * cosy;
    CGPoint startPoint = CGPointMake(x + _pieCenter.x, _pieCenter.y - y);
    CGFloat x_a = pieRadiusAdd * sinx;
    CGFloat y_a = pieRadiusAdd * cosy;
    CGPoint point1 = CGPointMake(floor(x_a + _pieCenter.x), floor(_pieCenter.y - y_a));
    
    CGPoint textPosition = point1;
    if (_drawInstructionLine) {
        CGPoint point2;
        if (point1.x - _pieCenter.x < 0) {
            point2 = CGPointMake(point1.x - 15, point1.y);
            textPosition = point2;
        } else {
            point2 = CGPointMake(point1.x + 15, point1.y);
            textPosition = point2;
        }
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:startPoint];
        [path addLineToPoint:point1];
        [path moveToPoint:point1];
        [path addLineToPoint:point2];
        self.lineLayer.path = path.CGPath;
        self.lineLayer.hidden = NO;
    } else {
        _lineLayer.hidden = YES;
    }
    
    if ((angel == M_PI * 2 ||  angel == M_PI * 3) && !_drawInstructionLine) {
        _textLayer.position = CGPointMake(textPosition.x, textPosition.y);
    } else if (point1.x - _pieCenter.x < 0) {
        _textLayer.position = CGPointMake(textPosition.x - CGRectGetMidX(self.textLayer.bounds), textPosition.y);
    } else {
        _textLayer.position = CGPointMake(textPosition.x + CGRectGetMidX(self.textLayer.bounds), textPosition.y);
    }

    _textLayer.hidden = NO;
}

- (void)setString:(NSString *)string {
    if (string) {
        self.textLayer.string = string;
        _textLayer.bounds = [XHChartHelper boundingRectWithSize:CGSizeMake(_pieRadius * 2, 20) font:[UIFont systemFontOfSize:_textLayer.fontSize] string:string];
    }
    _string = string;
}

- (CATextLayer *)textLayer {
    
    if (!_textLayer) {
        _textLayer = [CATextLayer layer];
        CGFontRef font = CGFontCreateCopyWithVariations((__bridge CGFontRef)([UIFont systemFontOfSize:10]), (__bridge CFDictionaryRef)(@{}));
        _textLayer.font = font;
        CFRelease(font);
        _textLayer.bounds = CGRectMake(0, 0, 40, 20);
        _textLayer.fontSize = 10;
        _textLayer.alignmentMode = kCAAlignmentCenter;
        _textLayer.position = _pieCenter;
        _textLayer.hidden = YES;
        _textLayer.contentsScale = [UIScreen mainScreen].scale;
        _textLayer.foregroundColor = self.strokeColor;
        [self addSublayer:_textLayer];
    }
    return _textLayer;
}

- (void)setStrokeColor:(CGColorRef)strokeColor {
    [super setStrokeColor:strokeColor];
    _lineLayer.fillColor = self.strokeColor;
    _lineLayer.strokeColor = self.strokeColor;
    if (!_stringColor) {
        _textLayer.foregroundColor = self.strokeColor;
    }
}

- (void)setStringColor:(UIColor *)stringColor {
    _stringColor = stringColor;
    _textLayer.foregroundColor = stringColor.CGColor;
}

- (void)setDrawInstructionLine:(BOOL)drawInstructionLine {
    _drawInstructionLine = drawInstructionLine;
    [self updateTextLayer];
}

@end
