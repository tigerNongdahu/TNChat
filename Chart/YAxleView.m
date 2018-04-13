//
//  YAxleView.m
//  Chart
//
//  Created by TigerNong on 2018/3/29.
//  Copyright © 2018年 TigerNong. All rights reserved.
//  显示y轴的

#import "YAxleView.h"

@interface YAxleView()

@end

@implementation YAxleView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor redColor];
        [self addSubview:_line];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_titleLabel];
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.textColor = [UIColor redColor];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _line.frame = CGRectMake(self.frame.size.width - 6, (self.frame.size.height - 1) * 0.5, 6, 1);
    
    _titleLabel.frame = CGRectMake(0, 0, self.frame.size.width - 12, self.frame.size.height);
}

- (void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    CGRect frame = _line.frame;
    frame.size.width = _lineWidth;
    frame.origin.x = self.frame.size.width - _lineWidth;
    _line.frame = frame;
    
    [self layoutIfNeeded];
}

- (void)setLineBorder:(CGFloat)lineBorder{
    _lineBorder = lineBorder;
    
    CGRect frame = _line.frame;
    frame.size.height = _lineBorder;
    frame.origin.y = self.frame.size.width - _lineBorder;
    _line.frame = frame;
    
    [self layoutIfNeeded];
}

@end
