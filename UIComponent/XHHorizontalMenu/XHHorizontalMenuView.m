//
//  XHHorizontalMenuView.m
//  XHHorizontalMenuView
//
//  Created by 向洪 on 2017/7/4.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHHorizontalMenuView.h"
#import "UIImage+XHColor.h"
#import "NSAttributedString+XHExtension.h"

#define BUTTON_TAG 102
#define kHORIZONTALIDENTIFIERCELL @"XHHorizontalMenuCell"

@interface XHHorizontalMenuCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, assign, readwrite) CGSize textSize;

@property (nonatomic, strong) NSArray<NSLayoutConstraint *> *textLabelConstraints;

@end;

@implementation XHHorizontalMenuCell

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.textColor = [UIColor colorWithRed:163/255.f green:163/255.f blue:163/255.f alpha:1];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_textLabel];

        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableArray *constraints = [NSMutableArray array];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_textLabel(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textLabel)]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_textLabel(20)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textLabel)]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraints:constraints];
        
        self.textLabelConstraints = constraints;
        
    }
    return _textLabel;
}

- (void)setTextSize:(CGSize)textSize {
    
    self.textLabelConstraints[0].constant = textSize.width;
    self.textLabelConstraints[1].constant = textSize.height;
}
@end;

@interface XHHorizontalMenuItem : NSObject

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGSize itemTextSize;
@property (nonatomic, strong) NSMutableAttributedString *normalAttString;
@property (nonatomic, strong) NSMutableAttributedString *selectedAttString;

@end;

@implementation XHHorizontalMenuItem

@end;

@interface XHHorizontalMenuView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray<XHHorizontalMenuItem *> *itemList;

@property (nonatomic, strong) UIView *underlineView;
@property (nonatomic, copy) void(^handler)(NSInteger selectedIndex);

@end

@implementation XHHorizontalMenuView

#pragma mark - init Methods

- (instancetype)initWithFrame:(CGRect)frame itemTexts:(NSArray *)texts {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
        self.itemTexts = texts;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame itemImages:(NSArray *)images itemTexts:(NSArray *)texts {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
        self.itemTexts = texts;
        self.itemImages = images;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}


- (void)initialize {

    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
    _itemList = [NSMutableArray array];
    
    _font = [UIFont systemFontOfSize:15];
    _underLineHeight = 2;
    _normalColor = [UIColor colorWithRed:163/255.f green:163/255.f blue:163/255.f alpha:1];
    _themeColor = [UIColor colorWithRed:49/255.f green:189/255.f blue:243/255.f alpha:1];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = [UIColor colorWithRed:240/255.f green:240/255.f blue:240/255.f alpha:1];
    [self addSubview:lineView];
    self.lineView = lineView;
    
    _contentInset = UIEdgeInsetsMake(4, 8, 4, 8);
    _interitemSpacing = 8;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = _interitemSpacing;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(100, 30);
    layout.sectionInset = _contentInset;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    [_collectionView registerClass:[XHHorizontalMenuCell class] forCellWithReuseIdentifier:kHORIZONTALIDENTIFIERCELL];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.clipsToBounds = NO;
    
    [self addSubview:_collectionView];

    
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _lineView.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_lineView(1)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lineView)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_lineView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lineView)]];
    [self addConstraints:constraints];
    
    _underlineView = [[UIView alloc] init];
    _underlineView.backgroundColor = _themeColor;
    [_collectionView addSubview:_underlineView];
}

- (void)layoutSubviews {

    [super layoutSubviews];
    [self itemWidthIfNeededLayout];
}

#pragma mark - public Methods

- (void)menuSelectedIndexWithChangedHandler:(void(^)(NSInteger selectedIndex))handler {

    self.handler = handler;
}

- (void)underLoctionToWithIndex:(NSInteger)index progress:(CGFloat)progress {
    if (_itemList.count<=index||index<0) {
        return;
    }
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    CGRect cellRectTo = cell.frame;
    XHHorizontalMenuItem *startItem = _itemList[_selectedIndex];
    XHHorizontalMenuItem *endItem = _itemList[index];
    CGFloat endWidth = 0;
    CGFloat startWidth = 0;
    CGFloat startCenterX = CGRectGetMidX([_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]].frame);
    switch (_underLineStyle) {
        case XHHorizontalMenuUnderLineStyleNone:
        {
            endWidth = endItem.itemSize.width;
            startWidth = startItem.itemSize.width;
        }
            break;
        case XHHorizontalMenuUnderLineStyleText:
        {
            endWidth = endItem.itemTextSize.width;
            startWidth = startItem.itemTextSize.width;
        }
            break;
            
        default:
            break;
    }
    
    CGFloat endCenterX = CGRectGetMidX(cellRectTo);
    CGFloat width = startWidth + (endWidth - startWidth) * progress;
    CGFloat centerX = startCenterX + (endCenterX - startCenterX) * progress;
    _underlineView.bounds = CGRectMake(0, 0, width, _underLineHeight);
    _underlineView.center = CGPointMake(centerX, CGRectGetHeight(self.bounds) - _underLineHeight * 0.5);
}

#pragma mark - private Methods

- (void)itemWidthIfNeededLayout {
    CGFloat width = CGRectGetWidth(_collectionView.bounds);
    if (width > 0) {
        [self itemWidthUpdate];
        [self.collectionView reloadData] ;
        [self updateUnderlineViewWithAnimation:NO];
    }
}

- (void)itemWidthUpdate {
    // 设置cell宽度
    CGFloat itemWidth = 0;
    CGFloat itemHeight = CGRectGetHeight(_collectionView.bounds) - _contentInset.top - _contentInset.bottom - 1;
//    CGFloat itemTextWidth = 0;
    switch (_menuType) {
        case XHHorizontalMenuTyleNone:
        {
            NSInteger colum = _itemTexts.count;
            CGFloat width = CGRectGetWidth(_collectionView.bounds);
            itemWidth = floor((width - _contentInset.right - _contentInset.left - (colum - 1) * _interitemSpacing) / colum);
            [_itemList enumerateObjectsUsingBlock:^(XHHorizontalMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.itemSize = CGSizeMake(itemWidth, itemHeight);
                obj.itemTextSize = CGSizeMake(floor(obj.selectedAttString.size.width) + 1, floor(obj.selectedAttString.size.height) + 1);
            }];
        }
            break;
        case XHHorizontalMenuTyleScroll: {
            [_itemList enumerateObjectsUsingBlock:^(XHHorizontalMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.itemSize = CGSizeMake(floor(obj.selectedAttString.size.width) + 1, itemHeight);
                obj.itemTextSize = CGSizeMake(floor(obj.selectedAttString.size.width) + 1, floor(obj.selectedAttString.size.height) + 1);
            }];
        }
            break;
        case XHHorizontalMenuTyleAuto: {
            NSInteger colum = _itemTexts.count;
            CGFloat width = CGRectGetWidth(_collectionView.bounds);
            CGFloat iSpacingWidth = (colum>1?(colum - 1):0)*_interitemSpacing;
            CGFloat maxWidth = width - iSpacingWidth - _contentInset.right - _contentInset.left;
            CGFloat maxItemWidth = colum==0?:maxWidth/colum;
            CGFloat needMaxItemWidth = 0;
            for (XHHorizontalMenuItem *obj in _itemList) {
                CGFloat itemWidth = ceilf(obj.selectedAttString.size.width);
                needMaxItemWidth = MAX(needMaxItemWidth, itemWidth);
                obj.itemSize = CGSizeMake(itemWidth, itemHeight);
                obj.itemTextSize = CGSizeMake(itemWidth, ceilf(obj.selectedAttString.size.height));
            }
            
            if (needMaxItemWidth < maxItemWidth) {
                itemWidth = floor(maxWidth/colum);
                [_itemList enumerateObjectsUsingBlock:^(XHHorizontalMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.itemSize = CGSizeMake(itemWidth, itemHeight);
//                    obj.itemTextSize = CGSizeMake(floor(obj.selectedAttString.size.width) + 1, floor(obj.selectedAttString.size.height) + 1);;
                }];
            }
            
        }
            
        default:
            break;
    }
}

- (void)updateUnderlineViewWithAnimation:(BOOL)aniamtion {
    if (_itemList.count <= _selectedIndex) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
    if (!cell) {
        /* 由于reloadData刷新，会使cellForItemAtIndexPath的方法，获取不到cell 这个方法会等待同步cell存在了在执行 */
        [self.collectionView layoutIfNeeded];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
         cell = [_collectionView cellForItemAtIndexPath:indexPath];
    }
    
//    CGRect cellRectTo = [self convertRect:cell.frame fromView:_collectionView];
    CGRect cellRectTo = cell.frame;
    XHHorizontalMenuItem *item = _itemList[_selectedIndex];
    CGFloat width = 0;
    switch (_underLineStyle) {
        case XHHorizontalMenuUnderLineStyleNone:
        {
            width = item.itemSize.width;
        }
            break;
        case XHHorizontalMenuUnderLineStyleText:
        {
            width = item.itemTextSize.width;
        }
            break;
            
        default:
            break;
    }
    if (aniamtion) {
        [UIView animateWithDuration:0.25 animations:^{
            self.underlineView.bounds = CGRectMake(0, 0, width, self.underLineHeight);
            self.underlineView.center = CGPointMake(CGRectGetMidX(cellRectTo), CGRectGetHeight(self.bounds) - self.underLineHeight * 0.5);
        }];
    } else {
        self.underlineView.bounds = CGRectMake(0, 0, width, self.underLineHeight);
        self.underlineView.center = CGPointMake(CGRectGetMidX(cellRectTo), CGRectGetHeight(self.bounds) - self.underLineHeight * 0.5);
    }
    
}

// 设置items数量
- (void)setupItemsWithCount:(NSInteger)count {
    if (count > _itemList.count) {
        for (NSInteger i = _itemList.count; i < count; i ++) {
            XHHorizontalMenuItem *item = [[XHHorizontalMenuItem alloc] init];
            [_itemList addObject:item];
        }
    } else if (count < _itemList.count) {
        [_itemList removeObjectsInRange:NSMakeRange(count, _itemList.count - count)];
    }
}

- (NSMutableAttributedString *)getImageTextAttributedStringWithAttString:(NSMutableAttributedString *)attString image:(UIImage *)image color:(UIColor *)color size:(CGSize)size {

    image = [image xh_imageWithTintColor:color];
    NSAttributedString *imageAttributedString = [NSMutableAttributedString xh_attributedStringWithImage:image baselineOffset:(image.size.height - 20) * 0.5 leftMargin:0 rightMargin:0];
    if (attString.length) {
        
        NSDictionary *dic = [attString attributesAtIndex:0 effectiveRange:nil];
        if ([dic.allKeys containsObject:NSAttachmentAttributeName]) {
            [attString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:imageAttributedString];
        } else {
            [attString insertAttributedString:imageAttributedString atIndex:0];
        }
    } else {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
        [attString insertAttributedString:imageAttributedString atIndex:0];
    }
    return attString;
}

// 更新cell视图
- (void)updateHorizontalMenuWithCell:(XHHorizontalMenuCell *)cell atIndex:(NSInteger)index {
    if (index<0||index>=_itemList.count) {
        return;
    }
    XHHorizontalMenuItem *item = _itemList[index];
    cell.textLabel.attributedText = _selectedIndex==index?item.selectedAttString:item.normalAttString;
    cell.textSize = item.itemTextSize;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _itemList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XHHorizontalMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHORIZONTALIDENTIFIERCELL forIndexPath:indexPath];
//    [self updateHorizontalMenuWithCell:cell atIndex:indexPath.row];
    
    XHHorizontalMenuItem *item = _itemList[indexPath.row];
    cell.textLabel.attributedText = _selectedIndex==indexPath.row?item.selectedAttString:item.normalAttString;
    cell.textSize = item.itemTextSize;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    XHHorizontalMenuItem *item = _itemList[indexPath.row];
    return item.itemSize;
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//
//    return _interitemSpacing;
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return _interitemSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return _contentInset;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger unselectedIndex = _selectedIndex;
    XHHorizontalMenuCell *unselectedCell = (XHHorizontalMenuCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
    _selectedIndex = indexPath.row;
    XHHorizontalMenuCell *selectedCell = (XHHorizontalMenuCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
    [self updateHorizontalMenuWithCell:unselectedCell atIndex:unselectedIndex];
    [self updateHorizontalMenuWithCell:selectedCell atIndex:_selectedIndex];
    
    CGFloat maxX = CGRectGetMaxX(selectedCell.frame) - collectionView.contentOffset.x - CGRectGetWidth(collectionView.bounds);
    CGFloat minX = CGRectGetMinX(selectedCell.frame) - collectionView.contentOffset.x;
    if (maxX > 0) {
        [collectionView setContentOffset:CGPointMake(collectionView.contentOffset.x + maxX + _contentInset.right, 0) animated:YES];
    } else if (minX < 0) {
        [collectionView setContentOffset:CGPointMake(collectionView.contentOffset.x + minX - _contentInset.left, 0) animated:YES];
    }
    
    [self updateUnderlineViewWithAnimation:YES];
    // 回调
    if (_handler) {
        _handler(_selectedIndex);
    }
}

#pragma mark - Setter Methods

- (void)setItemTexts:(NSArray<NSString *> *)itemTexts {
    _itemTexts = itemTexts;
    [self setupItemsWithCount:_itemTexts.count];
    __weak __typeof(self)weakSelf = self;
    [self.itemList enumerateObjectsUsingBlock:^(XHHorizontalMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableAttributedString *normalAttString = [[NSMutableAttributedString alloc] initWithString:weakSelf.itemTexts[idx] attributes:@{NSFontAttributeName:weakSelf.font, NSForegroundColorAttributeName:weakSelf.normalColor}];
        NSMutableAttributedString *selectedAttString = [[NSMutableAttributedString alloc] initWithString:weakSelf.itemTexts[idx] attributes:@{NSFontAttributeName:weakSelf.font, NSForegroundColorAttributeName:weakSelf.themeColor}];
        obj.normalAttString = normalAttString;
        obj.selectedAttString = selectedAttString;
        
        // 如果有图片需要配置图片
        if (weakSelf.itemImages.count > idx) {
            obj.normalAttString = [weakSelf getImageTextAttributedStringWithAttString:obj.normalAttString image:weakSelf.itemImages[idx] color:weakSelf.normalColor size:CGSizeMake(weakSelf.font.lineHeight, weakSelf.font.lineHeight)];
            obj.selectedAttString = [weakSelf getImageTextAttributedStringWithAttString:obj.selectedAttString image:weakSelf.itemImages[idx] color:weakSelf.themeColor size:CGSizeMake(weakSelf.font.lineHeight, weakSelf.font.lineHeight)];
        }
    }];
    [_collectionView reloadData];
    _selectedIndex = (_itemTexts.count>_selectedIndex)?_selectedIndex:_itemTexts.count-1;
    [self itemWidthIfNeededLayout];
}

- (void)setItemImages:(NSArray<UIImage *> *)itemImages {
    _itemImages = itemImages;
    [self setupItemsWithCount:_itemImages.count];
    __weak __typeof(self)weakSelf = self;
    [self.itemList enumerateObjectsUsingBlock:^(XHHorizontalMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.normalAttString = [weakSelf getImageTextAttributedStringWithAttString:obj.normalAttString image:weakSelf.itemImages[idx] color:weakSelf.normalColor size:CGSizeMake(weakSelf.font.lineHeight, weakSelf.font.lineHeight)];
        obj.selectedAttString = [weakSelf getImageTextAttributedStringWithAttString:obj.selectedAttString image:weakSelf.itemImages[idx] color:weakSelf.themeColor size:CGSizeMake(weakSelf.font.lineHeight, weakSelf.font.lineHeight)];
        
    }];
    [_collectionView reloadData];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    __weak __typeof(self)weakSelf = self;
    [self.itemList enumerateObjectsUsingBlock:^(XHHorizontalMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.normalAttString addAttribute:NSFontAttributeName value:weakSelf.font range:NSMakeRange(0, obj.normalAttString.length)];
        [obj.selectedAttString addAttribute:NSFontAttributeName value:weakSelf.font range:NSMakeRange(0, obj.selectedAttString.length)];
    }];
    [_collectionView reloadData];
}

- (void)setThemeColor:(UIColor *)themeColor {
    _themeColor = themeColor;
    __weak __typeof(self)weakSelf = self;
    [self.itemList enumerateObjectsUsingBlock:^(XHHorizontalMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        [obj.selectedAttString addAttribute:NSForegroundColorAttributeName value:weakSelf.themeColor range:NSMakeRange(0, obj.selectedAttString.length)];
        
    }];
    _underlineView.backgroundColor = themeColor;
    
    XHHorizontalMenuCell *selectedCell = (XHHorizontalMenuCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
    [self updateHorizontalMenuWithCell:selectedCell atIndex:_selectedIndex];
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    [self.itemList enumerateObjectsUsingBlock:^(XHHorizontalMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj.normalAttString addAttribute:NSForegroundColorAttributeName value:normalColor range:NSMakeRange(0, obj.normalAttString.length)];
    }];
    [_collectionView reloadData];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    [self itemWidthIfNeededLayout];
}

- (void)setInteritemSpacing:(CGFloat)interitemSpacing {
    _interitemSpacing = interitemSpacing;
    [_collectionView reloadData];
    [self itemWidthIfNeededLayout];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self updateUnderlineViewWithAnimation:NO];
    [_collectionView reloadData];
}


@end
