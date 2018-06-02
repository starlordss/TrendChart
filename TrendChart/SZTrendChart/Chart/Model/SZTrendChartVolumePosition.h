//
//  SZTrendChartVolumePosition.h
//  TrendChart
//
//  Created by Zahi on 2018/5/31.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZTrendChartVolumePosition : NSObject

/**
 *  开始点
 */
@property (nonatomic, assign) CGPoint startPoint;

/**
 *  结束点
 */
@property (nonatomic, assign) CGPoint endPoint;

/**
 *  工厂方法
 */
+ (instancetype) modelWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end
