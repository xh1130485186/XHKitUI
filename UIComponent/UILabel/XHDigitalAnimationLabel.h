//
//  XHDigitalAnimationLabel.h
//  GrowthCompass_2
//
//  Created by 向洪 on 2019/2/26.
//  Copyright © 2019 向洪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * _Nullable (^XHDigitalAnimationLabelFormatBlock)(CGFloat value);
typedef NSAttributedString * _Nullable (^XHDigitalAnimationLabelAttributedFormatBlock)(CGFloat value);

typedef NS_ENUM(NSInteger, XHDigitalAnimationLabelMode) {
    XHDigitalAnimationLabelLinear,
    XHDigitalAnimationLabelCurveEaseIn,
    XHDigitalAnimationLabelCurveEaseOut,
    XHDigitalAnimationLabelCurveEaseInOut,
};

/**
 数字变换
 */
@interface XHDigitalAnimationLabel : UILabel

// format
@property (nonatomic, strong, readonly) NSNumberFormatter *formatter;  // 默认整数最大个数为10，不支持小数
@property (nonatomic, copy) XHDigitalAnimationLabelFormatBlock formatBlock;
@property (nonatomic, copy) XHDigitalAnimationLabelAttributedFormatBlock attributedFormatBlock;

// animation
@property (nonatomic, assign) XHDigitalAnimationLabelMode animationMode;
- (void)valueFrom:(CGFloat)startValue to:(CGFloat)endValue;
- (void)valueFrom:(CGFloat)startValue to:(CGFloat)endValue duration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
