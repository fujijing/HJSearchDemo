//
//  HJHistoryRecordCell.m
//  HJSearchDemo
//
//  Created by Revive on 16/9/14.
//  Copyright © 2016年 HJing. All rights reserved.
//

#import "HJHistoryRecordCell.h"
#import "View+MASAdditions.h"

@interface  HJHistoryRecordCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic) NSInteger row;

@end

@implementation HJHistoryRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *selectedBgView = [[UIView alloc] init];
        selectedBgView.backgroundColor = [UIColor lightGrayColor];
        self.selectedBackgroundView = selectedBgView;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_titleLabel];
        

        _cancleBtn = [[UIButton alloc] init];
        _cancleBtn.backgroundColor = [UIColor clearColor];
        _cancleBtn.layer.cornerRadius = 40.0/2;
        _cancleBtn.layer.masksToBounds = YES;
        [_cancleBtn setImage:[UIImage imageNamed:@"gww_search_cancle_button"] forState:UIControlStateNormal];
        _cancleBtn.imageEdgeInsets = UIEdgeInsetsMake(10,10,10,10);
        [self.contentView addSubview:_cancleBtn];
        
        [_cancleBtn addTarget:self action:@selector(cancelTheRecord) forControlEvents:UIControlEventTouchUpInside];
        
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
        [self.contentView addSubview:_bottomLine];
        
        
        CGFloat padding = 15.0;
        
        @_weakSelf(self)
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @_strongSelf(self)
            make.left.mas_equalTo(padding);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(_cancleBtn.mas_left).with.offset(-10);
            make.height.mas_equalTo(20);
        }];
        
        [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            @_strongSelf(self)
            make.right.mas_equalTo(-5);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.and.width.mas_equalTo(40);
        }];
        
        
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
            make.left.mas_equalTo(padding);
            make.right.mas_equalTo(0);
        }];
        

    }
    return self;
}

- (void)setItem:(NSString *)title row:(NSInteger)row
{
    _row = row;
    if (row == 0) {
        _titleLabel.text = @"搜索历史";
        _titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _cancleBtn.hidden = YES;
    }else
    {
        _titleLabel.text = title;
        _cancleBtn.hidden = NO;
    }
}

- (void)setItemWithTitle:(NSString *)title
{
    _titleLabel.text = title;
    _cancleBtn.hidden = YES;
}

- (void)cancelTheRecord
{
    [_delegate cancleSearchRecord:_row];
}


@end
