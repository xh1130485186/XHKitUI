//
//  XHAlertContorller.h
//  HuiJiaoXiaoxin
//
//  Created by 向洪 on 15/12/1.
//  Copyright © 2015年 向洪. All rights reserved.
//

/* 系统提示框适配ios 7， 8 */

/**
 注意事项：
 1.调用弹出时，如果没有设置showController 默认使用 [[[UIApplication sharedApplication] delegate] window].rootViewController 如果上面正在做一下[[[UIApplication sharedApplication] delegate] window]操作如，加了视图等，先移出在进行弹出警告框
 2.如果当前需要当初的视图控制器有父类的视图，建议使用父类
 3.如果需要销毁控制器后，需要弹出警告，可以使用不带showController的方式
 
 */
#import <UIKit/UIKit.h>

typedef void(^AlertActionHandler)(void);

@interface XHAlertAction : NSObject

// 标题
@property (nonatomic, copy, nullable) NSString *title;

// block 回调
@property (nonatomic, copy, nullable) AlertActionHandler handler;

@property (nonatomic) UIAlertActionStyle style;

/**
 初始化

 @param title   标题
 @param style   UIAlertActionStyle
 @param handler block回调

 @return XHAlertAction
 */
+ (nullable instancetype)actionWithTitle:(nullable NSString *)title actionStyle:(UIAlertActionStyle)style alertActionHandler:(void(^ _Nullable __strong)(void))handler;

@end

@interface XHAlertView : NSObject

+ (nullable XHAlertView *)shareXHAlertView;
- (void)createAlertIos8BeforeWithMessage:(nonnull NSString *)message actions:(nullable NSArray<XHAlertAction *> *)actions;

@end


@interface XHSheetAlertView : NSObject

+ (nullable XHSheetAlertView *)shareXHSheetAlertView;
- (void)createAlertIos8BeforeWithMessage:(nonnull NSString *)message actions:(nullable NSArray<XHAlertAction *> *)actions;

@end


typedef void(^XHAlertControllerBlock) (void);

@interface XHAlertController : NSObject
/**
 *  带确认的警告框
 *
 *  @param message 消息
 */
+ (void)alertWithMessage:(nonnull NSString *)message;

+ (void)alertWithMessage:(nonnull NSString *)message sure:(nullable XHAlertControllerBlock)sure;

/**
 *  带回调的确认取消的警告框
 *
 *  @param message 消息
 *  @param sure    确定block
 *  @param cancel  取消block
 */
+ (void)alertWithMessage:(nonnull NSString *)message sure:(nullable XHAlertControllerBlock)sure cancel:(nullable XHAlertControllerBlock)cancel;

/**
 *  自定义警告
 *
 *  @param message        消息
 *  @param preferredStyle 样式
 *  @param actions        回调
 */
+ (void)alertWithMessage:(nonnull NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle actions:(nullable NSArray<XHAlertAction *> *)actions;

/**
 *  带确认的警告框
 *
 *  @param message        消息
 *  @param viewController 显示的viewController
 */
+ (void)alertWithMessage:(nonnull NSString *)message showViewController:(nonnull UIViewController *)viewController;

+ (void)alertWithMessage:(nonnull NSString *)message sure:(nullable XHAlertControllerBlock)sure showViewController:(nonnull UIViewController *)viewController;

/**
 *  带回调的确认取消的警告框
 *
 *  @param message        消息
 *  @param sure           确定block
 *  @param cancel         取消block
 *  @param viewController 显示的viewController
 */
+ (void)alertWithMessage:(nonnull NSString *)message sure:(nullable XHAlertControllerBlock)sure cancel:(nullable XHAlertControllerBlock)cancel showViewController:(nonnull UIViewController *)viewController;

/**
 *  自定义警告
 *
 *  @param message        消息
 *  @param preferredStyle 样式
 *  @param actions        回调
 *  @param viewController 显示的viewController
 */
+ (void)alertWithMessage:(nonnull NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle actions:(nullable NSArray<XHAlertAction *> *)actions showViewController:(nullable UIViewController *)viewController;

@end

