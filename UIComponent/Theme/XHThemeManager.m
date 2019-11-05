//
//  XHThemeManager.m
//  BSGrowthViewing
//
//  Created by 向洪 on 2017/8/11.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHThemeManager.h"

NSString *const XHThemeChangedNotification = @"XHThemeChangedNotification";
NSString *const XHThemeBeforeChangedName = @"XHThemeBeforeChangedName";
NSString *const XHThemeAfterChangedName = @"XHThemeAfterChangedName";

@implementation XHThemeManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static XHThemeManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (void)setCurrentTheme:(NSObject<XHThemeProtocol> *)currentTheme {
    
    BOOL isThemeChanged = _currentTheme != currentTheme;
    NSObject<XHThemeProtocol> *themeBeforeChanged = nil;
    if (isThemeChanged) {
        themeBeforeChanged = _currentTheme;
    }
    _currentTheme = currentTheme;
    if (isThemeChanged) {
        [currentTheme setupConfigurationTemplate];
        [[NSNotificationCenter defaultCenter] postNotificationName:XHThemeChangedNotification object:self userInfo:@{XHThemeBeforeChangedName: themeBeforeChanged ?: [NSNull null], XHThemeAfterChangedName: currentTheme ?: [NSNull null]}];
    }
}


@end
