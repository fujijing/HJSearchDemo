//
// Created by luosong on 14-4-23.
// Copyright (c) 2014 chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PINYIN_TOKEN_LATIN = 1,
    PINYIN_TOKEN_PINYIN = 2,
    PINYIN_TOKEN_UNKNOWN = 3
} PINYIN_TOKEN;

@interface PinyinToken : NSObject

@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString * source;
@property (nonatomic, copy) NSString *target;

- (instancetype)initWithType:(int)type source:(NSString *)source target:(NSString *)target;

+ (instancetype)tokenWithType:(int)type source:(NSString *)source target:(NSString *)target;


@end

@interface HanziToPinyin : NSObject


+ (NSArray *)getPinyin:(NSString *)input;
@end