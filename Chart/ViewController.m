//
//  ViewController.m
//  Chart
//
//  Created by TigerNong on 2018/3/29.
//  Copyright © 2018年 TigerNong. All rights reserved.
//

#import "ViewController.h"
#import "ChartView.h"
#import "TNCicleChartView.h"
#import "TNLineChartView.h"

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define UIColorRGB(rgb) ([[UIColor alloc] initWithRed:(((rgb >> 16) & 0xff) / 255.0f) green:(((rgb >> 8) & 0xff) / 255.0f) blue:(((rgb) & 0xff) / 255.0f) alpha:1.0f])

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

#pragma 带有蒙版的平滑曲线图
    NSArray *datas = [NSArray arrayWithObjects:@"10.0",@"9.5",@"2.5",@"4.0",@"2.5",@"4.0",@"1.5", nil];
    NSArray *xAls = [NSArray arrayWithObjects:@"04-01",@"04-07", nil];

//    NSArray *gColors = @[(id)UIColorRGB(0x23283a),(id)UIColorRGB(0x23283a)];
    
    NSArray *gColors = @[(id)[UIColor redColor].CGColor,(id)[UIColor redColor].CGColor];

    ChartView *view = [[ChartView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 222) withDatas:datas withXAlxes:xAls withValueLineColor:UIColorRGB(0x7d92d8) withAlxeColor:RGBA(153, 153, 153, 1)  withGradients:gColors withYScale:3 withXScale:7 ];
    view.titleColor = RGBA(221, 221, 221, 1);
    view.unitValue = @"mA";
    view.backgroundColor = UIColorRGB(0x191b27);
    [self.view addSubview:view];


#pragma mark - 圆环
    TNCicleChartView *cicleView = [[TNCicleChartView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame) + 20, [UIScreen mainScreen].bounds.size.width * 0.5, 209) withFirstValue:5 withSecondValue:49 withFisrtTitle:@"离线率" withSecondTitle:@"离线:  " withThirdTitle:@"在线:  " withCicleColor:UIColorRGB(0x54b23b) withBackColor:[UIColor grayColor] withType:TNShowCicleOccupancyTypeNO];
    cicleView.backgroundColor = UIColorRGB(0x191b27);
    [self.view addSubview:cicleView];
    
    TNCicleChartView *cicleView1 = [[TNCicleChartView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 0.5, CGRectGetMaxY(view.frame) + 20, [UIScreen mainScreen].bounds.size.width * 0.5, 209) withFirstValue:49 withSecondValue:5 withFisrtTitle:@"处理率" withSecondTitle:@"隐患处理: " withThirdTitle:@"未处理: " withCicleColor:UIColorRGB(0xeb562a) withBackColor:[UIColor grayColor] withType:TNShowCicleOccupancyTypeYES];
    cicleView1.backgroundColor = UIColorRGB(0x191b27);
    [self.view addSubview:cicleView1];
    
#pragma mark - 折线和柱状图
    NSDictionary *dic = @{
                          @"电流1": @[@"26",@"16",@"18",@"22",@"16",@"14",@"9"],
                          @"电流2": @[@"6",@"15",@"23",@"21",@"17",@"12",@"13"],
                          @"电流3": @[@"13",@"14",@"13",@"26",@"26",@"14",@"10"],
                          @"电流4": @[@"17",@"13",@"11",@"6",@"26",@"24",@"19"]
                          };
    NSArray *xAlexs = @[@"04-01",@"04-02",@"04-03",@"04-04",@"04-05",@"04-06",@"04-07"];
    NSArray *titles = [dic allKeys];
    
    NSArray *colors = @[UIColorRGB(0xdddd2f),UIColorRGB(0x188ec5),UIColorRGB(0xeb562a),UIColorRGB(0x54b23b)];
    
    TNLineChartView *lineView = [[TNLineChartView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cicleView1.frame) + 20, view.frame.size.width, 237) withDic:dic withColors:colors withTitles:titles withYScaleCount:3 withAlexColor:RGBA(153, 153, 153, 1) withXAlexs:xAlexs withType:TNShowDrawTypeCloumn];
    lineView.backgroundColor = UIColorRGB(0x191b27);
    [self.view addSubview:lineView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
