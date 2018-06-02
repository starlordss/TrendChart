//
//  SZTrendChartPosition.m
//  TrendChart
//
//  Created by Zahi on 2018/5/31.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import "SZTrendChartPosition.h"

@implementation SZTrendChartPosition

+ (instancetype) modelWithOpen:(CGPoint)openPoint
                         close:(CGPoint)closePoint
                          high:(CGPoint)highPoint
                           low:(CGPoint)lowPoint {
    SZTrendChartPosition *model = [SZTrendChartPosition new];
    model.OpenPoint = openPoint;
    model.ClosePoint = closePoint;
    model.HighPoint = highPoint;
    model.LowPoint = lowPoint;
    return model;
}


@end
