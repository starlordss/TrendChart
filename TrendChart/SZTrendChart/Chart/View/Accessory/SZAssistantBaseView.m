//
//  SZAssistantBaseView.m
//  TrendChart
//
//  Created by Zahi on 2018/6/3.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import "SZAssistantBaseView.h"
#import "SZTrendChartView.h"

@implementation SZAssistantBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.autoFit = false;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture {
    CGPoint touchPoint = [tapGesture locationInView:self];
    [self.baseChartView showTipBoardWithOuterViewTouchPoint:touchPoint];
    
    
}

- (void)showTitleView:(SZKLineModel *)model {
    self.titleView.hidden = false;
    [self.titleView updateWithVolume:model.volume MA5:model.MA7 MA10:model.MA20];
}

- (void)hideTitleView {
    self.titleView.hidden = true;
}

- (SZTrendChartTitleView *)titleView {
    if (!_titleView) {
        _titleView = [SZTrendChartTitleView titleView];
        _titleView.hidden = true;
        [self addSubview:_titleView];
    }
 
    _titleView.frame = CGRectMake(_stockCtx.leftMargin + 8, 0, self.bounds.size.width, 16);
    return _titleView;
}

- (void)update {
    
}

@end
