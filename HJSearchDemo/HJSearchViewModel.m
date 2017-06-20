//
//  HJSearchViewModel.m
//  HJSearchDemo
//
//  Created by Revive on 2017/6/19.
//  Copyright © 2017年 HJing. All rights reserved.
//

#import "HJSearchViewModel.h"
#import "PinyinHelper.h"
#import "NSArray+CSPExtension.h"
#import "NSObject+CSPTypeConversion.h"
#import "HJHistoryRecordCell.h"

@interface HJSearchViewModel ()

@property (nonatomic, strong) NSMutableDictionary *cachePinyinDict;

@end

@implementation HJSearchViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _rac_update = [RACSubject subject];
        _dataArray = [NSMutableArray array];
        _afterFilterDataArray = [NSMutableArray array];
        _cachePinyinDict = [NSMutableDictionary dictionary];
//        @synchronized (self.cachePinyinDict) {
//            if (self.cachePinyinDict == nil) {
//                self.cachePinyinDict = [NSMutableDictionary dictionary];
//            }
//        }
    }
    return self;
}


- (void)dealData
{
    NSArray *array = @[@"动漫",@"游戏",@"视频",@"小说",@"美食",@"动漫-日本动漫",@"影视",@"影视-楚乔传"];
    [self.dataArray addObjectsFromArray:array];
    [self cachePinyin];
    
}

- (void)cachePinyin
{
    if (!self.dataArray.count) return;
    
    for (NSString *name in self.dataArray) {
        NSString *p = [self.cachePinyinDict objectForKey:name];
        if (p == nil) {
            p = [[PinyinHelper getPinyin:name  isXingshi:NO] join:@" "];
            self.cachePinyinDict[name] = p;
        }
    }
}

- (void)filterObjectsWithKeyWords:(NSString *)words
{
    if (!words) return;
    if (!self.dataArray.count) return;
    
    words = [words uppercaseString];
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSString *name in self.dataArray) {
        NSString *pinyin = [self.cachePinyinDict objectForKey:name];
        pinyin = pinyin.uppercaseString;
        
        if ([name rangeOfString:pinyin].length > 0) {
            [array addObject:name];
        }else if ([pinyin rangeOfString:words].length > 0 && [pinyin rangeOfString:words].location == 0) {
            [array addObject:name];
        }
    }
    
    //若强匹配没有获取数据，则再进行一次弱匹配
    if (!array.count) {
        for (NSString *name in self.dataArray) {
            NSString *pinyin = [self.cachePinyinDict objectForKey:name];
            pinyin = pinyin.uppercaseString;
            
            if ([pinyin rangeOfString:words].length > 0 && [pinyin rangeOfString:words].location != 0) {
                [array addObject:name];
            }
        }
    }
    
    [self.afterFilterDataArray removeAllObjects];
    [self.afterFilterDataArray addObjectsFromArray:array];
    [self.rac_update sendNext:nil];
}

#pragma mark -- tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.afterFilterDataArray.count) return self.afterFilterDataArray.count;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [((HJHistoryRecordCell *)cell) setItemWithTitle:self.afterFilterDataArray[indexPath.row]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *content = self.afterFilterDataArray[indexPath.row];
    NSLog(@"===================选中%@",content);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
