//
//  XHPopupSectionMenu.m
//  XHPopupSectionMenu
//
//  Created by 向洪 on 2017/12/18.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHPopupSectionMenu.h"

typedef enum : NSUInteger {
    XHPopupMenuTypePain,
    XHPopupMenuTypeGroup,
} XHPopupMenuType;

#define kIDENTIFIERCELLPOPUPSECTION @"kXHIDENTIFIERCELLPOPUPSECTION"

@interface XHPopupSectionMenu () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, assign) NSInteger menuType;
@property (nonatomic, assign) NSInteger section;
//@property(nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray<NSArray<NSLayoutConstraint * > *> *collectionViewConstraints;
@property (nonatomic, strong) NSMutableArray<UICollectionView *> *collectionViewArr;

@property(nonatomic, strong) UIButton *cancelButton;

@end

@implementation XHPopupSectionMenu

- (instancetype)initWithSize:(CGSize)size style:(XHContainerStyle)style {
    self = [super initWithSize:size style:XHContainerBottom];
    if (self) {
        [self initalize];
    }
    return self;
}

- (void)initalize {
    
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.effectView.effect = blurEffect;
    
    _collectionViewArr = [NSMutableArray array];
    
    [self setupCancelUI];
}


#pragma mark - UI Methods

/// 取消按钮
- (void)setupCancelUI {
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancelButton.backgroundColor = [UIColor colorWithWhite:251/255.f alpha:1];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor colorWithWhite:153/255.f alpha:1] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    
    _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *cancelButtonConstraints = [NSMutableArray array];
    [cancelButtonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_cancelButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cancelButton)]];
    [cancelButtonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_cancelButton(40)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cancelButton)]];
    [self addConstraints:cancelButtonConstraints];
}

#pragma mark - 数据

- (void)setItems:(NSArray *)items {
    _items = items;
    [self update];
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [self updateContentConstraints];
}

#pragma mark - 更新视图

- (void)update {
    self.section = 0;
    if (self.items.count > 0 && [self.items.firstObject isKindOfClass:[XHPopupMenuItem class]]) {
        self.menuType = XHPopupMenuTypePain;
        self.section = 1;
    } else {
        self.menuType = XHPopupMenuTypeGroup;
        self.section = self.items.count;
    }
    // 更新菜单视图
    [self updateCollectionViewArr];
    [self reloadData];
}

/// 更新数据动态加载菜单.
- (void)updateCollectionViewArr {
    
    for (NSInteger i = _section; i < _collectionViewArr.count;  i ++) {
        UICollectionView *view = (UICollectionView *)[self viewWithTag:i * 10 + 100];
        [view removeFromSuperview];
        [_collectionViewArr removeObject:view];
    }
    
    self.collectionViewConstraints = [NSMutableArray array];

    for (NSInteger i = _collectionViewArr.count; i < _section;  i ++) {
        
        NSInteger tag = i * 10 + 100;
        
        CGFloat colum = 4.65;
        CGFloat minimumInteritemSpacing = 24;
        CGFloat itemWidth =  floor((CGRectGetWidth(self.bounds) - 12 - ceilf(colum - 1) * minimumInteritemSpacing) / colum);
        CGFloat itemHeight = itemWidth + 24;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = minimumInteritemSpacing;
        layout.minimumInteritemSpacing = 16;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.sectionInset = UIEdgeInsetsMake(8, 12, 8, 12);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.tag = tag;
        [collectionView registerClass:[XHPopupMenuCell class] forCellWithReuseIdentifier:kIDENTIFIERCELLPOPUPSECTION];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [self addSubview:collectionView];
        [self.collectionViewArr addObject:collectionView];
        
        collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableArray *collectionViewConstraints = [NSMutableArray array];
        [collectionViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
        [collectionViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[collectionView(100)]"] options:0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
        [self addConstraints:collectionViewConstraints];
        [self.collectionViewConstraints addObject:collectionViewConstraints];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.tag = tag - 1;
        [self addSubview:titleLabel];
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableArray *titleLabelConstraints = [NSMutableArray array];
        [titleLabelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[titleLabel(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView, titleLabel)]];
        [titleLabelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel(20)]-0-[collectionView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView, titleLabel)]];
        [self addConstraints:titleLabelConstraints];
    }
    
    [self updateContentConstraints];
}

/// 更新布局
- (void)updateContentConstraints {
    
    CGFloat height = 0;
    for (NSInteger i = 0; i < _collectionViewArr.count; i ++) {
        
        UICollectionView *collectionView = _collectionViewArr[i];
        UILabel *titleLabel = [self viewWithTag:collectionView.tag - 1];
        NSString *title = nil;
        if (self.titles.count > i && ((NSString *)self.titles[i]).length > 0) {
            title = self.titles[i];
            height += 30;
            titleLabel.text = title;
            titleLabel.hidden = NO;
        } else {
            titleLabel.hidden = YES;
        }
        
        __weak __typeof(UICollectionViewFlowLayout *)layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
        self.collectionViewConstraints[i][2].constant = height;
        self.collectionViewConstraints[i][3].constant = layout.itemSize.height+16;

        height += (layout.itemSize.height+16+0.5);
    }
    
    CGRect frame = self.frame;
    frame.size.height = height-0.5+50;
    self.frame = frame;
}

/// 刷新
- (void)reloadData {
    [_collectionViewArr enumerateObjectsUsingBlock:^(UICollectionView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj reloadData];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger num = (collectionView.tag - 100)/10;
    return _menuType==XHPopupMenuTypePain?self.items.count:((NSArray *)self.items[num]).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XHPopupMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIDENTIFIERCELLPOPUPSECTION forIndexPath:indexPath];
    NSInteger num = (collectionView.tag - 100)/10;
    XHPopupMenuItem *item = _menuType==XHPopupMenuTypePain?self.items[indexPath.row]:self.items[num][indexPath.row];
    cell.imageView.image = item.image;
    cell.nameLabel.text = item.name;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger num = (collectionView.tag - 100)/10;
    XHPopupMenuItem *item = _menuType==XHPopupMenuTypePain?self.items[indexPath.row]:self.items[num][indexPath.row];
    if (item.handler) {
        item.handler();
    }
}

@end

