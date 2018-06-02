//
//  SZTrendChartGlobalVariable.m
//  TrendChart
//
//  Created by Zahi on 2018/5/30.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import "SZTrendChartGlobalVariable.h"

/**
 *  K线图的宽度，默认2
 */
static CGFloat SZTrendChartKLineWidth = 2;

/**
 *  K线图的间隔，默认1
 */
static CGFloat SZTrendChartKLineGap = 1;


/**
 *  MainView的高度占比,默认为0.5
 */
static CGFloat SZTrendChartKLineMainViewRadio = 0.5;

/**
 *  VolumeView的高度占比,默认为0.5
 */
static CGFloat SZTrendChartKLineVolumeViewRadio = 0.2;


/**
 *  是否为EMA线
 */
static SZTrendChartTargetLineStatus SZTrendChartKLineIsEMALine = SZTrendChartTargetLineStatusMA;

/**
 *  是否为BOLL线
 */
static SZTrendChartTargetLineStatus SZTrendChartKLineIsBOLLLine = SZTrendChartTargetLineStatusBOLL;


@implementation SZTrendChartGlobalVariable

/**
 *  K线图的宽度，默认20
 */
+(CGFloat)kLineWidth {
    return SZTrendChartKLineWidth;
}

+(void)setkLineWith:(CGFloat)kLineWidth {
    if (kLineWidth > SZTrendChartKLineMaxWidth) {
        kLineWidth = SZTrendChartKLineMaxWidth;
    }
    else if (kLineWidth < SZTrendChartKLineMinWidth){
        kLineWidth = SZTrendChartKLineMinWidth;
    }
    SZTrendChartKLineWidth = kLineWidth;
}

/**
 *  K线图的间隔，默认1
 */
+(CGFloat)kLineGap {
    return SZTrendChartKLineGap;
}

+(void)setkLineGap:(CGFloat)kLineGap {
    SZTrendChartKLineGap = kLineGap;
}

/**
 *  MainView的高度占比,默认为0.5
 */
+ (CGFloat)kLineMainViewRadio {
    return SZTrendChartKLineMainViewRadio;
}

+ (void)setkLineMainViewRadio:(CGFloat)radio {
    SZTrendChartKLineMainViewRadio = radio;
}

/**
 *  VolumeView的高度占比,默认为0.2
 */
+ (CGFloat)kLineVolumeViewRadio {
    return SZTrendChartKLineVolumeViewRadio;
}

+ (void)setkLineVolumeViewRadio:(CGFloat)radio {
    SZTrendChartKLineVolumeViewRadio = radio;
}


/**
 *  isEMA线
 */

+ (CGFloat)isEMALine {
    return SZTrendChartKLineIsEMALine;
}

+ (void)setisEMALine:(SZTrendChartTargetLineStatus)type {
    SZTrendChartKLineIsEMALine = type;
}

/**
 *  isBOLL线
 */
+ (CGFloat)isBOLLLine {
    return SZTrendChartKLineIsBOLLLine;
}

+ (void)setisBOLLLine:(SZTrendChartTargetLineStatus)type {
    SZTrendChartKLineIsBOLLLine = type;
}


@end
