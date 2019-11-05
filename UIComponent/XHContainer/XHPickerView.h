//
//  XHPickerView.h
//  BSGrowthViewing
//
//  Created by 向洪 on 2017/8/16.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHContainerControl.h"

@protocol XHPickerViewDelegate;
@protocol XHPickerViewDataSource;

@interface XHPickerView : XHContainerControl

/**
 内容显示的pickerView
 */
@property (nonatomic, strong, readonly) UIPickerView *contentPickerView;

/**
 协议
 */
@property (nonatomic, weak) id<XHPickerViewDataSource> dataSource;
@property (nonatomic, weak) id<XHPickerViewDelegate> delegate;

@property (nonatomic, strong) UIColor *tintColor;

/**
 标题
 */
@property (nonatomic, copy) NSString *title;
/**
 字体等数值
 */
@property (nonatomic, strong) NSDictionary<NSString *,id> *textAttributes;

@end


@class XHPickerView;

@protocol XHPickerViewDelegate <NSObject>

@optional
- (void)xh_pickerView:(XHPickerView *)pickerView didConfirmDisappear:(BOOL)isConfirm;
- (void)xh_pickerViewDisappearInConfirmation:(XHPickerView *)pickerView;
- (void)xh_pickerViewDisappearInUnConfirmation:(XHPickerView *)pickerView;

@end

@protocol XHPickerViewDataSource <NSObject>

- (NSInteger)xh_numberOfComponentsInPickerView:(XHPickerView *)pickerView;

- (NSInteger)xh_pickerView:(XHPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@optional

- (NSString *)xh_pickerView:(XHPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void)xh_pickerView:(XHPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end
