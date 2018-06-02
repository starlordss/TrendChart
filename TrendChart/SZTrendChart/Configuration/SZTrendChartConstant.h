//
//  SZTrendChartConstant.h
//  TrendChart
//
//  Created by Zahi on 2018/5/30.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#ifndef SZTrendChartConstant_h
#define SZTrendChartConstant_h


#endif /* SZTrendChartConstant_h */


/**
 *  K线图需要加载更多数据的通知
 */
#define SZTrendChartKLineNeedLoadMoreDataNotification @"SZTrendChartKLineNeedLoadMoreDataNotification"

/**
 *  K线图Y的View的宽度
 */
#define SZTrendChartKLinePriceViewWidth 47

/**
 *  K线图的X的View的高度
 */
#define SZTrendChartKLineTimeViewHeight 20

/**
 *  K线最大的宽度
 */
#define SZTrendChartKLineMaxWidth 20

/**
 *  K线图最小的宽度
 */
#define SZTrendChartKLineMinWidth 2

/**
 *  K线图缩放界限
 */
#define SZTrendChartScaleBound 0.03

/**
 *  K线的缩放因子
 */
#define SZTrendChartScaleFactor 0.03

/**
 *  UIScrollView的contentOffset属性
 */
#define SZTrendChartContentOffsetKey @"contentOffset"

/**
 *  时分线的宽度
 */
#define SZTrendChartTimeLineLineWidth 0.5

/**
 *  时分线图的Above上最小的X
 */
#define SZTrendChartTimeLineMainViewMinX 0.0

/**
 *  分时线的timeLabelView的高度
 */
#define SZTrendChartTimeLineTimeLabelViewHeight 19

/**
 *  时分线的成交量的线宽
 */
#define SZTrendChartTimeLineVolumeLineWidth 0.5

/**
 *  长按时的线的宽度
 */
#define SZTrendChartLongPressVerticalViewWidth 0.5

/**
 *  MA线的宽度
 */
#define SZTrendChartMALineWidth 0.8

/**
 *  上下影线宽度
 */
#define SZTrendChartShadowLineWidth 1
/**
 *  所有profileView的高度
 */
#define SZTrendChartProfileViewHeight 50

/**
 *  K线图上可画区域最小的Y
 */
#define SZTrendChartKLineMainViewMinY 20

/**
 *  K线图上可画区域最大的Y
 */
#define SZTrendChartKLineMainViewMaxY (self.frame.size.height - 15)

/**
 *  K线图的成交量上最小的Y
 */
#define SZTrendChartKLineVolumeViewMinY 20

/**
 *  K线图的成交量最大的Y
 */
#define SZTrendChartKLineVolumeViewMaxY (self.frame.size.height)

/**
 *  K线图的副图上最小的Y
 */
#define SZTrendChartKLineAccessoryViewMinY 20

/**
 *  K线图的副图最大的Y
 */
#define SZTrendChartKLineAccessoryViewMaxY (self.frame.size.height)

/**
 *  K线图的副图中间的Y
 */
#define SZTrendChartKLineAccessoryViewMiddleY (maxY - (0.f-minValue)/unitValue)

/**
 *  时分线图的Above上最小的Y
 */
#define SZTrendChartTimeLineMainViewMinY 0

/**
 *  时分线图的Above上最大的Y
 */
#define SZTrendChartTimeLineMainViewMaxY (self.frame.size.height-SZTrendChartTimeLineTimeLabelViewHeight)


/**
 *  时分线图的Above上最大的Y
 */
#define SZTrendChartTimeLineMainViewMaxX (self.frame.size.width)

/**
 *  时分线图的Below上最小的Y
 */
#define SZTrendChartTimeLineVolumeViewMinY 0

/**
 *  时分线图的Below上最大的Y
 */
#define SZTrendChartTimeLineVolumeViewMaxY (self.frame.size.height)

/**
 *  时分线图的Below最大的X
 */
#define SZTrendChartTimeLineVolumeViewMaxX (self.frame.size.width)

/**
 * 时分线图的Below最小的X
 */
#define SZTrendChartTimeLineVolumeViewMinX 0

//Kline种类
typedef NS_ENUM(NSInteger, SZTrendChartCenterViewType) {
    SZTrendChartCenterViewTypeKline= 1, //K线
    SZTrendChartCenterViewTypeTimeLine,  //分时图
    SZTrendChartCenterViewTypeOther
};

//Accessory指标种类
typedef NS_ENUM(NSInteger, SZTrendChartTargetLineStatus) {
    SZTrendChartTargetLineStatusMACD = 100,    //MACD线
    SZTrendChartTargetLineStatusKDJ,    //KDJ线
    SZTrendChartTargetLineStatusAccessoryClose,    //关闭Accessory线
    SZTrendChartTargetLineStatusMA , //MA线
    SZTrendChartTargetLineStatusEMA,  //EMA线
    SZTrendChartTargetLineStatusBOLL,  //BOLL线
    SZTrendChartTargetLineStatusCloseMA  //MA关闭线
    
};
