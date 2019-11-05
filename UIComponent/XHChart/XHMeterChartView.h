//
//  XHInstrumentChartView.h
//  BSGrowthViewing
//
//  Created by 向洪 on 2018/1/10.
//  Copyright © 2018年 向洪. All rights reserved.
//

#import "XHPieChart.h"


/**
 仪表图
 */
@interface XHMeterChartView : UIView

@property (nonatomic, strong, readonly) XHPieChart *pieChart;   // 饼图

// 值设置
@property (nonatomic, copy) NSArray<NSNumber *> *values;  // 设置值，不支持负数
@property (nonatomic, copy) NSArray<UIColor *> *colors;  // 颜色值，16进制
@property (nonatomic, copy) NSArray<NSString *> *instructions;  // 指示文本
@property (nonatomic, copy) NSArray<UIColor *> *instructionColors;  // 指示文本颜色

@property (nonatomic, assign) CGFloat value;      // 值
@property (nonatomic, strong) UIColor *valueColor; // 值颜色

@property (nonatomic, copy) NSString *pieCenterText;  // 圆心文本
@property (nonatomic, copy) NSAttributedString *pieCenterAttributedString;  // 圆心文本

/* 刷新数据 */
- (void)reloadData;


@end
