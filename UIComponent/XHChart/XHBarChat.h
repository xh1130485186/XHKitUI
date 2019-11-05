//
//  XHBarChat.h
//  图表
//
//  Created by 向洪 on 2017/10/16.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHChat.h"
#import "XHBarChatElement.h"

/**
 柱状图
 */
@interface XHBarChat : XHChat

// 显示x轴，默认为yes
@property (nonatomic) BOOL disPlayAxisX;
// 显示y轴，默认为yes
@property (nonatomic) BOOL disPlayAxisY;

// 显示x轴辅助线，默认为no
@property (nonatomic) BOOL disPlayAuxiliaryLineX;
// 显示y轴辅助线，默认为no
@property (nonatomic) BOOL disPlayAuxiliaryLineY;

// 允许负x轴，默认为no
@property (nonatomic) BOOL allowMinusAxisX;
// 允许负y轴，默认为no
@property (nonatomic) BOOL allowMinusAxisY;
// 名字，设置块的名字
@property (nonatomic, copy) NSArray *names;
// 颜色
@property (nonatomic, copy) NSArray *colors;
// 值
@property (nonatomic, copy) NSArray<XHBarChatElement *> *values;

@end
