//
//  XHHorizontalMenuView.h
//  XHHorizontalMenuView
//
//  Created by 向洪 on 2017/7/4.
//  Copyright © 2017年 向洪. All rights reserved.
//



#import <UIKit/UIKit.h>

// 菜单种类
typedef enum : NSUInteger {
    XHHorizontalMenuTyleNone,    // 默认不滑动,item的宽度等值分配
    XHHorizontalMenuTyleScroll,  // 可以滑动，动态计算item宽度
    XHHorizontalMenuTyleAuto,    // 根据视图大小，自动适应
} XHHorizontalMenuTyle;

// 下划线样式
typedef enum : NSUInteger {
    XHHorizontalMenuUnderLineStyleNone,  // 根据item宽度来设置
    XHHorizontalMenuUnderLineStyleText,  // 根据文本的宽度来设置
} XHHorizontalMenuUnderLineStyle;

@interface XHHorizontalMenuView : UIView
// 字体大小
@property (nonatomic, strong) UIFont *font UI_APPEARANCE_SELECTOR;
// 颜色
@property (nonatomic, strong) UIColor *themeColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *normalColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) UIEdgeInsets contentInset UI_APPEARANCE_SELECTOR;   // default is UIEdgeInsetsMake(4, 8, 4, 8)
@property (nonatomic, assign) CGFloat interitemSpacing UI_APPEARANCE_SELECTOR;    // default is 8
@property (nonatomic, assign) XHHorizontalMenuTyle menuType UI_APPEARANCE_SELECTOR;
// 下划线样式
@property (nonatomic, assign) XHHorizontalMenuUnderLineStyle underLineStyle UI_APPEARANCE_SELECTOR;  //  default is XHHorizontalMenuUnderLineStyleNone
@property (nonatomic, assign) CGFloat underLineHeight UI_APPEARANCE_SELECTOR; // default is 2.0
// 设置下划线的位置。从当前位置移动到其他位置。progress可以设置进度
- (void)underLoctionToWithIndex:(NSInteger)index progress:(CGFloat)progress;

//@property(nonatomic, assign) BOOL alwaysBounceHorizontal;   // default is no

// 设置菜单标题
@property (nonatomic, copy) NSArray<NSString *> *itemTexts;
@property (nonatomic, copy) NSArray<UIImage *> *itemImages;   // 目前对图片的支持不是很好建议不要使用

// 当前选中
@property (nonatomic, assign) NSInteger selectedIndex;

// 初始化
- (instancetype)initWithFrame:(CGRect)frame itemTexts:(NSArray *)texts;
- (instancetype)initWithFrame:(CGRect)frame itemImages:(NSArray *)images itemTexts:(NSArray *)texts;

// 回调事件
- (void)menuSelectedIndexWithChangedHandler:(void(^)(NSInteger selectedIndex))handler;


@end
