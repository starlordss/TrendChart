//
//  SZTrendChartGroupModel.h
//  TrendChart
//
//  Created by Zahi on 2018/5/31.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import <Foundation/Foundation.h>


//第一个 EMA(12) 是前n1个c相加和后除以n1,第一个 EMA(26) 是前n2个c相加和后除以n2
@class SZKLineModel;

@interface SZTrendChartGroupModel : NSObject

@property (nonatomic, copy) NSArray<SZKLineModel *> *models;

//初始化Model
+ (instancetype)groupModelWithDataSource:(NSArray *)dataSource;

@end
