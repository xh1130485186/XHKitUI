//
//  XHPopupMenu.m
//  XHKitDemo
//
//  Created by 向洪 on 2019/8/28.
//  Copyright © 2019 向洪. All rights reserved.
//

#import "XHPopupMenu.h"
#import "UIImage+XHColor.h"

#define kIDENTIFIERCELLPOPUP @"kXHIDENTIFIERCELLPOPUP"

@interface XHPopupMenu () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *cancelButton;

// 计算item显示的size
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) NSInteger minimumInteritemSpacing;
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *collectionViewConstraints;

@end

@implementation XHPopupMenu

- (instancetype)initWithSize:(CGSize)size style:(XHContainerStyle)style {
    self = [super initWithSize:size style:XHContainerBottom];
    if (self) {
        [self initalize];
    }
    return self;
}

- (void)initalize {
    
    // 设置背景
    UIImage *backgroundImage = [UIImage xh_imageWithColor:[UIColor whiteColor] size:CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) cornerRadius:8 roundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
//    self.clipsToBounds = NO;
    self.backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
    self.effectView.hidden = YES;
    
    [self setupCollectionUI];
    [self setupCancelUI];
}

/// 内容视图
- (void)setupCollectionUI {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 24;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [collectionView registerClass:[XHPopupMenuCell class] forCellWithReuseIdentifier:kIDENTIFIERCELLPOPUP];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self addSubview:collectionView];
    
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *collectionViewConstraints = [NSMutableArray array];
//    [collectionViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
//    [collectionViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[collectionView]-45-|"] options:0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
    [collectionViewConstraints addObject:[NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [collectionViewConstraints addObject:[NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-22.5]];
    [collectionViewConstraints addObject:[NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [collectionViewConstraints addObject:[NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self addConstraints:collectionViewConstraints];
    _collectionViewConstraints = collectionViewConstraints;
}

/// 取消按钮
- (void)setupCancelUI {
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancelButton.backgroundColor = [UIColor colorWithWhite:251/255.f alpha:1];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor colorWithWhite:153/255.f alpha:1] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    
    BOOL isPhoneX = NO;
    if (@available(iOS 11.0, *)) {
        isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;
    }
    CGFloat height = isPhoneX?65:45;
    
    _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *cancelButtonConstraints = [NSMutableArray array];
    [cancelButtonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_cancelButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cancelButton)]];
    [cancelButtonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[_cancelButton(%lf)]-0-|", height] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cancelButton)]];
    [self addConstraints:cancelButtonConstraints];
}

#pragma mark - 数据更新

- (void)setItems:(NSArray<XHPopupMenuItem *> *)items {
    _items = items;
    [self updateContentsForData];
}

- (void)updateContentsForData {
    
    if (_items.count > 0) {
        
        // 计算出适合显示的大小
        CGFloat colum = 4;
        CGFloat minimumInteritemSpacing = 10;
        CGFloat itemWidthMax = floor((CGRectGetWidth(self.bounds) - colum*minimumInteritemSpacing) / colum);
        
        UIImage *image = _items[0].image;
        CGFloat width = MIN(image.size.width, itemWidthMax);
        _itemSize = CGSizeMake(width, width+24);
        _minimumInteritemSpacing = floor((CGRectGetWidth(self.bounds) - self.itemSize.width*colum) / colum);
        
        [self updateCollectionViewConstraintsWithMaxColum:colum];
        
    } else {
        _itemSize = CGSizeZero;
    }

    
    [self.collectionView reloadData];
}

/// 更新界面视图
- (void)updateCollectionViewConstraintsWithMaxColum:(NSInteger)maxColum {
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    NSInteger row = (_items.count+3)/maxColum;
    NSInteger colum = (_items.count<maxColum)?_items.count:maxColum;
    CGFloat needHeight = ceil(MAX(row-1, 0)*layout.minimumLineSpacing+row*_itemSize.height)+48;  // 48 为边距，需改的时候注意代理对应也要进行修改
    CGFloat needWidth = colum<maxColum?(_minimumInteritemSpacing*colum+_itemSize.width*colum):CGRectGetWidth(self.bounds);
    self.collectionViewConstraints[2].constant = needWidth;
    self.collectionViewConstraints[3].constant = MIN(needHeight, CGRectGetHeight(self.bounds)-45);
}

#pragma mark - delegate <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XHPopupMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIDENTIFIERCELLPOPUP forIndexPath:indexPath];
    XHPopupMenuItem *item = _items[indexPath.row];
    cell.imageView.image = item.image;
    cell.nameLabel.text = item.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XHPopupMenuItem *item = _items[indexPath.row];
    if (item.handler) {
        item.handler();
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.minimumInteritemSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 边距，需改的时候注意updateCollectionViewConstraintsWithMaxColum对应也要进行修改
    return UIEdgeInsetsMake(24, self.minimumInteritemSpacing*0.5, 24, self.minimumInteritemSpacing*0.5);
}

@end


@implementation XHPopupMenuItem

- (instancetype)initWithName:(NSString *)name
                     image:(UIImage *)image
                     handler:(void(^)(void))handler {
    self = [super init];
    if (self) {
        self.name = name;
        self.image = image;
        self.handler = handler;
    }
    return self;
}
@end

@implementation XHPopupMenuCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imageView];
        
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableArray *imageViewConstraints = [NSMutableArray array];
        [imageViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
        [imageViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imageView]-24-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
        [self.contentView addConstraints:imageViewConstraints];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor darkGrayColor];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLabel];
        
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableArray *nameLabelConstraints = [NSMutableArray array];
//        [nameLabelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_nameLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel)]];
        [nameLabelConstraints addObject:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [nameLabelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_nameLabel(12)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel)]];
        [self.contentView addConstraints:nameLabelConstraints];
    }
    return self;
}

@end
