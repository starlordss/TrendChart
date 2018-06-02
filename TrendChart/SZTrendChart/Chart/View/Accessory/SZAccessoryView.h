//
//  SZAccessoryView.h
//  TrendChart
//
//  Created by Zahi on 2018/6/3.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import "SZAssistantBaseView.h"
#import "SZTrendChartHeader.h"

@interface SZAccessoryView : SZAssistantBaseView

@property (nonatomic, assign) SZAccessoryChartType accessoryChartType;

- (void)showModelInfo:(SZKLineModel *)model type:(SZAccessoryChartType)type;
@end
