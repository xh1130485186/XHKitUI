//
//  XHPopupMenu.h
//  XHKitDemo
//
//  Created by 向洪 on 2019/8/28.
//  Copyright © 2019 向洪. All rights reserved.
//

#import "XHContainerControl.h"

NS_ASSUME_NONNULL_BEGIN

@class XHPopupMenuItem;

/// 弹出菜单
@interface XHPopupMenu : XHContainerControl

/// 数据
@property (nonatomic, copy) NSArray<XHPopupMenuItem *> *items;

@end

/// 弹出菜单的数据存储类
@interface XHPopupMenuItem : NSObject

@property (nonatomic, copy) UIImage *image; ///< 图片
@property (nonatomic, copy) NSString *name; ///< 名字
@property (nonatomic, copy) void(^handler)(void); ///< 回调

/// 创建
- (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image
                     handler:(void(^)(void))handler;

@end


@interface XHPopupMenuCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end


NS_ASSUME_NONNULL_END
