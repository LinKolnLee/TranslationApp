//
//  TranslationAudioManager.h
//  TranslationApp
//
//  Created by llk on 2018/6/27.
//  Copyright © 2018年 Beauty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TranslationAudioManager : NSObject
//开始录音
-(void)startRecordWithType:(NSString *)type;

-(void)stopRecordSuccess:(void (^)(NSString * str))success;
@end
