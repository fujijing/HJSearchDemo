//
//  ViewController.m
//  HJSearchDemo
//
//  Created by Revive on 16/9/13.
//  Copyright © 2016年 HJing. All rights reserved.
//

#import "ViewController.h"
#import "View+MASAdditions.h"
#import "HJHistoryViewController.h"
#import "DXPopover.h"
#import "HJSearchViewModel.h"
#import "HJHistoryRecordCell.h"

@interface ViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) UIView *searchBgView;
// to display the search results
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UISearchBar *searchBar;

//store the search record
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) HJHistoryViewController *historyViewController;
@property (nonatomic, strong) DXPopover *popover;

@property (nonatomic, strong) HJSearchViewModel *viewModel;

@end

@implementation ViewController

- (void)dealloc {
    NSLog(@"********************************ViewController dealloc");
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _historyArray = [NSMutableArray array];
    _viewModel = [[HJSearchViewModel alloc] init];
    [_historyArray  addObjectsFromArray:[[APPUserDefaults instance] getUserSearchHistory]];
    if (_historyArray.count == 0) {
        [_historyArray addObject:@"游戏"];
        [_historyArray addObject:@"动漫"];
    }
    
    [self buildUIElements];
    [self.viewModel dealData];
    
    //清空搜索记录
    @_weakSelf(self)
    [self.historyViewController.rac_cancleAllHistory subscribeNext:^(id x) {
        @_strongSelf(self)
        [self.historyArray removeAllObjects];
        [self hiddenTheHistoryRecords];
    }];
    
    //清除某条搜索记录
    [self.historyViewController.rac_cancleHistoryRecord subscribeNext:^(NSNumber *x) {
        @_strongSelf(self)
        [self.historyArray removeObjectAtIndex: x.integerValue - 1];
        if(self.historyArray.count == 0)
            [self hiddenTheHistoryRecords];
    }];
    
    //点击某条搜索记录进行搜索
    [self.historyViewController.rac_searchContent subscribeNext:^(NSIndexPath *x) {
        @_strongSelf(self)
        NSString *string = [self.historyArray objectAtIndex:x.row - 1];
        [self.searchBar resignFirstResponder];
        self.searchBar.text = string;
        [self hiddenTheHistoryRecords];
        
        // do sth about get search result
    }];
    
    [self.viewModel.rac_update subscribeNext:^(id x) {
        @_strongSelf(self)
        [self.tableView reloadData];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //store the new history records in the userDefaults
    [[APPUserDefaults instance] setUserSearchHistory:_historyArray];
}


#pragma  mark -- UI

- (void)buildUIElements
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.searchBgView];
    [self.view addSubview:self.tableView];
    _tableView.delegate = self.viewModel;
    _tableView.dataSource = self.viewModel;

    @_weakSelf(self)
    [self.searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(80);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @_strongSelf(self)
        make.top.mas_equalTo(self.searchBgView.mas_bottom);
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];

    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        @_strongSelf(self)
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.cancleBtn.mas_left).with.offset(-10);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @_strongSelf(self)
        make.centerY.mas_equalTo(self.searchBar.mas_centerY);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(self.searchBar.mas_right).with.offset(10);
    }];
    
}

- (UIView *)searchBgView
{
    if (!_searchBgView) {
        _searchBgView = [[UIView alloc] init];
        _searchBgView.backgroundColor = [UIColor whiteColor];
        
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.showsCancelButton = NO;
        _searchBar.tintColor = [UIColor orangeColor];
        _searchBar.placeholder = @"搜索感兴趣的内容";
        _searchBar.delegate = self;
        
        for (UIView *subView in _searchBar.subviews) {
            if ([subView isKindOfClass:[UIView  class]]) {
                [[subView.subviews objectAtIndex:0] removeFromSuperview];
                if ([[subView.subviews objectAtIndex:0] isKindOfClass:[UITextField class]]) {
                    UITextField *textField = [subView.subviews objectAtIndex:0];
                    textField.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
                    
                    //设置输入框边框的颜色
//                    textField.layer.borderColor = [UIColor blackColor].CGColor;
//                    textField.layer.borderWidth = 1;
                    
                    //设置输入字体颜色
//                    textField.textColor = [UIColor lightGrayColor];
                    
                    //设置默认文字颜色
                    UIColor *color = [UIColor grayColor];
                    [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"搜索感兴趣的内容"
                                                                                        attributes:@{NSForegroundColorAttributeName:color}]];
                    //修改默认的放大镜图片
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
                    imageView.backgroundColor = [UIColor clearColor];
                    imageView.image = [UIImage imageNamed:@"gww_search_ misplaces"];
                    textField.leftView = imageView;
                }
            }
        }
        
        UIImage *image = [UIImage imageNamed:@"gww_search_cancle_button"];
        [_searchBar setImage:image forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
        
        [_searchBgView addSubview:_searchBar];
        
        
        _cancleBtn = [[UIButton alloc] init];
        _cancleBtn.backgroundColor = [UIColor clearColor];
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        [_searchBgView addSubview:_cancleBtn];
        
        [_cancleBtn addTarget:self action:@selector(cancleBtnTouched) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _searchBgView;
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        [_tableView registerClass:[HJHistoryRecordCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (HJHistoryViewController *)historyViewController
{
    if (_historyViewController == nil)
    {
        _historyViewController = [[HJHistoryViewController alloc] init];
        _historyViewController.historyRecords = _historyArray;
    }
    return _historyViewController;
}

- (DXPopover *)popover
{
    if (_popover == nil)
    {
        _popover = [DXPopover popover];
        _popover.cornerRadius = 0.0;
        _popover.arrowSize = CGSizeZero;
        _popover.animationSpring = NO;
        _popover.maskType = DXPopoverMaskTypeNone;
        _popover.animationOut = 0.15;
        _popover.animationIn = 0.15;
        _popover.applyShadow = NO;
        _popover.isNeedtransform = NO;
        _popover.blackOverlayInset = UIEdgeInsetsMake(64,0,0,0);
        _popover.backgroundColor = [UIColor clearColor];
        
    }
    return _popover;
}



#pragma mark ---searchBar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] > 20) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"字数不能超过20" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:nil completion:nil];
        [_searchBar setText:[searchText substringToIndex:20]];
    }
    
    [self.viewModel filterObjectsWithKeyWords:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"========search");
    
    //store the records,  records are not contain the blank, so should remove the blank record
    NSString *regex = @"\\s*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![_historyArray containsObject:_searchBar.text] && ![pred evaluateWithObject:_searchBar.text]) {
        [_historyArray insertObject:_searchBar.text atIndex:0];
    }
    
    _historyViewController.historyRecords = _historyArray;
    [self hiddenTheHistoryRecords];
    [self.searchBar resignFirstResponder];
    
    // do sth about get search result
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // when we start to write sth, the record should display to us
    if (_historyArray.count != 0) {
        _historyViewController.historyRecords = _historyArray;
        [self showTheHistoryRecords];
        [self.searchBar becomeFirstResponder];
    }
}

#pragma  mark- history records

- (void)showTheHistoryRecords
{
    CGPoint startPoint = CGPointMake(CGRectGetWidth(self.view.frame), 64);
    [self.popover showAtPoint:startPoint
               popoverPostion:DXPopoverPositionDown
              withContentView:self.historyViewController.view
                       inView:self.view];
    self.popover.didDismissHandler = ^{
        
    };
}

- (void)hiddenTheHistoryRecords
{
    [self.popover dismiss];
}


- (void)cancleBtnTouched
{
    [self.searchBar resignFirstResponder];
    [self hiddenTheHistoryRecords];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
