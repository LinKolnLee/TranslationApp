//
//  UIView+LLFrame.h
//  TranslationApp
//
//  Created by llk on 2018/6/22.
//  Copyright © 2018年 Beauty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LLFrame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign, readonly) CGFloat bottomFromSuperView;

@end
