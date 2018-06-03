//
//  SZTrendChartView.m
//  TrendChart
//
//  Created by Zahi on 2018/5/31.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import "SZTrendChartView.h"
#import <Masonry.h>
#import "SZTrendChartTitleView.h"
#import "SZTrendChartUtil.h"
#import "SZTrendChartSegmentView.h"
#import "SZTrendChartTopView.h"
#import "SZVolumeView.h"
#import "SZAccessoryView.h"
#import "NSString+Common.h"
#import "UIView+Addition.h"


#define MaxYAxis       (self.topMargin + self.yAxisHeight)
#define MaxBoundSize   (MAX(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)))
#define MinBoundSize   (MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)))
#define SelfWidth      (_landscapeMode ? MaxBoundSize : MinBoundSize)
#define SelfHeight     (_landscapeMode ? MinBoundSize : MaxBoundSize)

static const NSUInteger kXAxisCutCount = 5; //!< X轴切割份数
static const NSUInteger kYAxisCutCount = 5; //!< Y轴切割份数
static const CGFloat kBarChartHeightRatio = .182f; //!< 副图的高度占比
static const CGFloat kChartVerticalMargin = 30.f;  //!< 图表上下各留的间隙
static const CGFloat kTimeAxisHeight = 14.f;       //!< 时间轴的高度
static const CGFloat kAccessoryMargin = 6.f; //!< 两个副图的间距

@interface SZTrendChartView () <SZTrendChartSegmentViewDelegate>

@property (nonatomic, assign) CGFloat yAxisHeight;
@property (nonatomic, assign) CGFloat xAxisWidth;
@property (nonatomic, strong) NSArray <SZKLineModel *> *dataSource;
@property (nonatomic, assign) NSInteger startDrawIndex;
@property (nonatomic, assign) NSInteger kLineDrawNum;
@property (nonatomic, strong) SZKLineModel *highestItem;
@property (nonatomic, assign) CGFloat highestPriceOfAll;
@property (nonatomic, assign) CGFloat lowestPriceOfAll;
//手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longGesture;
@property (nonatomic, assign) CGFloat lastPanScale;
//坐标轴
@property (nonatomic, strong) NSMutableDictionary *xAxisMapper;
//十字线
@property (nonatomic, strong) UIView *verticalCrossLine;     //垂直十字线
@property (nonatomic, strong) UIView *horizontalCrossLine;   //水平十字线
// 成交量图
@property (nonatomic, strong) SZVolumeView *volView;
@property (nonatomic, strong) SZAccessoryView *accessoryView;
//时间
@property (nonatomic, strong) UILabel *timeLabel;
//价格
@property (nonatomic, strong) UILabel *priceLabel;
//实时数据提示按钮
@property (nonatomic, strong) UIButton *realDataTipBtn;

@property (nonatomic, assign) NSInteger lastDrawNum; //!< 缩放手势 记录上次的绘制个数
@property (nonatomic, strong) SZTrendChartTitleView *KLineTitleView;
@property (nonatomic, strong) SZTrendChartSegmentView *segmentView;
@property (nonatomic, assign) CGFloat bottomSegmentViewHeight;
@property (nonatomic, assign) SZMainChartType mainChartType;
@property (nonatomic, strong) SZTrendChartTopView *topView;
@property (nonatomic, strong) UIButton *rotateBtn;

@end


@implementation SZTrendChartView

#pragma mark - life cycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = GlobalBGColor_Dark;
    [self initDate];
    //添加手势
    [self addGestures];
    [self registerObserver];
    [self setupHeader];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupBottomSegmentView];
    });
}

- (void)setupHeader {
    _topView = [SZTrendChartTopView trendChartTopView];
    [self addSubview:_topView];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SZTrendChartTopViewHeight));
        make.top.mas_equalTo(_navBarHeight);
        make.left.mas_equalTo(0);
    }];
}

- (void)setupBottomSegmentView {
    _segmentView = [SZTrendChartSegmentView segmentView];
    [self addSubview:_segmentView];
    _segmentView.delegate = self;
    _segmentView.frame = CGRectMake(0, SelfHeight - SZSegmentCellHeight, SelfWidth, SZSegmentTotalHeight);
}

- (void)initDate {
    _landscapeMode = false;
    
    self.MAValues = @[ @7, @12, @26, @30 ];
    self.MAColors = @[ [UIColor lightGrayColor],
                       [UIColor yellowColor],
                       [UIColor purpleColor],
                       [UIColor greenColor], ];
    
    self.zoomEnable = YES;
    self.showAvgLine = YES;
    self.showBarChart = YES;
    self.autoFit = YES;
    self.lastPanScale = 1.0;
    self.xAxisMapper = [NSMutableDictionary dictionary];
    self.topMargin = SZTrendChartTopViewHeight + _navBarHeight;
    self.KLineTitleView.hidden = true;
    
    _bottomSegmentViewHeight = SZSegmentCellHeight;
    _mainChartType = SZMainChartTypeMA;
}

/**
 *  添加手势
 */
- (void)addGestures {
    [self addGestureRecognizer:self.tapGesture];
    [self addGestureRecognizer:self.panGesture];
    [self addGestureRecognizer:self.pinchGesture];
    [self addGestureRecognizer:self.longGesture];
}

/**
 *  通知
 */
- (void)registerObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)removeCrossLine {
    [_verticalCrossLine removeFromSuperview];
    _verticalCrossLine = nil;
    [_horizontalCrossLine removeFromSuperview];
    _horizontalCrossLine = nil;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self hideTipsWithAnimated:NO];
    [self removeCrossLine];
    
    if (!self.dataSource.count) {
        return;
    }
    
    self.xAxisWidth = rect.size.width - _stockCtx.rightMargin - _stockCtx.leftMargin;
    
    CGFloat accessoryViewTotalHeight = rect.size.height * kBarChartHeightRatio * 2;
    self.yAxisHeight = rect.size.height - self.topMargin - kTimeAxisHeight - accessoryViewTotalHeight - kAccessoryMargin - _bottomSegmentViewHeight;
    
    // 纵轴的分割线
    [self drawYAxisInRect:rect];
    [self drawYAxisTitle];
    //时间轴
    [self drawXAxis];
    //k线
    [self drawKLine];
    //均线
    [self drawMALine];
    [self drawVolAndMACD];
}

#pragma mark - render UI

- (void)drawChartWithDataSource:(NSArray<SZKLineModel *> *)dataSource {
    self.dataSource = dataSource;
    
    if (self.showBarChart) {
        self.volView.data = dataSource;
        self.accessoryView.data = dataSource;
    }
    // 设置
    [self drawSetting];
    [self update];
}

- (void)drawSetting {
    NSString *priceTitle = [NSString stringWithFormat:@"%.2f", self.highestItem.High];
    CGSize size = [priceTitle stringSizeWithFont:YAxisTitleFont];
    
    _stockCtx.rightMargin = size.width + 4.f;
    [self resetDrawNumAndIndex];
}

- (void)resetDrawNumAndIndex {
    self.kLineDrawNum = floor(((SelfWidth - _stockCtx.leftMargin - _stockCtx.rightMargin - _stockCtx.KLinePadding) / (_stockCtx.KLineWidth + _stockCtx.KLinePadding)));
    self.startDrawIndex = self.dataSource.count > 0 ? self.dataSource.count - self.kLineDrawNum : 0;
}

#pragma mark - public methods

- (void)updateChartWithOpen:(CGFloat)open
                      close:(CGFloat)close
                       high:(CGFloat)high
                        low:(CGFloat)low
                       date:(NSString *)date
                      isNew:(BOOL)isNew {
    [self updateChartWithOpen:open close:close high:high low:low date:date mas:nil isNew:isNew];
}

- (void)updateChartWithOpen:(CGFloat)open
                      close:(CGFloat)close
                       high:(CGFloat)high
                        low:(CGFloat)low
                       date:(NSString *)date
                        mas:(NSArray *)mas
                      isNew:(BOOL)isNew {
    SZKLineModel *item= [SZKLineModel new];
    item.Open = open;
    item.Close = close;
    item.High = high;
    item.Low = low;
    item.date = date;
    
    if (isNew) {
        self.dataSource = self.dataSource.count ? [self.dataSource arrayByAddingObject:item] : @[item];
    }
    else {
        if (item.Close == self.dataSource.lastObject.Close) {
            return;
        }
        NSMutableArray *copy = [self.dataSource mutableCopy];
        [copy removeLastObject];
        [copy addObject:item];
        self.dataSource = copy;
    }
    [self drawChartWithDataSource:self.dataSource];
}

#pragma mark - event reponse

- (void)updateChartPressed:(UIButton *)button {
    self.startDrawIndex = self.dataSource.count - self.kLineDrawNum;
}

- (void)tapEvent:(UITapGestureRecognizer *)tapGesture {
    if (self.dataSource.count == 0 || !self.dataSource || _segmentView.isOpening) {
        return;
    }
    CGPoint touchPoint = [tapGesture locationInView:self];
    [self showTipsViewWithPoint:touchPoint];
}

- (void)panEvent:(UIPanGestureRecognizer *)panGesture {
    [self hideTipsWithAnimated:NO];
    CGPoint touchPoint = [panGesture translationInView:self];
    NSInteger offsetIndex = fabs(touchPoint.x / (_stockCtx.KLineWidth + _stockCtx.KLinePadding));
    if (self.dataSource.count == 0 || offsetIndex == 0) {
        return;
    }
    if (touchPoint.x > 0) {
        self.startDrawIndex = self.startDrawIndex - offsetIndex < 0 ? 0 : self.startDrawIndex - offsetIndex;
    }
    else {
        self.startDrawIndex = self.startDrawIndex + offsetIndex + self.kLineDrawNum >= self.dataSource.count ? self.dataSource.count - self.kLineDrawNum : self.startDrawIndex + offsetIndex;
    }
    [panGesture setTranslation:CGPointZero inView:self];
    [self update];
}

- (void)pinchEvent:(UIPinchGestureRecognizer *)pinchEvent {
    [self hideTipsWithAnimated:NO];
    if (!self.zoomEnable || self.dataSource.count == 0) {
        return;
    }
    CGFloat scale = pinchEvent.scale - self.lastPanScale + 1;
    if ((scale < 1 && _stockCtx.KLineWidth <= _stockCtx.minKLineWidth) || (scale > 1 && _stockCtx.KLineWidth >= _stockCtx.maxKLineWidth)) {
        return;
    }
    _stockCtx.KLineWidth = _stockCtx.KLineWidth * scale;
    _kLineDrawNum = floor((SelfWidth - _stockCtx.leftMargin - _stockCtx.rightMargin) / (_stockCtx.KLineWidth + _stockCtx.KLinePadding));
    
    //容差处理
    CGFloat diffWidth = (SelfWidth - _stockCtx.leftMargin - _stockCtx.rightMargin) - (_stockCtx.KLineWidth + _stockCtx.KLinePadding)*_kLineDrawNum;
    if (diffWidth > 4*(_stockCtx.KLineWidth + _stockCtx.KLinePadding)/5.0) {
        _kLineDrawNum = _kLineDrawNum + 1;
    }
    _kLineDrawNum = (self.dataSource.count > 0 && _kLineDrawNum < self.dataSource.count) ? _kLineDrawNum : self.dataSource.count;
    
    NSInteger offset = (NSInteger)((_lastDrawNum - _kLineDrawNum) / 2);
    if (ABS(offset)) {
        _lastDrawNum = _kLineDrawNum;
        if (ABS(offset) < 1.5) {
            _startDrawIndex += offset;
            if (_startDrawIndex + self.kLineDrawNum > self.dataSource.count) {
                _startDrawIndex = self.dataSource.count - self.kLineDrawNum;
            }
            if (_startDrawIndex < 0) {
                _startDrawIndex = 0;
            }
            [self update];
        }
    }
    
    pinchEvent.scale = scale;
    self.lastPanScale = pinchEvent.scale;
}

- (void)longPressEvent:(UILongPressGestureRecognizer *)longGesture {
    if (self.dataSource.count == 0 || !self.dataSource) {
        return;
    }
    if (longGesture.state == UIGestureRecognizerStateEnded) {
        [self hideTipsWithAnimated:NO];
    }
    else {
        CGPoint touchPoint = [longGesture locationInView:self];
        [self showTipsViewWithPoint:touchPoint];
    }
}

- (void)showTipBoardWithOuterViewTouchPoint:(CGPoint)touchPoint {
    [self showTipsViewWithPoint:touchPoint isInMainView:false];
}

- (void)showTipsViewWithPoint:(CGPoint)point {
    [self showTipsViewWithPoint:point isInMainView:true];
}

- (void)showTipsViewWithPoint:(CGPoint)touchPoint isInMainView:(BOOL)inMainView {
    // 防止tap事件与segmentView的collectionView的点击冲突导致
    if (touchPoint.y > SelfHeight - SZSegmentCellHeight) {
        return;
    }
    CGFloat relativeTouchX = touchPoint.x - _stockCtx.leftMargin;
    // 如果是来自外部的点击事件，Y坐标防止跨到其他图层
    if (!inMainView) {
        touchPoint.y = _topMargin + _yAxisHeight;
    }
    touchPoint.y = MIN(_topMargin + _yAxisHeight, touchPoint.y);
    // 注意在_xAxisMapper的xAxisKey值是仅仅是坐标原点开始的横坐标值，不是从视图最左开始计算的。即完整的在视图上的坐标需加上_stockCtx.leftMargin
    [self.xAxisMapper enumerateKeysAndObjectsUsingBlock:^(NSNumber *xAxisKey, NSNumber *indexObject, BOOL *stop) {
        CGFloat xAxisValue = [xAxisKey floatValue];
        if (relativeTouchX > xAxisValue - _stockCtx.KLineWidth - _stockCtx.KLinePadding && relativeTouchX < xAxisValue + _stockCtx.KLinePadding)  {
            NSInteger index = [indexObject integerValue];
            // 获取对应的k线数据
            SZKLineModel *item = self.dataSource[index];
            CGFloat xAxis = xAxisValue - _stockCtx.KLineWidth / 2.0 + _stockCtx.leftMargin;
            [self showItemInfo:item atPoint:CGPointMake(xAxis, touchPoint.y)];
            *stop = YES;
        }
    }];
}

- (void)showItemInfo:(SZKLineModel *)item atPoint:(CGPoint)point {
    //十字线
    self.verticalCrossLine.hidden = NO;
    self.verticalCrossLine.us_height = SelfHeight - self.topMargin;
    self.verticalCrossLine.us_left = point.x;
    
    self.horizontalCrossLine.hidden = NO;
    self.horizontalCrossLine.us_top = point.y;
    
    self.KLineTitleView.hidden = false;
    [self.KLineTitleView updateWithHigh:item.High open:item.Open close:item.Close low:item.Low];
    
    //时间，价额
    self.priceLabel.hidden = NO;
    self.priceLabel.text = [self finalPriceWithTouchPointY:point.y];
    
    CGFloat priceLabelHeight = [_priceLabel.text stringHeightWithFont:_priceLabel.font width:MAXFLOAT];
    CGFloat priceLabelY = point.y - priceLabelHeight / 2;
    self.priceLabel.frame = CGRectMake(SelfWidth-_stockCtx.rightMargin,
                                       priceLabelY,
                                       _stockCtx.rightMargin - SeparatorWidth,
                                       priceLabelHeight);
    [self bringSubviewToFront:self.priceLabel];
    
    NSString *date = item.Time;
    self.timeLabel.text = date;
    self.timeLabel.hidden = !date.length;
    [self bringSubviewToFront:self.timeLabel];
    if (date.length > 0) {
        CGFloat textWidth = [date stringWidthWithFont:XAxisTitleFont height:MAXFLOAT];
        CGFloat originX = MIN(MAX(0, point.x - textWidth/2.0 - 2), SelfWidth - _stockCtx.rightMargin - textWidth - 4);
        self.timeLabel.frame = CGRectMake(originX,
                                          MaxYAxis + SeparatorWidth,
                                          textWidth + 4,
                                          kTimeAxisHeight - SeparatorWidth*2);
    }
    [self.volView showTitleView:item];
    [self.accessoryView showModelInfo:item type:_stockCtx.selectedModel.accessoryChartType];
}

- (NSString *)finalPriceWithTouchPointY:(CGFloat)pointY {
    CGFloat currentHeight = MaxYAxis - pointY;
    CGFloat unit = [self getPricePerHeightUnit];
    CGFloat oriPrice = unit * currentHeight;
    CGFloat finalPrice = oriPrice + self.lowestPriceOfAll - kChartVerticalMargin * unit;
    
    return [SZTrendChartUtil decimalValue:finalPrice];
}

- (void)hideTipsWithAnimated:(BOOL)animated {
    self.horizontalCrossLine.hidden = YES;
    self.verticalCrossLine.hidden = YES;
    self.priceLabel.hidden = YES;
    self.timeLabel.hidden = YES;
    self.KLineTitleView.hidden = true;
    [self.volView hideTitleView];
    [self.accessoryView hideTitleView];
}

#pragma mark - private methods
- (void)drawYAxisInRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //k线边框
    CGRect strokeRect = CGRectMake(_stockCtx.leftMargin, self.topMargin, self.xAxisWidth, self.yAxisHeight);
    CGContextSetLineWidth(context, AxisLineWidth);
    CGContextSetStrokeColorWithColor(context, AxisLineColor.CGColor);
    CGContextStrokeRect(context, strokeRect);
    
    //k线分割线
    CGFloat avgHeight = strokeRect.size.height/kYAxisCutCount;
    for (int i = 1; i < kYAxisCutCount; i ++) {
        [self drawDashLineInContext:context
                          movePoint:CGPointMake(_stockCtx.leftMargin + 1.25, self.topMargin + avgHeight*i)
                            toPoint:CGPointMake(rect.size.width  - _stockCtx.rightMargin - 0.8, self.topMargin + avgHeight*i)];
    }
    
    //这必须把dash给初始化一次，不然会影响其他线条的绘制
    CGContextSetLineDash(context, 0, 0, 0);
}

- (void)drawYAxisTitle {
    NSUInteger cutNum = 5; // 纵坐标均分成5份
    CGFloat unitValue = [self getPricePerHeightUnit];
    CGFloat avgValue = (self.highestPriceOfAll - self.lowestPriceOfAll + kChartVerticalMargin * 2 * unitValue) / cutNum;
    CGFloat lowest = self.lowestPriceOfAll - kChartVerticalMargin * unitValue;
    CGFloat highetst = self.highestPriceOfAll + kChartVerticalMargin * unitValue;
    
    for (int i = 0; i < cutNum+1; i ++) {
        CGFloat yAxisValue = (i == cutNum) ? lowest : (highetst - avgValue * i);
        NSAttributedString *attString = [SZTrendChartUtil attributeText:[SZTrendChartUtil decimalValue:yAxisValue] textColor:YAxisTitleColor font:YAxisTitleFont];
        CGSize size = [attString.string stringSizeWithFont:YAxisTitleFont];
        
        CGFloat diffHeight = 0;
        if (i == cutNum) {
            diffHeight = size.height;
        }
        else if (i > 0 && i < cutNum) {
            diffHeight = size.height/2.0;
        }
        if ([self landscapeMode] && !i) {
            continue;
        }
        [attString drawInRect:CGRectMake(SelfWidth - _stockCtx.rightMargin + 2.f,
                                         self.yAxisHeight / cutNum * i + self.topMargin - diffHeight,
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

- (void)drawXAxis {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat widthPerGrid = self.xAxisWidth / kXAxisCutCount;
    NSInteger lineCountPerGrid = ceil(widthPerGrid / (_stockCtx.KLinePadding + _stockCtx.KLineWidth));
    
    CGFloat xAxisValue = _stockCtx.leftMargin + _stockCtx.KLineWidth/2.0 + _stockCtx.KLinePadding;
    //画X条虚线
    for (int i = 0; i < kXAxisCutCount; i ++) {
        if (xAxisValue > _stockCtx.leftMargin + self.xAxisWidth) {
            break;
        }
        [self drawDashLineInContext:context movePoint:CGPointMake(xAxisValue, self.topMargin + 1.25) toPoint:CGPointMake(xAxisValue, SelfHeight - _bottomSegmentViewHeight + 5)];
        //x轴坐标
        NSInteger timeIndex = i * lineCountPerGrid + self.startDrawIndex;
        if (timeIndex > self.dataSource.count - 1) {
            xAxisValue += lineCountPerGrid * (_stockCtx.KLinePadding + _stockCtx.KLineWidth);
            continue;
        }
        CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
        CGRect textBgRect = CGRectMake(xAxisValue - 5, MaxYAxis + SeparatorWidth, 10, kTimeAxisHeight - 2 * SeparatorWidth);
        CGContextAddRect(context, textBgRect);
        CGContextFillPath(context);
        
        NSAttributedString *attString = [SZTrendChartUtil attributeText:self.dataSource[timeIndex].date textColor:XAxisTitleColor font:XAxisTitleFont lineSpacing:2];
        CGSize size = [SZTrendChartUtil attributeString:attString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        CGFloat originX = MAX(MIN(xAxisValue - size.width/2.0, SelfWidth - _stockCtx.rightMargin - size.width), 0);
        [attString drawInRect:CGRectMake(originX, MaxYAxis + 2.0, size.width, size.height)];
        
        xAxisValue += lineCountPerGrid * (_stockCtx.KLinePadding + _stockCtx.KLineWidth);
    }
    
    CGContextSetLineDash(context, 0, 0, 0);
}

- (CGFloat)getPricePerHeightUnit {
    CGFloat unitValue = (self.highestPriceOfAll - self.lowestPriceOfAll) / (self.yAxisHeight - kChartVerticalMargin * 2);
    return unitValue ?: 1.f;
}

/**
 *  K线
 */
- (void)drawKLine {
    CGFloat pricePerHeightUnit = [self getPricePerHeightUnit];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    
    CGFloat xAxis = _stockCtx.KLinePadding;
    [self.xAxisMapper removeAllObjects];
    
    CGPoint maxPoint = CGPointZero;
    CGPoint minPoint = CGPointZero;
    
    NSArray *items = [self safeDrawItems];
    for (SZKLineModel *item in items) {
        self.xAxisMapper[@(xAxis + _stockCtx.KLineWidth)] = @([self.dataSource indexOfObject:item]);
        //通过开盘价、收盘价判断颜色
        CGFloat open = item.Open;
        CGFloat close = item.Close;
        UIColor *fillColor = open > close ? _stockCtx.positiveLineColor : _stockCtx.negativeLineColor;
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        
        CGFloat diffValue = fabs(open - close);
        CGFloat maxValue = MAX(open, close);
        CGFloat KLineHeight = MAX(diffValue/pricePerHeightUnit ?: 1, 0.5);
        CGFloat deltaToBottomAxis = (maxValue - self.lowestPriceOfAll) / pricePerHeightUnit + kChartVerticalMargin;
        CGFloat yAxis = MaxYAxis - (deltaToBottomAxis ?: 1);
        
        CGRect rect = CGRectMake(xAxis + _stockCtx.leftMargin, yAxis, _stockCtx.KLineWidth, KLineHeight);
        CGContextAddRect(context, rect);
        CGContextFillPath(context);
        
        //上、下影线
        CGFloat highYAxis = MaxYAxis - kChartVerticalMargin - (item.High - self.lowestPriceOfAll)/pricePerHeightUnit;
        CGFloat lowYAxis = MaxYAxis - kChartVerticalMargin - (item.Low - self.lowestPriceOfAll)/pricePerHeightUnit;
        CGPoint highPoint = CGPointMake(xAxis + _stockCtx.KLineWidth/2.0 + _stockCtx.leftMargin, highYAxis);
        CGPoint lowPoint = CGPointMake(xAxis + _stockCtx.KLineWidth/2.0 + _stockCtx.leftMargin, lowYAxis);
        CGContextSetStrokeColorWithColor(context, fillColor.CGColor);
        CGFloat shadowLineWidth = MAX(.7, MIN(4, _stockCtx.KLineWidth / 4));
        CGContextSetLineWidth(context, shadowLineWidth);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, highPoint.x, highPoint.y);  //起点坐标
        CGContextAddLineToPoint(context, lowPoint.x, lowPoint.y);   //终点坐标
        CGContextStrokePath(context);
        
        if (item.High == self.highestPriceOfAll) {
            maxPoint = highPoint;
        }
        if (item.Low == self.lowestPriceOfAll) {
            minPoint = lowPoint;
        }
        xAxis += _stockCtx.KLineWidth + _stockCtx.KLinePadding;
    }
    
    [self drawHintTitleWithPoint:maxPoint isMax:true];
    [self drawHintTitleWithPoint:minPoint isMax:false];
}

- (void)drawHintTitleWithPoint:(CGPoint)point isMax:(BOOL)isMax {
    // ⇠ ← →
    UIFont *titleFont = [UIFont systemFontOfSize:8.f];
    CGFloat price = isMax ? self.highestPriceOfAll : self.lowestPriceOfAll;
    NSString *priceStr = [SZTrendChartUtil decimalValue:price];
    
    NSString *hintTitle = [NSString stringWithFormat:@"←%@", priceStr];
    CGSize titleSize = [hintTitle stringSizeWithFont:titleFont];
    BOOL shouldTitleLeft = point.x + titleSize.width > SelfWidth - _stockCtx.rightMargin;
    
    CGFloat titleX = 0;
    if (shouldTitleLeft) {
        hintTitle = [NSString stringWithFormat:@"%@→", priceStr];
        titleX = point.x - titleSize.width;
    }
    else {
        hintTitle = [NSString stringWithFormat:@"←%@", priceStr];
        titleX = point.x;
    }
    CGFloat titleY = isMax ? point.y - titleSize.height : point.y;
    NSAttributedString *attString = [SZTrendChartUtil attributeText:hintTitle textColor:XAxisTitleColor font:titleFont];
    [attString drawInRect:(CGRect){titleX, titleY, titleSize}];
}

/**
 *  均线图
 */
- (void)drawMALine {
    if (!self.showAvgLine || _MAValues.count > _MAColors.count) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, MALineWidth);
    
    for (int i = 0; i < self.MAValues.count; i ++) {
        CGContextSetStrokeColorWithColor(context, self.MAColors[i].CGColor);
        CGPathRef path = [self movingAvgGraphPathForContextAtIndex:i];
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
    }
}

/**
 *  均线path
 */
- (CGPathRef)movingAvgGraphPathForContextAtIndex:(NSInteger)index {
    UIBezierPath *path = nil;
    
    CGFloat xAxisValue = _stockCtx.leftMargin + 0.5*_stockCtx.KLineWidth + _stockCtx.KLinePadding;
    CGFloat pricePerHeightUnit = [self getPricePerHeightUnit];
    
    // 均线个数
    NSInteger maLength = [self.MAValues[index] integerValue];
    
    NSArray *drawArrays = [self safeDrawItems];
    for (int i = 0; i < drawArrays.count; i ++) {
        SZKLineModel *item = drawArrays[i];
        
        CGFloat MAValue = 0;
        if (_mainChartType == SZMainChartTypeMA) {
            if (index == 0) {
                MAValue = item.MA7;
            }
            else if (index == 1) {
                MAValue = item.MA12;
            }
            else if (index == 2) {
                MAValue = item.MA26;
            }
            else if (index == 3) {
                MAValue = item.MA30;
            }
        }
        else if (_mainChartType == SZMainChartTypeBOLL) {
            if (index == 0) {
                MAValue = item.BOLL_MB;
            }
            else if (index == 1) {
                MAValue = item.BOLL_UP;
            }
            else if (index == 2) {
                MAValue = item.BOLL_DN;
            }
        }
        
        // 不足均线个数，则不需要获取该段均线数据(例如: 均5，个数小于5个，则不需要绘制前四均线，...)
        if ([self.dataSource indexOfObject:item] < maLength - 1 || !MAValue) {
            xAxisValue += _stockCtx.KLineWidth + _stockCtx.KLinePadding;
            continue;
        }
        CGFloat deltaToBottomAxis = (MAValue - self.lowestPriceOfAll) / pricePerHeightUnit + kChartVerticalMargin;
        CGFloat yAxisValue = MaxYAxis - (deltaToBottomAxis ?: 1);
        
        CGPoint maPoint = CGPointMake(xAxisValue, yAxisValue);
        
        if (yAxisValue < self.topMargin || yAxisValue > MaxYAxis) {
            xAxisValue += _stockCtx.KLineWidth + _stockCtx.KLinePadding;
            continue;
        }
        if (!path) {
            path = [UIBezierPath bezierPath];
            [path moveToPoint:maPoint];
        }
        else {
            [path addLineToPoint:maPoint];
        }
        xAxisValue += _stockCtx.KLineWidth + _stockCtx.KLinePadding;
    }
    
    return path.CGPath;
}

- (void)drawVolAndMACD {
    if (!self.showBarChart) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, _stockCtx.KLineWidth);
    
    CGRect rect = self.bounds;
    
    CGFloat boxOriginY = MaxYAxis + kTimeAxisHeight;
    self.volView.frame = CGRectMake(0, boxOriginY, rect.size.width, rect.size.height * kBarChartHeightRatio);
    
    self.volView.startDrawIndex = self.startDrawIndex;
    self.volView.numberOfDrawCount = self.kLineDrawNum;
    self.volView.autoFit = _autoFit;
    [self.volView update];
    
    self.accessoryView.frame = CGRectMake(0, CGRectGetMaxY(self.volView.frame) + kAccessoryMargin, rect.size.width, rect.size.height * kBarChartHeightRatio);
    
    self.accessoryView.startDrawIndex = self.startDrawIndex;
    self.accessoryView.numberOfDrawCount = self.kLineDrawNum;
    self.accessoryView.autoFit = _autoFit;
    [self.accessoryView update];
}

- (void)resetMaxAndMin {
    self.highestPriceOfAll = -MAXFLOAT;
    self.lowestPriceOfAll = MAXFLOAT;
    
    NSArray *subChartValues = [self safeDrawItems];
    NSArray *drawContext = self.autoFit ? subChartValues : self.dataSource;
    for (int i = 0; i < drawContext.count; i++) {
        SZKLineModel *model = drawContext[i];
        self.highestPriceOfAll = MAX(model.High, self.highestPriceOfAll);
        self.lowestPriceOfAll = MIN(model.Low, self.lowestPriceOfAll);
    }
    // 如果是BOLL，要重置最大最小值
    if (_mainChartType == SZMainChartTypeBOLL) {
        for (int i = 0; i < drawContext.count; i++) {
            SZKLineModel *model = drawContext[i];
            if (model.BOLL_UP) {
                self.highestPriceOfAll = MAX(model.BOLL_UP, self.highestPriceOfAll);
            }
            if (model.BOLL_DN) {
                self.lowestPriceOfAll = MIN(model.BOLL_DN, self.lowestPriceOfAll);
            }
        }
    }
}

- (NSArray <SZKLineModel *> *)safeDrawItems {
    NSInteger totalCount = [self.dataSource count];
    self.kLineDrawNum = MIN(self.kLineDrawNum, self.dataSource.count);
    NSRange subRange = NSMakeRange(self.startDrawIndex, _kLineDrawNum);
    if (NSMaxRange(subRange) > totalCount) {
        subRange = NSMakeRange(totalCount - self.kLineDrawNum, self.kLineDrawNum);
        self.startDrawIndex = totalCount - self.kLineDrawNum;
    }
    NSArray *drawItems = [self.dataSource subarrayWithRange:subRange];
    return drawItems;
}

#pragma mark -  public methods

- (void)clear {
    self.dataSource = nil;
    [self setNeedsDisplay];
}

#pragma mark - notificaiton events

- (void)deviceOrientationDidChangeNotification:(NSNotification *)notificaiton {
    
}

#pragma mark - getters

- (SZVolumeView *)volView {
    if (!_volView) {
        _volView = [SZVolumeView new];
        _volView.backgroundColor  = [UIColor clearColor];
        _volView.baseChartView = self;
        [self addSubview:_volView];
    }
    return _volView;
}

- (SZAccessoryView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [SZAccessoryView new];
        _accessoryView.backgroundColor  = [UIColor clearColor];
        _accessoryView.baseChartView = self;
        [self addSubview:_accessoryView];
    }
    return _accessoryView;
}

- (UIView *)verticalCrossLine {
    if (!_verticalCrossLine) {
        _verticalCrossLine = [[UIView alloc] initWithFrame:CGRectMake(_stockCtx.leftMargin, self.topMargin, 0.5, self.yAxisHeight)];
        _verticalCrossLine.backgroundColor = CrossLineColor;
        [self insertSubview:_verticalCrossLine belowSubview:self.segmentView];
    }
    return _verticalCrossLine;
}

- (UIView *)horizontalCrossLine {
    if (!_horizontalCrossLine) {
        _horizontalCrossLine = [[UIView alloc] initWithFrame:CGRectMake(_stockCtx.leftMargin, self.topMargin, self.xAxisWidth, 0.5)];
        _horizontalCrossLine.backgroundColor = CrossLineColor;
        [self addSubview:_horizontalCrossLine];
    }
    return _horizontalCrossLine;
}

- (UIButton *)realDataTipBtn {
    if (!_realDataTipBtn) {
        _realDataTipBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_realDataTipBtn setTitle:@"New Data" forState:UIControlStateNormal];
        [_realDataTipBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _realDataTipBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _realDataTipBtn.frame = CGRectMake(SelfWidth - _stockCtx.rightMargin - 60.0f, self.topMargin + 10.0f, 60.0f, 25.0f);
        [_realDataTipBtn addTarget:self action:@selector(updateChartPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_realDataTipBtn];
        _realDataTipBtn.layer.borderWidth = 1.0;
        _realDataTipBtn.layer.borderColor = [UIColor redColor].CGColor;
        _realDataTipBtn.hidden = YES;
    }
    return _realDataTipBtn;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.backgroundColor = timeAndPriceTipsBackgroundColor;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = YAxisTitleFont;
        _timeLabel.textColor = TimeAndPriceTextColor;
        _timeLabel.numberOfLines = 0;
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.backgroundColor = timeAndPriceTipsBackgroundColor;
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = [UIFont systemFontOfSize:XAxisTitleFont.pointSize];
        _priceLabel.textColor = TimeAndPriceTextColor;
        [self addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (SZTrendChartTitleView *)KLineTitleView {
    if (!_KLineTitleView) {
        _KLineTitleView = [SZTrendChartTitleView titleView];
        [self addSubview:_KLineTitleView];
    }
    _KLineTitleView.frame = CGRectMake(_stockCtx.leftMargin + 10, _topMargin, SelfWidth, 20);
    return _KLineTitleView;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
        [_tapGesture setCancelsTouchesInView:false];
    }
    return _tapGesture;
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEvent:)];
    }
    return _panGesture;
}

- (UIPinchGestureRecognizer *)pinchGesture {
    if (!_pinchGesture) {
        _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchEvent:)];
    }
    return _pinchGesture;
}

- (UILongPressGestureRecognizer *)longGesture {
    if (!_longGesture) {
        _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
    }
    return _longGesture;
}

- (UIButton *)rotateBtn {
    if (!_rotateBtn) {
        _rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_rotateBtn];
        [_rotateBtn setImage:[UIImage imageNamed:@"full_rotate"] forState:UIControlStateNormal];
        [_rotateBtn addTarget:self action:@selector(rotateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    CGFloat btnWidth = _stockCtx.rightMargin;
    _rotateBtn.frame = CGRectMake(SelfWidth-btnWidth, 0, btnWidth, btnWidth);
    return _rotateBtn;
}

#pragma mark - setters

- (void)setDataSource:(NSArray<SZKLineModel *> *)chartValues {
    _dataSource = chartValues;
    
    CGFloat maxHigh = -MAXFLOAT;
    for (SZKLineModel *item in self.dataSource) {
        if (item.High > maxHigh) {
            maxHigh = item.High;
            self.highestItem = item;
        }
    }
}

- (void)setKLineDrawNum:(NSInteger)kLineDrawNum {
    _kLineDrawNum = MAX(MIN(self.dataSource.count, kLineDrawNum), 0);
    
    if (_kLineDrawNum != 0) {
        _stockCtx.KLineWidth = (SelfWidth - _stockCtx.leftMargin - _stockCtx.rightMargin - _stockCtx.KLinePadding)/_kLineDrawNum - _stockCtx.KLinePadding;
    }
}

- (void)setLandscapeMode:(BOOL)landscapeMode {
    _landscapeMode = landscapeMode;
    CGFloat angle = 0;
    CGRect bounds = CGRectZero;
    CGPoint center = CGPointZero;
    CGFloat navAlpha = 0;
    
    if (landscapeMode) {
        angle = M_PI_2;
        bounds = CGRectMake(0, 0, CGRectGetHeight(self.superview.bounds), CGRectGetWidth(self.superview.bounds));
        center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
        self.topMargin = 8.f;
        [_topView hide];
        navAlpha = 0;
        [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationSlide];
    }
    else {
        angle = 0;
        bounds = CGRectMake(0, 0, CGRectGetWidth(self.superview.bounds), CGRectGetHeight(self.superview.bounds));
        center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
        self.topMargin = SZTrendChartTopViewHeight + _navBarHeight;
        [_topView show];
        navAlpha = 1.f;
        [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationSlide];
    }
    
    [UIView animateWithDuration:.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeRotation(angle);
        self.bounds = bounds;
        self.center = center;
        
        self.viewController.navigationController.navigationBar.alpha = navAlpha;
        
        [self rotateBtn];
        self.segmentView.frame = CGRectMake(0, SelfHeight-SZSegmentTotalHeight, SelfWidth, SZSegmentTotalHeight);
    } completion:nil];
    [self drawChartWithDataSource:_dataSource];
}

- (void)setMainChartType:(SZMainChartType)mainChartType {
    _mainChartType = mainChartType;
    _MAValues = @[ @20, @20, @20 ];
}

- (void)update {
    [self resetMaxAndMin];
    [self setNeedsDisplay];
}

- (void)rotateBtnClick {
    self.landscapeMode = false;
}

#pragma mark - <SZTrendChartSegmentViewDelegate>

- (void)stockSegmentView:(SZTrendChartSegmentView *)segmentView didSelectModel:(SZSegmentSelectedModel *)model {
    
    _stockCtx.selectedModel = model;
    
    if (model.subType == SZSegmentViewSubTypeMain) {
        if (model.mainChartType == SZMainChartTypeMA) {
            DLog(@"点击主图 == SZMainChartTypeMA");
            self.mainChartType = SZMainChartTypeMA;
        }
        else if (model.mainChartType == SZMainChartTypeBOLL) {
            DLog(@"点击主图 == SZMainChartTypeBOLL");
            self.mainChartType = SZMainChartTypeBOLL;
        }
        else if (model.mainChartType == SZMainChartTypeClose) {
            DLog(@"点击主图 == 关闭");
        }
        [self update];
    }
    else if (model.subType == SZSegmentViewSubTypeAccessory) {
        if (model.accessoryChartType == SZAccessoryChartTypeMACD) {
            DLog(@"点击副图 == SZAccessoryChartTypeMACD");
            _accessoryView.accessoryChartType = SZAccessoryChartTypeMACD;
        }
        else if (model.accessoryChartType == SZAccessoryChartTypeKDJ) {
            DLog(@"点击副图 == SZAccessoryChartTypeKDJ");
            _accessoryView.accessoryChartType = SZAccessoryChartTypeKDJ;
        }
        else if (model.accessoryChartType == SZAccessoryChartTypeRSI) {
            DLog(@"点击副图 == SZAccessoryChartTypeRSI");
            _accessoryView.accessoryChartType = SZAccessoryChartTypeRSI;
        }
        else if (model.accessoryChartType == SZAccessoryChartTypeWR) {
            DLog(@"点击副图 == SZAccessoryChartTypeWR");
        }
        else if (model.accessoryChartType == SZAccessoryChartTypeClose) {
            DLog(@"点击副图 == SZAccessoryChartTypeClose");
        }
        [_accessoryView update];
    }
    else if (model.subType == SZSegmentViewSubTypeTime) {
        if ([self.delegate respondsToSelector:@selector(trendChartView:didSelectTargetTime:)]) {
            [self.delegate trendChartView:self didSelectTargetTime:model.targetTimeType];
            
        }
    }
}

- (void)stockSegmentView:(SZTrendChartSegmentView *)segmentView showPopupView:(BOOL)showPopupView {
    [self hideTipsWithAnimated:false];
}

- (void)dealloc {
    [self removeObserver];
}

@end
