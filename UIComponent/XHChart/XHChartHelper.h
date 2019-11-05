//
//  XHChartHelper.h
//  图表
//
//  Created by 向洪 on 2017/10/16.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHChartHelper : NSObject

/**
 计算字体显示需要的大小

 @param size 最大size
 @param font 字体
 @param string 文字
 @return 显示需要的size
 */
+ (CGRect)boundingRectWithSize:(CGSize)size
                          font:(UIFont *)font
                        string:(NSString *)string;

@end
