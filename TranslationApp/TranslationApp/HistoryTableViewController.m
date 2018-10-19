//
//  HistoryTableViewController.m
//  TranslationApp
//
//  Created by llk on 2018/6/26.
//  Copyright © 2018年 Beauty. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "HistoryTableViewCell.h"
#import "TranslationMicTipView.h"
@interface HistoryTableViewController ()

@property(nonatomic,strong)UIButton * headViewBtn;

@property(nonatomic,strong)NSMutableArray * words;

@property(nonatomic,strong)TranslationMicTipView * micTipView;
@end

@implementation HistoryTableViewController
-(UIButton *)headViewBtn{
    if (!_headViewBtn) {
        _headViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headViewBtn.frame = CGRectMake(0,CGRectGetMidY(self.tableView.frame) - 40, SCREEN_WIDTH, kIphone6Width(40));
        [_headViewBtn setTitle:@"收回" forState:UIControlStateNormal];
        _headViewBtn.backgroundColor = kHexRGB(0x5CACEE);
        [_headViewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _headViewBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_headViewBtn addTarget:self action:@selector(headViewBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headViewBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _words = [[NSMutableArray alloc] init];
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path1 = [pathArray objectAtIndex:0];
    NSString *myPath = [path1 stringByAppendingPathComponent:@"HistoryWord.plist"];
  
    _words = [[NSMutableArray alloc] initWithContentsOfFile:myPath];
    self.tableView.separatorColor = kHexRGB(0Xe5e5e5);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 01);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    // _tableView.tableHeaderView = self.headViewBtn;
    [self.tableView registerClass:[HistoryTableViewCell class] forCellReuseIdentifier:@"HistoryTableViewCell"];
    [self setupMicTipView];
    
}
-(void)setupMicTipView{
    CGFloat popHeight =kIphone6Width(35.0);
    CGRect popRect = [self.view convertRect:self.tableView.frame toView:self.view];
    popRect.origin.y = popRect.origin.y - popHeight;
    popRect.size.width = kIphone6Width(140);
    popRect.size.height = popHeight;
    
    self.micTipView = [[TranslationMicTipView alloc] initWithFrame:popRect Title:@"向下滑动返回"];
    self.micTipView.centerX = SCREEN_WIDTH/2;
    self.micTipView.centerY = kIphone6Width(340);
    [self.tableView addSubview:self.micTipView];
    [self performSelector:@selector(hideTipView) withObject:nil afterDelay:2.0];
}
- (void)hideTipView {
    //WEAK(weakSelf, self)
    [UIView animateWithDuration:0.25 animations:^{
        self.micTipView.alpha = 0;
    } completion:^(BOOL finished) {
        self.micTipView.hidden = YES;
    }];
}

-(void)headViewBtnTouchUpInside:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _words.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCell"];
    if (cell == nil) {
        cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HistoryTableViewCell"];
    }
    cell.word = [NSString stringWithFormat:@"%@:%@",_words[indexPath.row][@"query"],_words[indexPath.row][@"result"]];
    cell.index = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return self.headViewBtn;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return kIphone6Width(40);
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < -65) {
         VIBRATION;
        [self dismissViewControllerAnimated:YES completion:^{
            VIBRATION;
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
