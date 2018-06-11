//
//  SZTopTipView.h
//  ChaoBiNet
//
//  Created by Zahi on 2018/3/11.
//  Copyright © 2018年 ShangShang Technology Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
extern const CGFloat SZTrendChartTopViewHeight;
@class CBNContract;
@interface SZTrendChartTopView : UIView



+ (instancetype)trendChartTopView;
- (void)updateWithHeaderModel:(CBNContract *)model;
- (void)hide;
- (void)show;


@end
