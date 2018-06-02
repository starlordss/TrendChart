//
//  SZTrendChartHeader.h
//  TrendChart
//
//  Created by Zahi on 2018/5/31.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#ifndef SZTrendChartHeader_h
#define SZTrendChartHeader_h


typedef NS_ENUM(NSInteger, SZMainChartType) {
    SZMainChartTypeMA,
    SZMainChartTypeBOLL,
    SZMainChartTypeClose,
};

typedef NS_ENUM(NSInteger, SZAccessoryChartType) {
    SZAccessoryChartTypeMACD,
    SZAccessoryChartTypeKDJ,
    SZAccessoryChartTypeRSI,
    SZAccessoryChartTypeWR,
    SZAccessoryChartTypeClose,
};

typedef NS_ENUM(NSInteger, SZTargetTimeType) {
    SZTargetTimeTypeTiming,
    SZTargetTimeTypeMin_5,
    SZTargetTimeTypeMin_30,
    SZTargetTimeTypeMin_60,
    SZTargetTimeTypeDay,
};

typedef NS_ENUM(NSInteger, SZSegmentViewSubType) {
    SZSegmentViewSubTypeMain,     //!< 主图
    SZSegmentViewSubTypeAccessory,//!< 副图
    SZSegmentViewSubTypeTime,     //!< 时间轴
};

#import "SZTrendChartContext.h"
#endif /* SZTrendChartHeader_h */
