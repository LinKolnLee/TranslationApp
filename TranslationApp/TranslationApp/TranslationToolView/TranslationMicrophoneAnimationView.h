//
//  TranslationMicrophoneAnimationView.h
//  TranslationApp
//
//  Created by llk on 2018/6/25.
//  Copyright © 2018年 Beauty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TranslationMicrophoneAnimationView : UIView

@property (nonatomic, assign) CGFloat waveSpeed;

@property (nonatomic, assign) CGFloat waveHeight;

@property (nonatomic, assign) CGFloat waveAmplitude;
- (void)startWaveAnimation;
- (void)stopWaveAnimation;
@end
