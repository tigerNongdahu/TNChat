//
//  YAxleView.h
//  Chart
//
//  Created by TigerNong on 2018/3/29.
//  Copyright © 2018年 TigerNong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YAxleView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *line;
/*宽度*/
@property (nonatomic, assign) CGFloat lineWidth;
/*大小度*/
@property (nonatomic, assign) CGFloat lineBorder;
@end
