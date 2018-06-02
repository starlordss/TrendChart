//
//  SZTrendChartSegmentView.h
//  TrendChart
//
//  Created by Zahi on 2018/5/31.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTrendChartHeader.h"

extern const CGFloat SZSegmentCellHeight;
extern const CGFloat SZSegmentTotalHeight;


@class SZTrendChartSegmentView;
@protocol SZTrendChartSegmentViewDelegate <NSObject>

@optional

- (void)stockSegmentView:(SZTrendChartSegmentView *)segmentView didSelectModel:(SZSegmentSelectedModel *)model;
- (void)stockSegmentView:(SZTrendChartSegmentView *)segmentView showPopupView:(BOOL)showPopupView;

@end

@interface SZTrendChartSegmentView : UIView

@property (nonatomic, weak) id <SZTrendChartSegmentViewDelegate> delegate;

@property (nonatomic, assign, readonly) BOOL isOpening;

+ (instancetype)segmentView;


@end
