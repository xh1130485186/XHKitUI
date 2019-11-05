//
//  XHBarChat.m
//  图表
//
//  Created by 向洪 on 2017/10/16.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHBarChat.h"

@implementation XHBarChat

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    // 设置默认值
    _disPlayAxisX = YES;
    _disPlayAxisY = YES;
}

@end
