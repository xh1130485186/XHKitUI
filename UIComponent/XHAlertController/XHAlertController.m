//
//  XHAlertContorller.m
//  HuiJiaoXiaoxin
//
//  Created by 向洪 on 15/12/1.
//  Copyright © 2015年 向洪. All rights reserved.
//

#import "XHAlertController.h"
#import "UIApplication+VisibleViewController.h"

//#define kKeyWindow [[[UIApplication sharedApplication] delegate] window]
#define IOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

@implementation XHAlertAction

+ (nullable instancetype)actionWithTitle:(nullable NSString *)title actionStyle:(UIAlertActionStyle)style alertActionHandler:( void(^_Nullable __strong)(void))handler {
    XHAlertAction *action = [[XHAlertAction alloc] init];
    action.title = title;
    action.handler = handler;
    action.style = style;
    return action;
}
@end


@interface XHAlertView ()<UIAlertViewDelegate>

@property (nonatomic, copy) NSArray<XHAlertAction *> *actions;

@end

@implementation XHAlertView

+ (nullable XHAlertView *)shareXHAlertView; {
    
    static XHAlertView *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XHAlertView alloc] init];
    });
    
    return manager;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

- (void)createAlertIos8BeforeWithMessage:(nonnull NSString *)message actions:(nullable NSArray<XHAlertAction *> *)actions {

    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    _actions = actions;
    [actions enumerateObjectsUsingBlock:^(XHAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [alertView addButtonWithTitle:obj.title];
    }];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    XHAlertAction *action = self.actions[buttonIndex];
    if (action && action.handler) {
        action.handler();
    }
    _actions = nil;
}
#pragma clang diagnostic pop

@end


@interface XHSheetAlertView ()<UIActionSheetDelegate>

@property (nonatomic, copy) NSArray<XHAlertAction *> *actions;

@end


@implementation XHSheetAlertView

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

+ (nullable XHSheetAlertView *)shareXHSheetAlertView {
    
    static XHSheetAlertView *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XHSheetAlertView alloc] init];
    });
    
    return manager;
}

- (void)createAlertIos8BeforeWithMessage:(nonnull NSString *)message actions:(nullable NSArray<XHAlertAction *> *)actions {
    
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"温馨提示" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    _actions = actions;
    [actions enumerateObjectsUsingBlock:^(XHAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [sheet addButtonWithTitle:obj.title];
    }];
    
    [sheet showInView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
}

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//
//    XHAlertAction *action = self.actions[buttonIndex];
//    if (action && action.handler) {
//        action.handler();
//    }
//    _actions = nil;
//}
#pragma clang diagnostic pop

@end



@interface XHAlertController ()<UIAlertViewDelegate, UIActionSheetDelegate>

@end

@implementation XHAlertController

+ (void)alertWithMessage:(nonnull NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle actions:(nullable NSArray<XHAlertAction *> *)actions {
    
    [XHAlertController alertWithMessage:message preferredStyle:preferredStyle actions:actions showViewController:nil];
}

+ (void)alertWithMessage:(nonnull NSString *)message {
    
    [self alertWithMessage:message sure:nil];

}

+ (void)alertWithMessage:(nonnull NSString *)message sure:(nullable XHAlertControllerBlock)sure {

    if (![message isKindOfClass:[NSString class]]) {
        return;
    }
    XHAlertAction *action1 = [XHAlertAction actionWithTitle:@"确定" actionStyle:UIAlertActionStyleDefault alertActionHandler:^{
        
        if (sure) {
            sure();
        }
    }];
    [XHAlertController alertWithMessage:message preferredStyle:UIAlertControllerStyleAlert actions:@[action1]];
}

+ (void)alertWithMessage:(nonnull NSString *)message sure:(nullable XHAlertControllerBlock)sure cancel:(nullable XHAlertControllerBlock)cancel;
 {
    
    if (![message isKindOfClass:[NSString class]]) {
        return;
    }
     XHAlertAction *action1 = [XHAlertAction actionWithTitle:@"确定" actionStyle:UIAlertActionStyleDefault alertActionHandler:sure];
     XHAlertAction *action2 = [XHAlertAction actionWithTitle:@"取消" actionStyle:UIAlertActionStyleCancel alertActionHandler:cancel];
    [XHAlertController alertWithMessage:message preferredStyle:UIAlertControllerStyleAlert actions:@[action1, action2]];

}


+ (void)alertWithMessage:(nonnull NSString *)message showViewController:(nonnull UIViewController *)viewController {

    [XHAlertController alertWithMessage:message sure:nil showViewController:viewController];
    
}

+ (void)alertWithMessage:(nonnull NSString *)message sure:(nullable XHAlertControllerBlock)sure showViewController:(nonnull UIViewController *)viewController {

    if (![message isKindOfClass:[NSString class]]) {
        return;
    }
    
    XHAlertAction *action1 = [XHAlertAction actionWithTitle:@"确定" actionStyle:UIAlertActionStyleDefault alertActionHandler:^{
        
        if (sure) {
            sure();
        }
    }];
    [XHAlertController alertWithMessage:message preferredStyle:UIAlertControllerStyleAlert actions:@[action1] showViewController:viewController];
}

+ (void)alertWithMessage:(nonnull NSString *)message sure:(nullable XHAlertControllerBlock)sure cancel:(nullable XHAlertControllerBlock)cancel showViewController:(nonnull UIViewController *)viewController {

    if (![message isKindOfClass:[NSString class]]) {
        return;
    }
    
    XHAlertAction *action1 = [XHAlertAction actionWithTitle:@"确定" actionStyle:UIAlertActionStyleDefault alertActionHandler:sure];
    XHAlertAction *action2 = [XHAlertAction actionWithTitle:@"取消" actionStyle:UIAlertActionStyleCancel alertActionHandler:cancel];
    [XHAlertController alertWithMessage:message preferredStyle:UIAlertControllerStyleAlert actions:@[action1, action2] showViewController:viewController];
}

+ (void)alertWithMessage:(nonnull NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle actions:(nullable NSArray<XHAlertAction *> *)actions showViewController:(nullable UIViewController *)viewController {

    CGFloat iosVersion = IOSVersion;
    
    if (iosVersion > 8.0) {
        if (!viewController) {
            
            viewController = [[UIApplication sharedApplication] visibleViewController];
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:preferredStyle];
    
        [actions enumerateObjectsUsingBlock:^(XHAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:obj.title style:obj.style handler:^(UIAlertAction *action) {
                if (obj.handler) {
                    obj.handler();
                }
            }];
            [alertController addAction:confirmAction];
        }];
        [viewController presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        if (preferredStyle == UIAlertControllerStyleAlert) {
            XHAlertView *alertView = [XHAlertView shareXHAlertView];
            [alertView createAlertIos8BeforeWithMessage:message actions:actions];
        } else {
            
            XHSheetAlertView *sheet = [XHSheetAlertView shareXHSheetAlertView];
            [sheet createAlertIos8BeforeWithMessage:message actions:actions];
        }
        
    }
    
}

@end
