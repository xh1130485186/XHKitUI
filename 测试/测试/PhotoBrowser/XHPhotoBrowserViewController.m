//
//  XHPhotoBrowserViewController.m
//  GrowthCompass
//
//  Created by 向洪 on 16/11/21.
//  Copyright © 2016年 向洪. All rights reserved.
//

#import "XHPhotoBrowserViewController.h"
#import "XHPhotoBrowserCell.h"
#import "UIView+XHRect.h"
#import "Masonry.h"
#import "XHUICommonDefines.h"

@interface XHPhotoBrowserViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,UIScrollViewDelegate>
{

    UICollectionView *_collectionView;
    
    UIButton *_backButton;
    UIButton *_selectButton;
    UILabel *_titleLabel;
    
    NSBundle *_resourcesBundle;
}
@property (nonatomic, strong) UIView *navBar;

@end

@implementation XHPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializedAppearance];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if (self.navigationController && self.navigationController.viewControllers.count != 1) {
        [_backButton setImage:[UIImage imageNamed:@"xh.photo.browser.bundle/返回.png"] forState:UIControlStateNormal];
    } else {
        
        [_backButton setImage:[UIImage imageNamed:@"xh.photo.browser.bundle/叉.png"] forState:UIControlStateNormal];
    }
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(XHPhotoBrowserViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(photoBrowserViewController:didCurrentIndexChanged:)]) {
        [self.delegate photoBrowserViewController:self didCurrentIndexChanged:self.currentIndex];
    }
    
//    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navBar setHidden:YES];
        [self.bottomCustomView setHidden:YES];
    });
}

- (void)viewWillDisappear:(BOOL)animated {

    if (self.navigationController) {
    
        // 消失的时候关闭播放器
        [_collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            XHPhotoBrowserCell *photoBrowsercell = obj;
            [photoBrowsercell.playerView pause];
            
        }];
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    
    
    [super viewWillDisappear:animated];
}

- (void)initializedAppearance {
    
    _resourcesBundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"xh.photo.browser"]];
    _navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.xh_width, 64)];
    _navBar.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.6];

    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
//    _titleLabel.bounds = CGRectMake(0, 32, 100, 20);
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = [NSString stringWithFormat:@"%zi/%zi", (long)_currentIndex + 1, (long)_dataSource.count];
    //    [_titleLabel sizeToFit];
//    [_titleLabel setCenter:CGPointMake(self.view.xh_width * 0.5, 40)];
    [_navBar addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-14);
    }];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _backButton.frame = CGRectMake(0, 30, 28, 28);
    _backButton.titleLabel.font = [UIFont systemFontOfSize:14];

    [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [_navBar addSubview:_backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(-8);
    }];
    
    _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectButton.frame = CGRectMake(self.view.xh_width - 35, 30, 28, 28);
    [_selectButton addTarget:self action:@selector(meaunAction) forControlEvents:UIControlEventTouchUpInside];
    [_selectButton setImage:[UIImage imageNamed:@"xh.photo.browser.bundle/更多.png"] forState:UIControlStateNormal];
//    [_navBar addSubview:_selectButton];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.xh_width, self.view.xh_height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
//    [_collectionView registerNib:[UINib nibWithNibName:@"XHPhotoBrowserCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kIDENTIFIERCELL_XHPHOTOBROWSERCELL];
    [_collectionView registerClass:[XHPhotoBrowserCell class] forCellWithReuseIdentifier:kIDENTIFIERCELL_XHPHOTOBROWSERCELL];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake((self.view.xh_width) * _currentIndex, 0);
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.view addSubview:_navBar];
    [_navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(UINavTopHeight);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

#pragma mark - setter
- (void)setBottomCustomView:(UIView *)bottomCustomView {

    if (_bottomCustomView.superview) {
        [_bottomCustomView removeFromSuperview];
    }
    
    bottomCustomView.frame = CGRectMake(0, self.view.xh_height - bottomCustomView.xh_height, self.view.xh_width, bottomCustomView.xh_height);
    [self.view addSubview:bottomCustomView];

    _bottomCustomView = bottomCustomView;
}


#pragma mark - Event

- (void)backAction {

    if (self.navigationController && self.navigationController.viewControllers.count != 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)meaunAction {

    if (_delegate && [_delegate conformsToProtocol:@protocol(XHPhotoBrowserViewControllerDelegate)] && [_delegate respondsToSelector:@selector(didClickMoreOfPhotoBrowserViewController:)]) {
        [_delegate didClickMoreOfPhotoBrowserViewController:self];
    }
    
}

#pragma mark - delegate <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XHPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIDENTIFIERCELL_XHPHOTOBROWSERCELL forIndexPath:indexPath];
    cell.model = _dataSource[indexPath.row];
    if (!cell.singleTapGestureBlock) {
        __weak __typeof(self)weakSelf = self;
        cell.singleTapGestureBlock = ^(){
            
            if (weakSelf.navBar.hidden) {
                [weakSelf.navBar setHidden:NO];
                [weakSelf.bottomCustomView setHidden:NO];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navBar setHidden:YES];
                    [weakSelf.bottomCustomView setHidden:YES];
                });
            } else {
            
//                if (self.navigationController && self.navigationController.viewControllers.count != 1) {
//                    [self.navigationController popViewControllerAnimated:YES];
//                } else {
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                }
            }
        };
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

    XHPhotoBrowserCell *photoBrowsercell = (XHPhotoBrowserCell *)cell;
    [photoBrowsercell setZoomScale:1];
    [photoBrowsercell.playerView pause];
    
    CGPoint offSet = collectionView.contentOffset;
    _currentIndex = offSet.x / self.view.xh_width;
    
    _titleLabel.text = [NSString stringWithFormat:@"%zi/%zi", (long)_currentIndex + 1, (long)_dataSource.count];
    [_titleLabel setCenter:CGPointMake(self.view.xh_width * 0.5, 40)];
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(XHPhotoBrowserViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(photoBrowserViewController:didCurrentIndexChanged:)]) {
        [self.delegate photoBrowserViewController:self didCurrentIndexChanged:self.currentIndex];
    }
}

#pragma mark - Setter Methods
- (void)setPhotoArr:(NSArray *)photoArr {

    _photoArr = [photoArr copy];
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:photoArr.count];
    [_photoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        XHPhotoBrowser *photo = [XHPhotoBrowser photoBrowserWithThumbImage:obj bigImageURL:nil];
        [dataArr addObject:photo];
    }];
    self.dataSource = dataArr;
}

- (void)setPhotoURLArr:(NSArray *)photoURLArr {

    _photoURLArr = [photoURLArr copy];
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:_photoURLArr.count];
    [_photoURLArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        XHPhotoBrowser *photo = [XHPhotoBrowser photoBrowserWithThumbImage:nil bigImageURL:obj];
        [dataArr addObject:photo];
    }];
    
    self.dataSource = dataArr;
}
- (void)setPhotoPathArr:(NSArray *)photoPathArr {

    _photoPathArr = photoPathArr;
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:_photoPathArr.count];
    NSMutableArray *urlArr = [NSMutableArray arrayWithCapacity:_photoPathArr.count];
    [_photoPathArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURL *url = [NSURL URLWithString:obj];
        XHPhotoBrowser *photo = [XHPhotoBrowser photoBrowserWithThumbImage:nil bigImageURL:url];
        [dataArr addObject:photo];
        [urlArr addObject:url];
    }];
    self.dataSource = dataArr;
    _photoURLArr = urlArr;
}

- (void)setDataSource:(NSArray<XHPhotoBrowser *> *)dataSource {

    _dataSource = [dataSource copy];
    self.currentIndex = 0;
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(XHPhotoBrowserViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(photoBrowserViewController:didCurrentIndexChanged:)]) {
        [self.delegate photoBrowserViewController:self didCurrentIndexChanged:self.currentIndex];
    }
    
    [_collectionView reloadData];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    
    if (currentIndex < _dataSource.count) {
        _currentIndex = currentIndex;
        _titleLabel.text = [NSString stringWithFormat:@"%zi/%zi", (long)_currentIndex + 1, (long)_dataSource.count];
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
//        [_collectionView setContentOffset:CGPointMake((self.view.xh_width) * _currentIndex, 0) animated:NO];
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
