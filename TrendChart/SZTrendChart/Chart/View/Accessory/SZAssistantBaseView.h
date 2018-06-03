//
//  SZAssistantBaseView.h
//  TrendChart
//
//  Created by Zahi on 2018/6/3.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTrendChartTitleView.h"
#import "SZTrendChartContext.h"

@class SZKLineModel, SZTrendChartView;
@interface SZAssistantBaseView : UIView

@property (nonatomic, strong) SZTrendChartTitleView *titleView;

@property (nonatomic, assign) NSInteger startDrawIndex; //!< 取值位置

@property (nonatomic, assign) NSInteger numberOfDrawCount; //!< 绘制个数

@property (nonatomic, assign) BOOL autoFit;

//默认 YES
@property (nonatomic, assign) BOOL gestureEnable;

@property (nonatomic, strong) NSArray <SZKLineModel *> *data;

@property (nonatomic, weak) SZTrendChartView *trendChartView;

- (void)update;

- (void)showTitleView:(SZKLineModel *)model;

- (void)hideTitleView;

@end
