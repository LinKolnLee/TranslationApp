//
//  HistoryTableViewCell.m
//  TranslationApp
//
//  Created by llk on 2018/6/26.
//  Copyright © 2018年 Beauty. All rights reserved.
//

#import "HistoryTableViewCell.h"
@interface HistoryTableViewCell()

@property(nonatomic,strong)UIView * toplineView;

@property(nonatomic,strong)UIView * bottomlineView;

@property(nonatomic,strong)UILabel * titleLabel;
@end
@implementation HistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.toplineView];
        [self.contentView addSubview:self.bottomlineView];
        [self.contentView addSubview:self.titleLabel];
        [self.toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        [self.bottomlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.toplineView.mas_bottom);
            make.bottom.mas_equalTo(self.bottomlineView.mas_top);
        }];
        
    }
     return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(UIView *)toplineView{
    if (!_toplineView) {
        _toplineView = [[UIView alloc] init];
        _toplineView.backgroundColor = kHexRGB(0XCFCFCF);
    }
    return _toplineView;
}
-(UIView *)bottomlineView{
    if (!_bottomlineView) {
        _bottomlineView = [[UIView alloc] init];
        _bottomlineView.backgroundColor = kHexRGB(0XCFCFCF);
    }
    return _bottomlineView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
-(void)setWord:(NSString *)word{
    self.titleLabel.text = word;
}
-(void)setIndex:(NSInteger)index{
    if ( index != 0) {
        self.toplineView.hidden = YES;
    }
}
@end
