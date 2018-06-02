//
//  SZTrendChartVolumePosition.m
//  TrendChart
//
//  Created by Zahi on 2018/5/31.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import "SZTrendChartVolumePosition.h"


@class SZKLineModel;
@implementation SZTrendChartVolumePosition

+ (instancetype) modelWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    SZTrendChartVolumePosition *volumePositionModel = [SZTrendChartVolumePosition new];
    volumePositionModel.startPoint = startPoint;
    volumePositionModel.endPoint = endPoint;
    return volumePositionModel;
}


@end

