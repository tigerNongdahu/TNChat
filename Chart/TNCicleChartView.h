//
//  TNCicleChartView.h
//  Chart
//
//  Created by TigerNong on 2018/4/5.
//  Copyright © 2018年 TigerNong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TNShowCicleOccupancyType) {
    TNShowCicleOccupancyTypeYES = 0,//花颜色显示要表达的数据
    TNShowCicleOccupancyTypeNO //花颜色显示不需要表达的数据
};


@interface TNCicleChartView : UIView

- (instancetype)initWithFrame:(CGRect)frame withFirstValue:(int)firstValue withSecondValue:(int)secondValue withFisrtTitle:(NSString *)firstTitle withSecondTitle:(NSString *)sencodTitle withThirdTitle:(NSString *)thirdTitle withCicleColor:(UIColor *)cicleColor withBackColor:(UIColor *)backColor withType:(TNShowCicleOccupancyType)type;
@end
