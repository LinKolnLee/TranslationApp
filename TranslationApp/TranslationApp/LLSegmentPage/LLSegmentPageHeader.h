//
//  LLSegmentPageHeader.h
//  TranslationApp
//
//  Created by llk on 2018/6/22.
//  Copyright © 2018年 Beauty. All rights reserved.
//

#ifndef LLSegmentPageHeader_h
#define LLSegmentPageHeader_h

#import "UIView+LLFrame.h"
#import "UIView+LLFrame.h"
#import "LLSegmentPageHead.h"
#import "LLSegmentPageScroll.h"
#import "LLSegmentPageManager.h"

/**
 UIScreen width
 */
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
/**
 UIScreen height
 */
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
/**
 navigation height
 */
#define kNavigationHeight (44 + [[UIApplication sharedApplication] statusBarFrame].size.height)
/**
status height
 */
#define kStatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)
/**
 weak self
 */
#define WEAK(weaks,s)  __weak __typeof(&*s)weaks = s;
#endif /* LLSegmentPageHeader_h */
