//
//  ChartView.m
//  Chart
//
//  Created by TigerNong on 2018/3/29.
//  Copyright © 2018年 TigerNong. All rights reserved.
//

#import "ChartView.h"
#import "YAxleView.h"
#define annimationTime 3

@interface ChartView()
/*标题标签*/
@property (nonatomic, strong) UILabel *titleLabel;
/*y轴的单位标签*/
@property (nonatomic, strong) UILabel *yUnitLabel;
/*数据数组*/
@property (nonatomic, strong) NSArray *datas;

/*x轴数据数组*/
@property (nonatomic, strong) NSArray *xAlxes;

/*数据线的颜色*/
@property (nonatomic, strong) UIColor *valueLineColor;
/*轴线的颜色*/
@property (nonatomic, strong) UIColor *alxeColor;

/*蒙版的渐变颜色*/
@property (nonatomic, strong) NSArray *gradients;
/*y轴绘制几个刻度*/
@property (nonatomic, assign) int yScale;

/*x轴绘制几个刻度*/
@property (nonatomic, assign) int xScale;
@end

@implementation ChartView

- (instancetype)initWithFrame:(CGRect)frame withDatas:(NSArray *)datas withXAlxes:(NSArray *)xAlxes withValueLineColor:(UIColor *)valueLineColor withAlxeColor:(UIColor *)alxeColor withGradients:(NSArray *)gradients withYScale:(int)yScale withXScale:(int)xScale{
    if (self = [super initWithFrame:frame]) {
        _valueLineColor = valueLineColor;
        _alxeColor = alxeColor;
        _gradients = gradients;
        _datas = datas;
        _xAlxes = xAlxes;
        _yScale = yScale;
        _xScale = xScale;

        [self titleLabel];
        [self yUnitLabel];
    }
    return self;
}

- (NSArray *)xAlxes{
    if (!_xAlxes) {
        _xAlxes = [NSArray array];
    }
    return _xAlxes;
}

- (NSArray *)datas{
    if (!_datas) {
        _datas = [NSArray array];
    }
    return _datas;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 22, self.frame.size.width - 2 * 17, 15)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"漏电回路运行曲线";
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)yUnitLabel{
    if (!_yUnitLabel) {
        _yUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, CGRectGetMaxY(_titleLabel.frame) + 10, 80, 12)];
        _yUnitLabel.font = [UIFont systemFontOfSize:12];
        _yUnitLabel.textColor = [UIColor whiteColor];
        _yUnitLabel.textAlignment = NSTextAlignmentLeft;
        _yUnitLabel.text = @"mA";
        [self addSubview:_yUnitLabel];
    }
    return _yUnitLabel;
}

- (void)drawRect:(CGRect)rect {
    [self dramXYAxle];
}

#pragma mark - 传人的数据
- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    _titleLabel.textColor = titleColor;
}

- (void)setUnitValue:(NSString *)unitValue{
    _unitValue = [unitValue copy];
    _yUnitLabel.text = _unitValue;
}

#pragma mark - 绘制
/*x、y轴*/
- (void)dramXYAxle{
    
    //根据传进来的数据，转换成坐标
    NSArray *datas = _datas;
    
    //x轴刻度显示数据数组
    NSArray *xAlxes = _xAlxes;
    
    //获取y的最大刻度值
    int maxAlxeValue = [self getMaxYValueWithDatas:datas];

    //显示的刻度个数
    int yCount = _yScale;
    //y轴的间隔数则刻度数减去1
    int yMarginCount = yCount - 1;

    //刻度之间的间隔
    CGFloat yAlxeHeight = 104;
    //刻度view的高度
    CGFloat yViewH = 12.0f;
    CGFloat yViewW = 40;
    CGFloat yMargin = (yAlxeHeight - yViewH * 0.5) / yMarginCount;
    CGFloat insetMargin = 10.0;
    CGFloat xRightMargin = 25.0;
    
    //y轴的数据
    NSMutableArray *yAlxeValues = [NSMutableArray array];
    for (int i = 0; i < yCount; i ++) {
        int yV = maxAlxeValue - i * maxAlxeValue / yMarginCount;
        [yAlxeValues addObject:@(yV)];
    }
    
    
    CGFloat startX = yViewW + insetMargin;
    CGFloat startY = CGRectGetMaxY(_yUnitLabel.frame) + 11;
    
    
    //点一点之间x的间距
    CGFloat xAxlePerWidth = (self.frame.size.width - (yViewW + insetMargin) - xRightMargin) / _xScale;
    CGFloat perX = xAxlePerWidth * 0.5;
    //获取每个点的x（从0开始的点）
    NSMutableArray *xPoints = [NSMutableArray array];
    for (int i = 0; i < datas.count; i ++) {
        CGFloat xPoint = startX + perX + i * xAxlePerWidth;
        [xPoints addObject:@(xPoint)];
    }
    
    //计算每个点的y
    NSMutableArray *yPoints = [NSMutableArray array];
    for (int i = 0; i < datas.count; i ++) {
        NSString *valueStr = datas[i];
        CGFloat value = [valueStr floatValue];
        CGFloat l = maxAlxeValue - value;
        CGFloat yPoint = startY;
        if (l == 0) {
            yPoint = startY + yViewH * 0.5 + (l * yAlxeHeight) / (maxAlxeValue);
        }else{
            yPoint = startY + (l * (yAlxeHeight + yViewH * 0.5)) / (maxAlxeValue);
        }
        
        [yPoints addObject:@(yPoint)];
    }
    

    //绘制x轴
    CGPoint xAlxeStartPoint = CGPointMake(startX, yAlxeHeight + startY);
    CGPoint xAlxeEndPoint = CGPointMake(self.frame.size.width - xRightMargin, yAlxeHeight + startY);
    
    CGFloat xViewW = 40;
    CGFloat xViewH = 20;
    CGRect labelFrame = CGRectMake(yViewW + insetMargin + 1, yAlxeHeight + startY + 6, xViewW, xViewH);
    
    [self drawXAlxeWithStartPoint:xAlxeStartPoint withEndPoint:xAlxeEndPoint withYDatas:xAlxes withRightMargin:xRightMargin withXLabelFrame:labelFrame];
    
    
    //绘制y轴
    [self drawyAlxeWithYCount:yCount withYValues:yAlxeValues withStartPoint:CGPointMake(startX, startY) withEndPoint:CGPointMake(yViewW + insetMargin, yAlxeHeight + startY) withXInsetMargin:insetMargin withYInsetMargin:yMargin withScaleWidth:yViewW withScaleHeight:yViewH];

    
    //绘制数据折线图
    [self drawDataLayerWithXPoins:xPoints withYPoint:yPoints withDatas:datas withOffsetX:perX withY:yAlxeHeight + startY];

}
#pragma mark - 根据数据获取最大的y刻度值
- (int)getMaxYValueWithDatas:(NSArray *)datas{
    //获取传入数据的最大值
    CGFloat maxAlxeValue = 0;
    for (int i = 0; i < datas.count; i ++) {
        NSString *valueStr = datas[i];
        CGFloat value = [valueStr floatValue];
        if (maxAlxeValue < value) {
            maxAlxeValue = value;
        }
    }
    
    //获取所需y轴的最大刻度值
    for (int i = 0; i < 50; i ++) {
        int value = i / maxAlxeValue;
        if (value == 1) {
            maxAlxeValue = i;
            break;
        }
    }
    
    return (int)maxAlxeValue;
}

#pragma mark - 绘制x轴
- (void)drawXAlxeWithStartPoint:(CGPoint)startPoint withEndPoint:(CGPoint)endPoint withYDatas:(NSArray *)datas withRightMargin:(CGFloat)xRightMargin withXLabelFrame:(CGRect)frame{
    //开始绘制x轴
    UIBezierPath *xPath = [UIBezierPath bezierPath];
    [xPath moveToPoint:startPoint];
    [xPath addLineToPoint:endPoint];
    
    CAShapeLayer *xlayer = [CAShapeLayer layer];
    xlayer.path = xPath.CGPath;
    xlayer.lineWidth = 1;
    xlayer.strokeColor = _alxeColor.CGColor;
    [self.layer addSublayer:xlayer];
    
    UILabel *dayLabel1 = [[UILabel alloc] initWithFrame:frame];
    dayLabel1.text = datas[0];
    dayLabel1.textAlignment = NSTextAlignmentLeft;
    dayLabel1.font = [UIFont systemFontOfSize:12];
    dayLabel1.textColor = _alxeColor;
    [self addSubview:dayLabel1];
    
    UILabel *dayLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - xRightMargin - dayLabel1.frame.size.width, dayLabel1.frame.origin.y, dayLabel1.frame.size.width, dayLabel1.frame.size.height)];
    dayLabel2.text = datas[1];
    dayLabel2.textAlignment = NSTextAlignmentRight;
    dayLabel2.font = [UIFont systemFontOfSize:12];
    dayLabel2.textColor = _alxeColor;
    [self addSubview:dayLabel2];
}

#pragma mark - 绘制y轴和刻度
/**
 yCount : y轴上的可读书
 yAlxeValues : y轴显示的数据数组
 startPoint : 绘制开始的点
 endPoint : 绘制最后的点
 insetMargin : 刻度左侧的距离
 yMargin : 刻度之间的距离
 yViewW : 刻度标签的宽度
 yViewH : 刻度标签的高度
 */
- (void)drawyAlxeWithYCount:(NSInteger)yCount withYValues:(NSArray *)yAlxeValues withStartPoint:(CGPoint)startPoint withEndPoint:(CGPoint)endPoint withXInsetMargin:(CGFloat)insetMargin withYInsetMargin:(CGFloat)yMargin withScaleWidth:(CGFloat)yViewW withScaleHeight:(CGFloat)yViewH{
    //绘制左侧刻度
    for (NSInteger i = 0; i < yCount; i ++) {
        YAxleView *yView = [[YAxleView alloc] init];
        yView.line.backgroundColor = _alxeColor;
        yView.titleLabel.textColor = _alxeColor;
        yView.backgroundColor = [UIColor clearColor];
        [self addSubview:yView];
         yView.frame = CGRectMake(insetMargin, i * yMargin + startPoint.y, yViewW, yViewH);
        if (i == yCount - 1) {
            yView.line.backgroundColor = [UIColor clearColor];
        }
        yView.titleLabel.text = [NSString stringWithFormat:@"%@",yAlxeValues[i]];
    }
    
    //绘制y轴的直线
    UIBezierPath *yPath = [UIBezierPath bezierPath];
    [yPath moveToPoint:startPoint];
    [yPath addLineToPoint:endPoint];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = yPath.CGPath;
    layer.lineWidth = 1;
    layer.strokeColor = _alxeColor.CGColor;
    [self.layer addSublayer:layer];
}

#pragma mark - 绘制曲线
/**
 xPoints : x轴x点的数组
 yPoints : y轴y点的数组
 datas : 数据数组
 offsetX : 第一个数据点距离左侧和最后一个数据点距离右侧的距离
 yHeight : 绘制曲线最大的y值
 */
- (void)drawDataLayerWithXPoins:(NSArray *)xPoints withYPoint:(NSArray *)yPoints withDatas:(NSArray *)datas withOffsetX:(CGFloat)offsetX withY:(CGFloat)yHeight{
    //绘制数据平滑曲线的路径
    UIBezierPath *valuePath = [UIBezierPath bezierPath];
    
    //绘制蒙版的路径
    UIBezierPath *coverPath = [UIBezierPath bezierPath];
    //第一个数据点
    CGFloat xStartPoint = [xPoints[0] floatValue];
    CGFloat yStartPoint = [yPoints[0] floatValue];
    CGPoint valueStartPoint = CGPointMake(xStartPoint + 0.3, yStartPoint);
    
    //第一个绘制点
    CGPoint fisrtDrawPoint = CGPointMake(valueStartPoint.x - offsetX , yStartPoint);
    [valuePath moveToPoint:fisrtDrawPoint];
    
    [coverPath moveToPoint:CGPointMake(fisrtDrawPoint.x, fisrtDrawPoint.y)];
    
    //存放最近的一个点，用于实现控制点
    CGPoint lastPoint = valueStartPoint;
    CGPoint lastCoverdataPoint = valueStartPoint;
    
    [valuePath addLineToPoint:valueStartPoint];
    
    [coverPath moveToPoint:CGPointMake(valueStartPoint.x, valueStartPoint.y)];
    
    for (int i = 1; i < datas.count; i ++) {
        CGFloat xPoint = [xPoints[i] floatValue];
        CGFloat yPoint = [yPoints[i] floatValue];
        CGPoint point = CGPointMake(xPoint, yPoint);
        [valuePath addCurveToPoint:point controlPoint1:CGPointMake((point.x+lastPoint.x)/2, lastPoint.y) controlPoint2:CGPointMake((point.x+lastPoint.x)/2, point.y)];
        
        CGPoint cPoint = CGPointMake(xPoint, yPoint);
        
        [coverPath addCurveToPoint:cPoint controlPoint1:CGPointMake((cPoint.x+lastCoverdataPoint.x)/2, lastCoverdataPoint.y) controlPoint2:CGPointMake((cPoint.x+lastCoverdataPoint.x)/2, cPoint.y)];
        
        lastPoint = point;
        lastCoverdataPoint = cPoint;
    }
    
    CGPoint lastDrawPoint = CGPointMake(lastPoint.x + offsetX, lastPoint.y);
    [valuePath addLineToPoint:lastDrawPoint];
    
    //绘制蒙版
    CGPoint lastCoverDrawPoint = CGPointMake(lastCoverdataPoint.x + offsetX, lastCoverdataPoint.y);
    [coverPath addLineToPoint:lastCoverDrawPoint];
    
    CGPoint lastSecondCoverDrawPoint = CGPointMake(lastCoverdataPoint.x + offsetX, yHeight);
    [coverPath addLineToPoint:lastSecondCoverDrawPoint];
    
    CGPoint lastThirdCoverDrawPoint = CGPointMake(fisrtDrawPoint.x, yHeight);
    [coverPath addLineToPoint:lastThirdCoverDrawPoint];
    
    CGPoint lastLastCoverDrawPoint = fisrtDrawPoint;
    [coverPath addLineToPoint:lastLastCoverDrawPoint];
    
    
    CAShapeLayer *coverlayer = [CAShapeLayer layer];
    coverlayer.path = coverPath.CGPath;
    coverlayer.fillColor = (__bridge CGColorRef _Nullable)(_gradients[0]);
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 0, self.frame.size.height);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.colors = _gradients;
    gradientLayer.locations = @[@(0.5f)];
    
    
    CALayer *baseLayer = [CALayer layer];
    baseLayer.frame = CGRectMake(0, 0, 100, self.frame.size.height);
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:coverlayer];
    [self.layer addSublayer:baseLayer];
    
    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = 3;
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 2 * self.frame.size.width, self.frame.size.height)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];
    
    
    CAShapeLayer *valuelayer = [CAShapeLayer layer];
    valuelayer.path = valuePath.CGPath;
    valuelayer.lineWidth = 3;
    valuelayer.strokeColor = _valueLineColor.CGColor;
    valuelayer.fillColor = [UIColor clearColor].CGColor;
    
    
    //动画
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    ani.fromValue = @0;
    ani.toValue = @1;
    ani.duration = 2.8;
    [valuelayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
    [self.layer addSublayer:valuelayer];
    
}

#pragma mark - 绘制蒙版
/**
 * 绘制颜色一致的蒙版
 xPoints : x轴x点的数组
 yPoints : y轴y点的数组
 datas : 数据数组
 offsetX : 第一个数据点距离左侧和最后一个数据点距离右侧的距离
 yHeight : 绘制曲线最大的y值
 */
- (void)drawCoverLayerWithXPoins:(NSArray *)xPoints withYPoint:(NSArray *)yPoints withDatas:(NSArray *)datas withOffsetX:(CGFloat)offsetX withY:(CGFloat)yHeight{
    UIBezierPath *coverPath = [UIBezierPath bezierPath];
    //第一个数据点
    CGFloat coverXStartPoint = [xPoints[0] floatValue];
    CGFloat coverYStartPoint = [yPoints[0] floatValue];
    CGPoint coverStartPoint = CGPointMake(coverXStartPoint + 0.5, coverYStartPoint);
    //第一个绘制蒙版的点
    CGPoint fisrtCoverPoint = CGPointMake(coverStartPoint.x - offsetX, coverYStartPoint);
    [coverPath moveToPoint:fisrtCoverPoint];
    [coverPath addLineToPoint:coverStartPoint];

    CGPoint coverLastPoint = coverStartPoint;
    for (int i = 1; i < datas.count; i ++) {
        CGFloat xPoint = [xPoints[i] floatValue];
        CGFloat yPoint = [yPoints[i] floatValue];
        CGPoint point = CGPointMake(xPoint, yPoint);
        [coverPath addCurveToPoint:point controlPoint1:CGPointMake((point.x+coverLastPoint.x)/2, coverLastPoint.y) controlPoint2:CGPointMake((point.x+coverLastPoint.x)/2, point.y)];
        coverLastPoint = point;
    }

    //蒙版的倒数第三个点
    CGPoint lastThreeCoverPoint = CGPointMake(coverLastPoint.x + offsetX, coverLastPoint.y);
    [coverPath addLineToPoint:lastThreeCoverPoint];

    //蒙版的倒数第二个点
    CGPoint lastSecondCoverPoint = CGPointMake(coverLastPoint.x + offsetX, yHeight - 1);
    [coverPath addLineToPoint:lastSecondCoverPoint];

    //蒙版的倒是第一个点
    CGPoint lastCoverPoint = CGPointMake(fisrtCoverPoint.x, yHeight - 1);
    [coverPath addLineToPoint:lastCoverPoint];
    [coverPath addLineToPoint:fisrtCoverPoint];

    CAShapeLayer *coverlayer = [CAShapeLayer layer];
    coverlayer.path = coverPath.CGPath;
    coverlayer.frame = CGRectMake(0, 0, 0, yHeight);
    coverlayer.fillColor = (__bridge CGColorRef _Nullable)(_gradients[0]);

    [self.layer addSublayer:coverlayer];

}

/**
 * 绘制渐变颜色的蒙版
 xPoints : x轴x点的数组
 yPoints : y轴y点的数组
 datas : 数据数组
 offsetX : 第一个数据点距离左侧和最后一个数据点距离右侧的距离
 yHeight : 绘制曲线最大的y值
 */

- (void)drawGradientCoverLayerWithXPoins:(NSArray *)xPoints withYPoint:(NSArray *)yPoints withDatas:(NSArray *)datas withOffsetX:(CGFloat)offsetX withY:(CGFloat)yHeight{
    UIBezierPath *coverPath = [UIBezierPath bezierPath];
    //第一个数据点
    CGFloat coverXStartPoint = [xPoints[0] floatValue];
    CGFloat coverYStartPoint = [yPoints[0] floatValue];
    CGPoint coverStartPoint = CGPointMake(coverXStartPoint + 0.5, coverYStartPoint);
    //第一个绘制蒙版的点
    CGPoint fisrtCoverPoint = CGPointMake(coverStartPoint.x - offsetX, coverYStartPoint);
    [coverPath moveToPoint:fisrtCoverPoint];
    [coverPath addLineToPoint:coverStartPoint];
    
    CGPoint coverLastPoint = coverStartPoint;
    for (int i = 1; i < datas.count; i ++) {
        CGFloat xPoint = [xPoints[i] floatValue];
        CGFloat yPoint = [yPoints[i] floatValue];
        CGPoint point = CGPointMake(xPoint, yPoint);
        [coverPath addCurveToPoint:point controlPoint1:CGPointMake((point.x+coverLastPoint.x)/2, coverLastPoint.y) controlPoint2:CGPointMake((point.x+coverLastPoint.x)/2, point.y)];
        coverLastPoint = point;
    }
    
    //蒙版的倒数第三个点
    CGPoint lastThreeCoverPoint = CGPointMake(coverLastPoint.x + offsetX, coverLastPoint.y);
    [coverPath addLineToPoint:lastThreeCoverPoint];
    
    //蒙版的倒数第二个点
    CGPoint lastSecondCoverPoint = CGPointMake(coverLastPoint.x + offsetX, yHeight - 0.3);
    [coverPath addLineToPoint:lastSecondCoverPoint];
    
    //蒙版的倒是第一个点
    CGPoint lastCoverPoint = CGPointMake(fisrtCoverPoint.x, yHeight - 0.3);
    [coverPath addLineToPoint:lastCoverPoint];
    //回到起始点
    [coverPath addLineToPoint:fisrtCoverPoint];
    
    CAShapeLayer *coverlayer = [CAShapeLayer layer];
    coverlayer.path = coverPath.CGPath;
    coverlayer.fillColor = (__bridge CGColorRef _Nullable)(_gradients[0]);
    
   
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 0, self.frame.size.height);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.colors = _gradients;
    gradientLayer.locations = @[@(0.5f)];

    
    CALayer *baseLayer = [CALayer layer];
    baseLayer.frame = CGRectMake(0, 0, 100, self.frame.size.height);
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:coverlayer];
    [self.layer addSublayer:baseLayer];
    
    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = 4;
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 2 * self.frame.size.width, self.frame.size.height)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];
}





@end
