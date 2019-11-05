//
//  XHDatePicker.h
//  BSGrowthViewing
//
//  Created by 向洪 on 2017/8/15.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHContainerControl.h"

@protocol XHDatePickerDelegate;

@interface XHDatePicker : XHContainerControl

@property (nonatomic, assign) id<XHDatePickerDelegate> delegate;

/**
 时间显示datePicker
 */
@property (nonatomic, strong, readonly) UIDatePicker *contentDatePicker;

/**
 当前日期
 */
@property (nonatomic, strong) NSDate *currentDate;

/**
 主题颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *tintColor;


@end


@protocol XHDatePickerDelegate <NSObject>

@optional

/**
 消失的时候
 
 @param datePicker XHDatePicker
 @param isConfirm 是否点击确定后消失，yes表示的确定消息，no表示放弃消失
 */
- (void)xh_datePicker:(XHDatePicker *)datePicker didConfirmDisappear:(BOOL)isConfirm;

/**
 选择某一个时间
 
 @param datePicker XHDatePicker
 @param date 选中的时间
 */
- (void)xh_datePicker:(XHDatePicker *)datePicker didSelectedAtDate:(NSDate *)date;

@end
