//
//  WRChartView.m
//  WRChartDemo
//
//  Created by xianghui on 2017/6/29.
//  Copyright © 2017年 xianghui. All rights reserved.
//

#import "WRChartView.h"

@interface WRChartView ()

@property (strong, nonatomic) NSArray *chartConfigsArray; // 图表配置数组
@property (strong, nonatomic) NSMutableArray <NSArray *>*normalizedChartPointsArray; // 归一化点集合
@property (strong, nonatomic) NSMutableArray <NSArray *>*drawChartPointsArray; // 绘制点集合

@property (assign, nonatomic) CGFloat chartWidth; // 图表宽度
@property (assign, nonatomic) CGFloat chartHeight; // 图表高度
@property (assign, nonatomic) CGFloat maxValueX; // X最大值
@property (assign, nonatomic) CGFloat maxValueY; // Y最大值

@end

@implementation WRChartView

- (instancetype)initWithFrame:(CGRect)frame
               configurations:(NSArray <WRChartConfig *> *)chartConfigsArray {
    if (self = [super initWithFrame:frame]) {
        [self prepareDrawChart:chartConfigsArray];
        [self installSubLayers];
    }
    return self;
}
#pragma mark - 准备绘制图表
- (void)prepareDrawChart:(NSArray <WRChartConfig *> *)chartConfigsArray {
    self.chartConfigsArray = [NSArray arrayWithArray:chartConfigsArray];
    
    WRChartConfig *firstChartConfig = self.chartConfigsArray.firstObject;

    // 图表宽高
    self.chartWidth = self.frame.size.width - firstChartConfig.paddingLeft - firstChartConfig.paddingRight;
    self.chartHeight = self.frame.size.height - firstChartConfig.paddingTop - firstChartConfig.paddingBottom;
    // 图表最大值
    self.maxValueX = 0;
    self.maxValueY = 0;
    for (WRChartConfig *chartConfig in chartConfigsArray) {
        for (WRChartPoint *point in chartConfig.chartPoints) {
            self.maxValueX = self.maxValueX < point.x ? point.x : self.maxValueX;
            self.maxValueY = self.maxValueY < point.y ? point.y : self.maxValueY;
        }
    }
    self.maxValueX = MAX(1, self.maxValueX);
    self.maxValueY = MAX(1, self.maxValueY);
    
    // 数据归一
    self.normalizedChartPointsArray = [NSMutableArray arrayWithCapacity:chartConfigsArray.count];
    self.drawChartPointsArray = [NSMutableArray arrayWithCapacity:chartConfigsArray.count];
    for (NSInteger i = 0; i < chartConfigsArray.count; i++) {
        WRChartConfig *chartConfig = chartConfigsArray[i];
        NSMutableArray *normalizedChartPointsArray = [NSMutableArray arrayWithCapacity:chartConfigsArray.count];
        NSMutableArray *drawChartPointsArray = [NSMutableArray arrayWithCapacity:chartConfigsArray.count];
        for (WRChartPoint *point in chartConfig.chartPoints) {
            WRChartPoint *normalizedPoint = [[WRChartPoint alloc] initWithX:point.x / self.maxValueX andY:point.y / self.maxValueY];
            [normalizedChartPointsArray addObject:normalizedPoint];
            
            WRChartPoint *drawPoint = [[WRChartPoint alloc] initWithX:normalizedPoint.x * self.chartWidth + chartConfig.paddingLeft
                                                                 andY:(1 - normalizedPoint.y) * self.chartHeight + chartConfig.paddingTop];
            [drawChartPointsArray addObject:drawPoint];
        }
        [self.normalizedChartPointsArray addObject:normalizedChartPointsArray];
        [self.drawChartPointsArray addObject:drawChartPointsArray];
    }
}
#pragma mark - 添加图层
- (void)installSubLayers {
    [self installXAxisLayer];
    [self installYAxisLayer];
    [self installGradientLayer];
    [self installLineLayer];
}

- (void)installXAxisLayer {
    WRChartConfig *chartConfig = self.chartConfigsArray[0];
    if (chartConfig == nil) {
        return;
    }
    
    CALayer *xAxisLayer = [CALayer layer];
    xAxisLayer.frame = self.layer.bounds;
    
    // 坐标轴
    CAShapeLayer *axisLineLayer = [CAShapeLayer layer];
    axisLineLayer.frame = xAxisLayer.bounds;
    UIBezierPath *axisPath = [UIBezierPath bezierPath];
    [axisPath moveToPoint:CGPointMake(chartConfig.paddingLeft,
                                      chartConfig.paddingTop + self.chartHeight)];
    [axisPath addLineToPoint:CGPointMake( chartConfig.paddingLeft + self.chartWidth,
                                         chartConfig.paddingTop + self.chartHeight)];
    axisLineLayer.path = axisPath.CGPath;
    axisLineLayer.lineWidth = chartConfig.xAxisLineWidth;
    axisLineLayer.strokeColor = chartConfig.xAxisLineColor.CGColor;
    axisLineLayer.fillColor = [UIColor clearColor].CGColor;
    [xAxisLayer addSublayer:axisLineLayer];
    // 坐标轴文本
    CGFloat xGridWidth = self.chartWidth / (chartConfig.xAxisItemsArray.count - 1);
    if (chartConfig.xAxisItemsArray.count > 0) {
        for (int i = 0; i < chartConfig.xAxisItemsArray.count; i++) {
            NSString *stringOfValue = chartConfig.xAxisItemsArray[i];
            CGSize size = [stringOfValue boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesFontLeading
                                                   attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:chartConfig.xAxisLabelFontSize]}
                                                      context:nil].size;
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.frame = CGRectMake(chartConfig.paddingLeft + i * xGridWidth - size.width / 2,
                                         chartConfig.paddingTop + self.chartHeight + chartConfig.paddingBottom,
                                         size.width,
                                         size.height);
            [textLayer setString:stringOfValue];
            [textLayer setFontSize:chartConfig.xAxisLabelFontSize];
            [textLayer setForegroundColor:chartConfig.xAxisLabelColor.CGColor];
            [textLayer setContentsScale:[UIScreen mainScreen].scale];
            [xAxisLayer addSublayer:textLayer];
        }
    }
    // 分割线
    if (chartConfig.xSeparateLineShow) {
        for (int i = 0; i < chartConfig.xAxisItemsArray.count; i++) {
            CAShapeLayer *separateLineLayer = [CAShapeLayer layer];
            separateLineLayer.frame = xAxisLayer.bounds;
            UIBezierPath *axisPath = [UIBezierPath bezierPath];
            [axisPath moveToPoint:CGPointMake(chartConfig.paddingLeft + xGridWidth * i,
                                              chartConfig.paddingTop)];
            [axisPath addLineToPoint:CGPointMake(chartConfig.paddingLeft + xGridWidth * i,
                                                 chartConfig.paddingTop + self.chartHeight)];
            separateLineLayer.path = axisPath.CGPath;
            separateLineLayer.lineWidth = chartConfig.xAxisLineWidth;
            separateLineLayer.strokeColor = chartConfig.xAxisLineColor.CGColor;
            separateLineLayer.fillColor = [UIColor clearColor].CGColor;
            [xAxisLayer addSublayer:separateLineLayer];
        }
    }
    [self.layer addSublayer:xAxisLayer];
}
- (void)installYAxisLayer {
    WRChartConfig *chartConfig = self.chartConfigsArray[0];
    if (chartConfig == nil) {
        return;
    }
    CALayer *yAxisLayer = [CALayer layer];
    yAxisLayer.frame = self.layer.bounds;

    // 坐标轴
    CAShapeLayer *axisLineLayer = [CAShapeLayer layer];
    axisLineLayer.frame = yAxisLayer.bounds;
    UIBezierPath *axisPath = [UIBezierPath bezierPath];
    [axisPath moveToPoint:CGPointMake(chartConfig.paddingLeft,
                                      chartConfig.paddingTop)];
    [axisPath addLineToPoint:CGPointMake( chartConfig.paddingLeft,
                                         chartConfig.paddingTop + self.chartHeight)];
    axisLineLayer.path = axisPath.CGPath;
    axisLineLayer.lineWidth = chartConfig.yAxisLineWidth;
    axisLineLayer.strokeColor = chartConfig.yAxisLineColor.CGColor;
    axisLineLayer.fillColor = [UIColor clearColor].CGColor;
    [yAxisLayer addSublayer:axisLineLayer];
    // 坐标轴文本
    CGFloat yGridWidth = self.chartHeight / (chartConfig.yAxisItemsArray.count - 1);
    if (chartConfig.yAxisItemsArray.count > 0) {
        for (int i = 0; i < chartConfig.yAxisItemsArray.count; i++) {
            NSString *stringOfValue = chartConfig.yAxisItemsArray[i];
            CGSize size = [stringOfValue boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesFontLeading
                                                   attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:chartConfig.yAxisLabelFontSize]}
                                                      context:nil].size;
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.frame = CGRectMake((chartConfig.paddingLeft - size.width) / 2,
                                         chartConfig.paddingTop + i * yGridWidth - size.height / 2,
                                         size.width,
                                         size.height);
            [textLayer setString:stringOfValue];
            [textLayer setFontSize:chartConfig.yAxisLabelFontSize];
            [textLayer setForegroundColor:chartConfig.yAxisLabelColor.CGColor];
            [textLayer setContentsScale:2.0];
            [yAxisLayer addSublayer:textLayer];
        }
    }
    // 分割线
    if (chartConfig.ySeparateLineShow) {
        for (int i = 0; i < chartConfig.yAxisItemsArray.count; i++) {
            CAShapeLayer *separateLineLayer = [CAShapeLayer layer];
            separateLineLayer.frame = yAxisLayer.bounds;
            UIBezierPath *axisPath = [UIBezierPath bezierPath];
            [axisPath moveToPoint:CGPointMake(chartConfig.paddingLeft,
                                              chartConfig.paddingTop + yGridWidth * i)];
            [axisPath addLineToPoint:CGPointMake( chartConfig.paddingLeft + self.chartWidth,
                                                 chartConfig.paddingTop + yGridWidth * i)];
            separateLineLayer.path = axisPath.CGPath;
            separateLineLayer.lineWidth = chartConfig.yAxisLineWidth;
            separateLineLayer.strokeColor = chartConfig.xAxisLineColor.CGColor;
            separateLineLayer.fillColor = [UIColor clearColor].CGColor;
            [yAxisLayer addSublayer:separateLineLayer];
        }
    }
    
    [self.layer addSublayer:yAxisLayer];
}
// 绘制渐变
- (void)installGradientLayer {
    for (NSInteger i = 0; i < self.chartConfigsArray.count; i++) {
        WRChartConfig *chartConfig = self.chartConfigsArray[i];
        if (chartConfig.chartType == WRChartType_Bar) {
            continue;
        }
        NSArray *drawingChartPoints = self.drawChartPointsArray[i];

        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.layer.bounds;
        gradientLayer.locations = @[ @(0.1), @(0.99) ];
        gradientLayer.colors = @[(__bridge id)([chartConfig.fillColor colorWithAlphaComponent:0.2].CGColor),
                                 (__bridge id)([chartConfig.fillColor colorWithAlphaComponent:0.01].CGColor)
                                ];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        [self.layer addSublayer:gradientLayer];

        CAShapeLayer *fillLayer = [CAShapeLayer layer];
        fillLayer.frame = self.layer.bounds;
        UIBezierPath *path = [self bezierPathOfStrokeLayer:chartConfig drawingChartPoints:drawingChartPoints];
        WRChartPoint *lastPoint = drawingChartPoints.lastObject;
        WRChartPoint *firstPoint = drawingChartPoints.firstPoint;
        [path addLineToPoint:CGPointMake(lastPoint.x,
                                         chartConfig.paddingTop + self.chartHeight)];
        [path addLineToPoint:CGPointMake(firstPoint.x,
                                         chartConfig.paddingTop + self.chartHeight)];
        [path closePath];
        fillLayer.path = path.CGPath;
        fillLayer.fillColor = [UIColor whiteColor].CGColor;
        fillLayer.strokeColor = [UIColor whiteColor].CGColor;
        gradientLayer.mask = fillLayer;
   }
}
// 绘制线layer
- (void)installLineLayer {
    for (NSInteger i = 0; i < self.drawChartPointsArray.count; i++) {
        WRChartConfig *chartConfig = self.chartConfigsArray[i];
        NSArray *drawingChartPoints = self.drawChartPointsArray[i];

        CALayer *lineLayer = [CALayer layer];
        lineLayer.frame = self.layer.bounds;
    
        CAShapeLayer *strokeLayer = [CAShapeLayer layer];
        strokeLayer.frame = lineLayer.bounds;
        strokeLayer.path = [self bezierPathOfStrokeLayer:chartConfig drawingChartPoints:drawingChartPoints].CGPath;
        strokeLayer.strokeColor = chartConfig.strokeColor.CGColor;
        strokeLayer.fillColor = [UIColor clearColor].CGColor;
        strokeLayer.lineWidth = chartConfig.lineWidth;
        strokeLayer.lineJoin = kCALineJoinRound;
        strokeLayer.lineCap = kCALineCapRound;
        if (chartConfig.chartType == WRChartType_Bar) {
            strokeLayer.strokeColor = chartConfig.fillColor.CGColor;
            strokeLayer.lineCap = kCALineCapButt;
            if (strokeLayer.lineWidth >
                (self.chartWidth / drawingChartPoints.count - 2)) {
                strokeLayer.lineWidth =
                self.chartWidth / drawingChartPoints.count - 2;
            }
        }
        [lineLayer addSublayer:strokeLayer];
        //  add lineLayer
        [self.layer addSublayer:lineLayer];
    }
}
- (UIBezierPath *)bezierPathOfStrokeLayer:(WRChartConfig *)chartConfig drawingChartPoints:(NSArray *)drawingChartPoints {
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (chartConfig.chartType == WRChartType_Line) {
        BOOL isFirst = YES;
        for (WRChartPoint *point in drawingChartPoints) {
            if (isFirst) {
                [path moveToPoint:CGPointMake(point.x, point.y)];
                isFirst = NO;
            } else {
                [path addLineToPoint:CGPointMake(point.x, point.y)];
            }
        }
    }
    if (chartConfig.chartType == WRChartType_Curve) {
        BOOL isFirst = YES;
        CGPoint lastPoint;
        for (WRChartPoint *point in drawingChartPoints) {
            if (isFirst) {
                [path moveToPoint:CGPointMake(point.x, point.y)];
                lastPoint = CGPointMake(point.x, point.y);
                isFirst = NO;
            } else {
                CGPoint mid, cp1, cp2;
                CGFloat delta;
                mid.x = (lastPoint.x + point.x) / 2;
                mid.y = (lastPoint.y + point.y) / 2;
                //  cp1
                cp1.x = (lastPoint.x + mid.x) / 2;
                cp1.y = (lastPoint.y + mid.y) / 2;
                delta = fabs(mid.y - cp1.y);
                if (cp1.y > mid.y) {
                    cp1.y += delta;
                } else {
                    cp1.y -= delta;
                }
                //  cp2
                cp2.x = (mid.x + point.x) / 2;
                cp2.y = (mid.y + point.y) / 2;
                delta = fabs(point.y - cp2.y);
                if (cp2.y < point.y) {
                    cp2.y += delta;
                } else {
                    cp2.y -= delta;
                }
                //  curve
                [path addQuadCurveToPoint:mid controlPoint:cp1];
                [path addQuadCurveToPoint:CGPointMake(point.x, point.y)
                             controlPoint:cp2];
                //  更新lastPoint
                lastPoint = CGPointMake(point.x, point.y);
            }
        }
    }
    if (chartConfig.chartType == WRChartType_Bar) {
        for (WRChartPoint *point in drawingChartPoints) {
            [path moveToPoint:CGPointMake(point.x, point.y)];
            [path addLineToPoint:CGPointMake(point.x,
                                             self.chartHeight + chartConfig.paddingTop)];
        }
    }
    return path;
}

@end
