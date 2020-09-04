//
//  XHPhotoBrowserCell.m
//  GrowthCompass
//
//  Created by 向洪 on 16/11/21.
//  Copyright © 2016年 向洪. All rights reserved.
//

#import "XHPhotoBrowserCell.h"
#import "UIView+XHRect.h"
#import "UIImageView+WebCache.h"
#import "WMPlayer.h"
#import "SVProgressHUD.h"
#import "UIImage+XHRemote.h"
//#import "NSURL+XHExtension.h"
//#import "UIImage+XHExtension.h"
//#import "XHAVAILABILITY.h"

@interface XHPhotoBrowserCell ()<UIGestureRecognizerDelegate,UIScrollViewDelegate, WMPlayerDelegate> {
    
    CGFloat _aspectRatio;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *imageContainerView;

// 播放按钮
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) WMPlayer *playerView;

@end

@implementation XHPhotoBrowserCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {

    self.backgroundColor = [UIColor blackColor];
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, self.xh_width, self.xh_height);
    _scrollView.bouncesZoom = YES;
    _scrollView.maximumZoomScale = 2.5;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.multipleTouchEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    _scrollView.alwaysBounceVertical = NO;
    [self.contentView addSubview:_scrollView];
    
    _imageContainerView = [[UIView alloc] init];
    _imageContainerView.clipsToBounds = YES;
    [_scrollView addSubview:_imageContainerView];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_imageContainerView addSubview:_imageView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [tap1 requireGestureRecognizerToFail:tap2];
    [self addGestureRecognizer:tap2];
}

- (void)layoutSubviews {

    [super layoutSubviews];
    _playButton.center = CGPointMake(self.contentView.xh_width * 0.5, self.contentView.xh_height * 0.5);
    
}


#pragma mark - private Methods

/**
 设置视频

 @param model XHPhotoBrowser
 */
- (void)setVideoWithModel:(XHPhotoBrowser *)model {
    WMPlayerModel *playerModel = [[WMPlayerModel alloc] init];
    playerModel.videoURL = model.url;
}

/**
 设置图片

 @param model XHPhotoBrowser
 */
- (void)setImageWithModel:(XHPhotoBrowser *)model {

    if (_playerView.superview) {
        [_playerView removeFromSuperview];
        [self.imageContainerView addSubview:self.imageView];
    }
    
    if (_model.thumbImage) {
        self.imageView.image = model.thumbImage;
    } else {
        self.imageView.image = _placeholderImage;
    }
    [self resizeSubviews];
    
    if (_model.url) {
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        __weak __typeof(self)weakSelf = self;
        [manager.imageCache containsImageForKey:_model.url.path cacheType:SDImageCacheTypeAll completion:^(SDImageCacheType containsCacheType) {
            if (containsCacheType == SDImageCacheTypeDisk || containsCacheType == SDImageCacheTypeMemory) {
                [weakSelf.imageView sd_setImageWithURL:weakSelf.model.url placeholderImage:weakSelf.imageView.image completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    [weakSelf resizeSubviews];
                }];
            } else {
                
                if (weakSelf.model.thumbUrl) {
                    [weakSelf.imageView sd_setImageWithURL:weakSelf.model.thumbUrl placeholderImage:weakSelf.imageView.image completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        [weakSelf resizeSubviews];
                    }];
                }
                [SVProgressHUD showProgress:0];
                [weakSelf.imageView sd_setImageWithURL:weakSelf.model.url placeholderImage:weakSelf.imageView.image options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                    dispatch_main_async_safe(^{
                        [SVProgressHUD showProgress:receivedSize / expectedSize];
                    });
                    
                } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    
                    [SVProgressHUD dismiss];
                    weakSelf.imageView.image = image;
                    [weakSelf resizeSubviews];
                    
                }];
            }
        }];
    }

}


#pragma mark - setter
- (void)setModel:(XHPhotoBrowser *)model {
    
    _model = model;
    [_scrollView setZoomScale:1.0 animated:NO];
    
//    XHFileType fileType = model.url.getFileType;
//    if (fileType == XHFileTypeVideo) {
//
//        [self setVideoWithModel:model];
//
//    } else if (fileType == XHFileTypeVoice) {
//
//    } else {
//
//        [self setImageWithModel:model];
//    }
//    if ([@[@"png", @"jpg", @"jpeg"] containsObject:model.url.pathExtension]) {
//        [self setImageWithModel:model];
//    }
    [self setImageWithModel:model];
    
}

- (void)setZoomScale:(CGFloat)scale {

    if (_scrollView.zoomScale != scale) {
        [_scrollView setZoomScale:scale animated:YES];
    }
}

#pragma mark - Public Methods

- (void)resizeSubviews {
    
    _imageContainerView.xh_origin = CGPointZero;
    _imageContainerView.xh_width = self.xh_width;
    
    UIImage *image = _imageView.image;
    CGFloat max_height = self.contentView.xh_height;
    if (_imageView.superview) {
        image = _imageView.image;
    } else if (_playerView.superview) {
//        image = _playerView.placeholderImage;
//        max_height -= _playerContentInset.bottom;
//        max_height -= _playerContentInset.top;
    }
    
    if (image.size.height / image.size.width > max_height / self.xh_width) {
        _imageContainerView.xh_height = floor(image.size.height / (image.size.width / self.xh_width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.xh_width;
        if (height < 1 || isnan(height)) height = max_height;
        height = floor(height);
        _imageContainerView.xh_height = height;
        _imageContainerView.xh_centerY = self.xh_height / 2;
    }
    if (_imageContainerView.xh_height > max_height && _imageContainerView.xh_height - max_height <= 1) {
        _imageContainerView.xh_height = max_height;
    }
    _scrollView.contentSize = CGSizeMake(self.xh_width, MAX(_imageContainerView.xh_height, max_height));
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.xh_height <= max_height ? NO : YES;
    //_imageView.frame = _imageContainerView.bounds;
    _imageContainerView.xh_centerY = self.xh_height / 2;
    if (_imageView.superview) {
        _imageView.frame = _imageContainerView.bounds;
    }
    
    if (_playerView.superview) {
        _playerView.frame = _imageContainerView.bounds;
    }
}

#pragma mark - delegate<WMPlayer>

- (void)wmplayer:(WMPlayer *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap {
    
    [self singleTap:nil];
}

#pragma mark - UITapGestureRecognizer Event


- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.xh_width/ newZoomScale;
        CGFloat ysize = self.xh_height/ newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    
    if (self.singleTapGestureBlock) {
        [_scrollView setZoomScale:1.0 animated:YES];
        self.singleTapGestureBlock();
        
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.xh_width > scrollView.contentSize.width) ? (scrollView.xh_width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.xh_height > scrollView.contentSize.height) ? (scrollView.xh_height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageContainerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initialize];
}

#pragma mark - getter

- (WMPlayer *)playerView {

    if (!_playerView) {
        _playerView = [[WMPlayer alloc] initWithFrame:self.contentView.bounds];
        _playerView.backBtnStyle = BackBtnStyleNone;
        _playerView.delegate = self;
     }
    return _playerView;
}

@end
