//
//  SZTrendChartContext.m
//  TrendChart
//
//  Created by Zahi on 2018/5/31.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import "SZTrendChartContext.h"
#import "SZTrendChartMacro.h"

@implementation SZSegmentSelectedModel
@end



@implementation SZTrendChartContext

+ (instancetype)shareInstance {
    static SZTrendChartContext *context_;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context_ = [SZTrendChartContext new];
        [context_ setup];
    });
    return context_;
}

- (void)setup {
    [self initData];
    [self setupSelectedModel];
}

- (void)setupSelectedModel {
    _selectedModel = [SZSegmentSelectedModel new];
    _selectedModel.mainChartType = SZMainChartTypeMA;
    _selectedModel.accessoryChartType = SZAccessoryChartTypeMACD;
    _selectedModel.targetTimeType = SZTargetTimeTypeMin_30;
}

- (void)initData {
    _KLineWidth = 4.f;
    _KLinePadding = 2.f;
    _leftMargin = 5.f;
    _rightMargin = 2.f;
    _maxKLineWidth = 24;
    _minKLineWidth = 1.f;
    _positiveLineColor = KLineColor_Green;
    _negativeLineColor = KLineColor_Red;
}

- (void)setKLineWidth:(CGFloat)KLineWidth {
    _KLineWidth = MIN(MAX(KLineWidth, _minKLineWidth), _maxKLineWidth);
}


@end
