//
//  WRChartConfig.h
//  WRChartDemo
//
//  Created by xianghui on 2017/6/29.
//  Copyright © 2017年 xianghui. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
/**
 @brief 图表样式枚举
 */
typedef enum : NSUInteger {
    WRChartType_Line = 100,     // 线条
    WRChartType_Curve,          // 弧线
    WRChartType_Bar,            // 柱形
} WRChartType;
#pragma mark - 
#pragma mark WRChartPoint
/**
 @brief 图标点
 */
@interface WRChartPoint : NSObject

@property (assign, nonatomic, readonly) CGFloat x; //x坐标
@property (assign, nonatomic, readonly) CGFloat y; //y坐标
/**
 @brief 初始化
 
 @param x x坐标
 @param y y坐标
 
 @return 图标点对象
 */
- (instancetype)initWithX:(CGFloat)x andY:(CGFloat)y;

@end
#pragma mark -
#pragma mark WRChartConfig
/**
 @brief 图表配置
 */
@interface WRChartConfig : NSObject
/**
 @brief 图表样式
 */
@property (assign, nonatomic) WRChartType chartType;
/**
 @brief 图表点
 */
@property (strong, nonatomic) NSArray<WRChartPoint *> *chartPoints;
/**
 @brief 背景色
 */
@property (strong, nonatomic) UIColor *backgroundColor;
/**
 @brief 线条颜色
 */
@property (strong, nonatomic) UIColor *strokeColor;
/**
 @brief 填充颜色
 */
@property (strong, nonatomic) UIColor *fillColor;
/**
 @brief 线宽
 */
@property (assign, nonatomic) CGFloat lineWidth;
/**
 @brief 边距
 */
@property (assign, nonatomic) CGFloat paddingTop;
@property (assign, nonatomic) CGFloat paddingLeft;
@property (assign, nonatomic) CGFloat paddingBottom;
@property (assign, nonatomic) CGFloat paddingRight;
/**
 @brief 坐标轴标签数组
 */
@property (strong, nonatomic) NSArray <NSString *>*xAxisItemsArray;
@property (strong, nonatomic) NSArray <NSString *>*yAxisItemsArray;
/**
 @brief 坐标轴标签颜色
 */
@property (strong, nonatomic) UIColor *xAxisLabelColor;
@property (strong, nonatomic) UIColor *yAxisLabelColor;
/**
 @brief 坐标轴标签字体大小
 */
@property (assign, nonatomic) CGFloat xAxisLabelFontSize;
@property (assign, nonatomic) CGFloat yAxisLabelFontSize;
/**
 @brief 坐标轴标线颜色
 */
@property (strong, nonatomic) UIColor *xAxisLineColor;
@property (strong, nonatomic) UIColor *yAxisLineColor;
/**
 @brief 坐标轴标线线宽
 */
@property (assign, nonatomic) CGFloat xAxisLineWidth;
@property (assign, nonatomic) CGFloat yAxisLineWidth;
/**
 @brief 坐标轴分割线是否显示
 */
@property (assign, nonatomic) BOOL xSeparateLineShow;
@property (assign, nonatomic) BOOL ySeparateLineShow;
@end
