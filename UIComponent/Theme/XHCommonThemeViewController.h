//
//  XHCommonThemeViewController.h
//  BSGrowthViewing
//
//  Created by 向洪 on 2017/8/11.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHUICommonViewController.h"
#import "XHThemeProtocol.h"

@interface XHCommonThemeViewController : XHUICommonViewController<XHChangingThemeDelegate>

/**
 主题颜色
 */
@property (nonatomic, strong) UIColor *themeTintColor;
@property (nonatomic, strong) UIColor *assistColor;


/**
 主题更改
 重新这个方法，进行主题改变之后的界面调整。
 使用：
 1.在主题改变中，对于已经存在的界面的试图，如果button的文字颜色无法更改，可以调用这个方法去更改颜色。
 2.针对改变全局的改变，比如apperce，可以是写XHThemeProtocol的 -setupConfigurationTemplate 方法去实现配置。

 @param themeBeforeChanged 改变前的主题协议对象
 @param themeAfterChanged 改变后的主题协议对象
 */
- (void)themeBeforeChanged:(NSObject<XHThemeProtocol> *)themeBeforeChanged afterChanged:(NSObject<XHThemeProtocol> *)themeAfterChanged;

@end
