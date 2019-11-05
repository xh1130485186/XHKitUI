//
//  XHUIConfiguration.h
//  BSGrowthViewing
//
//  Created by 向洪 on 2017/8/11.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XHUICMI [XHUIConfiguration sharedInstance]
/**
 界面ui配置，可以简单的去设置配置
 */
@interface XHUIConfiguration : NSObject

@property (nonatomic, strong) UIColor *themeTintColor;
@property (nonatomic, strong) UIColor *assistColor;

@property (nonatomic, strong) UIColor *grayColor;
@property (nonatomic, strong) UIColor *darkGrayColor;
@property (nonatomic, strong) UIColor *lightGrayColor;

@property (nonatomic, strong) UIColor *separatorColor;

@property (nonatomic, strong) UIColor *imageViewBackgroundColor;

/// 单例对象
+ (instancetype)sharedInstance;


@end
