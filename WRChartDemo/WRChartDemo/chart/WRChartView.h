//
//  WRChartView.h
//  WRChartDemo
//
//  Created by xianghui on 2017/6/29.
//  Copyright © 2017年 xianghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRChartConfig.h"

/**
 @brief 图表视图
 */
@interface WRChartView : UIView
/**
 @brief 初始化
 
 @param frame frame
 @param chartConfigsArray 图表配置数组
 
 @return 图表视图
 */
- (instancetype)initWithFrame:(CGRect)frame
               configurations:(NSArray <WRChartConfig *> *)chartConfigsArray;

@end
