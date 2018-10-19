//
//  LLSegmentPageHead.h
//  TranslationApp
//
//  Created by llk on 2018/6/22.
//  Copyright © 2018年 Beauty. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, LLSegmentPageHeadStyle) {
    /// Default
    LLSegmentPageHeadStyleDefault,
    /// line
    LLSegmentPageHeadStyleLine,
    /// arrow
    LLSegmentPageHeadStyleArrow,
    /// slide
    LLSegmentPageHeadStyleSlide
};
typedef NS_ENUM(NSUInteger,LLSegmentPageHeadLayoutStyle) {
    /// Default
    LLSegmentPageHeadLayoutStyleDefault,
    /// center
    LLSegmentPageHeadLayoutStyleCenter,
    /// left
    LLSegmentPageHeadLayoutStyleLeft,
    /// right
    LLSegmentPageHeadLayoutStyleRight
};
@protocol LLSegmentPageHeadDelegate <NSObject>
/**
 *  selected
 */
- (void)didSelectedIndex:(NSInteger)index;
@end
@interface LLSegmentPageHead : UIView

/**
 delegate
 */
@property(nonatomic,weak)id<LLSegmentPageHeadDelegate >delegate;

/**
 *  block
 */
@property (nonatomic, copy) void(^selectedIndex)(NSInteger);

#pragma mark Object

/**
 more button
 */
@property(nonatomic,strong)UIView * moreButton;

#pragma mark Data

/**
 nav background color
 */
@property(nonatomic,strong)UIColor * headColor;

/**
 title select color
 */
@property(nonatomic,strong)UIColor * selectColor;
/**
 title normal select color
 */
@property(nonatomic,strong)UIColor * normalSelectColor;
/**
 font scale
 */
@property(nonatomic,assign)CGFloat fontScale;
/**
 defult index
 */
@property(nonatomic,assign)NSInteger showIndex;
/**
  max title number
 */
@property(nonatomic,assign)NSInteger maxTitleNumber;

/**
 title font
 */
@property(nonatomic,strong)UIFont * titleFont;
/**
 title font size
 */
@property(nonatomic,assign)CGFloat titleFontSize;

/**
 ！LLSegmentPageHeadLayoutStyleDefault titleWidth
 */
@property (nonatomic, assign) CGFloat singleWidth;

/**
 bottom line height
 */
@property(nonatomic,assign)CGFloat bottomLineHeight;

/**
 bottom line color
 */
@property(nonatomic,strong)UIColor * bottomLineColor;

/**
 top line height
 */
@property(nonatomic,assign)CGFloat topLineHeight;

/**
 top line color
 */
@property(nonatomic,strong)UIColor * topLineColor;

/**
 moreButton width
 */
@property(nonatomic,assign)CGFloat moreButtonWidth;

/**
 head line height
 */
@property(nonatomic,assign)CGFloat lineHeight;

/**
 head line color
 */
@property(nonatomic,strong)UIColor * lineColor;

/**
 line scale
 */
@property(nonatomic,assign)CGFloat lineScale;

/**
 arrow color
 */
@property(nonatomic,strong)UIColor * arrowColor;

/**
 slider height
 */
@property(nonatomic,assign)CGFloat sliderHeight;

/**
 slider color
 */
@property(nonatomic,assign)UIColor * sliderColor;

/**
 slider Scale
 */
@property(nonatomic,assign)CGFloat sliderScale;

/**
 slide Corner
 */
@property (nonatomic, assign)CGFloat sliderCorner;

#pragma mark Public Method

/**
 *  init method
 */
- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles;


/**
 *  init method
 */
- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                    headStyle:(LLSegmentPageHeadStyle)style;

/**
 *  init method
  *  @return SegmentHeadView
 */
- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                    headStyle:(LLSegmentPageHeadStyle)style
                  layoutStyle:(LLSegmentPageHeadLayoutStyle)layout;

/**
 *  set currentIndex
 *
 *  @param index , set currendIndex
 */
- (void)setSelectIndex:(NSInteger)index;

/**
 *  animation by scale
 *
 *  @param scale scale
 */
- (void)changePointScale:(CGFloat)scale;

/**
 animation end
 */
- (void)animationEnd;


/**
 setup defult style subviews
 */
-(void)setupDefultSubviews;


@end
