//
//  XHCommonThemeViewController.m
//  BSGrowthViewing
//
//  Created by 向洪 on 2017/8/11.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHCommonThemeViewController.h"
#import "XHThemeManager.h"

@interface XHCommonThemeViewController ()

@end

@implementation XHCommonThemeViewController

- (void)viewDidLoad {
    
    id currentTheme = [XHThemeManager sharedInstance].currentTheme;
    if (currentTheme) {
        
        _themeTintColor = [XHThemeManager sharedInstance].currentTheme.themeTintColor;
        
    } else {
        
        _themeTintColor = [[UIApplication sharedApplication] keyWindow].tintColor;
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (currentTheme) {
        [self themeBeforeChanged:nil afterChanged:currentTheme];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThemeChangedNotification:) name:XHThemeChangedNotification object:nil];
}


// 主题改变通知调用

- (void)handleThemeChangedNotification:(NSNotification *)notification {
    
    NSObject<XHThemeProtocol> *themeBeforeChanged = notification.userInfo[XHThemeBeforeChangedName];
    NSObject<XHThemeProtocol> *themeAfterChanged = notification.userInfo[XHThemeAfterChangedName];
    _themeTintColor = themeAfterChanged.themeTintColor;
    _assistColor = themeAfterChanged.assistColor;
    [self themeBeforeChanged:themeBeforeChanged afterChanged:themeAfterChanged];
}

#pragma mark - 主题更改协议

- (void)themeBeforeChanged:(NSObject<XHThemeProtocol> *)themeBeforeChanged afterChanged:(NSObject<XHThemeProtocol> *)themeAfterChanged {

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
