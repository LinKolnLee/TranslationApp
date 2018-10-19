//
//  TranslationViewController.h
//  TranslationApp
//
//  Created by llk on 2018/6/25.
//  Copyright © 2018年 Beauty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TranslationViewController : UIViewController

@property(nonatomic,strong)NSString * resultString;

@property(nonatomic,strong)NSString * audioString;

@property(nonatomic,assign)NSInteger showIndex;

@property (nonatomic, copy) void(^translationTextviewEndInput)(NSString * string,NSInteger showIndex);

-(void)setupLayoutWithType:(NSInteger)type;

@end
