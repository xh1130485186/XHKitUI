//
//  XHPhotoBrowserViewController.h
//  GrowthCompass
//
//  Created by 向洪 on 16/11/21.
//  Copyright © 2016年 向洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHPhotoBrowser.h"

@class XHPhotoBrowserViewController;

@protocol XHPhotoBrowserViewControllerDelegate <NSObject>

@optional
/**
 点击更多的时候调用 （目前更多也屏蔽）

 @param photoBrowserViewController XHPhotoBrowserViewController
 */
- (void)didClickMoreOfPhotoBrowserViewController:(XHPhotoBrowserViewController *)photoBrowserViewController;


/**
 当前index发送变换时

 @param photoBrowserViewController photoBrowserViewController
 @param currentIndex index
 */
- (void)photoBrowserViewController:(XHPhotoBrowserViewController *)photoBrowserViewController didCurrentIndexChanged:(NSInteger)currentIndex;

@end

@interface XHPhotoBrowserViewController : UIViewController

@property (nonatomic, weak) id<XHPhotoBrowserViewControllerDelegate> delegate;

/** data */
@property (nonatomic, copy) NSArray<XHPhotoBrowser *> *dataSource;
@property (nonatomic, copy) NSArray *photoArr;
@property (nonatomic, copy) NSArray *photoURLArr;
@property (nonatomic, copy) NSArray *photoPathArr;

@property (nonatomic, assign) NSInteger currentIndex;


// The custom view
@property (nonatomic, strong) UIView *bottomCustomView;

@end
