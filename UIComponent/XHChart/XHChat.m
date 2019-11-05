//
//  XHChat.m
//  图表
//
//  Created by 向洪 on 2017/10/16.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHChat.h"

@implementation XHChat

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeDate];
    }
    return self;
}

- (void)initializeDate {
    _animationDuring = 0.5;
}

@end
