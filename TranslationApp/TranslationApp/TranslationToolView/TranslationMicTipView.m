//
//  TranslationMicTipView.m
//  TranslationApp
//
//  Created by llk on 2018/6/25.
//  Copyright © 2018年 Beauty. All rights reserved.
//

#import "TranslationMicTipView.h"
#import "UIView+LLFrame.h"
#define DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)

@implementation TranslationMicTipView

-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        
        UIBezierPath *path = [[UIBezierPath alloc] init];
        CGFloat arrowWidth = 8.0;
        CGFloat arrowHeight = 4.0;
        CGRect baloonFrame = CGRectMake(0, 0, frame.size.width, frame.size.height - arrowHeight);
        
        CGPoint arrowPosition = CGPointMake(frame.size.width / 2.0 , CGRectGetHeight(frame));
        CGSize arrowSize = CGSizeMake(arrowWidth, arrowHeight);
        CGFloat radius = 4;
        CGFloat borderWidth = 0;
        
        [path moveToPoint:(CGPoint){ arrowPosition.x + borderWidth, arrowPosition.y - borderWidth }];
        [path addLineToPoint:(CGPoint){ borderWidth + arrowPosition.x + arrowSize.width / 2, arrowPosition.y - arrowSize.height - borderWidth }];
        [path addLineToPoint:(CGPoint){ baloonFrame.size.width - radius, baloonFrame.origin.y + baloonFrame.size.height + borderWidth }];
        [path addArcWithCenter:(CGPoint){ baloonFrame.size.width - radius, baloonFrame.origin.y + baloonFrame.size.height - radius + borderWidth } radius:radius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(0) clockwise:NO];
        [path addLineToPoint:(CGPoint){ baloonFrame.size.width, baloonFrame.origin.y + radius + borderWidth }];
        [path addArcWithCenter:(CGPoint){ baloonFrame.size.width - radius, baloonFrame.origin.y + radius + borderWidth } radius:radius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(270) clockwise:NO];
        [path addLineToPoint:(CGPoint){ borderWidth + radius, baloonFrame.origin.y + borderWidth }];
        [path addArcWithCenter:(CGPoint){ borderWidth + radius, baloonFrame.origin.y + radius + borderWidth } radius:radius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(180) clockwise:NO];
        [path addLineToPoint:(CGPoint){ borderWidth, baloonFrame.origin.y + baloonFrame.size.height - radius + borderWidth }];
        [path addArcWithCenter:(CGPoint){ borderWidth + radius, baloonFrame.origin.y + baloonFrame.size.height - radius + borderWidth } radius:radius startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(90) clockwise:NO];
        [path addLineToPoint:(CGPoint){ borderWidth + arrowPosition.x - arrowSize.width / 2, arrowPosition.y - arrowSize.height - borderWidth }];
        [path closePath];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = (CGRect){0, 0, frame.size.width, frame.size.height - arrowHeight};
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
        self.layer.backgroundColor = kHexRGB(0x5CACEE).CGColor;
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        label.centerX = frame.size.width / 2.0;
        label.centerY = ceil(frame.size.height / 2.0) - arrowHeight / 2.0;
        [self addSubview:label];
    }
    return self;
}

@end
