//
//  XHTextView.h
//  BSGrowthViewing
//
//  Created by 向洪 on 2017/8/18.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const XHTextViewPaddingTop;
extern CGFloat const XHTextViewPaddingLeft;
extern CGFloat const XHTextViewPaddingRight;
extern CGFloat const XHTextViewPaddingBottom;

@interface XHTextView : UITextView


@property(nullable, nonatomic,copy) IBInspectable NSString *placeholder;

/// placeholder 在默认位置上的偏移（默认位置会自动根据 textContainerInset、contentInset 来调整）
@property(nonatomic, assign) UIEdgeInsets placeholderMargins;

@end
