//
//  XHDigitalAnimationLabel.m
//  GrowthCompass_2
//
//  Created by 向洪 on 2019/2/26.
//  Copyright © 2019 向洪. All rights reserved.
//

#import "XHDigitalAnimationLabel.h"

#define kXHDigitalAnimationLabelRate 3

@protocol XHDigitalAnimationLabelUpdateCounter <NSObject>

// 通过线性进度值，转换为动画种类的进度值，
- (CGFloat)transformForProgress:(CGFloat)progress;

@end

@interface XHDigitaLabelLinear : NSObject<XHDigitalAnimationLabelUpdateCounter>

@end

@interface XHDigitaLabelCurveEaseIn : NSObject<XHDigitalAnimationLabelUpdateCounter>

@end

@interface XHDigitaLabelCurveEaseOut : NSObject<XHDigitalAnimationLabelUpdateCounter>

@end

@interface XHDigitaLabelCurveEaseInOut : NSObject<XHDigitalAnimationLabelUpdateCounter>

@end

@implementation XHDigitaLabelLinear

- (CGFloat)transformForProgress:(CGFloat)progress {
    return progress;
}

@end

@implementation XHDigitaLabelCurveEaseIn

- (CGFloat)transformForProgress:(CGFloat)progress {
    return powf(progress, kXHDigitalAnimationLabelRate);
}

@end

@implementation XHDigitaLabelCurveEaseOut

- (CGFloat)transformForProgress:(CGFloat)progress {
    return 1-powf(1-progress, kXHDigitalAnimationLabelRate);
}

@end

@implementation XHDigitaLabelCurveEaseInOut

- (CGFloat)transformForProgress:(CGFloat)progress { 
    progress *= 2;
    if (progress < 1)
        return 0.5f * powf (progress, kXHDigitalAnimationLabelRate);
    else
        return 0.5f * (2.0f - powf(2.0 - progress, kXHDigitalAnimationLabelRate));
}

@end

@interface XHDigitalAnimationLabel ()

@property (nonatomic, strong) NSNumberFormatter *formatter;

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGFloat fromValue;
@property (nonatomic, assign) CGFloat toValue;

@property (nonatomic, assign) CGFloat progress;  // 进度0-1

@property (nonatomic, assign) CGFloat framesValue; // 动画进行当前值，根据progress动态计算
@property (nonatomic, assign) CGFloat duration; // 动画持续时间
@property (nonatomic, assign) NSTimeInterval startTime; // 动画开始时间

@property (nonatomic, strong) id<XHDigitalAnimationLabelUpdateCounter> counter;

@property (nonatomic, strong) NSDate *date;

@end

@implementation XHDigitalAnimationLabel

#pragma mark - Public Methods

- (void)valueFrom:(CGFloat)startValue to:(CGFloat)endValue {
    
    [self valueFrom:startValue to:endValue duration:2];
}

- (void)valueFrom:(CGFloat)startValue to:(CGFloat)endValue duration:(NSTimeInterval)duration {
    
    self.fromValue = startValue;
    self.toValue = endValue;
    
    switch(self.animationMode)
    {
        case XHDigitalAnimationLabelLinear:
            self.counter = [[XHDigitaLabelLinear alloc] init];
            break;
        case XHDigitalAnimationLabelCurveEaseIn:
            self.counter = [[XHDigitaLabelCurveEaseInOut alloc] init];
            break;
        case XHDigitalAnimationLabelCurveEaseOut:
            self.counter = [[XHDigitaLabelCurveEaseOut alloc] init];
            break;
        case XHDigitalAnimationLabelCurveEaseInOut:
            self.counter = [[XHDigitaLabelCurveEaseInOut alloc] init];
            break;
    }
    
    // 如果在设置的时候正在进行动画，重置当前动画的值，进行新的计算
    self.startTime = 0;
    self.duration = duration;
    self.progress = 0;
    
    if (!self.displayLink) {
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateValue:)];
        displayLink.frameInterval = 2;
        if (@available(iOS 10, *)) {
            displayLink.preferredFramesPerSecond = 30;
        } else {
            displayLink.frameInterval = 2;
        }
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
        self.displayLink = displayLink;
        
        self.date = [NSDate date];
    }
}

#pragma mark - Private Methods

- (void)updateValue:(CADisplayLink *)displayLink {
    
    // update progress
    if (self.startTime == 0) {
        self.startTime = displayLink.timestamp;
    } else {
        self.progress = (displayLink.timestamp - self.startTime)/self.duration;
    }
//    NSLog(@"%lf", self.progress);
    if (self.progress >= 1 || self.progress < 0) {
        [displayLink invalidate];
        [self setDisplayLink:nil];
        [self setProgress:1];
    }
    
    [self setTextValue:[self framesValue]];
}

- (void)setTextValue:(CGFloat)value {
    
    if (self.attributedFormatBlock != nil) {
        self.attributedText = self.attributedFormatBlock(value);
    } else if (self.formatBlock != nil) {
        self.text = self.formatBlock(value);
    } else {
        // check if counting with ints - cast to int
        // 整数需要添加类型转换
        self.text = [self.formatter stringFromNumber:@(value)];
    }
}

- (CGFloat)framesValue {
    if (self.counter) {
        CGFloat updateVal = [self.counter transformForProgress:self.progress];
        return self.fromValue + (updateVal * (self.toValue - self.fromValue));
    } else {
       return self.fromValue;
    }
}

- (NSNumberFormatter *)formatter {
    if (!_formatter) {
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterNoStyle;
        numberFormatter.maximumFractionDigits = 0;
        numberFormatter.minimumIntegerDigits = 1;
        numberFormatter.maximumIntegerDigits = 10;
        numberFormatter.multiplier = @1;
        
        _formatter = numberFormatter;
    }
    return _formatter;
}

@end

