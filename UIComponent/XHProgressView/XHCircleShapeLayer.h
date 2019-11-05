//
//  XHCircleShapeLayer.h
//  GrowthCompass
//
//  Created by 向洪 on 2017/5/3.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

/**
 进度条
 */
@interface XHCircleShapeLayer : CAShapeLayer

/**
 开始度数，默认为-M_PI_2
 */
@property (nonatomic, assign) CGFloat startAngle;

/**
 结束度数，默认为3*M_PI_2;
 */
@property (nonatomic, assign) CGFloat endAngle;

/**
 方向，默认为yes
 */
@property (nonatomic, assign) BOOL clockwise;

/**
 设置线条颜色。设置strokeColor属性能达到同样的效果
 */
@property (nonatomic, strong) UIColor *progressColor;

/**
 阴影颜色
 */
@property (nonatomic, strong) UIColor *progressShadowColor;

/**
 进度值，0-1
 */
@property (nonatomic, assign) CGFloat value;

/**
 中间文本字符串
 */
@property (nonatomic, copy) NSString *string;
@property (nonatomic, copy) NSAttributedString *attributedString;

@end
