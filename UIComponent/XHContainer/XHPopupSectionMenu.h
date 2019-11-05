//
//  XHPopupSectionMenu.h
//  XHPopupSectionMenu
//
//  Created by 向洪 on 2017/12/18.
//  Copyright © 2017年 向洪. All rights reserved.
//


#import "XHPopupMenu.h"

NS_ASSUME_NONNULL_BEGIN

/// 分章节显示的弹出菜单，每一节显示一行，方向水平滑动。
@interface XHPopupSectionMenu : XHContainerControl

// items和titles对应
@property (nonatomic, copy) NSArray *items;  ///< XHPopupMenuItem，或者XHPopupMenuItem的数组
@property (nonatomic, copy) NSArray *titles; ///< 标题

@end

NS_ASSUME_NONNULL_END
