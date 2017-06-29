//
//  ViewController.m
//  WRChartDemo
//
//  Created by xianghui on 2017/6/29.
//  Copyright © 2017年 xianghui. All rights reserved.
//

#import "ViewController.h"
#import "WRChartView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WRChartConfig *config = [[WRChartConfig alloc] init];
    NSMutableArray *chartPoints = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 10; i++) {
        WRChartPoint *point =
        [[WRChartPoint alloc] initWithX:i andY:arc4random_uniform(5) + 10];
        [chartPoints addObject:point];
    }
    config.chartPoints = chartPoints;
    config.xAxisItemsArray = @[@"0", @"4", @"8", @"12", @"16", @"20", @"24"];
    config.yAxisItemsArray = @[@"12", @"9", @"6", @"3", @"0"];
    
    WRChartConfig *config1 = [[WRChartConfig alloc] init];
    NSMutableArray *chartPoints1 = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 10; i++) {
        WRChartPoint *point =
        [[WRChartPoint alloc] initWithX:i andY:arc4random_uniform(5) + 5];
        [chartPoints1 addObject:point];
    }
    config1.strokeColor = [UIColor orangeColor];
    config1.fillColor = [UIColor orangeColor];
    config1.chartPoints = chartPoints1;

    WRChartConfig *config2 = [[WRChartConfig alloc] init];
    NSMutableArray *chartPoints2 = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 10; i++) {
        WRChartPoint *point =
        [[WRChartPoint alloc] initWithX:i andY:arc4random_uniform(10)];
        [chartPoints2 addObject:point];
    }
    config2.strokeColor = [UIColor colorWithRed:0 green:0 blue:0.8 alpha:1];
    config2.fillColor = [UIColor colorWithRed:0 green:0 blue:0.8 alpha:1];
    config2.chartPoints = chartPoints2;

    WRChartView *chartView = [[WRChartView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 100)
//                                                 configurations:@[config]];
                                                 configurations:@[config, config1, config2]];
    chartView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:chartView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
