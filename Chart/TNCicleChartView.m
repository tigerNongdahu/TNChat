//
//  TNCicleChartView.m
//  Chart
//
//  Created by TigerNong on 2018/4/5.
//  Copyright © 2018年 TigerNong. All rights reserved.
//

#import "TNCicleChartView.h"
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define UIColorRGB(rgb) ([[UIColor alloc] initWithRed:(((rgb >> 16) & 0xff) / 255.0f) green:(((rgb >> 8) & 0xff) / 255.0f) blue:(((rgb) & 0xff) / 255.0f) alpha:1.0f])

@interface TNCicleChartView()
@property (nonatomic, strong) UILabel *outLineLabel;
@property (nonatomic, strong) UILabel *inlineLabel;
@property (nonatomic, strong) UILabel *perLabel;
@property (nonatomic, strong) UILabel *perNameLabel;

@property (nonatomic, assign) int firstValue;
@property (nonatomic, assign) int sencodValue;
@property (nonatomic, copy) NSString *firstTitle;
@property (nonatomic, copy) NSString *sencodTitle;
@property (nonatomic, copy) NSString *thirdTitle;
@property (nonatomic, strong) UIColor *cicleColor;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, assign) int type;
@end

@implementation TNCicleChartView

- (instancetype)initWithFrame:(CGRect)frame withFirstValue:(int)firstValue withSecondValue:(int)secondValue withFisrtTitle:(NSString *)firstTitle withSecondTitle:(NSString *)sencodTitle withThirdTitle:(NSString *)thirdTitle withCicleColor:(UIColor *)cicleColor withBackColor:(UIColor *)backColor withType:(TNShowCicleOccupancyType)type{
    if (self = [super initWithFrame:frame]) {
        _firstValue = firstValue;
        _sencodValue = secondValue;
        _firstTitle = firstTitle;
        _sencodTitle = sencodTitle;
        _thirdTitle = thirdTitle;
        _cicleColor = cicleColor;
        _backColor = backColor;
        _type = type;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    CGFloat topMargin = 29;
    CGFloat width = 89;
    CGFloat height = width;
    
    int outlineCount = _firstValue;
    int inlineCount = _sencodValue;
    
    
    // 所占百分比
    CGFloat per = outlineCount * 1.0 / (outlineCount + inlineCount);
    
    CGFloat value = per * 100;

    //绘制背景圆框
    [self setUpBackCicleWithWidth:width withHeight:height withTopMargin:topMargin];
    
    //绘制百分比
    [self setUpCoverCicleWithWidth:width withHeight:height withTopMargin:topMargin withPer:per];
    
  //赋值
    NSString *firstValue = [NSString stringWithFormat:@"%0.1f%%",value];
    [self setPerLabelWithFirstValue:firstValue withSecondValue:_firstTitle withHeight:height withYopMargin:topMargin];
    
    //绘制
    [self setUpLabelWithFirstValue:outlineCount withSecondValue:inlineCount withWidth:width withTop:topMargin withFirstStr:_sencodTitle withSecondStr:_thirdTitle];
}

- (void)setUpCoverCicleWithWidth:(CGFloat)width withHeight:(CGFloat)height withTopMargin:(CGFloat)topMargin withPer:(CGFloat)per{
    
    //百分比转换成角度
    CGFloat endAngle = per * M_PI * 2;;
    if (_type == TNShowCicleOccupancyTypeNO) {
        endAngle = M_PI * 2 - per * M_PI * 2;
    }
    
    CGFloat startAngle =  0;
    UIBezierPath *valuePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0, topMargin + height * 0.5) radius:width * 0.5 startAngle:startAngle endAngle: endAngle  clockwise:YES];
    
    CAShapeLayer *valueLayer = [CAShapeLayer layer];
    //清空填充色
    valueLayer.fillColor = [UIColor clearColor].CGColor;
    //设置画笔颜色 即圆环背景色
    valueLayer.strokeColor =  _cicleColor.CGColor;
    valueLayer.lineWidth = 7;
    valueLayer.lineCap = @"round";
    valueLayer.path = valuePath.CGPath;
    [self.layer addSublayer:valueLayer];
    
    //动画
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    ani.fromValue = @0;
    ani.toValue = @1;
    ani.duration = 3;
    [valueLayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
}

- (void)setUpBackCicleWithWidth:(CGFloat)width withHeight:(CGFloat)height withTopMargin:(CGFloat)topMargin{
    //创建背景圆环
    CAShapeLayer *trackLayer = [CAShapeLayer layer];
    //清空填充色
    trackLayer.fillColor = [UIColor clearColor].CGColor;
    //设置画笔颜色 即圆环背景色
    trackLayer.strokeColor =  _backColor.CGColor;
    trackLayer.lineWidth = 7;
    //设置画笔路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0, topMargin + height * 0.5) radius:width * 0.5 startAngle:- M_PI_2 endAngle:-M_PI_2 + M_PI * 2 clockwise:YES];
    //path 决定layer将被渲染成何种形状
    trackLayer.path = path.CGPath;
    [self.layer addSublayer:trackLayer];
}

- (void)setPerLabelWithFirstValue:(NSString *)firstValue withSecondValue:(NSString *)sencodValue withHeight:(CGFloat)height withYopMargin:(CGFloat)topMargin{
    
    CGFloat labelH = 15;
    if (!_perLabel) {
        _perLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 60) * 0.5, topMargin + (height - 2 * labelH - 10) * 0.5, 60, labelH)];
        [self addSubview:_perLabel];
        _perLabel.text = firstValue;
        _perLabel.textAlignment = NSTextAlignmentCenter;
        _perLabel.font = [UIFont systemFontOfSize:14];
        _perLabel.textColor = RGBA(221, 221, 221, 1);
    }
    
    if (!_perNameLabel) {
        _perNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 60) * 0.5, CGRectGetMaxY(_perLabel.frame) + 10, 60, labelH)];
        [self addSubview:_perNameLabel];
        _perNameLabel.text = sencodValue;
        _perNameLabel.textAlignment = NSTextAlignmentCenter;
        _perNameLabel.font = [UIFont systemFontOfSize:14];
        _perNameLabel.textColor = RGBA(221, 221, 221, 1);
    }
}

- (void)setUpLabelWithFirstValue:(int)outlineCount withSecondValue:(int)inlineCount withWidth:(CGFloat)width withTop:(CGFloat)topMargin withFirstStr:(NSString *)firstStr withSecondStr:(NSString *)secondStr{
    NSString *outlineTitleStr = firstStr;
    NSString *outlineValue = [NSString stringWithFormat:@"%d次",outlineCount];
    NSString *outlineResultStr = [NSString stringWithFormat:@"%@%@",outlineTitleStr,outlineValue];
    
    CGFloat x = (self.frame.size.width - width) * 0.5 + 10;
    CGFloat w = self.frame.size.width - x;
    
    if (!_outLineLabel) {
        _outLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, topMargin + width + 20, w, 15)];
        [self addSubview:_outLineLabel];
        _outLineLabel.textColor = RGBA(221, 221, 221, 1);
        _outLineLabel.font = [UIFont systemFontOfSize:12];
        _outLineLabel.textAlignment = NSTextAlignmentLeft;
        NSMutableAttributedString *outlineAttStr = [[NSMutableAttributedString alloc] initWithString:outlineResultStr];
        [outlineAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(outlineTitleStr.length, outlineValue.length)];
        _outLineLabel.attributedText = outlineAttStr;
    }
    
    
    NSString *inlineTitleStr = secondStr;
    NSString *inlineValue = [NSString stringWithFormat:@"%d次",inlineCount];
    NSString *inlineResultStr = [NSString stringWithFormat:@"%@%@",inlineTitleStr,inlineValue];
    
    if (!_inlineLabel) {
        _inlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(_outLineLabel.frame) + 7, w, 15)];
        [self addSubview:_inlineLabel];
        _inlineLabel.textColor = RGBA(221, 221, 221, 1);
        _inlineLabel.font = [UIFont systemFontOfSize:12];
        _inlineLabel.textAlignment = NSTextAlignmentLeft;
        NSMutableAttributedString *inlineAttStr = [[NSMutableAttributedString alloc] initWithString:inlineResultStr];
        [inlineAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(inlineTitleStr.length, inlineValue.length)];
        _inlineLabel.attributedText = inlineAttStr;
    }
}

@end
