//
//  TranslationMicrophoneAnimationView.m
//  TranslationApp
//
//  Created by llk on 2018/6/25.
//  Copyright © 2018年 Beauty. All rights reserved.
//

#import "TranslationMicrophoneAnimationView.h"
@interface TranslationMicrophoneAnimationView()

@property (nonatomic, strong) CADisplayLink *timer;

@end
@implementation TranslationMicrophoneAnimationView

{
    CGFloat _waterLineY;//线的起始位置
    CGFloat _waveCycle; //波浪线的弧度
    CGFloat _offsetX;    //正弦函数中变量   切换速度
}

- (instancetype)init {
    
    if (self = [super init]) {
        [self initData];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)initData {
    self.waveSpeed = 0.2;
    _offsetX = self.waveSpeed;
    _waveCycle = 100;
    self.waveHeight = 5;
    _waterLineY=25;
}

- (void)startWaveAnimation{
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(wave)];
    [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopWaveAnimation{
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)wave {
    _offsetX += self.waveSpeed;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    UIColor * one = kHexRGB(0x5CACEE);
    UIColor * two = kHexRGB(0x63B8FF);
    UIColor * three = kHexRGB(0x6495ED);
    
    [self drawLineWithIndex:1 andColor:one];
    [self drawLineWithIndex:2 andColor:two];
    [self drawLineWithIndex:3 andColor:three];
}

- (void)drawLineWithIndex:(NSInteger)index andColor:(UIColor *)color{
    float frontY;
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetLineWidth(currentContext, 1);
    CGContextSetStrokeColorWithColor(currentContext, color.CGColor);
    CGPathMoveToPoint(path, NULL, 0, _waterLineY);
    for (float x = 0.f; x <= SCREEN_WIDTH ; x++) {
        //前波浪绘制
        if (index == 1) {
            frontY =  self.waveHeight*sin( x/_waveCycle * M_PI  - _offsetX * M_PI/10) + _waterLineY;
            
        } else if (index == 2) {
            frontY = self.waveHeight*sin( x/_waveCycle * M_PI  + _offsetX * M_PI/10) + _waterLineY;
            CGPathAddLineToPoint(path, nil, x, frontY);
        } else {
            frontY = self.waveHeight*cos(x/_waveCycle * M_PI  - _offsetX * M_PI/10) + _waterLineY;
            CGPathAddLineToPoint(path, nil, x, frontY);
        }
        CGPathAddLineToPoint(path, nil, x, frontY);
    }
    CGContextAddPath(currentContext, path);
    CGContextDrawPath(currentContext, kCGPathStroke);
    CGPathRelease(path);
}

- (void)draw1 {
    float frontY;
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, 0, 100);
    for (float x = 0.f; x <= SCREEN_WIDTH; x++) {
        //前波浪绘制
        frontY =  5*sin( x/100 * M_PI  - _offsetX * M_PI/3) + 100;
        CGContextAddLineToPoint(currentContext, x, frontY);
    }
    [[UIColor blackColor] setStroke];
    CGContextStrokePath(currentContext);
}

@end
