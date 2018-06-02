
//
//  SZTrendChartTopView.m
//  TrendChart
//
//  Created by Zahi on 2018/5/31.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import "SZTrendChartTopView.h"
#import <Masonry/Masonry.h>

const CGFloat SZTrendChartTopViewHeight = 60.f;



@implementation SZTrendChartTopViewModel
@end

@interface SZTrendChartTopView ()

@property (strong, nonatomic) UILabel *priceLbl;
@property (strong, nonatomic) UILabel *rateLabel;
@property (strong, nonatomic) UILabel *lowLabel;
@property (strong, nonatomic) UILabel *volLabel;
@property (strong, nonatomic) UILabel *highLabel;
@property (strong, nonatomic) UILabel *cnyLbl;

@end


@implementation SZTrendChartTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame ];
    if (self) {
        [self setupUI];
        [self setupConstraints];

    }
    return self;
}


+ (instancetype)trendChartTopView {
    SZTrendChartTopView *view = [[SZTrendChartTopView alloc] init];
    return view;
}

- (void)setupUI {
    
//    [self addSubview:self.priceLbl];
//    [self addSubview:self.cnyLbl];
//    [self addSubview:self.rateLabel];
//    [self addSubview:self.highLabel];
//    [self addSubview:self.lowLabel];
//    [self addSubview:self.volLabel];
//
}

- (void)setupConstraints {
//    [_priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//    }];
//    [_priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//    }];
//    [_priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//    }];
//    [_priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//    }];
//    [_priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//    }];
}

- (void)updateWithHeaderModel:(SZTrendChartTopViewModel *)model {
    
}


- (void)hide {
    [UIView animateWithDuration:.12 animations:^{
        self.alpha = 0;
    }];
}

- (void)show {
    [UIView animateWithDuration:.12 animations:^{
        self.alpha = 1.f;
    }];
}




@end
