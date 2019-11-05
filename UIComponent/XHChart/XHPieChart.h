//
//  XHPieChart.h
//  图表
//
//  Created by 向洪 on 2017/10/12.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHChat.h"

@interface XHPieChart : XHChat

// 饼图配置
@property (nonatomic, assign) CGPoint pieCenter;  // 图表中心位置，默认为视图的中间
@property (nonatomic, assign) CGFloat pieRadius;  // 图表半径。默认为长宽取最小值的一半减30,最小10。
@property (nonatomic, assign) CGFloat pieHollowRadiusPercentage;  // 图表空心半径。0,取值[0~1];
@property (nonatomic, assign) CGFloat startPieAngle;   // 图表开始位置的角度。默认为 -M_PI_2
@property (nonatomic, assign) CGFloat endPieAngle;     // 图表开始位置的角度。默认为 M_PI_2*3

// 项设置
@property (nonatomic, assign) CGFloat sliceSpace;       // 圆心间隙，默认为0
@property (nonatomic, assign) CGFloat selectSliceOffset; // 选择一项时，偏移的值，默认为3.0，是在sliceOffset的基础上加上这个值
@property (nonatomic, assign) CGFloat selectedSliceOffsetRadius;  // 选中后偏移，偏移的值，默认为10，不能小于selectSliceOffset

// 值设置
@property (nonatomic, copy) NSArray<NSNumber *> *values;  // 设置值，不支持负数
@property (nonatomic, copy) NSArray<UIColor *> *colors;  // 颜色值，16进制
@property (nonatomic, copy) NSArray<NSString *> *instructions;  // 指示文本
@property (nonatomic, copy) NSArray<UIColor *> *instructionColors;  // 指示文本颜色

@property (nonatomic, assign) BOOL drawInstructionLine;  // 画线

@property (nonatomic, copy) NSString *pieCenterText;  // 圆心文本
@property (nonatomic, copy) NSAttributedString *pieCenterAttributedString;  // 圆心文本

// 重新加载刷新数据
- (void)reloadData;

@end
