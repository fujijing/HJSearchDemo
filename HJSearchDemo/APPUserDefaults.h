//
//  APPUserDefaults.h
//  HJSearchDemo
//
//  Created by Revive on 16/9/14.
//  Copyright © 2016年 HJing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPUserDefaults : NSObject

+(id)instance;

//store the record of search
-(void)setUserSearchHistory:(NSMutableArray *)array;
-(NSMutableArray *)getUserSearchHistory;

@end
