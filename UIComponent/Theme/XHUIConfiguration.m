//
//  XHUIConfiguration.m
//  BSGrowthViewing
//
//  Created by 向洪 on 2017/8/11.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHUIConfiguration.h"
#import "XHThemeManager.h"

@implementation XHUIConfiguration

+ (instancetype)sharedInstance {
    
    static dispatch_once_t pred;
    static XHUIConfiguration *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[XHUIConfiguration alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {

    self = [super init];
    if (self) {
        [self initDefaultConfiguration];
    }
    return self;
}

- (void)initDefaultConfiguration {

    self.grayColor = [UIColor grayColor];
    self.darkGrayColor = [UIColor darkGrayColor];
    self.lightGrayColor = [UIColor lightGrayColor];
    self.imageViewBackgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.themeTintColor = [UIApplication sharedApplication].keyWindow.tintColor;
    self.assistColor = [UIApplication sharedApplication].keyWindow.tintColor;
    self.separatorColor = [UIColor colorWithWhite:231/255.f alpha:1];
    
}
@end
