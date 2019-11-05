//
//  XHPieChart.m
//  图表
//
//  Created by 向洪 on 2017/10/12.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHPieChart.h"
#import "XHChartHelper.h"
#import "XHPieChartSliceLayer.h"
#import <CoreGraphics/CoreGraphics.h>

#define pieclockwise 1

@interface XHPieChart ()

// lyaer片数组
@property (nonatomic, strong) NSMutableArray<XHPieChartSliceLayer *> *sliceLayerArr;
@property (nonatomic, strong) NSArray<UIView *> *describeViewArr;

// 当前选中的片
@property (nonatomic) NSInteger selectedSliceIndex;

// 用户选择是界面效果控制
@property (nonatomic) NSInteger selectSliceIndex;

// 用于界面旋转控制
@property (nonatomic) CGFloat startPieAngle_U;
@property (nonatomic) CGFloat endPieAngle_U;

// 圆心label
@property (nonatomic, strong) CATextLayer *pieCenterTextLayer;

@end


@implementation XHPieChart

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    // 设置默认
    _pieCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _pieRadius = MAX(floor(MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) * 0.5) - 10, 10);
    _pieHollowRadiusPercentage = 0;
    _sliceSpace = 0;
    _drawInstructionLine = YES;

    _startPieAngle = -M_PI_2;
    _endPieAngle = M_PI_2*3;
    self.startPieAngle_U = _startPieAngle;
    self.endPieAngle_U = _endPieAngle;
    
    _selectSliceOffset = 3.0;
    _selectedSliceOffsetRadius = 10;
    
    _selectedSliceIndex = -1;
    _selectSliceIndex = -1;
    _sliceLayerArr = [NSMutableArray array];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 更新饼图
    _pieCenterTextLayer.position = _pieCenter;
    [self updatePieChart];

}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self adjustLoctionAttribute];
}

/**
 调整视图
 */
- (void)adjustLoctionAttribute {
    if (CGPointEqualToPoint(_pieCenter, CGPointZero)) {
        // 视图改变设置属性
        self.pieRadius = MAX(floor(MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) * 0.5) - 10, 10);
        self.pieCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    }
}

#pragma mark - Public Methods

- (void)reloadData {
    
    [self selectedSliceLayerWithIndex:-1];
    [self congfigSubSliceLayer];
    [self reloadSubSliceLayer];
}

#pragma mark - Private Methods

/* 配置块的数量 */
- (void)congfigSubSliceLayer {

    NSInteger count = self.values.count;
    [self.sliceLayerArr makeObjectsPerformSelector:@selector(removeFromSuperlayer) withObject:nil];
    [self.sliceLayerArr removeAllObjects];

    for (NSInteger i = 0; i < count; i ++) {
        XHPieChartSliceLayer *layer = [XHPieChartSliceLayer layer];
        layer.fillColor = [UIColor clearColor].CGColor;
        if (_pieCenterTextLayer) {
            [self.layer insertSublayer:layer below:_pieCenterTextLayer];
        } else {
            [self.layer addSublayer:layer];
        }
        [self.sliceLayerArr addObject:layer];
    }
}

/* 设置块的值 */
- (void)reloadSubSliceLayer {
    
    __block CGFloat total = 0;
    [self.values enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        total += [obj doubleValue];
    }];
    NSMutableArray *percentages = [NSMutableArray array];
    [self.values enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat div = 0;
        if (total != 0) {
            div = [obj doubleValue] / total;
        }
        [percentages addObject:@(div)];
    }];
    
    __block CGFloat startTo = 0.0;
    __block CGFloat endTo = startTo;
    __weak __typeof(self)weakSelf = self;
    [self.sliceLayerArr enumerateObjectsUsingBlock:^(XHPieChartSliceLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat div = [percentages[idx] doubleValue];
        endTo += div;

        [obj createArcAnimationForKey:@"strokeStart"
                            fromValue:[NSNumber numberWithDouble:obj.startAngle/M_PI * 2]
                              toValue:[NSNumber numberWithDouble:startTo]
                             duration:weakSelf.animationDuring
                             delegate:nil];
        [obj createArcAnimationForKey:@"strokeEnd"
                            fromValue:[NSNumber numberWithDouble:obj.endAngle/M_PI * 2]
                              toValue:[NSNumber numberWithDouble:endTo]
                             duration:weakSelf.animationDuring
                             delegate:nil];
        // 计算幅度
        CGFloat m_angele = weakSelf.endPieAngle_U - weakSelf.startPieAngle_U;
        obj.angle = m_angele * div;
        obj.startAngle = m_angele * startTo;
        obj.endAngle = obj.angle + obj.startAngle;
        obj.pieRadius = weakSelf.pieRadius;
        obj.pieCenter = weakSelf.pieCenter;
        obj.offsetAngle = weakSelf.startPieAngle_U;
        obj.drawInstructionLine = weakSelf.drawInstructionLine;
        startTo = endTo;
        startTo = endTo;
        
        NSInteger index = idx;
        if (weakSelf.colors) {
            UIColor *color = weakSelf.colors[index];
            [obj setStrokeColor:color.CGColor];
        } else {
            UIColor *color = [UIColor colorWithHue:((index/8)%20)/20.0+0.02 saturation:(index%8+3)/10.0 brightness:91/100.0 alpha:1];
            [obj setStrokeColor:color.CGColor];
        }
        if (weakSelf.instructions) {
            obj.string = weakSelf.instructions[idx];
        }
        if (weakSelf.instructionColors) {
            obj.stringColor = weakSelf.instructionColors[idx];
        }
        [obj updateSubLayerWithAnimationDuring:weakSelf.animationDuring];
    }];
    
    [self updateSliceLayer];
}


/**
 更新饼图，设置每个块的大小
 */
- (void)updatePieChart {
    for (XHPieChartSliceLayer *obj in self.sliceLayerArr) {
        obj.lineWidth = _pieRadius *(1-_pieHollowRadiusPercentage);
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:_pieCenter radius:_pieRadius-obj.lineWidth*0.5 startAngle:_startPieAngle_U endAngle:_endPieAngle_U clockwise:pieclockwise];
        obj.path = path.CGPath;
    }
}

/* 更新滑块 */
- (void)updateSliceLayer {
    __weak __typeof(self)weakSelf = self;
    [self.sliceLayerArr enumerateObjectsUsingBlock:^(XHPieChartSliceLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            [weakSelf sliceLayerOffsetWithIndex:idx offset:weakSelf.sliceSpace+weakSelf.selectedSliceOffsetRadius];
        } else {
            [weakSelf sliceLayerOffsetWithIndex:idx offset:weakSelf.sliceSpace];
        }
    }];
}

#pragma mark - offset Methods  块偏移量

// 设置选中块，是会动做选中动画。设置为-1可以取消全部选中效果
- (void)selectedSliceLayerWithIndex:(NSInteger)index {
    
    if (_selectedSliceIndex == index) {
        return;
    }
    if (_selectedSliceIndex >= 0) {
        self.sliceLayerArr[_selectedSliceIndex].isSelected = NO;
    }
    
    if (index >= 0) {
        self.sliceLayerArr[index].isSelected = YES;
    }
    _selectedSliceIndex = index;
    
    [self updateSliceLayer];
}

- (void)sliceLayerOffsetWithIndex:(NSInteger)index offset:(CGFloat)offset {
    if (index >= 0) {
        XHPieChartSliceLayer *layer = self.sliceLayerArr[index];
        [self sliceLayerOffsetWithLayer:layer offset:offset];
    }
}

- (void)sliceLayerOffsetWithLayer:(XHPieChartSliceLayer *)layer offset:(CGFloat)offset {
    CGFloat angel = layer.startAngle + layer.angle * 0.5 + _startPieAngle_U;
    CGFloat sinx = sin(angel);
    CGFloat cosy = cos(angel);
    CGFloat x = offset * (sinx);
    CGFloat y = offset * (cosy);
    // 如果度数为M_PI * 2，说明只有个圆，那么不做偏移
    if (layer.angle == M_PI * 2) {
        x = 0;
        y = 0;
    }
    
    layer.position = CGPointMake(y, x);
}

#pragma mark - Touch Methods

- (NSInteger)getCurrentSelectedOnTouch:(CGPoint)point {
    
    __block NSUInteger selectedIndex = -1;
    CGFloat x = point.x - _pieCenter.x;
    CGFloat y = point.y - _pieCenter.y;
    // 幅度-M_PI~M_PI
    CGFloat angle = atan2(y, x);
    angle -= _startPieAngle_U;
    if (angle < 0) {
        angle += M_PI * 2;
    }
    if (angle > M_PI * 2) {
        angle -= M_PI * 2;
    }
    // 圆心距
    CGFloat distance = sqrt(x * x + y * y);
    __weak __typeof(self)weakSelf = self;
    [self.sliceLayerArr enumerateObjectsUsingBlock:^(XHPieChartSliceLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat pieHollowRadius = weakSelf.pieRadius * weakSelf.pieHollowRadiusPercentage + weakSelf.sliceSpace;
        CGFloat pieRadius = weakSelf.pieRadius + weakSelf.sliceSpace;
        // 如果选中，且度数不是M_PI * 2
        if (obj.isSelected && obj.angle != M_PI * 2) {
            pieHollowRadius += weakSelf.selectedSliceOffsetRadius;
            pieRadius += weakSelf.selectedSliceOffsetRadius;
        }
        if (distance >= pieHollowRadius && distance <= pieRadius && angle >= obj.startAngle && angle < obj.endAngle) {
            selectedIndex = idx;
            *stop = YES;
        }
    }];
    return selectedIndex;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _selectSliceIndex = _selectedSliceIndex;
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSInteger selectedIndex = [self getCurrentSelectedOnTouch:point];
    
    [self sliceLayerOffsetWithIndex:_selectSliceIndex offset:_sliceSpace];
    if (selectedIndex > 0) {
        [self sliceLayerOffsetWithIndex:selectedIndex offset:_sliceSpace + _selectSliceOffset];
        _selectSliceIndex = selectedIndex;
    }

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSInteger selectedIndex = [self getCurrentSelectedOnTouch:point];
    
    if (selectedIndex == _selectedSliceIndex) {
        [self selectedSliceLayerWithIndex:-1];
    } else {
        [self selectedSliceLayerWithIndex:selectedIndex];
    }
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self updateSliceLayer];
}

#pragma mark - pieCenterText Methods

- (void)setPieCenterText:(NSString *)pieCenterText {
    _pieCenterText = [pieCenterText copy];
    self.pieCenterTextLayer.string = _pieCenterText;
    CGFloat width = floor(sqrt(_pieRadius * _pieRadius/2));
    _pieCenterTextLayer.bounds = [XHChartHelper boundingRectWithSize:CGSizeMake(width*2, width*2) font:[UIFont systemFontOfSize:_pieCenterTextLayer.fontSize] string:_pieCenterText];
}

- (void)setPieCenterAttributedString:(NSAttributedString *)pieCenterAttributedString {
    _pieCenterAttributedString = [pieCenterAttributedString mutableCopy];
    self.pieCenterTextLayer.string = _pieCenterAttributedString;
    CGFloat width = floor(sqrt(_pieRadius * _pieRadius/2));
    _pieCenterTextLayer.bounds = [pieCenterAttributedString boundingRectWithSize:CGSizeMake(width*2, width*2) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
}

- (CATextLayer *)pieCenterTextLayer {
    
    if (!_pieCenterTextLayer) {
        _pieCenterTextLayer = [CATextLayer layer];
        CGFontRef font = CGFontCreateCopyWithVariations((__bridge CGFontRef)([UIFont systemFontOfSize:12]), (__bridge CFDictionaryRef)(@{}));
        _pieCenterTextLayer.font = font;
        _pieCenterTextLayer.wrapped = YES;
        CFRelease(font);
        _pieCenterTextLayer.bounds = CGRectMake(0, 0, 40, 20);
        _pieCenterTextLayer.fontSize = 12;
        _pieCenterTextLayer.alignmentMode = kCAAlignmentCenter;
        _pieCenterTextLayer.contentsScale = [UIScreen mainScreen].scale;
        _pieCenterTextLayer.foregroundColor = [UIColor darkTextColor].CGColor;
        [self.layer addSublayer:_pieCenterTextLayer];
    }
    return _pieCenterTextLayer;
}

#pragma mark - Setter Methods

- (void)setStartPieAngle_U:(CGFloat)startPieAngle_U {
    _startPieAngle_U = startPieAngle_U;
    while (_startPieAngle_U >= _endPieAngle_U) {
        _startPieAngle_U -= M_PI * 2;
    }
    while (_endPieAngle_U -_startPieAngle_U > M_PI * 2) {
        _startPieAngle_U += M_PI * 2;
    }
    
    while (_startPieAngle_U > M_PI) {
        _startPieAngle_U -= M_PI * 2;;
        _endPieAngle_U -= M_PI * 2;
    }
    
    while (_startPieAngle_U < -M_PI) {
        _startPieAngle_U += M_PI * 2;;
        _endPieAngle_U += M_PI * 2;
    }
    
}

- (void)setEndPieAngle_U:(CGFloat)endPieAngle_U {
    _endPieAngle_U = endPieAngle_U;
    while (_endPieAngle_U <= _startPieAngle_U) {
        _endPieAngle_U += M_PI * 2;
    }
    while (_endPieAngle_U -_startPieAngle_U > M_PI * 2) {
        _endPieAngle_U -= M_PI * 2;
    }
    
    while (_endPieAngle_U > M_PI*3) {
        _startPieAngle_U -= M_PI * 2;;
        _endPieAngle_U -= M_PI * 2;
    }
    
    while (_endPieAngle_U < -M_PI) {
        _startPieAngle_U += M_PI * 2;;
        _endPieAngle_U += M_PI * 2;
    }
    
}

- (void)setStartPieAngle:(CGFloat)startPieAngle {
    
    _startPieAngle = startPieAngle;
    self.startPieAngle_U = startPieAngle;
    [self updatePieChart];
}

- (void)setEndPieAngle:(CGFloat)endPieAngle {
    
    _endPieAngle = endPieAngle;
    self.endPieAngle_U = endPieAngle;
    [self updatePieChart];
}

- (void)setPieCenter:(CGPoint)pieCenter {
    
    _pieCenter = pieCenter;
    _pieCenterTextLayer.position = _pieCenter;
    [self updatePieChart];
}

- (void)setPieRadius:(CGFloat)pieRadius {
    
    _pieRadius = pieRadius;
    [self updatePieChart];
}

- (void)setPieHollowRadiusPercentage:(CGFloat)pieHollowRadiusPercentage {
    
    _pieHollowRadiusPercentage = pieHollowRadiusPercentage;
    [self updatePieChart];
}

- (void)setSelectedSliceOffsetRadius:(CGFloat)selectedSliceOffsetRadius {
    
    _selectedSliceOffsetRadius = MAX(selectedSliceOffsetRadius, _selectSliceOffset);
    [self updateSliceLayer];
}

- (void)setSelectSliceOffset:(CGFloat)selectSliceOffset {
    _selectSliceOffset = selectSliceOffset;
    [self setSelectedSliceOffsetRadius:_selectedSliceOffsetRadius];
}

- (void)setSliceSpace:(CGFloat)sliceSpace {
    _sliceSpace= sliceSpace;
    [self updateSliceLayer];
}

- (void)setDrawInstructionLine:(BOOL)drawInstructionLine {

    _drawInstructionLine = drawInstructionLine;
    [self.sliceLayerArr enumerateObjectsUsingBlock:^(XHPieChartSliceLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.drawInstructionLine = drawInstructionLine;
    }];
}

@end


