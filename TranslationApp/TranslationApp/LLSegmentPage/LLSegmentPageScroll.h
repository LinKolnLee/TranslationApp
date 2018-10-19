//
//  LLSegmentPageScroll.h
//  TranslationApp
//
//  Created by llk on 2018/6/22.
//  Copyright © 2018年 Beauty. All rights reserved.
//

#import <UIKit/UIKit.h>
//add view time
typedef NS_ENUM(NSUInteger, LLSegmentAddTiming) {
    //normal
    SegmentAddNormal,
    //scale
    SegmentAddScale
};

/**
 delegate
 */
@protocol LLSegmentPageScrollDelegate <NSObject>

/**
 end scroll
 */
- (void)scrollEndIndex:(NSInteger)index;

/**
 end animation

 */
- (void)animationEndIndex:(NSInteger)index;

/**
 scale
 */
- (void)scrollOffsetScale:(CGFloat)scale;

@end
@interface LLSegmentPageScroll : UIScrollView

/// one init load all view?
@property (nonatomic, assign) BOOL loadAll;

///cache count
@property (nonatomic, assign) NSInteger countLimit;

///defult show index
@property (nonatomic, assign) NSInteger showIndex;

///delegate
@property (nonatomic, weak) id<LLSegmentPageScrollDelegate> segDelegate;

///blcok
@property (nonatomic, copy) void(^scrollEnd)(NSInteger);
@property (nonatomic, copy) void(^animationEnd)(NSInteger);
@property (nonatomic, copy) void(^offsetScale)(CGFloat);

///view add time
@property (nonatomic, assign) LLSegmentAddTiming addTiming;

///SegmentAddScale
@property (nonatomic, assign) CGFloat addScale;


///class name
@property (nonatomic, copy) void(^initSource)(id vcOrview, NSInteger index);


/**
 init
 */
- (instancetype)initWithFrame:(CGRect)frame vcOrViews:(NSArray *)sources;

/**
 chang source
 */
- (void)changeSource:(NSArray *)sources;


/**
 * setup defult subviews
 */
- (void)setupDefultSubviews;


@end
