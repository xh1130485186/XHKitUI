//
//  XHCircleProgressView.h
//  GrowthCompass
//
//  Created by 向洪 on 2017/5/3.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHCircleShapeLayer.h"

/**
 圆环进度条
 */
@interface XHCircleProgressView : UIView

/**
 进度值，0-1
 */
@property (nonatomic) CGFloat progress;

/**
 线条宽度，默认20
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 主调颜色
 */
@property (nonatomic, strong) UIColor *tintColor;

/**
 中间文本字符串
 */
@property (nonatomic, copy) NSString *string;
@property (nonatomic, copy) NSAttributedString *attributedString;

@property (nonatomic, strong, readonly) XHCircleShapeLayer *progressLayer;

@end
