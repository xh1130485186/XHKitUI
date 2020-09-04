//
//  XHPhotoBrowser.h
//  XHPhotoBrowser
//
//  Created by 向洪 on 16/11/21.
//  Copyright © 2016年 向洪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XHPhotoBrowser : NSObject

@property (nonatomic, strong, readonly) UIImage *thumbImage;
@property (nonatomic, strong, readonly) NSURL *thumbUrl;
@property (nonatomic, strong, readonly) NSURL *url;

+ (XHPhotoBrowser *)photoBrowserWithThumbImage:(UIImage *)thumbImage bigImageURL:(NSURL *)url;
+ (XHPhotoBrowser *)photoBrowserWithThumbUrl:(NSURL *)thumbUrl bigImageURL:(NSURL *)url;

@end
