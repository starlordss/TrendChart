//
//  SZTopTipView.m
//  ChaoBiNet
//
//  Created by Zahi on 2018/3/11.
//  Copyright © 2018年 ShangShang Technology Co. Ltd. All rights reserved.
//

#import "SZTrendChartTopView.h"
//#import "UILabel+CBN.h"
//#import "NSString+CBN.h"

const CGFloat SZTrendChartTopViewHeight = 60.f;

@interface SZTrendChartTopView ()
// 价格
@property (nonatomic, strong) UILabel *priceLbl;
// 高
@property (nonatomic, strong) UILabel *highDescLbl;
@property (nonatomic, strong) UILabel *highLbl;
// 低
@property (nonatomic, strong) UILabel *lowLbl;
@property (nonatomic, strong) UILabel *lowDescLbl;
// 24H量
@property (nonatomic, strong) UILabel *dayVolumeDescLbl;
@property (nonatomic, strong) UILabel *dayVolumeLbl;
// 增幅
@property (nonatomic, strong) UILabel *rateLbl;
// 增幅
@property (nonatomic, strong) UILabel *cnyLbl;
@end

@implementation SZTrendChartTopView

+ (instancetype)trendChartTopView {
    return [self new];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self addSubview:self.priceLbl];
//        [self addSubview:self.highDescLbl];
//        [self addSubview:self.highLbl];
//        [self addSubview:self.lowDescLbl];
//        [self addSubview:self.lowLbl];
//        [self addSubview:self.dayVolumeLbl];
//        [self addSubview:self.dayVolumeDescLbl];
//        [self addSubview:self.rateLbl];
//        [self addSubview:self.cnyLbl];
//        // 约束
//        [_priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.offset(5);
//            make.top.equalTo(self->_highLbl);
//        }];
//
//        [_lowLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.trailing.equalTo(self);
//            make.centerY.equalTo(self);
//        }];
//        [_lowDescLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.trailing.equalTo(self->_lowLbl.mas_leading).offset(-40);
//            make.top.equalTo(self->_lowLbl);
//        }];
//        [_highLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.trailing.equalTo(self);
//            make.bottom.equalTo(self->_lowLbl.mas_top).offset(-5);
//        }];
//        [_highDescLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.equalTo(self->_lowDescLbl);
//            make.bottom.equalTo(self->_highLbl);
//
//        }];
//        [_dayVolumeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.trailing.equalTo(self);
//            make.top.equalTo(self->_lowLbl.mas_bottom).offset(8);
//        }];
//        [_dayVolumeDescLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.equalTo(self->_lowDescLbl);
//            make.bottom.equalTo(self->_dayVolumeLbl);
//        }];
//        [_cnyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.equalTo(self->_priceLbl);
//            make.bottom.equalTo(self->_dayVolumeDescLbl);
//        }];
//        [_rateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.equalTo(self->_cnyLbl.mas_trailing).offset(5);
//            make.bottom.equalTo(self->_dayVolumeDescLbl);
//        }];
        
    }
    return self;
}


//- (void)updateWithHeaderModel:(CBNContract *)model {
//    NSString *price = [NSString filterSurplusZero:model.price];
//    _priceLbl.text     = NSStringFormat(@"%@",price);
//    _highLbl.text      = NSStringFormat(@"%.6lf",model.dayHigh);
//    _lowLbl.text       = NSStringFormat(@"%.6lf",model.dayLow);
//    _dayVolumeLbl.text = NSStringFormat(@"%.lf",model.dayVolume);
//    _rateLbl.text      = NSStringFormat(@"%.2lf%%",model.updown);
//    _cnyLbl.text       = NSStringFormat(@"≈%.2f CNY", model.cny);
//    if (model.isUp) {
//        _priceLbl.textColor = H_Green_Rate;
//        _rateLbl.textColor = H_Green_Rate;
//        _rateLbl.text      = NSStringFormat(@"+%.2lf%%",model.updown);
//    } else {
//        _rateLbl.textColor = H_Red_Rate;
//        _priceLbl.textColor = H_Red_Rate;
//    }
//}

//- (UILabel *)cnyLbl
//{
//    if (_cnyLbl == nil) {
//        _cnyLbl = [UILabel labelWithFont:SYSTEMFONT(12) color:UIColorFromRGB(0x485367) text:@"--"];
//    }
//    return _cnyLbl;
//}
//- (UILabel *)priceLbl
//{
//    if (_priceLbl == nil) {
//        _priceLbl = [UILabel labelWithFont:BOLDSYSTEMFONT(24) color:H_Green_Rate text:@"--"];
//    }
//    return _priceLbl;
//}
//- (UILabel *)highLbl
//{
//    if (_highLbl == nil) {
//        _highLbl = [UILabel labelWithFont:SYSTEMFONT(12) color:KWhiteColor text:@"--"];
//    }
//    return _highLbl;
//}
//- (UILabel *)highDescLbl
//{
//    if (_highDescLbl == nil) {
//        _highDescLbl = [UILabel labelWithFont:SYSTEMFONT(12) color:UIColorFromRGB(0x485367) text:Localized(@"kline_high")];
//    }
//    return _highDescLbl;
//}
//- (UILabel *)lowLbl
//{
//    if (_lowLbl == nil) {
//        _lowLbl = [UILabel labelWithFont:SYSTEMFONT(12) color:KWhiteColor text:@"--"];
//    }
//    return _lowLbl;
//}
//- (UILabel *)lowDescLbl
//{
//    if (_lowDescLbl == nil) {
//        _lowDescLbl = [UILabel labelWithFont:SYSTEMFONT(12) color:UIColorFromRGB(0x485367) text:Localized(@"kline_Low")];
//    }
//    return _lowDescLbl;
//}
//- (UILabel *)dayVolumeDescLbl
//{
//    if (_dayVolumeDescLbl == nil) {
//        _dayVolumeDescLbl = [UILabel labelWithFont:SYSTEMFONT(12) color:UIColorFromRGB(0x485367) text:Localized(@"kline_dayValue")];
//    }
//    return _dayVolumeDescLbl;
//}
//- (UILabel *)dayVolumeLbl
//{
//    if (_dayVolumeLbl == nil) {
//        _dayVolumeLbl = [UILabel labelWithFont:SYSTEMFONT(12) color:KWhiteColor text:@"--"];
//    }
//    return _dayVolumeLbl;
//}
//- (UILabel *)rateLbl
//{
//    if (_rateLbl == nil) {
//        _rateLbl = [UILabel labelWithFont:SYSTEMFONT(13) color:H_Green_Rate text:@"--"];
//    }
//    return _rateLbl;
//}

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
