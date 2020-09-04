//
//  XHPhotoBrowser.m
//  XHPhotoBrowser
//
//  Created by 向洪 on 16/11/21.
//  Copyright © 2016年 向洪. All rights reserved.
//

#import "XHPhotoBrowser.h"

@interface XHPhotoBrowser ()

@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) NSURL *thumbUrl;
@property (nonatomic, strong) NSURL *url;

@end

@implementation XHPhotoBrowser

+ (XHPhotoBrowser *)photoBrowserWithThumbImage:(UIImage *)thumbImage bigImageURL:(NSURL *)url {
    
    XHPhotoBrowser *model = [[XHPhotoBrowser alloc] init];
    model.thumbImage = thumbImage;
    model.url = url;
    return model;
}

+ (XHPhotoBrowser *)photoBrowserWithThumbUrl:(NSURL *)thumbUrl bigImageURL:(NSURL *)url {

    XHPhotoBrowser *model = [[XHPhotoBrowser alloc] init];
    model.thumbUrl = thumbUrl;
    model.url = url;
    return model;
}

@end
