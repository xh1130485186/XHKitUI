//
//  XHDropDownMenu.h
//  XHDropDownMenu
//
//  Created by 向洪 on 2017/9/7.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XHAdjustmentImageButton, XHDropDownCustomTableView;
/**
 用来继承使用自定义view
 */
@interface XHDropDownCustomView : UIView

/**
 自定义继承XHDropDownCustomView 调用这个方法用来传递信息

 @param information 信息内容
 */
- (void)transinformation:(id)information;

@end

@protocol XHDropDownMenuDelegate, XHDropDownMenuSingleDelegate;
@interface XHDropDownMenu : UIView

/**
 下拉菜单数据源
 */
@property (nonatomic, weak) id<XHDropDownMenuDelegate> delegate;

/**
 分割线颜色
 */
@property (nonatomic, strong) UIColor *separateLineColor;

/**
 蒙版颜色
 */
@property (nonatomic, strong) UIColor *coverColor;

/**
 主调颜色
 */
@property (nonatomic, strong) UIColor *tintColor;


/**
 可以设置简单的单行下拉选中菜单
 */
@property (nonatomic, weak) id<XHDropDownMenuSingleDelegate> singleDelegate;
/**
 和XHDropDownMenuSingleDelegate协议配合使用 
 */
@property (nonatomic, strong, readonly) XHDropDownCustomTableView *singleCustomTableView;

/**
 刷新
 */
- (void)reload;


- (void)dismiss;

@end

/**
 XHDropDownMenu 数据协议
 */

@protocol XHDropDownMenuDelegate <NSObject>

@optional
// 菜单的列数，不实现，默认为1
- (NSInteger)numberOfColumnInMenu:(XHDropDownMenu *)dropDownMenu;
// 标题
- (NSString *)dropDownMenu:(XHDropDownMenu *)menu titleForColumnAtIndex:(NSInteger)index;
- (XHAdjustmentImageButton *)dropDownMenu:(XHDropDownMenu *)menu buttonForColumnAtIndex:(NSInteger)index;

// 视图
- (XHDropDownCustomView *)dropDownMenu:(XHDropDownMenu *)pullDownMenu customViewColumnAtIndex:(NSInteger)index;
// 控制是否打开下拉选项，默认为yes
- (BOOL)dropDownMenuItemMoreWillOpen:(XHDropDownMenu *)dropDownMenu atIndex:(NSInteger)index;

@end

@protocol XHDropDownMenuSingleDelegate <XHDropDownMenuDelegate>

// 这里可以设置简单的文本下拉
- (NSInteger)dropDownMenu:(XHDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column;
- (NSString *)dropDownMenu:(XHDropDownMenu *)menu stringForRowAtIndexPath:(NSIndexPath *)indexPath;  // column 和 setion对应
@optional
- (void)dropDownMenu:(XHDropDownMenu *)menu didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

//@interface XHDropDownButton : UIButton
//@end

@interface XHDropDownCustomTableView : XHDropDownCustomView

- (void)setSelectRow:(NSInteger)row inColumn:(NSInteger)column;
@end
