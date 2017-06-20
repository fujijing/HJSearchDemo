//
//  HJHistoryViewController.h
//  HJSearchDemo
//
//  Created by Revive on 16/9/14.
//  Copyright © 2016年 HJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RACSignal.h"
#import "RACSubject.h"

@interface HJHistoryViewController : UITableViewController

@property(nonatomic, strong) RACSubject *rac_cancleAllHistory;
@property(nonatomic, strong) RACSubject *rac_cancleHistoryRecord;
@property(nonatomic, strong) RACSubject *rac_searchContent;

@property (nonatomic, strong) NSMutableArray *historyRecords;

@end
