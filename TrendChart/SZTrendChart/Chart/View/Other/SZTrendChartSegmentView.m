//
//  SZTrendChartSegmentView.m
//  TrendChart
//
//  Created by Zahi on 2018/5/31.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import "SZTrendChartSegmentView.h"
#import "SZTrendChartMacro.h"
#import <Masonry/Masonry.h>
#import "UIView+Addition.h"


#define TitleColor_Nor  HexRGB(0x67798E)
#define TitleColor_HL   HexRGB(0x4481C4)
#define BGColor         HexRGB(0x20232b)

static NSString *cellID = @"SZStockSegmentViewCell";

@interface SZSegmentViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *flagImageView;

- (void)updateWithText:(NSString *)text selectedStyle:(BOOL)isSelectedStyle;

@end

@implementation SZSegmentViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _timeLabel = [UILabel new];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_timeLabel];
    _timeLabel.frame = self.bounds;
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = TitleColor_Nor;
}

- (void)updateWithText:(NSString *)text selectedStyle:(BOOL)isSelectedStyle {
    _timeLabel.text = text;
    _timeLabel.textColor = isSelectedStyle ? TitleColor_HL : TitleColor_Nor;
}

@end

// ---------

@interface SZTrendChartSegmentView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
// 指标按钮
@property (nonatomic, strong) UIButton *indexBtn;
@property (nonatomic, strong) UIView *popupPanel;
@property (nonatomic, copy)   NSArray *dataSource;
@property (nonatomic, strong) SZSegmentSelectedModel *selectedModel;
@property (nonatomic, strong) UIButton *selectedMainChartBtn;
@property (nonatomic, strong) UIButton *selectedAccessoryChartBtn;

@end

static const CGFloat kTargetBtnWidth = 60.f;
static const CGFloat kPopupViewHeight = 122.f;

const CGFloat SZSegmentCellHeight = 35.f;
const CGFloat SZSegmentTotalHeight = 200.f;

@implementation SZTrendChartSegmentView

+ (instancetype)segmentView {
    return [self new];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_collectionView reloadData];
}

- (void)setup {
    self.us_width = SCREEN_WIDTH;
    
    _selectedModel = [SZSegmentSelectedModel new];
    _selectedModel.mainChartType = SZMainChartTypeMA;
    _selectedModel.accessoryChartType = SZAccessoryChartTypeMACD;
    _selectedModel.targetTimeType = SZTargetTimeTypeMin_60;
    
    _dataSource = @[ @"分时", @"5分", @"30分", @"60分", @"日线" ];
    
    [self setupTargetBtn];
    [self setupCollectionView];
    [self setupPopupPanel];
}

- (void)setupPopupPanel {
    _popupPanel = [UIView new];
    _popupPanel.backgroundColor = HexRGB(0x111E2F);
    [self insertSubview:_popupPanel atIndex:0];
    
    [_popupPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(kPopupViewHeight);
        make.top.equalTo(self.collectionView.mas_bottom);
    }];
    
    CGFloat btnWidth = 60.f;
    CGFloat itemWidth = (self.us_width - kTargetBtnWidth) / _dataSource.count;
    
    UILabel *topTitleLabel = [self generateTitleLabel:@"主图"];
    [_popupPanel addSubview:topTitleLabel];
    [topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(itemWidth, 56));
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
    NSArray *topBtnTitles = @[ @"MA", @"BOLL", @"关闭" ];
    for (int i = 0; i < topBtnTitles.count; i++) {
        UIButton *btn = [self generateBtn:topBtnTitles[i]];
        [btn addTarget:self action:@selector(mainChartBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_popupPanel addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(btnWidth, 56));
            make.left.mas_equalTo(i * btnWidth + 100);
            make.top.mas_equalTo(topTitleLabel);
        }];
        
        if (i == 0) {
            [self mainChartBtnClick:btn];
        }
    }

    
    UILabel *bottomTitleLabel = [self generateTitleLabel:@"副图"];
    [_popupPanel addSubview:bottomTitleLabel];
    [bottomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topTitleLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(itemWidth, 56));
        make.left.mas_equalTo(0);
    }];
    
    NSArray *bottomBtnTitles = @[ @"MACD", @"KDJ", @"RSI", @"WR", @"关闭" ];
    for (int i = 0; i < bottomBtnTitles.count; i ++) {
        UIButton *btn = [self generateBtn:bottomBtnTitles[i]];
        [btn addTarget:self action:@selector(accessoryChartBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_popupPanel addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(btnWidth, 56));
            make.left.mas_equalTo(i * btnWidth + 100);
            make.top.mas_equalTo(bottomTitleLabel);
        }];
        
        if (i == 0) {
            [self accessoryChartBtnClick:btn];
        }
    }
}

- (UIButton *)generateBtn:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:HexRGB(0x67798E) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitleColor:TitleColor_HL forState:UIControlStateSelected];
    return btn;
}

- (UILabel *)generateTitleLabel:(NSString *)title {
    UILabel *label = [UILabel new];
    label.text = title;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = HexRGB(0x5C88B8);
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)setupTargetBtn {
    _indexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_indexBtn];
    _indexBtn.backgroundColor = GlobalBGColor_Blue;
    [_indexBtn setTitle:@"指标" forState:UIControlStateNormal];
    _indexBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [_indexBtn addTarget:self action:@selector(targetBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    [_indexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kTargetBtnWidth, SZSegmentCellHeight));
        make.trailing.mas_equalTo(self);
        make.bottom.mas_equalTo(self.us_height);
    }];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    [self addSubview:_collectionView];
    _collectionView.backgroundColor = HexRGB(0x111E2F);
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceHorizontal = true;
    _collectionView.showsHorizontalScrollIndicator = false;
    _collectionView.bounces = NO;
    
    [_collectionView registerClass:[SZSegmentViewCell class] forCellWithReuseIdentifier:cellID];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.bottom.mas_equalTo(self.us_height);
        make.trailing.offset(-kTargetBtnWidth);
        make.height.mas_equalTo(SZSegmentCellHeight);
    }];
}

#pragma mark - Actions

- (void)targetBtnClcik {
    _isOpening = !_isOpening;
    _indexBtn.backgroundColor = _isOpening? HexRGB(0x081825):HexRGB(0x111E2F);
    _popupPanel.hidden = !_isOpening;
    
    if ([self.delegate respondsToSelector:@selector(segmentView:showPopupView:)]) {
        [self.delegate segmentView:self showPopupView:_isOpening];
    }
}

- (void)accessoryChartBtnClick:(UIButton *)btn {
    _selectedAccessoryChartBtn.selected = false;
    btn.selected = true;
    _selectedAccessoryChartBtn = btn;
    
    SZSegmentSelectedModel *model = [SZSegmentSelectedModel new];
    model.subType = SZSegmentViewSubTypeAccessory;
    
    if ([btn.currentTitle isEqualToString:@"MACD"]) {
        model.accessoryChartType = SZAccessoryChartTypeMACD;
    }
    else if ([btn.currentTitle isEqualToString:@"KDJ"]) {
        model.accessoryChartType = SZAccessoryChartTypeKDJ;
    }
    else if ([btn.currentTitle isEqualToString:@"RSI"]) {
        model.accessoryChartType = SZAccessoryChartTypeRSI;
    }
    else if ([btn.currentTitle isEqualToString:@"WR"]) {
        model.accessoryChartType = SZAccessoryChartTypeWR;
    }
    else if ([btn.currentTitle isEqualToString:@"关闭"]) {
        model.accessoryChartType = SZAccessoryChartTypeClose;
    }
    if ([self.delegate respondsToSelector:@selector(segmentView:didSelectModel:)]) {
        [self.delegate segmentView:self didSelectModel:model];
    }
    [self hidePopupView];
}

- (void)mainChartBtnClick:(UIButton *)btn {
    _selectedMainChartBtn.selected = false;
    btn.selected = true;
    _selectedMainChartBtn = btn;
    
    SZSegmentSelectedModel *model = [SZSegmentSelectedModel new];
    model.subType = SZSegmentViewSubTypeMain;
    
    if ([btn.currentTitle isEqualToString:@"MA"]) {
        model.mainChartType = SZMainChartTypeMA;
    }
    else if ([btn.currentTitle isEqualToString:@"BOLL"]) {
        model.mainChartType = SZMainChartTypeBOLL;
    }
    else if ([btn.currentTitle isEqualToString:@"关闭"]) {
        model.mainChartType = SZMainChartTypeClose;
    }
    if ([self.delegate respondsToSelector:@selector(segmentView:didSelectModel:)]) {
        [self.delegate segmentView:self didSelectModel:model];
    }
    [self hidePopupView];
}

- (void)hidePopupView {
    [self targetBtnClcik];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SZSegmentViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell updateWithText:_dataSource[indexPath.item] selectedStyle:indexPath.item == _selectedModel.targetTimeType];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    CGFloat itemWidth = (self.us_width - kTargetBtnWidth) / _dataSource.count;
    
    size = CGSizeMake(itemWidth, SZSegmentCellHeight);
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_collectionView reloadData];
    _selectedModel.targetTimeType = indexPath.item;
    
    SZSegmentSelectedModel *model = [SZSegmentSelectedModel new];
    model.subType = SZSegmentViewSubTypeTime;
    
    switch (indexPath.item) {
        case 0: {
            model.targetTimeType = SZTargetTimeTypeTiming;
        } break;
        case 1: {
            model.targetTimeType = SZTargetTimeTypeMin_5;
        } break;
        case 2: {
            model.targetTimeType = SZTargetTimeTypeMin_30;
        } break;
        case 3: {
            model.targetTimeType = SZTargetTimeTypeMin_60;
        } break;
        case 4: {
            model.targetTimeType = SZTargetTimeTypeDay;
        } break;
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(segmentView:didSelectModel:)]) {
        [self.delegate segmentView:self didSelectModel:model];
    }
}


@end
