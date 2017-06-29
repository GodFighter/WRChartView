//
//  WRChartConfig.m
//  WRChartDemo
//
//  Created by xianghui on 2017/6/29.
//  Copyright © 2017年 xianghui. All rights reserved.
//

#import "WRChartConfig.h"

@implementation WRChartPoint

- (instancetype)initWithX:(CGFloat)x andY:(CGFloat)y {
    if (self = [super init]) {
        _x = x;
        _y = y;
    }
    return self;
}

@end

@implementation WRChartConfig

- (instancetype)init {
    if (self = [super init]) {
        _chartType = WRChartType_Curve;
        
        _backgroundColor = [UIColor clearColor];
        _strokeColor = [UIColor redColor];
        _fillColor = [UIColor redColor];
        _lineWidth = 1;
        
        _paddingTop = 0;
        _paddingLeft = 20;
        _paddingBottom = 0;
        _paddingRight = 10;
        
        _xAxisLabelColor = [UIColor blackColor];
        _yAxisLabelColor = [UIColor blackColor];

        _xAxisLabelFontSize = 10;
        _yAxisLabelFontSize = 10;
        
        _xAxisLineColor = [UIColor colorWithWhite:0.3 alpha:0.8];
        _yAxisLineColor = [UIColor clearColor];
        
        _xAxisLineWidth = 0.1;
        _yAxisLineWidth = 0.1;
        
        _xSeparateLineShow = YES;
        _ySeparateLineShow = YES;
    }
    return self;
}

@end
