//
//  XHChartHelper.m
//  图表
//
//  Created by 向洪 on 2017/10/16.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHChartHelper.h"

@implementation XHChartHelper

+ (CGRect)boundingRectWithSize:(CGSize)size font:(UIFont *)font string:(NSString *)string {
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSParagraphStyleAttributeName: paragraph};
    
    
    CGRect return_rect = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    return CGRectMake(0, 0, ceil(return_rect.size.width), ceil(return_rect.size.height));
    
    
}

@end
