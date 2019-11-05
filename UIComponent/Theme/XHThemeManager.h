//
//  XHThemeManager.h
//  BSGrowthViewing
//
//  Created by 向洪 on 2017/8/11.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHThemeProtocol.h"

/**
 主题控制
 */
@interface XHThemeManager : NSObject

@property(nonatomic, strong) id<XHThemeProtocol> currentTheme;

/**
 单列构造

 @return 主题管理控制器
 */
+ (instancetype)sharedInstance;

@end
