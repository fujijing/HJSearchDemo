//
//  HJHistoryViewController.m
//  HJSearchDemo
//
//  Created by Revive on 16/9/14.
//  Copyright © 2016年 HJing. All rights reserved.
//

#import "HJHistoryViewController.h"
#import "HJHistoryRecordCell.h"

@interface HJHistoryViewController ()<HJHistoryRecordCellDelegate>

@end

@implementation HJHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _rac_cancleAllHistory = [RACSubject subject];
    _rac_cancleHistoryRecord = [RACSubject subject];
    _rac_searchContent = [RACSubject subject];

    self.tableView.backgroundColor = [UIColor whiteColor];
    
    
    [self.tableView registerClass:[HJHistoryRecordCell class] forCellReuseIdentifier:@"historyCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 90)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-60, 30, 120, 35)];
    [cancleBtn setTitle:@"清除搜索历史" forState: UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [cancleBtn setTitleColor:[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1] forState:UIControlStateNormal];
    cancleBtn.layer.borderColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1].CGColor;
    cancleBtn.layer.cornerRadius = 3;
    cancleBtn.layer.borderWidth = 0.5;
    [view addSubview:cancleBtn];
    
    [cancleBtn addTarget:self action:@selector(clearAllHistory) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = view;
}

- (void)setHistoryRecords:(NSMutableArray *)historyRecords
{
    _historyRecords = [NSMutableArray arrayWithArray:historyRecords];
    [self.tableView reloadData];
}

- (void)clearAllHistory
{
    [_rac_cancleAllHistory sendNext:nil];
}

- (void)viewWillLayoutSubviews
{
    self.tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    [super viewWillLayoutSubviews];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _historyRecords.count > 0 ? _historyRecords.count + 1 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40;
    }
    return 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"historyCell";
    HJHistoryRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[HJHistoryRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row == 0) {
        [cell setItem:nil row:indexPath.row];
    }
    else
    {
        [cell setItem:_historyRecords[indexPath.row - 1] row:indexPath.row];
        [cell setDelegate:self];
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row != 0) {
        [_rac_searchContent sendNext:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)cancleSearchRecord:(NSInteger)row
{
    if (row > 0) {
        [_historyRecords removeObjectAtIndex:row - 1];
        [self.tableView reloadData];
    }
    
    [_rac_cancleHistoryRecord sendNext:[NSNumber numberWithInteger:row]];
}

@end
