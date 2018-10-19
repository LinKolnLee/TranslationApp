//
//  TranslationToolView.m
//  Buauty
//
//  Created by llk on 2018/6/25.
//  Copyright © 2017年 llk. All rights reserved.
//

#import "TranslationToolView.h"

@interface TranslationToolView ()

/**
 话筒title
 */
@property (nonatomic, strong) UILabel *microphoneLab;

/// 喇叭
@property (nonatomic, strong) UIButton *hornBtn;

/**
 喇叭title
 */
@property (nonatomic, strong) UILabel *hornLab;

/// 历史记录
@property (nonatomic, strong) UIButton *historicalBtn;

/**
 历史记录 title
 */
@property (nonatomic, strong) UILabel *historicalLab;


@end

@implementation TranslationToolView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.microphoneBtn];
        [self addSubview:self.hornBtn];
        [self addSubview:self.hornLab];
        [self addSubview:self.historicalBtn];
        [self addSubview:self.historicalLab];
        [self addMasonry];
    }
    return self;
}

#pragma mark - # Event Response
- (void)microphoneBtnTouchCancel:(UIButton *)sender {
    self.microPhoneButtonCancelClick(sender);
}
-(void)microphoneBtnTouchDown:(UIButton *)sender{
    self.microPhoneButtonClick(sender);
}
-(void)microphoneBtnTouchUpInsed:(UIButton *)sender{
    NSLog(@"hahah");
}
- (void)hornBtnTouchUpInside:(UIButton *)sender {
    self.hornPhoneButtonClick(sender);
}
- (void)historicalBtnTouchUpInside:(UIButton *)sender {
    self.historicalButtonClick(sender);
}

#pragma mark - # Private Methods
- (void)addMasonry {
    // 话筒
    [self.microphoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kIphone6Width(40));
        make.height.mas_equalTo(kIphone6Width(40));
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(kIphone6Width(40));
    }];
    // 喇叭
    [self.hornBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kIphone6Width(40));
        make.width.mas_equalTo(kIphone6Width(20));
        make.height.mas_equalTo(kIphone6Width(20));
        make.centerY.mas_equalTo(-kIphone6Width(30));
    }];
    [self.hornLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hornBtn.mas_bottom).offset(kIphone6Width(10));
        make.right.mas_equalTo(-kIphone6Width(30));
        make.width.mas_equalTo(kIphone6Width(40));
        make.height.mas_equalTo(kIphone6Width(20));
    }];
    // 历史记录
    [self.historicalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kIphone6Width(40));
        make.width.mas_equalTo(kIphone6Width(20));
        make.height.mas_equalTo(kIphone6Width(20));
        make.centerY.mas_equalTo(-kIphone6Width(30));
    }];
    [self.historicalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.historicalBtn.mas_bottom).offset(kIphone6Width(10));
        make.left.mas_equalTo(kIphone6Width(20));
        make.width.mas_equalTo(kIphone6Width(60));
        make.height.mas_equalTo(kIphone6Width(20));
    }];
}

#pragma mark - # Getter
- (UIButton *)microphoneBtn {
    if (!_microphoneBtn) {
        _microphoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_microphoneBtn setImage:[UIImage imageNamed:@"microphone"] forState:UIControlStateNormal];
        [_microphoneBtn setImage:[UIImage imageNamed:@"microphone"] forState:UIControlStateSelected];
        [_microphoneBtn addTarget:self action:@selector(microphoneBtnTouchCancel:) forControlEvents:UIControlEventTouchUpInside];
        [_microphoneBtn addTarget:self action:@selector(microphoneBtnTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_microphoneBtn setAdjustsImageWhenHighlighted:NO];

        //[_microphoneBtn addTarget:self action:@selector(microphoneBtnTouchUpInsed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _microphoneBtn;
}

- (UIButton *)hornBtn {
    if (!_hornBtn) {
        _hornBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hornBtn setImage:[UIImage imageNamed:@"horn"] forState:UIControlStateNormal];
        [_hornBtn setImage:[UIImage imageNamed:@"horn"] forState:UIControlStateSelected];
        [_hornBtn addTarget:self action:@selector(hornBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_hornBtn setAdjustsImageWhenHighlighted:NO];

    }
    return _hornBtn;
}

- (UIButton *)historicalBtn {
    if (!_historicalBtn) {
        _historicalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_historicalBtn setImage:[UIImage imageNamed:@"historical"] forState:UIControlStateNormal];
        [_historicalBtn setImage:[UIImage imageNamed:@"historical"] forState:UIControlStateSelected];
        [_historicalBtn addTarget:self action:@selector(historicalBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _historicalBtn;
}
-(UILabel *)hornLab{
    if (!_hornLab) {
        _hornLab = [[UILabel alloc] init];
        _hornLab.text = @"播放";
        _hornLab.textColor = kHexRGB(0x6e6e6e);
        _hornLab.textAlignment = NSTextAlignmentCenter;
        _hornLab.font = [UIFont systemFontOfSize:13];
    }
    return _hornLab;
}
-(UILabel *)historicalLab{
    if (!_historicalLab) {
        _historicalLab = [[UILabel alloc] init];
        _historicalLab.text = @"历史记录";
        _historicalLab.textColor = kHexRGB(0x6e6e6e);
        _historicalLab.textAlignment = NSTextAlignmentCenter;
        _historicalLab.font = [UIFont systemFontOfSize:13];
    }
    return _historicalLab;
}
@end
