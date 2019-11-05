//
//  XHUIKit.h
//  XHKitUIDemo
//
//  Created by 向洪 on 2019/11/5.
//  Copyright © 2019 向洪. All rights reserved.
//

#ifndef XHUIKit_h
#define XHUIKit_h

#pragma mark - 界面组件

// 文本控件
#import "XHDigitalAnimationLabel.h"  // 支持数字动态变化
// 提示
#import "XHAlertController.h"  // 对系统控制的简单封装
// 按钮
#import "XHAdjustmentImageButton.h" // 更好的支持一个图片和文字

// 图表
#import "XHChat.h" // 图表基类
#import "XHBarChat.h" // 柱状图
#import "XHMeterChartView.h" // 仪表图
#import "XHPieChart.h" // 饼图

#import "XHCircleProgressView.h" // 进度条

// 弹出
#import "XHContainerControl.h"
#import "XHPopupMenu.h"   // 底部弹出图文的菜单选择
#import "XHPopupSectionMenu.h"  // 底部弹出多组图文的菜单选择
#import "XHPickerView.h"  // 选择器
#import "XHDatePicker.h"  // 时间选择

// 下拉菜单
// 水平带下划线的选择菜单
#import "XHHorizontalMenuView.h"
// 支持设置placeholder的TextView
#import "XHTextView.h"

#endif /* XHUIKit_h */
