//
//  XHSecondMenu.m
//  GrowthCompass
//
//  Created by 向洪 on 2017/4/28.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "XHSecondMenu.h"
#import "UIImage+XHColor.h"
#import "XHUICommonDefines.h"

#define kIDENTIFIERCELLSECOND_L @"l"
#define kIDENTIFIERCELLSECOND_R @"r"
#define left_width 120.f

@interface RTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *selectedImageView;

@end

@implementation RTableViewCell

- (void)layoutSubviews {

    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(25, 0, CGRectGetWidth(self.contentView.frame) - 50, CGRectGetHeight(self.contentView.frame));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{

    [super setSelected:selected animated:animated];
    if (selected) {
        self.textLabel.textColor = self.tintColor;
        self.selectedImageView.hidden = NO;
    } else {
    
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.selectedImageView.hidden = YES;
    }
}

- (void)setTintColor:(UIColor *)tintColor {

    [super setTintColor:tintColor];
    NSString *path = XHBundlePathForResource(@"xhkit.ui", [self class], @"xh_secondmenu_choose", @"png", 1);
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    self.selectedImageView.image = [image xh_imageWithTintColor:tintColor];
}
#pragma mark - getter

- (UIImageView *)selectedImageView {

    if (!_selectedImageView) {
        _selectedImageView = [[UIImageView alloc] initWithImage:nil];
        [self addSubview:_selectedImageView];
        
        _selectedImageView.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableArray *constraints = [NSMutableArray array];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_selectedImageView(15)]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_selectedImageView)]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_selectedImageView(12)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_selectedImageView)]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_selectedImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraints:constraints];

    }
    return _selectedImageView;
}

@end

@interface LTableViewCell : UITableViewCell

@end

@implementation LTableViewCell


- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.textLabel.frame = self.contentView.bounds;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    [super setSelected:selected animated:animated];
    if (selected) {
        self.textLabel.textColor = self.tintColor;
        self.contentView.backgroundColor = [UIColor whiteColor];
    } else {
        
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
}

@end

@interface XHSecondMenu () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *titleTextLabel;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) UITableView *leftTableView;

@property (nonatomic) NSInteger displaySection;

@end

@implementation XHSecondMenu

- (instancetype)initWithSize:(CGSize)size style:(XHContainerStyle)style {

    self = [super initWithSize:size style:XHContainerBottom];
    if (self) {
        [self initialze];
    }
    return self;
}


- (void)initialze {
    
    self.layer.cornerRadius = 0;
    _tintColor = [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1];
    
    _titleTextLabel = [[UILabel alloc] init];
    _titleTextLabel.font = [UIFont systemFontOfSize:16];
    _titleTextLabel.textAlignment = NSTextAlignmentCenter;
    _titleTextLabel.textColor = _tintColor;
    
    [self addSubview:_titleTextLabel];
    
    _titleTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *titleTextLabelConstraints = [NSMutableArray array];
    [titleTextLabelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[_titleTextLabel(15)]-60-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleTextLabel)]];
    [titleTextLabelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_titleTextLabel(44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleTextLabel)]];
    [self addConstraints:titleTextLabelConstraints];

    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"xhkit.bundle/xh_secondmenu_close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(close_action) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeButton];
    
    _closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *closeButtonConstraints = [NSMutableArray array];
    [closeButtonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_closeButton(44)]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_closeButton)]];
    [closeButtonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_closeButton(44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_closeButton)]];
    [self addConstraints:closeButtonConstraints];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self addSubview:lineView];
    
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *lineViewConstraints = [NSMutableArray array];
    [lineViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[lineView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lineView)]];
    [lineViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-43.5-[lineView(0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lineView)]];
    [self addConstraints:lineViewConstraints];

    _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _leftTableView.rowHeight = 50;
    _leftTableView.showsVerticalScrollIndicator = NO;
    _leftTableView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _leftTableView.dataSource = self;
    _leftTableView.delegate = self;
    _leftTableView.tableFooterView = [[UIView alloc] init];
    _leftTableView.tag = 101;
    
    [self addSubview:_leftTableView];
    
    _leftTableView.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *leftTableViewConstraints = [NSMutableArray array];
    [leftTableViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[_leftTableView(%lf)]", left_width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_leftTableView)]];
    [leftTableViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-44-[_leftTableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_leftTableView)]];
    [self addConstraints:leftTableViewConstraints];
    
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _rightTableView.rowHeight = 40;
    _rightTableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    _rightTableView.showsVerticalScrollIndicator = NO;
    _rightTableView.backgroundColor = [UIColor whiteColor];
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rightTableView.dataSource = self;
    _rightTableView.delegate = self;
    _rightTableView.tableFooterView = [[UIView alloc] init];
    _rightTableView.tag = 102;
    
    [self addSubview:_rightTableView];
    
    _rightTableView.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *rightTableViewConstraints = [NSMutableArray array];
    [rightTableViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%lf-[_rightTableView]-0-|", left_width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_rightTableView)]];
    [rightTableViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-44-[_rightTableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_rightTableView)]];
    [self addConstraints:rightTableViewConstraints];
    
    
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _displaySection = 0;
    
}

#pragma mark - public Methods

- (void)relodData {
    
    [self.rightTableView reloadData];
    [self.leftTableView reloadData];
}

#pragma mark - event Methods

- (void)close_action {
    
    [self hide];
}

- (void)show {

    [super show];
    [self.rightTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    [self.leftTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

#pragma mark - delegate <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView.tag == 101) {
        
        if (_delegate && [_delegate conformsToProtocol:@protocol(XHSecondMenuDelegate)] && [_delegate respondsToSelector:@selector(numberOfSectionsInSecondMenu:)]) {
            return [_delegate numberOfSectionsInSecondMenu:self];
        }
        return 0;
    } else {
    
        if (_delegate && [_delegate conformsToProtocol:@protocol(XHSecondMenuDelegate)] && [_delegate respondsToSelector:@selector(xh_secondMenu:numberOfRowsInSection:)]) {
            NSInteger a = [_delegate xh_secondMenu:self numberOfRowsInSection:_displaySection];
            return a;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (tableView.tag == 101) {

        LTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIDENTIFIERCELLSECOND_L];
        if (!cell) {
            cell = [[LTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIDENTIFIERCELLSECOND_L];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.numberOfLines = 0;
            cell.backgroundColor = [UIColor clearColor];
            cell.tintColor = self.tintColor;
//            cell.textLabel.text = @"2017上学期";
        }
        if (_delegate && [_delegate conformsToProtocol:@protocol(XHSecondMenuDelegate)] && [_delegate respondsToSelector:@selector(xh_secondMenu:numberOfTitleInSection:)]) {
            cell.textLabel.text =  [_delegate xh_secondMenu:self numberOfTitleInSection:indexPath.row];
        } else {
        
            cell.textLabel.text = @"";
        }
        
        return cell;
    } else {
    
        RTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIDENTIFIERCELLSECOND_R];
        if (!cell) {
            cell = [[RTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIDENTIFIERCELLSECOND_R];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.numberOfLines = 0;
            cell.backgroundColor = [UIColor whiteColor];
            cell.tintColor = self.tintColor;
//            cell.textLabel.text = @"20170424-20170430 第九周";
        }
        if (_delegate && [_delegate conformsToProtocol:@protocol(XHSecondMenuDelegate)] && [_delegate respondsToSelector:@selector(xh_secondMenu:titleAtIndexPath:)]) {
            NSIndexPath *rightIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:_displaySection];
            cell.textLabel.text =  [_delegate xh_secondMenu:self titleAtIndexPath:rightIndexPath];
        } else {
            
            cell.textLabel.text = @"";
        }
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView.tag == 101) {
    
        if (_displaySection != indexPath.row) {
            _displaySection = indexPath.row;
            [self.rightTableView reloadData];
        }
        if (indexPath.row != self.selectedIndexPath.section) {

            [self.rightTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndexPath.row inSection:0] animated:YES];
        } else {

            [self.rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndexPath.row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            
        }
        
    } else {
    
        self.selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:_displaySection];
        if (_delegate && [_delegate conformsToProtocol:@protocol(XHSecondMenuDelegate)] && [_delegate respondsToSelector:@selector(xh_secondMenu:didSelectRowAtIndexPath:)]) {
            [_delegate xh_secondMenu:self didSelectRowAtIndexPath:self.selectedIndexPath];
        }
        
    }
}


#pragma mark - ovver Methods

- (void)hide {

    [super hide];
    if (_delegate && [_delegate conformsToProtocol:@protocol(XHSecondMenuDelegate)] && [_delegate respondsToSelector:@selector(xh_secondMenu:didEndDisplayingWithCurrentSelectedIndexPath:)]) {
        [_delegate xh_secondMenu:self didEndDisplayingWithCurrentSelectedIndexPath:self.selectedIndexPath];
    }
}


#pragma mark - setter Methods

- (void)setTitle:(NSString *)title {

    _title = title;
    self.titleTextLabel.text = title;
}

- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath {

    _selectedIndexPath = selectedIndexPath;
    _displaySection = _selectedIndexPath.section;
    
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndexPath.section inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [_rightTableView reloadData];
    [_rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndexPath.row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)setTintColor:(UIColor *)tintColor {

    _tintColor = tintColor;
    _titleTextLabel.textColor = tintColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
