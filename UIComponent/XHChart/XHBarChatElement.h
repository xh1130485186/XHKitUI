//
//  XHBarChatElement.h
//  图表
//
//  Created by 向洪 on 2017/10/16.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 柱状图元素
 */
@interface XHBarChatElement : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray<NSNumber *> *datas;

@end
