//
//  SZTrendChartGroupModel.m
//  TrendChart
//
//  Created by Zahi on 2018/5/31.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import "SZTrendChartGroupModel.h"
#import "SZKLineModel.h"

@implementation SZTrendChartGroupModel

+ (instancetype)groupModelWithDataSource:(NSArray *)dataSource {
    NSAssert([dataSource isKindOfClass:[NSArray class]], @"arr不是一个数组");

    
    SZTrendChartGroupModel *groupModel = [SZTrendChartGroupModel new];
    NSMutableArray *mutableArr = @[].mutableCopy;
    __block SZKLineModel *preModel = [[SZKLineModel alloc]init];
    
    //设置数据
    for (NSDictionary *dict in dataSource)
    {
        SZKLineModel *model = [SZKLineModel new];
        model.previousKlineModel = preModel;
        //        [model initWithArray:valueArr];
        [model initWithDict:dict];
        model.ParentGroupModel = groupModel;
        
        [mutableArr addObject:model];
        
        preModel = model;
    }
    
    groupModel.models = mutableArr;
    
    //初始化第一个Model的数据
    SZKLineModel *firstModel = mutableArr[0];
    [firstModel initFirstModel];
    
    //初始化其他Model的数据
    [mutableArr enumerateObjectsUsingBlock:^(SZKLineModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [model initData];
    }];
    
    
    return groupModel;
}

@end
