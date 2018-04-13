//
//  ChartView.h
//  Chart
//
//  Created by TigerNong on 2018/3/29.
//  Copyright © 2018年 TigerNong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartView : UIView
/*
 datas : 数据
 xAlxes : x轴的数组
 valueLineColor : 数据曲线的颜色
 alxeColor : 坐标轴的颜色
 gradients : 渐变颜色数组
 yScale : y轴的刻度数
 xScale : x轴数据个数
 */
- (instancetype)initWithFrame:(CGRect)frame withDatas:(NSArray *)datas withXAlxes:(NSArray *)xAlxes withValueLineColor:(UIColor *)valueLineColor withAlxeColor:(UIColor *)alxeColor withGradients:(NSArray *)gradients withYScale:(int)yScale withXScale:(int)xScale;
/*标题颜色*/
@property (nonatomic, strong) UIColor *titleColor;
/*单位*/
@property (nonatomic, copy) NSString *unitValue;
@end
