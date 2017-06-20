//
//  HJSearchViewModel.h
//  HJSearchDemo
//
//  Created by Revive on 2017/6/19.
//  Copyright © 2017年 HJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RACSubject.h"

@interface HJSearchViewModel : NSObject<UITableViewDelegate,
UITableViewDataSource>
@property(nonatomic, strong) RACSubject *rac_update;
@property (nonatomic, strong) NSMutableArray *dataArray; //存储数据
@property (nonatomic, strong) NSMutableArray *afterFilterDataArray; // 搜索得到的数据

- (void)dealData;
- (void)filterObjectsWithKeyWords:(NSString *)words;

@end
