//
//  XHSecondMenu.h
//  GrowthCompass
//
//  Created by 向洪 on 2017/4/28.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHContainerControl.h"

@class XHSecondMenu;

/**
 一个二级显示文本菜单的控制器
 目前只支持从底部弹出
 */


@protocol XHSecondMenuDelegate <NSObject>

@optional
/**
 左侧section的个数

 @param secondMenu XHSecondMenu
 @return 数量
 */
- (NSInteger)numberOfSectionsInSecondMenu:(XHSecondMenu *)secondMenu;

/**
 右侧row的个数

 @param secondMenu XHSecondMenu
 @param section 在哪一个section
 @return 数量
 */
- (NSInteger)xh_secondMenu:(XHSecondMenu *)secondMenu numberOfRowsInSection:(NSInteger)section;

/**
 左侧section的title

 @param secondMenu XHSecondMenu
 @param section 位置
 @return 文本
 */
- (NSString *)xh_secondMenu:(XHSecondMenu *)secondMenu numberOfTitleInSection:(NSInteger)section;

/**
 右侧的title

 @param secondMenu XHSecondMenu
 @param indexPath 位置
 @return 文本
 */
- (NSString *)xh_secondMenu:(XHSecondMenu *)secondMenu titleAtIndexPath:(NSIndexPath *)indexPath;

/**
 选中时

 @param secondMenu XHSecondMenu
 @param indexPath 选择的位置
 */
- (void)xh_secondMenu:(XHSecondMenu *)secondMenu didSelectRowAtIndexPath:(NSIndexPath *)indexPath;


/**
 消失

 @param secondMenu XHSecondMenu
 @param selectedIndexPath 当前选中的行
 */
- (void)xh_secondMenu:(XHSecondMenu *)secondMenu didEndDisplayingWithCurrentSelectedIndexPath:(NSIndexPath *)selectedIndexPath;

@end

@interface XHSecondMenu : XHContainerControl

@property (nonatomic, weak) id<XHSecondMenuDelegate> delegate;

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 主题颜色
 */
@property (nonatomic, strong) UIColor *tintColor;

/**
 当前选中的位置
 */
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;


/**
 刷新数据
 */
- (void)relodData;

@end
