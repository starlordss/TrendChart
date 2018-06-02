//
//  SZTrendChartGlobalVariable.h
//  TrendChart
//
//  Created by Zahi on 2018/5/30.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTrendChartConstant.h"

@interface SZTrendChartGlobalVariable : NSObject

/**
 *  K线图的宽度，默认20
 */
+(CGFloat)kLineWidth;

+(void)setkLineWith:(CGFloat)kLineWidth;

/**
 *  K线图的间隔，默认1
 */
+(CGFloat)kLineGap;

+(void)setkLineGap:(CGFloat)kLineGap;

/**
 *  MainView的高度占比,默认为0.5
 */
+ (CGFloat)kLineMainViewRadio;
+ (void)setkLineMainViewRadio:(CGFloat)radio;

/**
 *  VolumeView的高度占比,默认为0.2
 */
+ (CGFloat)kLineVolumeViewRadio;
+ (void)setkLineVolumeViewRadio:(CGFloat)radio;

/**
 *  isEMA线
 */
+ (CGFloat)isEMALine;
+ (void)setisEMALine:(SZTrendChartTargetLineStatus)type;

/**
 *  isBOLL线
 */
+ (CGFloat)isBOLLLine;
+ (void)setisBOLLLine:(SZTrendChartTargetLineStatus)type;


@end
