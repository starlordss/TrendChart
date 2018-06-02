//
//  SZAccessoryView.m
//  TrendChart
//
//  Created by Zahi on 2018/6/3.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import "SZAccessoryView.h"
#import "SZKLineModel.h"
#import "UIBezierPath+curved.h"
#import "NSString+Common.h"
#import "SZTrendChartUtil.h"

@interface SZAccessoryView ()

@property (nonatomic) CGFloat highestValue;
@property (nonatomic) CGFloat lowestValue;
@property (nonatomic, copy) NSArray <NSNumber *> *MAValues;
@property (nonatomic, copy) NSArray <UIColor *> *MAColors;

@end
static const CGFloat kVerticalMargin = 12.f;

@implementation SZAccessoryView


#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

#pragma mark - public methods

- (void)update {
    [self resetMaxAndMin];
    [self setNeedsDisplay];
}

- (void)showModelInfo:(SZKLineModel *)model type:(SZAccessoryChartType)type {
    self.titleView.hidden = false;
    switch (type) {
        case SZAccessoryChartTypeMACD: {
            [self.titleView updateWithMACD:model.MACD DIF:model.DIF DEA:model.DEA];
        } break;
            
        case SZAccessoryChartTypeKDJ: {
            [self.titleView updateKDJWithK:model.KDJ_K D:model.KDJ_D J:model.KDJ_J];
        } break;
        case SZAccessoryChartTypeRSI: {
            [self.titleView updateRSIWithRSI6:model.RSI_6 RSI12:model.RSI_12 RSI24:model.RSI_24];
        } break;
        default:
            break;
    }
}

- (void)showTitleView:(SZKLineModel *)model {
    self.titleView.hidden = false;
    [self.titleView updateWithMACD:model.MACD DIF:model.DIF DEA:model.DEA];
}


- (void)setup {
    _MAValues = [NSArray array];
    _MAColors = [NSArray array];
    
    _highestValue = -MAXFLOAT;
    _lowestValue = MAXFLOAT;
    self.accessoryChartType = SZAccessoryChartTypeMACD;
}

- (void)setAccessoryChartType:(SZAccessoryChartType)accessoryChartType {
    _accessoryChartType = accessoryChartType;
    switch (accessoryChartType) {
        case SZAccessoryChartTypeMACD: {
            _MAValues = @[ @0, @0 ];
            _MAColors = @[ [UIColor whiteColor], [UIColor yellowColor] ];
        }  break;
        case SZAccessoryChartTypeKDJ: {
            _MAValues = @[ @0, @0, @0 ];
            _MAColors = @[ [UIColor whiteColor], [UIColor yellowColor], [UIColor purpleColor] ];
        }  break;
        case SZAccessoryChartTypeRSI: {
            _MAValues = @[ @6, @12, @24 ];
            _MAColors = @[ [UIColor whiteColor], [UIColor yellowColor], [UIColor purpleColor] ];
        }  break;
        case SZAccessoryChartTypeWR: {
            
        }  break;
        case SZAccessoryChartTypeClose: {
            
        }  break;
    }
}

// overrite
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self drawAxis];
    [self drawChart];
    [self drawMALine];
}

- (void)drawMALine {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.f);
    for (int i = 0; i < _MAValues.count; i ++) {
        CGContextSetStrokeColorWithColor(context, _MAColors[i].CGColor);
        CGPathRef path = [self movingAvgGraphPathForContextAtIndex:i];
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
    }
}

- (CGFloat)calcValuePerHeightUnit {
    CGFloat unitValue = (_highestValue - _lowestValue) / (self.frame.size.height - kVerticalMargin * 2);
    return unitValue ?: 1.f;
}

- (CGPathRef)movingAvgGraphPathForContextAtIndex:(NSInteger)index {
    UIBezierPath *path = nil;
    CGFloat xAxisValue = _stockCtx.leftMargin + 0.5*_stockCtx.KLineWidth + _stockCtx.KLinePadding;
    CGFloat unitValue = [self calcValuePerHeightUnit];
    // 均线个数
    NSInteger maLength = [self.MAValues[index] integerValue];
    
    NSArray *drawArrays = [self.data subarrayWithRange:NSMakeRange(self.startDrawIndex, self.numberOfDrawCount)];
    for (int i = 0; i < drawArrays.count; i ++) {
        SZKLineModel *item = drawArrays[i];
        
        CGFloat MAValue = 0;
        
        switch (_accessoryChartType) {
            case SZAccessoryChartTypeMACD: {
                if (index == 0) {
                    MAValue = item.DEA;
                }
                else if (index == 1) {
                    MAValue = item.DIF;
                }
            } break;
            case SZAccessoryChartTypeKDJ: {
                if (index == 0) {
                    MAValue = item.KDJ_K;
                }
                else if (index == 1) {
                    MAValue = item.KDJ_D;
                }
                else if (index == 2) {
                    MAValue = item.KDJ_J;
                }
            } break;
            case SZAccessoryChartTypeRSI: {
                if (index == 0) {
                    MAValue = item.RSI_6;
                }
                else if (index == 1) {
                    MAValue = item.RSI_12;
                }
                else if (index == 2) {
                    MAValue = item.RSI_24;
                }
            } break;
            case SZAccessoryChartTypeWR: {
                
            } break;
            case SZAccessoryChartTypeClose: {
                
            } break;
        }
        // 不足均线个数，则不需要获取该段均线数据(例如: 均5，个数小于5个，则不需要绘制前四均线，...)
        BOOL notEnoughToDraw = [self.data indexOfObject:item] < maLength - 1;
        if ((notEnoughToDraw && maLength) || !MAValue) {
            xAxisValue += _stockCtx.KLineWidth + _stockCtx.KLinePadding;
            continue;
        }
        CGFloat deltaToBottomAxis = (MAValue - _lowestValue) / unitValue;
        CGFloat yAxisValue = self.bounds.size.height - (deltaToBottomAxis ?: 1) - kVerticalMargin;
        CGPoint maPoint = CGPointMake(xAxisValue, yAxisValue);
        if (!path) {
            path = [UIBezierPath bezierPath];
            [path moveToPoint:maPoint];
        }
        else {
            [path addLineToPoint:maPoint];
        }
        xAxisValue += _stockCtx.KLineWidth + _stockCtx.KLinePadding;
    }
    //圆滑
    path = [path mc_smoothedPathWithGranularity:15];
    return path.CGPath;
}

#pragma mark - private methods

- (void)resetMaxAndMin {
    _highestValue = CGFLOAT_MIN;
    _lowestValue = CGFLOAT_MAX;
    
    NSArray *subValues = [self.data subarrayWithRange:NSMakeRange(self.startDrawIndex, self.numberOfDrawCount)];
    NSArray *volums = self.autoFit ? subValues : self.data;
    for (SZKLineModel *model in volums) {
        switch (_accessoryChartType) {
            case SZAccessoryChartTypeMACD:{
                [self resetWhenTypeMACDWithModel:model];
            } break;
            case SZAccessoryChartTypeKDJ:{
                [self resetWhenTypeKDJWithModel:model];
            } break;
            case SZAccessoryChartTypeRSI:{
                [self resetWhenTypeRSIWithModel:model];
            } break;
            case SZAccessoryChartTypeWR:{
                
            } break;
            case SZAccessoryChartTypeClose:{
                
            } break;
        }
    }
}

- (void)resetWhenTypeRSIWithModel:(SZKLineModel *)model {
    if (model.RSI_6) {
        _lowestValue = MIN(_lowestValue, model.RSI_6);
        _highestValue = MAX(_highestValue, model.RSI_6);
    }
    if (model.RSI_12) {
        _lowestValue = MIN(_lowestValue, model.RSI_12);
        _highestValue = MAX(_highestValue, model.RSI_12);
    }
    if (model.RSI_24) {
        _lowestValue = MIN(_lowestValue, model.RSI_24);
        _highestValue = MAX(_highestValue, model.RSI_24);
    }
}

- (void)resetWhenTypeKDJWithModel:(SZKLineModel *)model {
    if (model.KDJ_K) {
        _lowestValue = MIN(_lowestValue, model.KDJ_K);
        _highestValue = MAX(_highestValue, model.KDJ_K);
    }
    if (model.KDJ_D) {
        _lowestValue = MIN(_lowestValue, model.KDJ_D);
        _highestValue = MAX(_highestValue, model.KDJ_D);
    }
    if (model.KDJ_J) {
        _lowestValue = MIN(_lowestValue, model.KDJ_J);
        _highestValue = MAX(_highestValue, model.KDJ_J);
    }
}

- (void)resetWhenTypeMACDWithModel:(SZKLineModel *)model {
    if(model.DIF) {
        _lowestValue = MIN(_lowestValue, model.DIF);
        _highestValue = MAX(_highestValue, model.DIF);
    }
    if(model.DEA) {
        _lowestValue = MIN(_lowestValue, model.DEA);
        _highestValue = MAX(_highestValue, model.DEA);
    }
    if(model.MACD) {
        _lowestValue = MIN(_lowestValue, model.MACD);
        _highestValue = MAX(_highestValue, model.MACD);
    }
}

- (void)drawAxis {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, AxisLineWidth);
    CGContextSetStrokeColorWithColor(context, AxisLineColor.CGColor);
    CGRect strokeRect = CGRectMake(_stockCtx.leftMargin, 0, self.bounds.size.width - _stockCtx.leftMargin - _stockCtx.rightMargin, self.bounds.size.height);
    CGContextStrokeRect(context, strokeRect);
}

- (void)drawChart {
    [self showYAxisTitleWithTitles:@[[NSString stringWithFormat:@"%.f", self.highestValue], [NSString stringWithFormat:@"%.f", self.highestValue/2.0], @"万"]];
    [self drawAccessoryView];
}

- (void)drawAccessoryView {
    if (_accessoryChartType != SZAccessoryChartTypeMACD) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, _stockCtx.KLineWidth);
    
    __block CGFloat xAxis = _stockCtx.KLinePadding + _stockCtx.leftMargin;
    NSArray *kLineModels = [self.data subarrayWithRange:NSMakeRange(self.startDrawIndex, self.numberOfDrawCount)];
    
    [self resetMaxAndMin];
    
    CGFloat unitValue = [self calcValuePerHeightUnit];
    
    [kLineModels enumerateObjectsUsingBlock:^(SZKLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        UIColor *fillColor = model.MACD > 0 ? _stockCtx.positiveLineColor : _stockCtx.negativeLineColor;
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        
        CGRect pathRect = CGRectZero;
        CGFloat centerY = self.frame.size.height + _lowestValue/unitValue - kVerticalMargin;
        
        CGFloat itemHeight = ABS(model.MACD/unitValue);
        if (model.MACD > 0) {
            pathRect = CGRectMake(xAxis, centerY - itemHeight, _stockCtx.KLineWidth, itemHeight);
        }
        else {
            pathRect = CGRectMake(xAxis, centerY, _stockCtx.KLineWidth, itemHeight);
        }
        CGContextAddRect(context, pathRect);
        CGContextFillPath(context);
        xAxis += _stockCtx.KLineWidth + _stockCtx.KLinePadding;
    }];
}

- (void)showYAxisTitleWithTitles:(NSArray *)yAxisTitles {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect = self.bounds;
    //交易量边框
    CGContextSetLineWidth(context, AxisLineWidth);
    CGContextSetStrokeColorWithColor(context, AxisLineColor.CGColor);
    CGRect strokeRect = CGRectMake(_stockCtx.leftMargin, AxisLineWidth/2.0, rect.size.width - _stockCtx.leftMargin - _stockCtx.rightMargin, rect.size.height);
    CGContextStrokeRect(context, strokeRect);
    
    [self drawDashLineInContext:context movePoint:CGPointMake(_stockCtx.leftMargin + 1.25,
                                                              rect.size.height/2.0)
                        toPoint:CGPointMake(rect.size.width  - _stockCtx.rightMargin - 0.8,
                                            rect.size.height/2.0)];
    
    //这必须把dash给初始化一次，不然会影响其他线条的绘制
    CGContextSetLineDash(context, 0, 0, 0);
    
    for (int i = 0; i < yAxisTitles.count; i ++) {
        NSAttributedString *attString = [SZTrendChartUtil attributeText:yAxisTitles[i] textColor:YAxisTitleColor font:YAxisTitleFont];
        CGSize size = [attString.string stringSizeWithFont:YAxisTitleFont];
        
        [attString drawInRect:CGRectMake(rect.size.width - _stockCtx.rightMargin + 2.f,
                                         strokeRect.origin.y + i*strokeRect.size.height/2.0 - size.height/2.0*i - (i==0?2 : 0),
                                         size.width,
                                         size.height)];
    }
}

- (void)drawDashLineInContext:(CGContextRef)context
                    movePoint:(CGPoint)mPoint toPoint:(CGPoint)toPoint {
    CGContextSetLineWidth(context, SeparatorWidth);
    CGFloat lengths[] = {5,5};
    CGContextSetStrokeColorWithColor(context, SeparatorColor.CGColor);
    CGContextSetLineDash(context, 0, lengths, 2);  //画虚线
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, mPoint.x, mPoint.y);    //开始画线
    CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
    
    CGContextStrokePath(context);
}



@end
