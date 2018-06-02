//
//  SZTrendChartContext.h
//  TrendChart
//
//  Created by Zahi on 2018/5/31.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTrendChartHeader.h"
#import "SZTrendChartMacro.h"

#define _stockCtx       [SZTrendChartContext shareInstance]
#define YAxisTitleFont  [UIFont systemFontOfSize:8.0]
#define YAxisTitleColor [UIColor colorWithRed:(130/255.0f) green:(130/255.0f) blue:(130/255.0f) alpha:1.0]
#define XAxisTitleFont  [UIFont systemFontOfSize:8.0]
#define XAxisTitleColor [UIColor colorWithRed:(130/255.0f) green:(130/255.0f) blue:(130/255.0f) alpha:1.0]
#define AxisLineColor   HexRGB(0x535d69)
#define AxisLineWidth   (.5f)
#define SeparatorWidth  (.5f)
#define SeparatorColor  HexRGB(0x535d69)
#define CrossLineColor  HexRGB(0xC9C9C9)
#define TimeAndPriceTextColor HexRGB(0x333333)
#define timeAndPriceTipsBackgroundColor HexRGBA(0xf6f6f6, .8)
#define MALineWidth  1.f

@interface SZSegmentSelectedModel: NSObject

@property (nonatomic, assign) SZSegmentViewSubType subType;
@property (nonatomic, assign) SZTargetTimeType targetTimeType;
@property (nonatomic, assign) SZAccessoryChartType accessoryChartType;
@property (nonatomic, assign) SZMainChartType mainChartType;

@end

@interface SZTrendChartContext : NSObject

+ (instancetype)shareInstance;
@property (nonatomic, assign) CGFloat KLineWidth;
@property (nonatomic, assign) CGFloat KLinePadding;
@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat rightMargin;
@property (nonatomic, assign) CGFloat maxKLineWidth; //!< k线最大宽度
@property (nonatomic, assign) CGFloat minKLineWidth; //!< k线最小宽度
@property (nonatomic, strong) UIColor *positiveLineColor; //!< 阳线颜色(negative line)
@property (nonatomic, strong) UIColor *negativeLineColor; //!< 阴线颜色

@property (nonatomic, strong) SZSegmentSelectedModel *selectedModel;


@end
