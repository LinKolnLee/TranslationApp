//
//  LLSegmentPageManager.m
//  TranslationApp
//
//  Created by llk on 2018/6/22.
//  Copyright © 2018年 Beauty. All rights reserved.
//

#import "LLSegmentPageManager.h"
#import "LLSegmentPageHeader.h"
#import "UIView+LLView.h"
@implementation LLSegmentPageManager
+ (void)associateHead:(LLSegmentPageHead *)head
           withScroll:(LLSegmentPageScroll *)scroll
           completion:(void(^)(void))completion {
    [LLSegmentPageManager associateHead:head withScroll:scroll contentChangeAni:YES completion:completion selectEnd:nil];
}


+ (void)associateHead:(LLSegmentPageHead *)head
           withScroll:(LLSegmentPageScroll *)scroll
     contentChangeAni:(BOOL)ani
           completion:(void(^)(void))completion
            selectEnd:(void(^)(NSInteger index))selectEnd {
    
    NSInteger showIndex;
    showIndex = head.showIndex?head.showIndex:scroll.showIndex;
    
    head.showIndex = showIndex;
    [head setupDefultSubviews];
    
    WEAK(weakScroll, scroll)
    head.selectedIndex = ^(NSInteger index) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakScroll setContentOffset:CGPointMake(index*weakScroll.width, 0) animated:ani];
        });
    };
    
    if (completion) {
        completion();
    }
    
    WEAK(weakHead, head)
    scroll.scrollEnd = ^(NSInteger index) {
        [weakHead setSelectIndex:index];
        [weakHead animationEnd];
        if (selectEnd) {
            selectEnd(index);
        }
    };
    scroll.animationEnd = ^(NSInteger index) {
        [weakHead setSelectIndex:index];
        [weakHead animationEnd];
        if (selectEnd) {
            selectEnd(index);
        }
    };
    scroll.offsetScale = ^(CGFloat scale) {
        [weakHead changePointScale:scale];
    };
    
    
    scroll.showIndex = showIndex;
    [scroll setupDefultSubviews];
    
    UIView *view = head.nextResponder?head:scroll;
    UIViewController *currentVC = [view viewController];
    currentVC.automaticallyAdjustsScrollViewInsets = NO;
}
@end
