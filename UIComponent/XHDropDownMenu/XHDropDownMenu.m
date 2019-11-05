//
//  XHDropDownMenu.m
//  XHDropDownMenu
//
//  Created by 向洪 on 2017/9/7.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHDropDownMenu.h"
#import "UIImage+XHColor.h"
#import "XHAdjustmentImageButton.h"
#import "XHKitUIDefines.h"

#define Button_Tag 102
#pragma mark - 下拉菜单蒙版

@interface XHDropDownCover : UIView

@property (nonatomic, strong) void(^clickCover)(void);

@end

@implementation XHDropDownCover

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_clickCover) {
        _clickCover();
    }
}

@end

@interface XHDropDownCustomView ()

@property (nonatomic, copy) void(^transinformationBlock)(id information);
- (void)setTransinformationBlock:(void (^)(id information))transinformationBlock;

@end

@implementation XHDropDownCustomView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

}

- (void)transinformation:(id)information {
 
    if (_transinformationBlock) {
        _transinformationBlock(information);
    }
}

@end

@interface XHDropDownCustomTableView () <UITableViewDelegate, UITableViewDataSource>
// 视图
@property (nonatomic, strong) UITableView *tableView;
// 当前选中
@property (nonatomic, strong) UIImageView *accessoryView;
@property (nonatomic, copy) NSArray<NSString *> *texts;
// 选中 section和column 对应， row代表行
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
// 主调颜色
@property (nonatomic, strong) UIColor *tintColor;
// 选择数据
@property (nonatomic, strong) NSMutableDictionary *selectedDataSource;

@end

@implementation XHDropDownCustomTableView

- (UITableView *)tableView {

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.rowHeight = 44;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.tableFooterView = [[UIView alloc] init];
        [self addSubview:_tableView];
        
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableArray *constraints = [NSMutableArray array];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
        [self addConstraints:constraints];
        
    }
    return _tableView;
}

- (UIImageView *)accessoryView {

    if (!_accessoryView) {
        _accessoryView = [[UIImageView alloc] initWithImage:[XHUIKitImage(@"xh_dropDownMenu_selected") xh_imageWithTintColor:_tintColor]];
    }
    return _accessoryView;
}

- (NSMutableDictionary *)selectedDataSource {

    if (!_selectedDataSource) {
        _selectedDataSource = [NSMutableDictionary dictionary];
    }
    return _selectedDataSource;
}

- (void)setTintColor:(UIColor *)tinColor {

    _tintColor = tinColor;
    _accessoryView.image = [XHUIKitImage(@"xh_dropDownMenu_selected") xh_imageWithTintColor:_tintColor];
}

- (void)setSelectRow:(NSInteger)row inColumn:(NSInteger)column {
    
    [self.selectedDataSource setObject:@(row) forKey:@(column)];
    
}

- (void)reloadSelectedWithColumn:(NSInteger)column {

    NSNumber *number = [self.selectedDataSource objectForKey:@(column)];
    if (number != nil) {
        _currentIndexPath = [NSIndexPath indexPathForRow:number.integerValue inSection:0];
    } else {
        _currentIndexPath = nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _texts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *kIdentifier = @"kDropDownCustomIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIdentifier];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    if ([indexPath isEqual:_currentIndexPath]) {
        cell.accessoryView = self.accessoryView;
        cell.textLabel.textColor = _tintColor;
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.accessoryView = nil;
    }
    cell.textLabel.text = _texts[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_currentIndexPath && ![_currentIndexPath isEqual:indexPath]) {
        
        UITableViewCell *old_cell = [tableView cellForRowAtIndexPath:_currentIndexPath];
        old_cell.accessoryView = nil;
        old_cell.textLabel.textColor = [UIColor blackColor];
    }
    if (![_currentIndexPath isEqual:indexPath]) {
    
        _currentIndexPath = indexPath;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = _tintColor;
        cell.accessoryView = self.accessoryView;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self transinformation:indexPath];
}

- (void)setTexts:(NSArray<NSString *> *)texts {

    _texts = [texts copy];
    self.frame = CGRectMake(0, 0, 0, 44 *texts.count);
}

@end

@class XHDropDownCover, XHDropDownCustomView;
@interface XHDropDownMenu ()


/**
 下拉菜单所有按钮
 */
@property (nonatomic, strong) NSMutableArray<UIButton *> *menuButtons;

/**
 下拉菜单所有分割线
 */
@property (nonatomic, strong) NSMutableArray<UIView *> *separateLines;
/**
 下拉菜单view
 */
@property (nonatomic, strong) NSMutableArray<XHDropDownCustomView *> *customViews;

/**
 下拉菜单蒙版
 */
@property (nonatomic, strong) XHDropDownCover *coverView;

/**
 下拉菜单内容View
 */
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSLayoutConstraint *contentViewHeightLayoutConstraint;

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;

/**
 分割线距离顶部间距，默认10
 */
@property (nonatomic, assign) NSInteger separateLineTopMargin;


@end
@implementation XHDropDownMenu

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {

    self.backgroundColor = [UIColor whiteColor];
    _separateLineTopMargin = 10;
    _separateLineColor =  [UIColor colorWithRed:203 / 255.0 green:203 / 255.0 blue:203 / 255.0 alpha:1];
    _coverColor = [UIColor colorWithWhite:0 alpha:0.3];
    _tintColor = [UIColor blueColor];
    
    _topLine = [[UIView alloc] initWithFrame:CGRectZero];
    _topLine.backgroundColor = [UIColor colorWithRed:224 / 255.0 green:224 / 255.0 blue:224 / 255.0 alpha:1];
    [self addSubview:_topLine];
    
    _topLine.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *topLineConstraints = [NSMutableArray array];
    [topLineConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_topLine]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_topLine)]];
    [topLineConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_topLine(0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_topLine)]];
    [self addConstraints:topLineConstraints];
    
    _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
    _bottomLine.backgroundColor = [UIColor colorWithRed:224 / 255.0 green:224 / 255.0 blue:224 / 255.0 alpha:1];;
    [self addSubview:_bottomLine];
    
    _bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *bottomLineConstraints = [NSMutableArray array];
    [bottomLineConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bottomLine]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bottomLine)]];
    [bottomLineConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bottomLine(0.5)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bottomLine)]];
    [self addConstraints:bottomLineConstraints];
}

#pragma mark - Getter Methods

- (XHDropDownCover *)coverView
{
    if (!_coverView) {
    
        _coverView = [[XHDropDownCover alloc] initWithFrame:CGRectZero];;
        _coverView.backgroundColor = _coverColor;
        _coverView.hidden = YES;
        [self.superview addSubview:_coverView];
        __weak typeof(self) weakSelf = self;
        _coverView.clickCover = ^{ // 点击蒙版调用
            [weakSelf dismiss];
        };
        
        _coverView.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableArray *constraints = [NSMutableArray array];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_coverView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_coverView)]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self]-0-[_coverView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_coverView, self)]];
        [self.superview addConstraints:constraints];
    }
    return _coverView;
}

- (UIView *)contentView {

    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.clipsToBounds = YES;
        [self.coverView addSubview:_contentView];
        
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableArray *constraints = [NSMutableArray array];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentView)]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_contentView(0)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentView)]];
        [self.coverView addConstraints:constraints];
        
        self.contentViewHeightLayoutConstraint = constraints[3];
        
    }
    return _contentView;
}

- (NSMutableArray<UIButton *> *)menuButtons {

    if (!_menuButtons) {
        _menuButtons = [NSMutableArray array];
    }
    return _menuButtons;
}

- (NSMutableArray<UIView *> *)separateLines {

    if (!_separateLines) {
        _separateLines = [NSMutableArray array];
    }
    return _separateLines;
}

- (NSMutableArray<XHDropDownCustomView *> *)customViews {

    if (!_customViews) {
        _customViews = [NSMutableArray array];
    }
    return _customViews;
}

#pragma mark - Setter Methods

- (void)setCoverColor:(UIColor *)coverColor {

    _coverColor = coverColor;
    _coverView.backgroundColor = _coverColor;
}

- (void)setSeparateLineColor:(UIColor *)separateLineColor {

    _separateLineColor = separateLineColor;
    _topLine.backgroundColor = _separateLineColor;
    _bottomLine.backgroundColor = _separateLineColor;
    [self.separateLines  enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        obj.backgroundColor = separateLineColor;
    }];
}

- (void)setTintColor:(UIColor *)tintColor {

    _tintColor = tintColor;
    __weak __typeof(self)weakSelf = self;
    [self.menuButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [obj setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [obj setTitleColor:weakSelf.tintColor forState:UIControlStateSelected];
        [obj setImage:[XHUIKitImage(@"xh_dropDownMenu_down") xh_imageWithTintColor:[UIColor grayColor]] forState:UIControlStateNormal];
        [obj setImage:[XHUIKitImage(@"xh_dropDownMenu_up") xh_imageWithTintColor:tintColor] forState:UIControlStateSelected];
    }];
}

- (void)setDelegate:(id<XHDropDownMenuDelegate>)delegate {

    _delegate = delegate;
    [self reload];
}


- (void)setSingleDelegate:(id<XHDropDownMenuSingleDelegate>)singleDelegate {

    _singleDelegate = singleDelegate;
    self.delegate = singleDelegate;
}

#pragma mark - 设置数据

- (void)reload {

    [self clear];
    if (self.delegate == nil || ![self.delegate conformsToProtocol:@protocol(XHDropDownMenuDelegate)]) return;
    
    NSInteger cols = 1;
    if ([self.delegate respondsToSelector:@selector(numberOfColumnInMenu:)]) {
        cols  = [_delegate numberOfColumnInMenu:self];
    }
    
    for (NSInteger col = 0; col < cols; col++) {
        
        // 获取按钮
        XHAdjustmentImageButton *menuButton;
        if ([self.delegate respondsToSelector:@selector(dropDownMenu:buttonForColumnAtIndex:)]) {
            menuButton = [self.delegate dropDownMenu:self buttonForColumnAtIndex:col];
        } else {
        
            menuButton = [XHAdjustmentImageButton buttonWithType:UIButtonTypeCustom];
            menuButton.adjustmentImageButtonType = XHAdjustmentImageRight;
            menuButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            menuButton.titleLabel.font = [UIFont systemFontOfSize:13];
            [menuButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [menuButton setTitleColor:_tintColor forState:UIControlStateSelected];
//            [menuButton setContentEdgeInsets:UIEdgeInsetsMake(0, 14, 0, 14)];
            [menuButton setImage:[XHUIKitImage(@"xh_dropDownMenu_down") xh_imageWithTintColor:[UIColor grayColor]] forState:UIControlStateNormal];
            [menuButton setImage:[XHUIKitImage(@"xh_dropDownMenu_up") xh_imageWithTintColor:_tintColor] forState:UIControlStateSelected];
        }
            
        if ([self.delegate respondsToSelector:@selector(dropDownMenu:titleForColumnAtIndex:)]) {
        
            NSString *title = [self.delegate dropDownMenu:self titleForColumnAtIndex:col];
            [menuButton setTitle:title forState:UIControlStateNormal];
        }
        
        menuButton.tag = col + Button_Tag;
        
        [menuButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (menuButton == nil) {
            @throw [NSException exceptionWithName:@"YZError" reason:@"pullDownMenu:buttonForColAtIndex:这个方法不能返回空的按钮" userInfo:nil];
            return;
        }
        
        [self addSubview:menuButton];
        
        menuButton.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableArray *constraints = [NSMutableArray array];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[menuButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(menuButton)]];
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:menuButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:2.f*(col+0.5)/cols constant:0];
        NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:menuButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.f/cols constant:0];
        [constraints addObject:constraint3];
        [constraints addObject:constraint4];
        [self addConstraints:constraints];
        
        // 添加按钮
        [self.menuButtons addObject:menuButton];
        
        // 添加分隔线
        if (col != cols-1) {
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = _separateLineColor;
            [self addSubview:lineView];
            [self.separateLines addObject:lineView];
            
            lineView.translatesAutoresizingMaskIntoConstraints = NO;
            NSMutableArray *constraints = [NSMutableArray array];
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lineView(20)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lineView)]];
            NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:2.f*(col+1)/cols constant:0];
            NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.f constant:0.5];
            NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
            [constraints addObject:constraint2];
            [constraints addObject:constraint3];
            [constraints addObject:constraint4];
            [self addConstraints:constraints];
        }
        
        // 添加view
        XHDropDownCustomView *customView;
        if (!_singleDelegate) {
            
            if ([self.delegate respondsToSelector:@selector(dropDownMenu:customViewColumnAtIndex:)]) {
                 
                customView = [self.delegate dropDownMenu:self customViewColumnAtIndex:col];
                
            } else {
                customView = [[XHDropDownCustomView alloc] initWithFrame:CGRectZero];
            }
            [self.customViews addObject:customView];
            
        } else {
        
            if (!_singleCustomTableView) {
                _singleCustomTableView = [[XHDropDownCustomTableView alloc] initWithFrame:CGRectMake(0, 0, 0, 200)];
                _singleCustomTableView.backgroundColor = [UIColor whiteColor];
            }
//            customView = _singleCustomTableView;
            
        }
    }
    [self layoutIfNeeded];
}

- (void)clear {

    [_menuButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj removeFromSuperview];
    }];
    
    [_separateLines enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [obj removeFromSuperview];
    }];
    [_customViews enumerateObjectsUsingBlock:^(XHDropDownCustomView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [obj removeFromSuperview];
    }];
    [_menuButtons removeAllObjects];
    [_separateLines removeAllObjects];
    [_customViews removeAllObjects];
}

#pragma mark - 出现，消失

- (void)dismiss {

    for (UIButton *button in self.menuButtons) {
        button.selected = NO;
    }
    
    self.coverView.backgroundColor = [UIColor clearColor];
    self.contentViewHeightLayoutConstraint.constant = 0;
    [UIView animateWithDuration:0.0 animations:^{
        
        [self.coverView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        self.coverView.hidden = YES;
        self.coverView.backgroundColor = self.coverColor;
        
    }];
}

#pragma mark - Action Methods

- (void)btnClick:(UIButton *)button {

    button.selected = !button.selected;
    
    // 取消其他按钮选中
    for (UIButton *otherButton in self.menuButtons) {
        if (otherButton == button) continue;
        otherButton.selected = NO;
    }
    
    // 获取角标
    NSInteger col = button.tag - Button_Tag;
    
    if (button.selected == YES) { // 当按钮选中，弹出蒙版
        
        if (self.delegate == nil || ![self.delegate conformsToProtocol:@protocol(XHDropDownMenuDelegate)] || ![self.delegate respondsToSelector:@selector(dropDownMenuItemMoreWillOpen:atIndex:)] || [self.delegate dropDownMenuItemMoreWillOpen:self atIndex:col]) {
            // 添加对应蒙版
            self.coverView.hidden = NO;
            [self.coverView bringSubviewToFront:self.superview.subviews.lastObject];
            
            // 移除之前子控制器的View
            [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            // 添加对应子控制器的view
            UIView *view;
            
            // 自带的视图内容控件
            if (_singleDelegate) {
                XHDropDownCustomTableView *customTableView = _singleCustomTableView;
                customTableView.backgroundColor = [UIColor whiteColor];
                customTableView.tintColor = _tintColor;
                [customTableView reloadSelectedWithColumn:col];
                NSInteger number = [self.singleDelegate dropDownMenu:self numberOfRowsInColumn:col];
                NSMutableArray *dataArr = [NSMutableArray array];
                for (NSInteger i = 0; i < number; i ++) {
                    
                    if ([self.singleDelegate respondsToSelector:@selector(dropDownMenu:stringForRowAtIndexPath:)]) {
                        NSString *string = [self.singleDelegate dropDownMenu:self stringForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:col]];
                        if (![string isKindOfClass:[NSString class]]) {
                            string = @"";
                        }
                        [dataArr addObject:string];
                    }
                    
                }
                customTableView.texts = dataArr;
                [customTableView.tableView reloadData];
                
                __weak typeof(self) weakSelf = self;
                __weak XHDropDownCustomTableView *weakCustomTableView = _singleCustomTableView;
                [_singleCustomTableView setTransinformationBlock:^(id infomation){
                    
                    [weakSelf dismiss];
                    NSIndexPath *indexPath = infomation;
                    [button setTitle:weakCustomTableView.texts[indexPath.row] forState:UIControlStateNormal];
                    [weakCustomTableView setSelectRow:indexPath.row inColumn:col];
                    if ([weakSelf.singleDelegate respondsToSelector:@selector(dropDownMenu:didSelectRowAtIndexPath:)]) {
                        
                        [weakSelf.singleDelegate dropDownMenu:weakSelf didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:col]];
                    }
                }];
                view = customTableView;
            } else {
                
                view = self.customViews[col];
            }
            
            if (view.superview) {
                [view removeFromSuperview];
            }
            
            [self.contentView addSubview:view];
            view.translatesAutoresizingMaskIntoConstraints = NO;
            NSMutableArray *constraints = [NSMutableArray array];
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self.contentView addConstraints:constraints];
            
            
            CGFloat maxHeight = CGRectGetHeight(self.coverView.bounds) * 0.8;
            if (maxHeight == 0) {
                maxHeight = (CGRectGetHeight(self.superview.bounds) - CGRectGetMaxY(self.frame)) * 0.8;
            }
            // 设置内容的高度
            CGFloat height = MIN(maxHeight, CGRectGetHeight(view.frame));
            
            self.contentViewHeightLayoutConstraint.constant = 0;
            [self.coverView layoutIfNeeded];
            [UIView animateWithDuration:0.3 delay:0 options:(7<<16) animations:^{
                
                self.contentViewHeightLayoutConstraint.constant = height;
                [self.coverView layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }
        
    } else { // 当按钮未选中，收回蒙版
        [self dismiss];
    }
}

@end

