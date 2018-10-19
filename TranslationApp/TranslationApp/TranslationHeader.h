//
//  TranslationHeader.h
//  TranslationApp
//
//  Created by llk on 2018/6/25.
//  Copyright © 2018年 Beauty. All rights reserved.
//

#ifndef TranslationHeader_h
#define TranslationHeader_h

/**
 vibration
 */
#define VIBRATION (AudioServicesPlaySystemSound(1519))

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
 像素系数
 */
#define kIphone6Width(w) (NSInteger)(((w) * SCREEN_WIDTH) / 375.0f)
/**
 color
 */
#define kHexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif /* TranslationHeader_h */
