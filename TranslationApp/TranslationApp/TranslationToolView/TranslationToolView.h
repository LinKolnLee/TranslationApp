//
//  TranslationToolView.h
//  TranslationApp
//
//  Created by llk on 2018/6/25.
//  Copyright © 2018年 Beauty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TranslationToolView : UIView

/// mic
@property (nonatomic, strong) UIButton *microphoneBtn;


@property (nonatomic, copy) void(^microPhoneButtonClick)(UIButton * button);

@property (nonatomic, copy) void(^microPhoneButtonCancelClick)(UIButton * button);

@property (nonatomic, copy) void(^hornPhoneButtonClick)(UIButton * button);

@property (nonatomic, copy) void(^historicalButtonClick)(UIButton * button);


@end
