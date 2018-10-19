//
//  TranslationManager.h
//  TranslationApp
//
//  Created by llk on 2018/6/26.
//  Copyright © 2018年 Beauty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TranslationManager : NSObject

+(void)translationWord:(NSString *)word type:(NSString *)type success:(void (^)(NSString * result))success;

@end
