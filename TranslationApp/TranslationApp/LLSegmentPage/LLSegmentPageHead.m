//
//  LLSegmentPageHead.m
//  TranslationApp
//
//  Created by llk on 2018/6/22.
//  Copyright © 2018年 Beauty. All rights reserved.
//

#import "LLSegmentPageHead.h"
#import "LLSegmentPageHeader.h"
#define SCROLL_WIDTH (self.width - _moreButtonWidth)
#define SCROLL_HEIGHT (self.height - _bottomLineHeight - _topLineHeight)
#define CURRENT_WIDTH(s) [_titleWidthsArray[s] floatValue]
static CGFloat arrow_H = 6;//箭头高
static CGFloat arrow_W = 18;//箭头宽
static CGFloat animation_time = .3;
@interface LLSegmentPageHead ()

/**
 *  LLSegmentPageHeadStyle
 */
@property (nonatomic, assign) LLSegmentPageHeadStyle headStyle;

/**
 *  LLSegmentPageHeadLayoutStyle
 */
@property (nonatomic, assign) LLSegmentPageHeadLayoutStyle layoutStyle;

/**
 titles
 */
@property(nonatomic,strong)NSMutableArray * titlesArray;

/**
 buttons
 */
@property(nonatomic,strong)NSMutableArray * buttonsArray;

/**
 widths
 */
@property(nonatomic,strong)NSMutableArray * titleWidthsArray;

/**
 title width sum
 */
@property(nonatomic,assign)CGFloat titleWidthSum;

/**
 head title scroll view
 */
@property(nonatomic,strong)UIScrollView * headTitleScrollView;

@property(nonatomic,strong)UIScrollView * headSliderScroll;

/**
 bottom line view
 */
@property(nonatomic,strong)UIView * bottomLineView;

/**
 top line view
 */
@property(nonatomic,strong)UIView * topLineView;

/**
 head line view
 */
@property(nonatomic,strong)UIView * headLineView;

/**
 arrow layer
 */
@property(nonatomic,strong)CAShapeLayer *arrowLayer;

/**
 slider view
 */
@property(nonatomic,strong)UIView * sliderView;

/**
 current index
 */
@property(nonatomic,assign)NSInteger currentIndex;

@property(nonatomic,assign)BOOL isSelected;

@property(nonatomic,assign)CGFloat endScale;
@end
@implementation LLSegmentPageHead
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles{
    return [self initWithFrame:frame titles:titles headStyle:LLSegmentPageHeadStyleDefault];
}
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles headStyle:(LLSegmentPageHeadStyle)style{
    return [self initWithFrame:frame titles:titles headStyle:style layoutStyle:LLSegmentPageHeadLayoutStyleDefault];
}
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles headStyle:(LLSegmentPageHeadStyle)style layoutStyle:(LLSegmentPageHeadLayoutStyle)layout{
    if (self = [super initWithFrame:frame]) {
        self.headStyle = style;
        self.layoutStyle = layout;
        self.titlesArray = [titles mutableCopy];
        [self setupSubview];
    }
    return self;
}
-(void)setupSubview{
    self.buttonsArray = [[NSMutableArray alloc] init];
    self.showIndex = 0;
    self.singleWidth = 20;
    self.maxTitleNumber = 5.0;
    self.titleFontSize = 13;
    self.lineHeight = 2.5;
    self.headColor = [UIColor whiteColor];
    self.lineColor = [UIColor blackColor];
    self.arrowColor = [UIColor blackColor];
    self.selectColor =[UIColor blackColor];
    self.normalSelectColor = [UIColor lightGrayColor];
    self.bottomLineColor = [UIColor grayColor];
    self.bottomLineHeight = 1;
    self.topLineColor = [UIColor grayColor];
    self.topLineHeight = 1;
    self.sliderHeight = SCROLL_HEIGHT;
    self.sliderColor = self.normalSelectColor;
    self.lineScale = 1.0;
    self.sliderScale = 1.0;
    self.fontScale = 1.0;
    self.sliderCorner = _sliderHeight/2;
    //[self setupDefultSubviews];
}
-(void)setupDefultSubviews{
    if (!self.titleWidthsArray) {
        self.titleWidthsArray = [NSMutableArray arrayWithCapacity:self.titlesArray.count];
    }
    [self.titleWidthsArray removeAllObjects];
    self.maxTitleNumber = self.maxTitleNumber>self.titlesArray.count?self.titlesArray.count:self.maxTitleNumber;
    [self setupTitleWidths];
    
    //判断总宽度
    if (self.titleWidthSum > SCROLL_WIDTH && _layoutStyle== LLSegmentPageHeadLayoutStyleCenter) {
        _layoutStyle = LLSegmentPageHeadLayoutStyleLeft;
    }
    [self createView];

    _showIndex = MIN(self.titlesArray.count-1, MAX(0, _showIndex));
    if (_showIndex != 0) {
        self.currentIndex = _showIndex;
        [self changeContentOffset];
        [self changeBtnFrom:0 to:self.currentIndex];
    }
}
#pragma mark Title Width
-(void)setupTitleWidths{
    self.titleWidthSum = 0.0;
    CGFloat width = SCREEN_WIDTH/self.maxTitleNumber;
    for (NSString * title in self.titlesArray) {
        if (self.layoutStyle != LLSegmentPageHeadLayoutStyleDefault) {
            width = [self getTieleWidth:title];
        }
        [self.titleWidthsArray addObject:@(width)];
        self.titleWidthSum += width;
    }
}
-(CGFloat)getTieleWidth:(NSString *)title{
    UIFont * font;
    if (self.titleFont) {
        font = self.titleFont;
    }else{
        font = [UIFont systemFontOfSize:self.titleFontSize];
    }
    return [title boundingRectWithSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.frame)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil].size.width + self.singleWidth;
}
-(void)createView{
    self.headTitleScrollView = [self setupHeadTitleScrollView];
    [self setupHeadTitleScrollViewSubviews:self.headTitleScrollView];
    [self addSubview:self.topLineView];
    [self addSubview:self.headTitleScrollView];
    [self addSubview:self.bottomLineView];
    [self setupHeadStyle];
}
-(UIScrollView *)setupHeadTitleScrollView{
    if (!self.titlesArray) {
        return nil;
    }
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topLineHeight, SCROLL_WIDTH, SCROLL_HEIGHT)];
    scroll.contentSize = CGSizeMake(MAX(SCROLL_WIDTH, self.titleWidthSum), SCROLL_HEIGHT);
    scroll.backgroundColor = self.headColor;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator  = NO;
    scroll.bounces = NO;
    return scroll;
}
-(void)setupHeadTitleScrollViewSubviews:(UIScrollView *)scroll{
    CGFloat start_x = 0;
    if (_layoutStyle == LLSegmentPageHeadLayoutStyleCenter) {
        //计算布局的起点
        start_x = SCROLL_WIDTH/2;
        for (NSInteger i = 0; i < self.titleWidthsArray.count/2; i ++) {
            start_x -= CURRENT_WIDTH(i);
        }
        if (self.titlesArray.count%2 != 0) {
            start_x -= CURRENT_WIDTH(self.titleWidthsArray.count/2)/2;
        }
    }
    if (_layoutStyle == LLSegmentPageHeadLayoutStyleRight) {
        start_x = SCROLL_WIDTH - self.titleWidthSum;
    }
    [self creatButtonWithTitles:self.titlesArray ScrollView:scroll StartX:start_x StartIndex:0];
    if ( self.headStyle != LLSegmentPageHeadStyleSlide) {
        UIButton *curBtn = self.buttonsArray[_showIndex];
        if (_fontScale != 1) {
            curBtn.titleLabel.font = [UIFont systemFontOfSize:self.titleFontSize*_fontScale];
        }
        [curBtn setTintColor:_selectColor];
    }
}
-(void)creatButtonWithTitles:(NSArray *)titles ScrollView:(UIScrollView *)scrollView StartX:(CGFloat)startX StartIndex:(NSInteger)startIndex{
    BOOL istTitles = [scrollView isEqual:self.headTitleScrollView];
    CGFloat width;
    for (NSInteger i = startIndex; i < titles.count; i ++) {
        width = CURRENT_WIDTH(i);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:self.titlesArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:self.titleFontSize];
        button.frame = CGRectMake(startX, 0, width, SCROLL_HEIGHT);
        startX += width;
        if (istTitles) {
            [button setTintColor:self.normalSelectColor];
            [button addTarget:self action:@selector(selectedHeadTitles:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonsArray addObject:button];
        } else {
            [button setTintColor:_selectColor];
        }
        [scrollView addSubview:button];
    }
    scrollView.contentSize = CGSizeMake(MAX(SCROLL_WIDTH, _titleWidthSum), self.height);
}
-(void)setMaxTitleNumber:(NSInteger)maxTitleNumber{
    _maxTitleNumber = maxTitleNumber;
}
-(void)setupHeadStyle{
    switch (self.headStyle) {
        case LLSegmentPageHeadStyleLine:
            {
                self.headLineView = [self setupHeadLineView];
                [self.headTitleScrollView addSubview:self.headLineView];
            }
            break;
        case LLSegmentPageHeadStyleArrow:
        {
            self.headLineView = [self setupHeadLineView];
            _lineHeight = arrow_H;
            self.lineScale = 1;
            self.headLineView.backgroundColor = [UIColor clearColor];
            [self.headTitleScrollView addSubview:self.headLineView];
            //arrow
            [self drawArrowLayer];
            self.arrowLayer.position = CGPointMake(self.headLineView.width/2, self.headLineView.height/2);
            [self.headLineView.layer addSublayer:self.arrowLayer];
        }
            break;
        case LLSegmentPageHeadStyleSlide:
        {
            self.sliderView = [self setupSliderView];
            [self.headTitleScrollView addSubview:self.sliderView];
        }
            break;
        default:
            break;
    }
}
-(void)drawArrowLayer{
    self.arrowLayer = [[CAShapeLayer alloc] init];
    self.arrowLayer.bounds = CGRectMake(0, 0, arrow_W, arrow_H);
    [self.arrowLayer setFillColor:self.arrowColor.CGColor];
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:CGPointMake(arrow_W/2, 0)];
    [arrowPath addLineToPoint:CGPointMake(arrow_W, arrow_H)];
    [arrowPath addLineToPoint:CGPointMake(0, arrow_H)];
    [arrowPath closePath];
    self.arrowLayer.path = arrowPath.CGPath;
}
-(UIView *)setupHeadLineView{
    self.lineScale = fabs(self.lineScale)>1?1:fabs(self.lineScale);
    CGFloat line_w = CURRENT_WIDTH(self.currentIndex);
    UIButton *current_btn = self.buttonsArray[self.currentIndex];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, SCROLL_HEIGHT-_lineHeight, line_w * self.lineScale, _lineHeight)];
    line.center = CGPointMake(current_btn.center.x, line.center.y);
    line.backgroundColor = _lineColor;
    return line;
}
-(UIView *)setupSliderView{
    CGFloat slide_w = CURRENT_WIDTH(self.currentIndex);
    UIView *slide = [[UIView alloc] initWithFrame:CGRectMake(0, (SCROLL_HEIGHT-self.sliderHeight)/2, slide_w*self.sliderScale, self.sliderHeight)];
    UIButton *current_btn = self.buttonsArray[self.currentIndex];
    slide.center = CGPointMake(current_btn.center.x, slide.center.y);
    slide.clipsToBounds = YES;
    slide.layer.cornerRadius = MIN(self.sliderCorner, self.sliderHeight/2);
    slide.backgroundColor = self.sliderColor;
    self.headSliderScroll = [self setupHeadTitleScrollView];
    [self setupHeadTitleScrollViewSubviews:self.headSliderScroll];
    self.headSliderScroll.userInteractionEnabled = NO;
    self.headSliderScroll.backgroundColor = [UIColor clearColor];
    CGRect convertRect = [slide convertRect:self.headTitleScrollView.frame fromView:self.headTitleScrollView.superview];
    self.headSliderScroll.frame = CGRectMake(convertRect.origin.x, -(SCROLL_HEIGHT - self.sliderHeight)/2, SCROLL_WIDTH, SCROLL_HEIGHT);
    [slide addSubview:self.headSliderScroll];
    return slide;
}
-(UIScrollView *)customHeadSliderScroll{
    if (!self.titlesArray) {
        return nil;
    }
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCROLL_WIDTH, SCROLL_HEIGHT)];
    scroll.contentSize = CGSizeMake(MAX(SCROLL_WIDTH, self.titleWidthSum), SCROLL_HEIGHT);
    scroll.backgroundColor = self.headColor;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator  = NO;
    scroll.bounces = NO;
    return scroll;
}
#pragma mark title click
-(void)selectedHeadTitles:(UIButton *)sender{
    NSInteger selectIndex = [self.buttonsArray indexOfObject:sender];
    [self changeIndex:selectIndex completion:YES];
}
- (void)changeIndex:(NSInteger)index completion:(BOOL)completion{
    if (index == self.currentIndex) {
        return;
    }
    NSInteger before = self.currentIndex;
    self.currentIndex = index;
    [self changeContentOffset];
    [UIView animateWithDuration:animation_time animations:^{
        [self changeBtnFrom:before to:self.currentIndex];
    } completion:^(BOOL finished) {
    }];
    self.isSelected = YES;
    
    if (completion) {
        if ([self.delegate respondsToSelector:@selector(didSelectedIndex:)]) {
            [self.delegate didSelectedIndex:self.currentIndex];
        }else if(self.selectedIndex){
            self.selectedIndex(self.currentIndex);
        }
    }
}
- (void)changeContentOffset {
    if (self.titleWidthSum > SCROLL_WIDTH) {
        UIButton *currentBtn = self.buttonsArray[self.currentIndex];
        if (currentBtn.center.x<SCROLL_WIDTH/2) {
            [self.headTitleScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        } else if (currentBtn.center.x > (self.titleWidthSum-SCROLL_WIDTH/2)) {
            [self.headTitleScrollView setContentOffset:CGPointMake(self.titleWidthSum-SCROLL_WIDTH, 0) animated:YES];
        } else {
            [self.headTitleScrollView setContentOffset:CGPointMake(currentBtn.center.x - SCROLL_WIDTH/2, 0) animated:YES];
        }
    }
}
- (void)changeBtnFrom:(NSInteger)from to:(NSInteger)to {
    UIButton *before_btn = self.buttonsArray[from];
    UIButton *select_btn = self.buttonsArray[to];
    if (_headStyle != LLSegmentPageHeadStyleSlide) {
        [before_btn setTintColor:self.normalSelectColor];
        [select_btn setTintColor:self.selectColor];
    }else{
        
    }
    if (self.headLineView) {
        self.headLineView.width = select_btn.width*self.lineScale;
        self.headLineView.center = CGPointMake(select_btn.center.x, self.headLineView.center.y);
    }
    if (self.arrowLayer) {
        self.arrowLayer.position = CGPointMake(self.headLineView.width/2, self.headLineView.height/2);
    }
    if (self.sliderView) {
        //slide位置变化
        self.sliderView.width = select_btn.width*self.sliderScale;
        self.sliderView.center = CGPointMake(select_btn.center.x, self.sliderView.center.y);
        //偏移
        CGRect convertRect = [self.sliderView convertRect:self.headTitleScrollView.frame fromView:self.headTitleScrollView];
        self.headSliderScroll.frame = CGRectMake(convertRect.origin.x, convertRect.origin.y, self.headSliderScroll.contentSize.width, self.headSliderScroll.contentSize.height);
    }
}
- (void)dealloc {
    self.arrowLayer.delegate = nil;
    [self.arrowLayer removeFromSuperlayer];
    self.arrowLayer = nil;
}

-(void)setSelectIndex:(NSInteger)index{
    [self changeIndex:index completion:NO];
}
- (void)animationEnd {
    self.isSelected = NO;
}
#pragma mark - animation
//外部关联的scrollView变化
- (void)changePointScale:(CGFloat)scale {
    if (self.isSelected) {
        return;
    }
    if (scale<0) {
        return;
    }
    //区分向左 还是向右
    BOOL left = self.endScale > scale;
    self.endScale = scale;
    
    //1.将scale变为对应titleScroll的titleScale
    //每个view所占的百分比
    CGFloat per_view = 1.0/(CGFloat)self.titlesArray.count;
    //下标
    NSInteger changeIndex = scale/per_view + (left?1:0);
    NSInteger nextIndex = changeIndex + (left?-1:1);
    //超出范围
    if (nextIndex >= self.titlesArray.count || changeIndex >= self.titlesArray.count) {
        return;
    }
    //currentbtn
    UIButton *currentBtn = self.buttonsArray[changeIndex];
    UIButton *nextBtn = self.buttonsArray[nextIndex];
    //startscla
    CGFloat start_scale = 0;
    for (NSInteger i = 0; i < nextIndex; i++) {
        start_scale += CURRENT_WIDTH(i)/self.titleWidthSum;
    }
    //滑动选中位置所占的相对百分比
    CGFloat current_title_Scale = CURRENT_WIDTH(changeIndex)/self.titleWidthSum;;
    //单个view偏移的百分比
    CGFloat single_offset_scale = (scale - per_view*changeIndex)/per_view;
    //转换成对应title的百分比
    CGFloat titleScale = single_offset_scale * current_title_Scale + start_scale;
    //变化的百分比
    CGFloat change_scale = (left?-1:1)*(titleScale - start_scale)/current_title_Scale;
    
    
    switch (_headStyle) {
        case LLSegmentPageHeadStyleDefault:
        case LLSegmentPageHeadStyleLine:
        case LLSegmentPageHeadStyleArrow:
        {
            if (self.headLineView) {
                //lineView位置变化
                self.headLineView.width = [self widthChangeCurWidth:CURRENT_WIDTH(changeIndex) nextWidth:CURRENT_WIDTH(nextIndex) changeScale:change_scale endScale:_lineScale];
                CGFloat center_x = [self centerChanegCurBtn:currentBtn nextBtn:nextBtn changeScale:change_scale];
                self.headLineView.center = CGPointMake(center_x, self.headLineView.center.y);
            }
            if (self.arrowLayer) {
                self.arrowLayer.position = CGPointMake(self.headLineView.width/2, self.headLineView.height/2);
            }
            //颜色变化
            [self colorChangeCurBtn:currentBtn nextBtn:nextBtn changeScale:change_scale];
            //字体大小变化
            [self fontChangeCurBtn:currentBtn nextBtn:nextBtn changeScale:change_scale];
        }
            break;
        case LLSegmentPageHeadStyleSlide:
        {
            //slide位置变化
            self.sliderView.width = [self widthChangeCurWidth:CURRENT_WIDTH(changeIndex) nextWidth:CURRENT_WIDTH(nextIndex) changeScale:change_scale endScale:self.sliderScale];
            CGFloat center_x = [self centerChanegCurBtn:currentBtn nextBtn:nextBtn changeScale:change_scale];
            self.sliderView.center = CGPointMake(center_x, self.sliderView.center.y);
            //偏移
            CGRect convertRect = [self.sliderView convertRect:self.headTitleScrollView.frame fromView:self.headTitleScrollView];
            self.headSliderScroll.frame = CGRectMake(convertRect.origin.x, convertRect.origin.y, self.headSliderScroll.contentSize.width, self.headSliderScroll.contentSize.height);
        }
            break;
        default:
            break;
    }
}


#pragma mark - 长度变化
- (CGFloat)widthChangeCurWidth:(CGFloat)curWidth nextWidth:(CGFloat)nextWidth changeScale:(CGFloat)changeScale endScale:(CGFloat)endscale{
    //改变的宽度
    CGFloat change_width = curWidth - nextWidth;
    //宽度变化
    CGFloat width = curWidth*endscale - changeScale * change_width;
    return width;
}

#pragma mark - 中心位置的变化
- (CGFloat)centerChanegCurBtn:(UIButton *)curBtn nextBtn:(UIButton *)nextBtn changeScale:(CGFloat)changeScale {
    //lineView改变的中心
    CGFloat change_center = nextBtn.center.x - curBtn.center.x;
    //lineView位置变化
    CGFloat center_x = curBtn.center.x + changeScale * change_center;
    return center_x;
}

#pragma mark - 字体大小变化
- (void)fontChangeCurBtn:(UIButton *)curBtn nextBtn:(UIButton *)nextBtn changeScale:(CGFloat)changeScale{
    //button字体改变的大小
    CGFloat btn_font_change = self.titleFontSize*(_fontScale - 1);
    //大小变化
    CGFloat next_font = self.titleFontSize + changeScale*btn_font_change;
    CGFloat cur_font = self.titleFontSize*_fontScale - changeScale*btn_font_change;
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:next_font];
    curBtn.titleLabel.font = [UIFont systemFontOfSize:cur_font];
}

#pragma mark - 颜色变化
- (void)colorChangeCurBtn:(UIButton *)curBtn nextBtn:(UIButton *)nextBtn changeScale:(CGFloat)changeScale {
    //button选中颜色
    CGFloat sel_red;
    CGFloat sel_green;
    CGFloat sel_blue;
    CGFloat sel_alpha;
    //button未选中的颜色
    CGFloat de_sel_red;
    CGFloat de_sel_green;
    CGFloat de_sel_blue;
    CGFloat de_sel_alpha;
    
    if ([_selectColor getRed:&sel_red green:&sel_green blue:&sel_blue alpha:&sel_alpha] && [self.normalSelectColor getRed:&de_sel_red green:&de_sel_green blue:&de_sel_blue alpha:&de_sel_alpha]) {
        //颜色的变化的大小
        CGFloat red_changge = sel_red - de_sel_red;
        CGFloat green_changge = sel_green - de_sel_green;
        CGFloat blue_changge = sel_blue - de_sel_blue;
        CGFloat alpha_changge = sel_alpha - de_sel_alpha;
        //颜色变化
        [nextBtn setTintColor:[UIColor colorWithRed:de_sel_red + red_changge*changeScale
                                              green:de_sel_green + green_changge*changeScale
                                               blue:de_sel_blue + blue_changge*changeScale
                                              alpha:de_sel_alpha + alpha_changge*changeScale]];
        
        [curBtn setTintColor:[UIColor colorWithRed:sel_red - red_changge*changeScale
                                             green:sel_green - green_changge*changeScale
                                              blue:sel_blue - blue_changge*changeScale
                                             alpha:sel_alpha - alpha_changge*changeScale]];
    }
}
#pragma mark GET
-(UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, SCROLL_HEIGHT, self.width, _bottomLineHeight)];
        _bottomLineView.backgroundColor = _bottomLineColor;
    }
    return _bottomLineView;
}
-(UIView *)topLineView{
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, _topLineHeight)];
        _topLineView.backgroundColor = _bottomLineColor;
    }
    return _topLineView;
}
@end
