//
//  TNLineChartView.m
//  Chart
//
//  Created by TigerNong on 2018/4/6.
//  Copyright © 2018年 TigerNong. All rights reserved.
//

#import "TNLineChartView.h"
#import "YAxleView.h"

@interface TNLineChartView ()
/*标题标签*/
@property (nonatomic, strong) UILabel *titleLabel;
/*y轴的单位标签*/
@property (nonatomic, strong) UILabel *yUnitLabel;
@property (nonatomic, strong) UIColor *alxeColor;
@property (nonatomic, copy) NSDictionary *dic;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *colors;
@property (nonatomic, assign) int yScaleCount;
@property (nonatomic, copy) NSArray *xAlexs;
@property (nonatomic, assign) TNShowDrawType type;
@end

@implementation TNLineChartView

- (instancetype)initWithFrame:(CGRect)frame withDic:(NSDictionary *)dic withColors:(NSArray *)colors withTitles:(NSArray *)titles withYScaleCount:(int)yScaleCount withAlexColor:(UIColor *)alexColor withXAlexs:(NSArray *)xAlexs withType:(TNShowDrawType)type{
    if (self = [super initWithFrame:frame]) {
        _alxeColor = alexColor;
        _dic = dic;
        _titles = titles;
        _colors = colors;
        _yScaleCount = yScaleCount;
        _xAlexs = xAlexs;
        _type = type;

        [self titleLabel];
        [self yUnitLabel];
        
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 22, self.frame.size.width - 2 * 17, 15)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"温度回路运行曲线";
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
        _yUnitLabel.text = @"C";
        [self addSubview:_yUnitLabel];
    }
    return _yUnitLabel;
}

- (void)setUpViewWithDatas:(NSArray *)arr withColors:(NSArray *)colors withTitles:(NSArray *)titles withEndYpoint:(CGPoint)endYPiont{
    
    for (int i = 0; i < arr.count; i ++) {
        UIColor *col = colors[i];
        CGFloat startx = endYPiont.x;
        NSString *title = titles[i];
        CGSize size = [title boundingRectWithSize:CGSizeMake(80, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        
        CGFloat viewW = size.width;
        CGFloat margin = 43;
        CGFloat x = startx + i *(viewW + margin);
        CGFloat y = endYPiont.y + 39;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, y, 8, 8)];
        view.backgroundColor = col;
        
        UILabel *tl = [[UILabel alloc] initWithFrame:CGRectMake(x + 17, y - 2, 40, 12)];
        tl.text = title;
        tl.font = [UIFont systemFontOfSize:12];
        tl.textColor = _alxeColor;
        [self addSubview:view];
        [self addSubview:tl];
    }
}


- (void)drawRect:(CGRect)rect {

    NSDictionary *dic = _dic;
    
    NSArray *xAlexs = _xAlexs;
    
    //根据数据确定y轴的最大刻度值
    int maxYAlxeValue = [self getDataMaxValueWithDic:dic];
    //显示的刻度数
    int yScaleCount = _yScaleCount;
    
    //刻度之间的间隔
    CGFloat yAlxeHeight = 104;
    //刻度view的高度
    CGFloat yScaleViewH = 12.0f;
    CGFloat yScaleViewW = 40;
    //刻度间的距离
    CGFloat yMargin = (yAlxeHeight - yScaleViewH * 0.5) / (yScaleCount - 1);
    //刻度距离左侧的间距
    CGFloat leftMargin = 10.0;
    CGFloat xRightMargin = 25.0;
    
    //数据绘制开始的y
    CGFloat startY = CGRectGetMaxY(_yUnitLabel.frame) + 11;
    //y轴坐标的“0”点y
    CGFloat endY = startY + yAlxeHeight;
    
    //绘制y轴的x坐标
    CGFloat startYAlexX = leftMargin + yScaleViewW;
    
    //获取y轴的刻度数组
    NSMutableArray *yAlxes = [NSMutableArray array];
    for (int i = 0; i < yScaleCount; i ++) {
        int yV = maxYAlxeValue - i * maxYAlxeValue / (yScaleCount - 1);
        [yAlxes addObject:@(yV)];
    }
    
    //开始的点
    CGPoint startYPoint = CGPointMake(startYAlexX, startY);
    //结束点
    CGPoint endYPoint = CGPointMake(startYAlexX, endY);
    
    //绘制y轴
    [self drawyAlxeWithYCount:yScaleCount withYValues:yAlxes withStartPoint:startYPoint withEndPoint:endYPoint withXInsetMargin:leftMargin withYInsetMargin:yMargin withScaleWidth:yScaleViewW withScaleHeight:yScaleViewH];
    
    
    //绘制x轴
    CGPoint startXPoint = CGPointMake(startYAlexX, endY);
    CGPoint endXPoint = CGPointMake(self.frame.size.width - xRightMargin, endY);
    [self drawXAlxeWithStartPoint:startXPoint withEndPoint:endXPoint withYDatas:xAlexs withRightMargin:xRightMargin];
    
    //获取四条线的数据数组
    NSArray *colors = _colors;
    
    if ((_type = TNShowDrawTypeCloumn)) {
        NSArray *datas = [self getNewDatasWithDic:dic];
        CGFloat xViewW = (self.frame.size.width - startXPoint.x - xRightMargin) / datas.count;
        
        for (int i = 0;i < datas.count;i ++) {
            NSArray *arr = datas[i];
            
            [self drawCloumnWithDatas:arr withIndex:i withXViewWidth:xViewW withStartYPoint:startYPoint withEndYPoint:endYPoint withHeight:yScaleViewH withMaxYValue:maxYAlxeValue withColors:colors];
        }
    }else{
        for (int i = 0; i < [dic allValues].count; i++) {
            NSArray *teps = [dic allValues][i];
            
            UIColor *col = colors[i];
            //获取对应的x点
            NSArray *xPoints = [self getXPointWithDatas:teps withStartXpoint:startXPoint];
            
            //获取y点
            NSArray *yPoints = [self getYPointsWithDatas:teps withMaxYScaleValue:maxYAlxeValue withStartYPoint:startYPoint withEndYPoint:endYPoint withScaleViewHeight:yScaleViewH * 0.5];
            
            //绘制曲线
            [self drawDataLayerWithXPoins:xPoints withYPoint:yPoints withDatas:teps withOffsetX:0 withY:endY withLineColor:col];
        }
    }

    //绘制底部的标识
    NSArray *titles = _titles;
    [self setUpViewWithDatas:[dic allValues] withColors:colors withTitles:titles withEndYpoint:endYPoint];
}

- (void)drawCloumnWithDatas:(NSArray *)datas withIndex:(NSInteger)index withXViewWidth:(CGFloat)width withStartYPoint:(CGPoint)startYPoint withEndYPoint:(CGPoint)endYPoint withHeight:(CGFloat)height withMaxYValue:(CGFloat)maxYAlxeValue withColors:(NSArray *)colors{
    
    CGFloat cloumnMargin = 2;
    CGFloat cloumnLeftMargin = 7;
    NSArray *yPoints = [self getYPointsWithDatas:datas withMaxYScaleValue:maxYAlxeValue withStartYPoint:startYPoint withEndYPoint:endYPoint withScaleViewHeight:height * 0.5];
    
    CGFloat cloumnWidth = (width - cloumnLeftMargin - (datas.count - 1) * cloumnMargin) / datas.count * 1.0;
    CGFloat startX = startYPoint.x + index * width;
    for (int i = 0; i < yPoints.count; i ++) {
        UIColor *clo = colors[i];

        CGFloat x = startX + (cloumnLeftMargin + i * (cloumnMargin + cloumnWidth)) + cloumnWidth * 0.5;

        CGFloat y = [yPoints[i] floatValue];

        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(x, endYPoint.y)];
        [path addLineToPoint:CGPointMake(x, y)];
        
        CAShapeLayer *valuelayer = [CAShapeLayer layer];
        valuelayer.path = path.CGPath;
        valuelayer.lineWidth = cloumnWidth;
        valuelayer.strokeColor = clo.CGColor;
        valuelayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:valuelayer];
        
        //动画
        CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
        ani.fromValue = @0;
        ani.toValue = @1;
        ani.duration = 2;
        [valuelayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
    }
}


- (NSArray *)getNewDatasWithDic:(NSDictionary *)dic{
    NSMutableArray *mulArr = [NSMutableArray array];
    
    NSArray<NSArray *> *values = [dic allValues];
    
    for (int i = 0; i < [values.firstObject count]; i ++) {
        NSMutableArray *strings = [NSMutableArray array];
        for (NSArray *array in values) {
            [strings addObject:array[i]];
        }
        [mulArr addObject:strings];
    }
    return [mulArr copy];
}


- (NSArray *)getXPointWithDatas:(NSArray *)datas withStartXpoint:(CGPoint)startXpoint{
    //点一点之间x的间距
    UILabel *l = (UILabel *)[self viewWithTag:2000];
    CGFloat xMarginF = l.frame.size.width;
    CGFloat perX = xMarginF * 0.5;
    //获取每个点的x（从0开始的点）
    NSMutableArray *xPoints = [NSMutableArray array];
    for (int i = 0; i < datas.count; i ++) {
        CGFloat xPoint = startXpoint.x + perX + i * xMarginF;
        [xPoints addObject:@(xPoint)];
    }
    
    return [xPoints copy];
}

//根据数据或者每个数据对应的y点
- (NSArray *)getYPointsWithDatas:(NSArray *)datas withMaxYScaleValue:(CGFloat)maxY withStartYPoint:(CGPoint)startYPoint withEndYPoint:(CGPoint)endYPoint withScaleViewHeight:(CGFloat)height{
    NSMutableArray *yPoints = [NSMutableArray array];
    for (int i = 0; i < datas.count; i ++) {
        NSString *valueStr = datas[i];
        CGFloat value = [valueStr floatValue];
        CGFloat l = maxY - value;
        CGFloat yPoint = 0;
        if (l == 0) {
             yPoint = startYPoint.y + height + (l * (endYPoint.y - startYPoint.y)) / maxY;
        }else{
            yPoint = startYPoint.y + (l * (endYPoint.y - startYPoint.y + height)) / maxY;
        }
       
        [yPoints addObject:@(yPoint)];
    }
    
    return [yPoints copy];
}

#pragma mark - 绘制曲线
/**
 xPoints : x轴x点的数组
 yPoints : y轴y点的数组
 datas : 数据数组
 offsetX : 第一个数据点距离左侧和最后一个数据点距离右侧的距离
 yHeight : 绘制曲线最大的y值
 */
- (void)drawDataLayerWithXPoins:(NSArray *)xPoints withYPoint:(NSArray *)yPoints withDatas:(NSArray *)datas withOffsetX:(CGFloat)offsetX withY:(CGFloat)yHeight withLineColor:(UIColor *)lineColor{
    
    UIBezierPath *valuePath = [UIBezierPath bezierPath];
    //第一个数据点
    CGFloat xStartPoint = [xPoints[0] floatValue];
    CGFloat yStartPoint = [yPoints[0] floatValue];
    CGPoint valueStartPoint = CGPointMake(xStartPoint, yStartPoint);
    
    [valuePath moveToPoint:valueStartPoint];
    
    for (int i = 1; i < datas.count; i ++) {
        CGFloat xPoint = [xPoints[i] floatValue];
        CGFloat yPoint = [yPoints[i] floatValue];
        CGPoint point = CGPointMake(xPoint, yPoint);
        [valuePath addLineToPoint:point];
    }
    
    CAShapeLayer *valuelayer = [CAShapeLayer layer];
    valuelayer.path = valuePath.CGPath;
    valuelayer.lineWidth = 3;
    valuelayer.strokeColor = lineColor.CGColor;
    valuelayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:valuelayer];
    
    //动画
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    ani.fromValue = @0;
    ani.toValue = @1;
    ani.duration = 3;
    [valuelayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
    
    //绘制每个点
    for (int i = 0; i < datas.count; i ++) {
        CGFloat xPoint = [xPoints[i] floatValue];
        CGFloat yPoint = [yPoints[i] floatValue];
        
        UIBezierPath *pointPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(xPoint - 6 * 0.5, yPoint - 6 * 0.5, 6, 6) cornerRadius:3];
        CAShapeLayer *pointlayer = [CAShapeLayer layer];
        pointlayer.path = pointPath.CGPath;
        pointlayer.fillColor = lineColor.CGColor;
        pointlayer.strokeColor = lineColor.CGColor;
        [self.layer addSublayer:pointlayer];
    }
    
}

- (void)drawXAlxeWithStartPoint:(CGPoint)startPoint withEndPoint:(CGPoint)endPoint withYDatas:(NSArray *)datas withRightMargin:(CGFloat)xRightMargin{
    //开始绘制x轴
    UIBezierPath *xPath = [UIBezierPath bezierPath];
    [xPath moveToPoint:startPoint];
    [xPath addLineToPoint:endPoint];
    
    CAShapeLayer *xlayer = [CAShapeLayer layer];
    xlayer.path = xPath.CGPath;
    xlayer.lineWidth = 1;
    xlayer.strokeColor = _alxeColor.CGColor;
    [self.layer addSublayer:xlayer];
    
    //获取x轴每个刻度的宽度
    CGFloat xViewW = (self.frame.size.width - startPoint.x - xRightMargin) / datas.count;
    
    for (int i = 0; i < datas.count; i++) {
        CGFloat x = startPoint.x + i * xViewW;
        CGFloat y = startPoint.y + 6;
        
        NSString *title = datas[i];
        CGSize size = [title boundingRectWithSize:CGSizeMake(xViewW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, xViewW, size.height)];
        dayLabel.text = title;
        dayLabel.tag = 2000+i;
        dayLabel.numberOfLines = 0;
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.font = [UIFont systemFontOfSize:12];
        dayLabel.textColor = _alxeColor;
        
        [self addSubview:dayLabel];
    }
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
        }else{ //只绘制y不是0的虚线
            //绘制虚线
            UIBezierPath *xuPath = [UIBezierPath bezierPath];
            [xuPath moveToPoint:CGPointMake(startPoint.x, (startPoint.y + yViewH * 0.5)  + i * yMargin)];
            [xuPath addLineToPoint:CGPointMake(self.frame.size.width - 25,startPoint.y + yViewH * 0.5 + i * yMargin)];
            CAShapeLayer *xulayer = [CAShapeLayer layer];
            xulayer.path = xuPath.CGPath;
            [xulayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber       numberWithInt:3], [NSNumber numberWithInt:1], nil]];
            xulayer.lineWidth = 1;
            xulayer.strokeColor = _alxeColor.CGColor;
            [self.layer addSublayer:xulayer];
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



- (int)getDataMaxValueWithDic:(NSDictionary *)dic{
    
    NSMutableArray *values = [NSMutableArray array];
    
    for (NSArray *arr in [dic allValues]) {
         [values addObjectsFromArray:arr];
    }
    int maxValue = 0;
    for (NSString *value in values) {
        int va = [value intValue];
        if (maxValue < va) {
            maxValue = va;
        }
    }
    
    return maxValue;
}



@end
