//
//  SZTrendChartTitleView.m
//  TrendChart
//
//  Created by Zahi on 2018/5/31.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import "SZTrendChartTitleView.h"
#import <Masonry/Masonry.h>
#import "SZTrendChartMacro.h"
#import "SZTrendChartUtil.h"
#import "NSString+SZTrendChart.h"

#define KLineTextColor_Gray HexRGB(0x606b76)

@interface SZTrendChartTitleView ()
// 从左往右的label
@property (nonatomic, strong) UILabel *label_0;
@property (nonatomic, strong) UILabel *label_1;
@property (nonatomic, strong) UILabel *label_2;
@property (nonatomic, strong) UILabel *label_3;

@end

static const CGFloat kDefaultMargin = 8.f;

@implementation SZTrendChartTitleView

+ (instancetype)titleView {
    return [self new];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _label_0 = [self generateLabel];
    [_label_0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(20);
        make.centerY.mas_equalTo(self);
    }];
    
    _label_1 = [self generateLabel];
    [_label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.left.mas_equalTo(self.label_0.mas_right).offset(kDefaultMargin);
        make.centerY.mas_equalTo(self);
    }];
    
    _label_2 = [self generateLabel];
    [_label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.left.mas_equalTo(self.label_1.mas_right).offset(kDefaultMargin);
        make.centerY.mas_equalTo(self);
    }];
    
    _label_3 = [self generateLabel];
    [_label_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.left.mas_equalTo(self.label_2.mas_right).offset(kDefaultMargin);
        make.centerY.mas_equalTo(self);
    }];
}

- (UILabel *)generateLabel {
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:8];
    label.textColor = KLineTextColor_Gray;
    [self addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (void)updateWithHigh:(CGFloat)high open:(CGFloat)open close:(CGFloat)close low:(CGFloat)low {
    [self updateLabel:_label_0 text:[@"开: " stringByAppendingString:[SZTrendChartUtil decimalValue:high]] color: nil];
    [self updateLabel:_label_1 text:[@"高: " stringByAppendingString:[SZTrendChartUtil decimalValue:open]] color: nil];
    [self updateLabel:_label_2 text:[@"收: " stringByAppendingString:[SZTrendChartUtil decimalValue:close]] color: nil];
    [self updateLabel:_label_3 text:[@"低: " stringByAppendingString:[SZTrendChartUtil decimalValue:low]] color: nil];
}

- (void)updateWithVolume:(CGFloat)volume MA5:(CGFloat)MA5 MA10:(CGFloat)MA10 {
    [self updateLabel:_label_0 text:[@"交易量: " stringByAppendingString:[SZTrendChartUtil decimalValue:volume count:4]] color: nil];
    [self updateLabel:_label_1 text:[@"MA(5): " stringByAppendingString:[SZTrendChartUtil decimalValue:MA5]] color: [UIColor whiteColor]];
    [self updateLabel:_label_2 text:[@"MA(10): " stringByAppendingString:[SZTrendChartUtil decimalValue:MA10]] color: [UIColor yellowColor]];
}

- (void)updateWithMACD:(CGFloat)MACD DIF:(CGFloat)DIF DEA:(CGFloat)DEA {
    [self updateLabel:_label_0 text:@"MACD(12, 26, 9)" color: nil];
    [self updateLabel:_label_1 text:[@"DIF: " stringByAppendingString:[SZTrendChartUtil decimalValue:DIF]] color: [UIColor whiteColor]];
    [self updateLabel:_label_2 text:[@"DEA: " stringByAppendingString:[SZTrendChartUtil decimalValue:DEA]] color: [UIColor yellowColor]];
    [self updateLabel:_label_3 text:[@"MACD: " stringByAppendingString:[SZTrendChartUtil decimalValue:MACD]] color: [UIColor redColor]];
}

- (void)updateKDJWithK:(CGFloat)K D:(CGFloat)D J:(CGFloat)J {
    [self updateLabel:_label_0 text:@"KDJ(N:9)" color: nil];
    [self updateLabel:_label_1 text:[@"K: " stringByAppendingString:[SZTrendChartUtil decimalValue:K]] color: [UIColor whiteColor]];
    [self updateLabel:_label_2 text:[@"D: " stringByAppendingString:[SZTrendChartUtil decimalValue:D]] color: [UIColor yellowColor]];
    [self updateLabel:_label_3 text:[@"J: " stringByAppendingString:[SZTrendChartUtil decimalValue:J]] color: [UIColor redColor]];
}

- (void)updateRSIWithRSI6:(CGFloat)RSI6 RSI12:(CGFloat)RSI12 RSI24:(CGFloat)RSI24 {
    [self updateLabel:_label_0 text:@"RSI(6, 12, 24)" color: nil];
    [self updateLabel:_label_1 text:[@"RSI(6): " stringByAppendingString:[SZTrendChartUtil decimalValue:RSI6]] color: [UIColor whiteColor]];
    [self updateLabel:_label_2 text:[@"RSI(12): " stringByAppendingString:[SZTrendChartUtil decimalValue:RSI12]] color: [UIColor yellowColor]];
    [self updateLabel:_label_3 text:[@"RSI(24): " stringByAppendingString:[SZTrendChartUtil decimalValue:RSI24]] color: [UIColor redColor]];
}

- (void)updateLabel:(UILabel *)label text:(NSString *)text color:(UIColor *)color {
    label.text = text;
    if (color) {
        label.textColor = color;
    }
    CGFloat labelWidth = [text stringWidthWithFont:label.font height:CGFLOAT_MAX];
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(labelWidth);
    }];
    [UIView animateWithDuration:.15 animations:^{
        [self layoutIfNeeded];
    }];
}

@end
