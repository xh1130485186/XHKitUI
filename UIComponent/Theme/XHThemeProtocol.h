//
//  XHThemeProtocol.h
//  BSGrowthViewing
//
//  Created by 向洪 on 2017/8/11.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XHThemeProtocol <NSObject>

/**
 主题颜色

 @return 返回主题颜色
 */
- (UIColor *)themeTintColor;


/**
 辅助颜色

 @return 返回辅助颜
 */
- (UIColor *)assistColor;

/**
 主题全局配置
 */
- (void)setupConfigurationTemplate;

@end

@protocol XHChangingThemeDelegate <NSObject>

@required

/**
 主题改变的使用调用

 @param themeBeforeChanged 改变前的主题协议
 @param themeAfterChanged 改变后的主题协议
 */
- (void)themeBeforeChanged:(NSObject<XHThemeProtocol> *)themeBeforeChanged afterChanged:(NSObject<XHThemeProtocol> *)themeAfterChanged;

@end


// 当主题发生变化时，会发送这个通知
extern NSString *const XHThemeChangedNotification;
// 主题发生改变前的值，类型为 NSObject<XHThemeProtocol>，可能为 NSNull
extern NSString *const XHThemeBeforeChangedName;
// 主题发生改变后的值，类型为 NSObject<XHThemeProtocol>，可能为 NSNull
extern NSString *const XHThemeAfterChangedName;
