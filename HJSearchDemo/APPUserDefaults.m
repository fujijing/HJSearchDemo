//
//  APPUserDefaults.m
//  HJSearchDemo
//
//  Created by Revive on 16/9/14.
//  Copyright © 2016年 HJing. All rights reserved.
//

#import "APPUserDefaults.h"

@implementation APPUserDefaults

+(id)instance
{
    static APPUserDefaults *_instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _instance = [[APPUserDefaults alloc] init];
    });
    return _instance;
}

-(void)setUserSearchHistory:(NSMutableArray *)array
{
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"SearchRecord"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableArray *)getUserSearchHistory
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"SearchRecord"];
}

@end
