//
//  SZTrendChartView.h
//  TrendChart
//
//  Created by Zahi on 2018/5/31.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZKLineModel.h"
#import "SZTrendChartHeader.h"

@class SZTrendChartView;

@protocol SZTrendChartViewDelegate <NSObject>

@optional
- (void)trendChartView:(SZTrendChartView *)trendChartView didSelectTargetTime:(SZTargetTimeType)targetTimeType;

@end

@interface SZTrendChartView : UIView

@property (nonatomic, assign) CGFloat topMargin; //!< 内容距离父试图顶部高度

@property (nonatomic, assign) BOOL zoomEnable; //!< 默认可以放大缩小

@property (nonatomic, assign) BOOL showAvgLine; //!< 默认显示均线

@property (nonatomic, assign) BOOL showBarChart; //!< 显示柱形图，默认显示

@property (nonatomic, assign) BOOL autoFit;

@property (nonatomic, strong) NSArray <NSNumber *> *MAValues; //!< 均线个数（默认ma5, ma10, ma20）

@property (nonatomic, strong) NSArray<UIColor *> *MAColors; //!< 均线颜色值 (默认 HexRGB(0x019FFD)、HexRGB(0xFF9900)、HexRGB(0xFF00FF))

@property (nonatomic, assign) BOOL landscapeMode;

@property (nonatomic, weak) id <SZTrendChartViewDelegate> delegate;

- (void)drawChartWithDataSource:(NSArray <SZKLineModel *> *)dataSource;

// 更新数据
- (void)updateChartWithOpen:(CGFloat)open
                      close:(CGFloat)close
                       high:(CGFloat)high
                        low:(CGFloat)low
                       date:(NSString *)date
                      isNew:(BOOL)isNew;

- (void)updateChartWithOpen:(CGFloat)open
                      close:(CGFloat)close
                       high:(CGFloat)high
                        low:(CGFloat)low
                       date:(NSString *)date
                        mas:(NSArray *)mas
                      isNew:(BOOL)isNew;

- (void)clear;

- (void)showTipBoardWithOuterViewTouchPoint:(CGPoint)touchPoint;


@end
