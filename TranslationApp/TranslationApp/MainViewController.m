//
//  MainViewController.m
//  TranslationApp
//
//  Created by llk on 2018/6/23.
//  Copyright © 2018年 Beauty. All rights reserved.
//

#import "MainViewController.h"
#import "LLSegmentPageHeader.h"
#import "TranslationViewController.h"
#import "TranslationToolView.h"
#import "TranslationMicTipView.h"
#import "HistoryTableViewController.h"
#import "TranslationManager.h"
#import "TranslationAudioManager.h"
@interface MainViewController ()<LLSegmentPageScrollDelegate>

@property(nonatomic,strong)LLSegmentPageHead * header;

@property(nonatomic,strong)LLSegmentPageScroll * scrollView;

@property(nonatomic,strong)UIButton * layoutBtn;

@property(nonatomic,strong)TranslationToolView * translationToolView;

@property(nonatomic,strong)TranslationMicrophoneAnimationView * animationView;

@property(nonatomic,strong)TranslationMicTipView * micTipView;

@property(nonatomic,strong)NSMutableArray * vcArrays;

@property(nonatomic,assign)NSInteger showIndex;

@property(nonatomic,strong)NSArray * tranistionTypes;

@property(nonatomic,strong)TranslationAudioManager * audioManager;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationSubviews];
    [self setupSubviews];
    [self setupMicTipView];
    self.tranistionTypes = @[@"EN2ZH_CN",@"ZH_CN2EN",
                             @"ZH_CN2JA",@"JA2ZH_CN"
                             ];
}
-(void)setupNavigationSubviews{
    NSArray * list = @[@"英译中",
                       @"中译英",
                       @"中译日",
                       @"日译中"
                       ];
    LLSegmentPageHead * head = [[LLSegmentPageHead alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kIphone6Width(40)) titles:list headStyle:LLSegmentPageHeadStyleArrow layoutStyle:LLSegmentPageHeadLayoutStyleCenter];
    head.headColor = [UIColor clearColor];
    head.topLineColor = [UIColor clearColor];
    head.bottomLineColor = [UIColor clearColor];
    head.titleFontSize = 14;
    head.selectColor = kHexRGB(0x5CACEE);
    head.arrowColor = kHexRGB(0x5CACEE);
    head.normalSelectColor = [UIColor blackColor];
   _scrollView = [[LLSegmentPageScroll alloc] initWithFrame:CGRectMake(0, kNavigationHeight , SCREEN_WIDTH, kIphone6Width(350)) vcOrViews:[self vcArr:list.count]];
    _scrollView.loadAll = YES;
    _scrollView.segDelegate = self;
    WEAK(weakSelf, self)
    [LLSegmentPageManager associateHead:head withScroll:_scrollView completion:^{
        self.navigationItem.titleView = head;
        [self.view addSubview:weakSelf.scrollView];
    }];
    self.showIndex = 0;
}

-(void)setupSubviews{
    [self.view addSubview:self.layoutBtn];
    [self.view addSubview:self.translationToolView];
    [self.view addSubview:self.animationView];
    [self.layoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView.mas_bottom).offset(kIphone6Width(5));
        make.right.mas_offset(kIphone6Width(-15));
        make.width.height.mas_offset(kIphone6Width(30));
    }];
    [self.translationToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.scrollView.mas_bottom).offset(kIphone6Width(50));
        make.height.mas_equalTo(kIphone6Width(150));
    }];
    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(kIphone6Width(50));
    }];
  
}
-(UIButton *)layoutBtn{
    if (!_layoutBtn) {
        _layoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_layoutBtn setImage:[UIImage imageNamed:@"LayoutButton"] forState:UIControlStateNormal];
        [_layoutBtn addTarget:self action:@selector(layoutBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _layoutBtn;
}
-(void)layoutBtnTouchUpInside:(UIButton *)sender{
    [UIView animateWithDuration:0.3 animations:^{
        sender.transform = CGAffineTransformRotate(sender.transform, M_PI_2);
    }];
    sender.selected = !sender.selected;
    if (sender.selected) {
        for (TranslationViewController * vc in self.vcArrays) {
            [vc setupLayoutWithType:0];
        }
    }else{
        for (TranslationViewController * vc in self.vcArrays) {
            [vc setupLayoutWithType:1];
        }
    }
    
}
-(TranslationAudioManager *)audioManager{
    if (!_audioManager) {
        _audioManager = [[TranslationAudioManager alloc] init];
    }
    return _audioManager;
}
-(TranslationMicrophoneAnimationView *)animationView{
    if (!_animationView) {
        _animationView = [[TranslationMicrophoneAnimationView alloc] init];
        _animationView.backgroundColor = [UIColor whiteColor];
        _animationView.hidden = YES;
    }
    return _animationView;
}
-(TranslationToolView *)translationToolView{
    if (!_translationToolView) {
        _translationToolView = [[TranslationToolView alloc] initWithFrame:CGRectMake(0, kIphone6Width(450), SCREEN_WIDTH, kIphone6Width(180))];
        _translationToolView.backgroundColor = [UIColor whiteColor];
        WEAK(weakSelf, self);
        _translationToolView.microPhoneButtonClick = ^(UIButton *button) {
            VIBRATION;
            weakSelf.animationView.hidden = NO;
            [weakSelf.animationView startWaveAnimation];
            switch (weakSelf.showIndex) {
                case 0:
                {
                    [weakSelf.audioManager startRecordWithType:@"en_US"];
                }
                    break;
                case 1:
                {
                    [weakSelf.audioManager startRecordWithType:@"zh_CN"];
                }
                     break;
                case 2:
                {
                    [weakSelf.audioManager startRecordWithType:@"zh_CN"];
                }
                    break;
                    case 3:
                {
                    [weakSelf.audioManager startRecordWithType:@"ja"];
                }
                     break;
                default:
                    break;
            }
        };
        _translationToolView.microPhoneButtonCancelClick = ^(UIButton *button) {
            weakSelf.animationView.hidden = YES;
            [weakSelf.animationView stopWaveAnimation];
            [weakSelf.audioManager stopRecordSuccess:^(NSString *str) {
                TranslationViewController * vc = weakSelf.vcArrays[weakSelf.showIndex];
                vc.audioString = str;
            }];
        };
        _translationToolView.historicalButtonClick = ^(UIButton *button) {
            VIBRATION;
            [weakSelf hh_presentBackScaleVC:[HistoryTableViewController new] height:kIphone6Width(400) completion:^{
                VIBRATION;
            }];

        };
    }
    return _translationToolView;
}
-(void)setupMicTipView{
    CGFloat popHeight =kIphone6Width(35.0);
    CGRect popRect = [self.translationToolView convertRect:self.translationToolView.microphoneBtn.frame toView:self.view];
    popRect.origin.y = popRect.origin.y - popHeight - 5;
    popRect.size.width = kIphone6Width(140);
    popRect.size.height = popHeight;
    
    self.micTipView = [[TranslationMicTipView alloc] initWithFrame:popRect Title:@"录制声音进行翻译"];
    self.micTipView.centerX = SCREEN_WIDTH/2;
    self.micTipView.centerY = kIphone6Width(70);
    [self.translationToolView addSubview:self.micTipView];
    [self performSelector:@selector(hideTipView) withObject:nil afterDelay:2.0];
}
- (void)hideTipView {
    WEAK(weakSelf, self)
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.micTipView.alpha = 0;
    } completion:^(BOOL finished) {
        weakSelf.micTipView.hidden = YES;
    }];
}

#pragma mark - 数据源
- (NSArray *)vcArr:(NSInteger)count {
    self.vcArrays = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < count; i ++) {
        TranslationViewController *vc = [TranslationViewController new];
        __weak typeof(TranslationViewController)  *weakvc = vc;
        vc.showIndex = i;
        vc.translationTextviewEndInput = ^(NSString *string,NSInteger showIndex) {
            [TranslationManager translationWord:string type:self.tranistionTypes[showIndex] success:^(NSString *result) {
                weakvc.resultString = result;
                NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsPath = [path objectAtIndex:0];
                NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"HistoryWord.plist"];
                NSMutableArray * words = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
                if (!words) {
                    words = [[NSMutableArray alloc] init];
                }
                NSMutableDictionary *newsDict = [NSMutableDictionary dictionary];
                //赋值
                [newsDict setObject:string forKey:@"query"];
                [newsDict setObject:result forKey:@"result"];
                [words addObject:newsDict];
                [words writeToFile:plistPath atomically:YES];
            }];
        };
        [self.vcArrays addObject:vc];
    }
    return self.vcArrays;
}
-(void)scrollEndIndex:(NSInteger)index{
    self.showIndex = index;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
