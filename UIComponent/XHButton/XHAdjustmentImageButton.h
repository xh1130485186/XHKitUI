//
//  XHAdjustmentImageButton.h
//  BSGrowthViewing
//
//  Created by 向洪 on 2018/4/16.
//  Copyright © 2018年 向洪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    XHAdjustmentImageTop,
    XHAdjustmentImageBottom,
    XHAdjustmentImageLeft,
    XHAdjustmentImageRight,
} XHAdjustmentImageButtonType;

@interface XHAdjustmentImageButton : UIButton

/**
 默认为XHAdjustmentImageRight
 */
@property (nonatomic, assign) XHAdjustmentImageButtonType adjustmentImageButtonType;

@property (nonatomic, strong) UIColor *highlightedBackgroundColor;

@end
