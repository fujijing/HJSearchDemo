//
//  HJTimelySearchViewController.m
//  HJSearchDemo
//
//  Created by Revive on 2017/6/20.
//  Copyright © 2017年 HJing. All rights reserved.
//

#import "HJTimelySearchViewController.h"
#import "View+MASAdditions.h"
#import "HJSearchViewModel.h"
#import "HJHistoryRecordCell.h"

@interface HJTimelySearchViewController ()<UISearchBarDelegate>
@property (nonatomic, strong) UIView *searchBgView;
// to display the search results
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) HJSearchViewModel *viewModel;

@end

@implementation HJTimelySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel = [[HJSearchViewModel alloc] init];
    [self buildUIElements];
    [self.viewModel dealData];
    @_weakSelf(self)
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
    [self.searchBar resignFirstResponder];
    
    // do sth about get search result
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar becomeFirstResponder];
}

- (void)cancleBtnTouched
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}




@end
