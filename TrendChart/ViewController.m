//
//  ViewController.m
//  TrendChart
//
//  Created by Zahi on 2018/5/21.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import "ViewController.h"
#import "SZTrendChartView.h"
#import "SZTrendChartGroupModel.h"
#import "SZTrendChartMacro.h"
#import "UIView+Addition.h"

#import <AFNetworking/AFNetworking.h>
#import "SZTrendChartMacro.h"

@interface ViewController ()<SZTrendChartViewDelegate>

@property (nonatomic, strong) SZTrendChartView *trendChartView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) NSString *typeStr;
@property (nonatomic, strong) NSMutableDictionary <NSString *, SZTrendChartGroupModel *> *groupModelDict;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupNav];
    [self setupKLineView];
    [self requestData];
}


- (void)initData {
    _groupModelDict = [NSMutableDictionary dictionary];
    _typeStr = @"5M";
}

- (void)setupNav {
    self.title = @"炒币网";
    self.view.backgroundColor = GlobalBGColor_Blue;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"旋转" style:UIBarButtonItemStyleDone target:self action:@selector(rotateScreen:)];
    [rightItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rotateScreen:(UIBarButtonItem *)item {
    _trendChartView.landscapeMode = YES;
}

- (void)setupKLineView {
    _trendChartView = [[SZTrendChartView alloc] initWithFrame:CGRectMake(0, 0, self.view.us_width, self.view.us_height)];
    [self.view addSubview:self.trendChartView];
    _trendChartView.autoFit = true;
    _trendChartView.delegate = self;
}
- (void)requestData {
    SZTrendChartGroupModel *groupModel = _groupModelDict[_typeStr];
    if (groupModel.models) {
        [self.trendChartView drawChartWithDataSource:groupModel.models];
        return;
    }
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"Cycle"] = self.typeStr.length ? self.typeStr : @"5M";
    param[@"Contract"] = @"BTC_USD";
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:@"https://www.chaobi.com:6443/quotation/kline" parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"-----%@",responseObject);
        if ([responseObject[@"status"] boolValue]) {
            NSArray *datas = responseObject[@"data"];
            datas = [[datas reverseObjectEnumerator] allObjects];
            SZTrendChartGroupModel *groupModel = [SZTrendChartGroupModel groupModelWithDataSource:datas];
            [self.trendChartView drawChartWithDataSource:groupModel.models];
            self.groupModelDict[self.typeStr] = groupModel;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--%@",error);
    }];
}

#pragma mark - <SZTrendChartViewDelegate>
- (void)trendChartView:(SZTrendChartView *)trendChartView didSelectTargetTime:(SZTargetTimeType)targetTimeType {
    if (targetTimeType == SZTargetTimeTypeTiming) {
        DLog(@"点击时间轴 == SZTargetTimeTypeTiming");
        self.typeStr = @"1M";
    }
    else if (targetTimeType == SZTargetTimeTypeMin_5) {
        DLog(@"点击时间轴 == SZTargetTimeTypeMin_5");
        self.typeStr = @"5M";
    }
    else if (targetTimeType == SZTargetTimeTypeMin_30) {
        DLog(@"点击时间轴 == SZTargetTimeTypeMin_30");
        self.typeStr = @"30M";
    }
    else if (targetTimeType == SZTargetTimeTypeMin_60) {
        DLog(@"点击时间轴 == SZTargetTimeTypeMin_60");
        self.typeStr = @"1H";
    }
    else if (targetTimeType == SZTargetTimeTypeDay) {
        DLog(@"点击时间轴 == SZTargetTimeTypeDay");
        self.typeStr = @"1D";
    }
    [self requestData];
}

@end
