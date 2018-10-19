//
//  LLSegmentPageManager.h
//  TranslationApp
//
//  Created by llk on 2018/6/22.
//  Copyright © 2018年 Beauty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLSegmentPageHead.h"
#import "LLSegmentPageScroll.h"
@interface LLSegmentPageManager : NSObject
/**
 * 绑定两个view
 */
+ (void)associateHead:(LLSegmentPageHead *)head
           withScroll:(LLSegmentPageScroll *)scroll
           completion:(void(^)(void))completion;

+ (void)associateHead:(LLSegmentPageHead *)head
           withScroll:(LLSegmentPageScroll *)scroll
     contentChangeAni:(BOOL)ani
           completion:(void(^)(void))completion
            selectEnd:(void(^)(NSInteger index))selectEnd;

@end
