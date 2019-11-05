//
//  XHSliceLayer.h
//  图表
//
//  Created by 向洪 on 2017/10/12.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface XHPieChartSliceLayer : CAShapeLayer

@property (nonatomic) CGFloat startAngle;  // 开始幅度
@property (nonatomic) CGFloat endAngle;    // 结束幅度
@property (nonatomic) CGFloat angle;       // 幅度
@property (nonatomic) BOOL isSelected;     // 是否选中

@property (nonatomic) CGFloat pieRadius;   // 半径
@property (nonatomic) CGFloat offsetAngle; // 偏移幅度
@property (nonatomic) CGPoint pieCenter;   // 圆心

@property (nonatomic, copy) NSString *string;        // 文字
@property (nonatomic, copy) UIColor *stringColor;   // 文字颜色
@property (nonatomic) BOOL drawInstructionLine;      // 默认no

// 更新，如果文字说明处于显示状态，会忽略delay
- (void)updateSubLayerWithAnimationDuring:(CGFloat)during;

/**
 快捷添加动画

 @param key 动画key
 @param from form
 @param to to
 @param delegate 协议
 */
- (void)createArcAnimationForKey:(NSString *)key fromValue:(id)from toValue:(id)to duration:(CGFloat)duration delegate:(id)delegate;
@end
