//
//  SZTrendChartTopView.h
//  TrendChart
//
//  Created by Zahi on 2018/5/31.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import <UIKit/UIKit.h>
extern const CGFloat SZTrendChartTopViewHeight;

@interface SZTrendChartTopViewModel : NSObject

@property (nonatomic, assign) CGFloat currentPrice;
@property (nonatomic, assign) CGFloat rate;
@property (nonatomic, assign) CGFloat low;
@property (nonatomic, assign) CGFloat high;
@property (nonatomic, assign) CGFloat vol;
@property (nonatomic, assign) CGFloat cny;
@end


@interface SZTrendChartTopView : UIView

+ (instancetype)trendChartTopView;
- (void)updateWithHeaderModel:(SZTrendChartTopViewModel *)model;
- (void)hide;
- (void)show;

@end

