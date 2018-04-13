//
//  TNLineChartView.h
//  Chart
//
//  Created by TigerNong on 2018/4/6.
//  Copyright © 2018年 TigerNong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TNShowDrawType) {
    TNShowDrawTypeCloumn = 1,//柱状图
    TNShowDrawTypeLine //折线图
};

@interface TNLineChartView : UIView
/*标题颜色*/
@property (nonatomic, strong) UIColor *titleColor;
/*单位*/
@property (nonatomic, copy) NSString *unitValue;

- (instancetype)initWithFrame:(CGRect)frame withDic:(NSDictionary *)dic withColors:(NSArray *)colors withTitles:(NSArray *)titles withYScaleCount:(int)yScaleCount withAlexColor:(UIColor *)alexColor withXAlexs:(NSArray *)xAlexs withType:(TNShowDrawType)type;
@end
