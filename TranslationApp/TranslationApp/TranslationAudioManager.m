//
//  TranslationAudioManager.m
//  TranslationApp
//
//  Created by llk on 2018/6/27.
//  Copyright © 2018年 Beauty. All rights reserved.
//

#import "TranslationAudioManager.h"
#import <Speech/Speech.h>
API_AVAILABLE(ios(10.0))

@interface TranslationAudioManager()<SFSpeechRecognizerDelegate>
//创建语音识别操作类对象
@property (nonatomic, strong) SFSpeechRecognizer *speechRecognizer;
//是音频引擎，用于音频输入
@property (nonatomic, strong) AVAudioEngine *audioEngine;
//
@property (nonatomic,strong) SFSpeechRecognitionTask *recognitionTask;
//
@property (nonatomic,strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property(nonatomic,strong)NSString * translationStr;
@end
@implementation TranslationAudioManager{
    UIButton *recordingBtn;
    UITextField *textF;
}
-(instancetype)init{
    if (self = [super init]) {
        if (@available(iOS 10.0, *)) {
            [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
                switch (status) {
                    case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                        NSLog(@"语音识别未授权");
                      //  [weakSelf creatAlertWithTitle:@"语音识别未授权"];
                        break;
                    case SFSpeechRecognizerAuthorizationStatusDenied:
                       // [weakSelf creatAlertWithTitle:@"语音未授权"];
                         NSLog(@"语音未授权");
                        break;
                    case SFSpeechRecognizerAuthorizationStatusRestricted:
                        //[weakSelf creatAlertWithTitle:@"设备不支持语音识别功能"];
                         NSLog(@"设备不支持语音识别功能");
                        break;
                    case SFSpeechRecognizerAuthorizationStatusAuthorized:
                        //self.recordBtn.enabled = YES;
                       // [weakSelf creatAlertWithTitle:@"可以语音识别"];
                         NSLog(@"可以语音识别");
                        break;
                    default:
                        break;
                }
            }];
        } else {
            // Fallback on earlier versions
            NSLog(@"ss");
        }
    }
    return self;
}
- (SFSpeechRecognizer *)speechRecognizer  API_AVAILABLE(ios(10.0)){
    if (!_speechRecognizer) {
        NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        self.speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:local];
        self.speechRecognizer.delegate = self;
        NSLog(@"可以设置语言种类：%@",[SFSpeechRecognizer supportedLocales]);
    }
    return _speechRecognizer;
}

- (AVAudioEngine *)audioEngine {
    if (!_audioEngine) {
        self.audioEngine = [[AVAudioEngine alloc] init];
    }
    return _audioEngine;
}
-(void)startRecordWithType:(NSString *)type{
    NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:type];
    self.speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:local];
    if (_recognitionTask) {
        [self.recognitionTask cancel];
        self.recognitionTask = nil;
    }
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error;
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    NSParameterAssert(!error);
    [audioSession setMode:AVAudioSessionModeMeasurement error:&error];
    NSParameterAssert(!error);
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    NSParameterAssert(!error);
    
    if (@available(iOS 10.0, *)) {
        self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
        AVAudioInputNode *inputNode = self.audioEngine.inputNode;
        NSAssert(inputNode, @"录入设备没有转备好");
        NSAssert(self.recognitionRequest, @"请求初始化失败");
        self.recognitionRequest.shouldReportPartialResults = YES;
        __weak typeof(self) weakSelf = self;
        self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
            BOOL isFinal = NO;
            if (result) {
               self.translationStr = result.bestTranscription.formattedString;
                isFinal = result.isFinal;
            }
            if (error || isFinal) {
                [self.audioEngine stop];
                [inputNode removeTapOnBus:0];
                weakSelf.recognitionTask = nil;
                weakSelf.recognitionRequest = nil;
//                weakSelf.recordBtn.enabled = YES;
//                [weakSelf.recordBtn setTitle:@"开始新的录音" forState:UIControlStateNormal];
            }
        }];
        
        AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
        //在添加tap之前先移除上一个,不然会报错 com.apple.coreaudio.avfaudio
        [inputNode removeTapOnBus:0];
        [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
            if (weakSelf.recognitionRequest) {
                [weakSelf.recognitionRequest appendAudioPCMBuffer:buffer];
            }
        }];
        [self.audioEngine prepare];
        [self.audioEngine startAndReturnError:&error];
        //self.translationStr = LoadingText;
    } else {
        // Fallback on earlier versions
    }
}
-(void)stopRecordSuccess:(void (^)(NSString *))success{
    if ([self.audioEngine isRunning]) {
        [self.audioEngine stop];
        [self.recognitionRequest endAudio];
        [self.recognitionTask cancel];
        self.recognitionTask = nil;
        if (self.translationStr) {
            success(self.translationStr);
        }
    }
}
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available{
    if (available) {
       // recordingBtn.enabled = YES;
    }else{
       // recordingBtn.enabled = NO;
    }
}

@end
