//
//  ViewController.m
//  测试
//
//  Created by 向洪 on 2020/7/6.
//  Copyright © 2020 向洪. All rights reserved.
//

#import "ViewController.h"
#import "XHPhotoBrowserViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterNoStyle;
    numberFormatter.maximumFractionDigits = 0;
    numberFormatter.minimumIntegerDigits = 2;
    numberFormatter.maximumIntegerDigits = 2;
    numberFormatter.multiplier = @1;
//    return [numberFormatter stringFromNumber:@(score)];
    
    NSMutableArray *paths = [NSMutableArray array];
    for (int i = 0; i < 100; i ++) {
        
        NSString *path = [NSString stringWithFormat:@"http://media.pinsn.com/tidesun/TIDESUN-60%@.jpg", [numberFormatter stringFromNumber:@(i)]];
        [paths addObject:path];
    }
    
    XHPhotoBrowserViewController *vc = [[XHPhotoBrowserViewController alloc] init];
    vc.photoPathArr = paths;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
