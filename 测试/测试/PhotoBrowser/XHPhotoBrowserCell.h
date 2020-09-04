//
//  XHPhotoBrowserCell.h
//  GrowthCompass
//
//  Created by 向洪 on 16/11/21.
//  Copyright © 2016年 向洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHPhotoBrowser.h"
#import "WMPlayer.h"

#define kIDENTIFIERCELL_XHPHOTOBROWSERCELL @"kXHPhotoBrowserCell"

@interface XHPhotoBrowserCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, copy) void (^singleTapGestureBlock)(void);
@property (nonatomic, strong) XHPhotoBrowser *model;
@property (nonatomic) UIEdgeInsets playerContentInset;
@property (nonatomic, strong, readonly) WMPlayer *playerView;

- (void)setZoomScale:(CGFloat)scale;

@end
