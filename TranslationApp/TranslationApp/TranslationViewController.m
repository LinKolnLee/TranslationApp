//
//  TranslationViewController.m
//  Buauty
//
//  Created by llk on 2018/6/25.
//  Copyright © 2017年 llk. All rights reserved.
//

#import "TranslationViewController.h"

@interface TranslationViewController () <
UITextViewDelegate
>

/// 输入框
@property (nonatomic, strong) UITextView *contentTextField;

/// 结果框
@property (nonatomic, strong) UILabel *resultLabel;

@end

@implementation TranslationViewController

#pragma mark - # Life Cycle
- (void)loadView {
    [super loadView];
    [self.view addSubview:self.contentTextField];
    [self.view addSubview:self.resultLabel];
    [self addMasonry];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - # Private Methods
- (void)addMasonry {
    // 输入框
    [self.contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kIphone6Width(10));
        make.right.mas_equalTo(-kIphone6Width(10));
        make.top.mas_equalTo(kIphone6Width(25));
        make.height.mas_equalTo(kIphone6Width(150));
    }];
    // 结果框
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kIphone6Width(10));
        make.right.mas_equalTo(-kIphone6Width(10));
        make.top.mas_equalTo(self.contentTextField.mas_bottom).mas_offset(kIphone6Width(15));
        make.height.mas_equalTo(kIphone6Width(150));
    }];
}

#pragma mark - # Getter
- (UITextView *)contentTextField {
    if (!_contentTextField) {
        _contentTextField = [[UITextView alloc] init];
        [_contentTextField setDelegate:self];
        [_contentTextField setTextColor:kHexRGB(0XBEBEBE)];
        _contentTextField.returnKeyType = UIReturnKeyGo;
        _contentTextField.clipsToBounds = NO;
        _contentTextField.layer.shadowColor = [UIColor grayColor].CGColor;//阴影颜色
        _contentTextField.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
        _contentTextField.layer.shadowOpacity = 0.5;//不透明度
        _contentTextField.layer.shadowRadius = 5.0;//半径
        _contentTextField.text = @"请输入翻译内容：";
        
    }
    return _contentTextField;
}

- (UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc] init];
        _resultLabel.font = [UIFont systemFontOfSize:14];
        _resultLabel.textAlignment = NSTextAlignmentLeft;
       // _resultLabel.textColor = kHexRGB(0XBEBEBE);
        _resultLabel.backgroundColor = [UIColor whiteColor];
        _resultLabel.layer.shadowColor = [UIColor grayColor].CGColor;//阴影颜色
        _resultLabel.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
        _resultLabel.layer.shadowOpacity = 0.5;//不透明度
        _resultLabel.layer.shadowRadius = 5.0;//半径
        [self setupAttributedStr];
        _resultLabel.lc_tapBlock = ^(NSInteger index, NSAttributedString *charAttributedString) {
            if (charAttributedString) {
                VIBRATION;
                UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
                pastboard.string = [charAttributedString string];
            }
        };
    }
    return _resultLabel;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"请输入翻译内容："]) {
        textView.text = @"";
    }
    textView.textColor = kHexRGB(0x171717);
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.textColor = kHexRGB(0XBEBEBE);
        textView.text = @"请输入翻译内容：";
    }
    
    self.translationTextviewEndInput(textView.text,_showIndex);
}
-(void)setResultString:(NSString *)resultString{
    if (![resultString isEqualToString:@""] && ![resultString isEqualToString:@"请输入翻译内容："]) {
        self.resultLabel.textColor = kHexRGB(0x171717);
        self.resultLabel.attributedText = nil;
        self.resultLabel.text = [NSString stringWithFormat:@" %@",resultString];
    }else{
        [self setupAttributedStr];
    }
}
-(void)setShowIndex:(NSInteger)showIndex{
    _showIndex = showIndex;
}
-(void)setupAttributedStr{
    _resultLabel.textColor = kHexRGB(0XBEBEBE);
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    // 对齐方式
    style.alignment = NSTextAlignmentJustified;
    // 首行缩进
    style.firstLineHeadIndent = 10.0f;
    // 头部缩进
    style.headIndent = 10.0f;
    // 尾部缩进
    style.tailIndent = -10.0f;
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:@"翻译结果" attributes:@{ NSParagraphStyleAttributeName : style}];
    _resultLabel.attributedText = attrText;
}
-(void)setupLayoutWithType:(NSInteger)type{
    switch (type) {
        case 0:
        {
            [self.view layoutIfNeeded];
            [self.contentTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kIphone6Width(20));
                make.top.mas_equalTo(kIphone6Width(25));
                make.width.mas_equalTo(kIphone6Width(150));
                make.height.mas_equalTo(kIphone6Width(280));
            }];
            [self.resultLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(kIphone6Width(25));
                make.right.mas_equalTo(-kIphone6Width(20));
                make.width.mas_equalTo(kIphone6Width(150));
                make.height.mas_equalTo(kIphone6Width(280));
            }];
            [UIView animateWithDuration:0.25 animations:^{
                [self.view layoutIfNeeded];
            }];
        }
            break;
        case 1:
        {
            [self.view layoutIfNeeded];
            // 输入框
            [self.contentTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kIphone6Width(10));
                make.right.mas_equalTo(-kIphone6Width(10));
                make.top.mas_equalTo(kIphone6Width(25));
                make.height.mas_equalTo(kIphone6Width(150));
            }];
            // 结果框
            [self.resultLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kIphone6Width(10));
                make.right.mas_equalTo(-kIphone6Width(10));
                make.top.mas_equalTo(self.contentTextField.mas_bottom).mas_offset(kIphone6Width(15));
                make.height.mas_equalTo(kIphone6Width(150));
            }];
            [UIView animateWithDuration:0.25 animations:^{
                [self.view layoutIfNeeded];
            }];
        }
            break;
        default:
            break;
    }
}
-(void)setAudioString:(NSString *)audioString{
    self.contentTextField.text = audioString;
    self.translationTextviewEndInput(audioString,_showIndex);
}
@end
