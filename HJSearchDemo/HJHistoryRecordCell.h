//
//  HJHistoryRecordCell.h
//  HJSearchDemo
//
//  Created by Revive on 16/9/14.
//  Copyright © 2016年 HJing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HJHistoryRecordCellDelegate<NSObject>

- (void)cancleSearchRecord:(NSInteger)row;

@end

@interface HJHistoryRecordCell : UITableViewCell

@property (nonatomic, weak) id<HJHistoryRecordCellDelegate> delegate;

- (void)setItem:(NSString *)title row:(NSInteger)row;
- (void)setItemWithTitle:(NSString *)title;

@end
