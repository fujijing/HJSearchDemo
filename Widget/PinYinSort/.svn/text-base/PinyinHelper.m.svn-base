//
// Created by luosong on 14-4-22.
// Copyright (c) 2014 chanjet. All rights reserved.
//

#import "PinyinHelper.h"
#import "HanziToPinyin.h"


@implementation PinyinHelper {
    NSMutableDictionary * aliasFullLetters;
}

static PinyinHelper * _instance;

+ (PinyinHelper *)sharedInstance {
    @synchronized (_instance) {
        if (_instance == nil)
            _instance = [[PinyinHelper alloc] init];
        return _instance;
    }
}

- (id)init {
    self = [super init];
    if (self) {
        aliasFullLetters = [[NSMutableDictionary alloc] init];

        aliasFullLetters[@"曾"] = @"Zeng";
        aliasFullLetters[@"沈"] = @"Shen";
        aliasFullLetters[@"单"] = @"Shan";
        aliasFullLetters[@"查"] = @"Zha";
        aliasFullLetters[@"仇"] = @"Qiu";
        aliasFullLetters[@"区"] = @"Ou";
        aliasFullLetters[@"卜"] = @"Bu";
        aliasFullLetters[@"贾"] = @"Jia";
        aliasFullLetters[@"折"] = @"She";
        aliasFullLetters[@"秘"] = @"Bi";
        aliasFullLetters[@"解"] = @"Xie";
        aliasFullLetters[@"朴"] = @"Piao";
        aliasFullLetters[@"尉"] = @"Yu";
        aliasFullLetters[@"褚"] = @"Chu";
        aliasFullLetters[@"翟"] = @"Zhai";
        aliasFullLetters[@"郇"] = @"Huan";
        aliasFullLetters[@"盖"] = @"Ge";
        aliasFullLetters[@"隗"] = @"Kui";
        aliasFullLetters[@"繁"] = @"Po";
        aliasFullLetters[@"乐"] = @"Yue";
        aliasFullLetters[@"乜"] = @"Nie";
        aliasFullLetters[@"孛"] = @"Bo";
        aliasFullLetters[@"卒"] = @"Zu";
        aliasFullLetters[@"贲"] = @"Ben";
        aliasFullLetters[@"什"] = @"Shi";
        aliasFullLetters[@"句"] = @"Gou";
        aliasFullLetters[@"覃"] = @"Qin";
    }

    return self;
}

+ (NSArray *)getPinyin:(NSString *)str isXingshi:(BOOL)isXingshi {
    return [[self sharedInstance] getPinyin:str isXingshi:isXingshi];
}

+ (NSString *)getFullPinyin:(NSString *)str isXingshi:(BOOL)isXingshi {
    return [[self sharedInstance] getFullPinyin:str isXingshi:isXingshi];
}

+ (NSString *)getShortPinyin:(NSString *)str isXingshi:(BOOL)isXingshi {
    return [[self sharedInstance] getShortPinyin:str isXingshi:isXingshi];
}

- (NSString *)getFullPinyin:(NSString *)str isXingshi:(BOOL)isXingshi {
    NSArray * tokens = [HanziToPinyin getPinyin:str];
    NSMutableString * sb = [[NSMutableString alloc] init];

    if ([tokens count] > 0) {
        int i = 0;

        for (PinyinToken * token in tokens) {
            if (token.type == PINYIN_TOKEN_PINYIN) {
                NSString * pinyin = token.target;
                if (isXingshi && i == 0) {
                    pinyin = aliasFullLetters[token.source];
                    if (pinyin == nil || pinyin.length == 0) {
                        pinyin = token.target;
                    }
                }

                [sb appendString:pinyin.capitalizedString];
            }
            else {
                [sb appendString:token.source.capitalizedString];
            }

            i++;
        }
    }

    return sb;
}


- (NSString *)getShortPinyin:(NSString *)str isXingshi:(BOOL)isXingshi {
    NSArray * tokens = [HanziToPinyin getPinyin:str];
    NSMutableString * sb = [[NSMutableString alloc] init];

    if ([tokens count] > 0) {
        int i = 0;

        for (PinyinToken * token in tokens) {
            if (token.type == PINYIN_TOKEN_PINYIN) {
                NSString * pinyin = token.target;
                if (isXingshi && i == 0) {
                    pinyin = aliasFullLetters[token.source];
                    if (pinyin == nil || pinyin.length == 0) {
                        pinyin = token.target;
                    }
                }

                [sb appendString:[pinyin substringToIndex:1]];
            }
            else {
                [sb appendString:[token.source substringToIndex:1]];
            }

            i++;
        }
    }

    return sb;
}


- (NSArray *)getPinyin:(NSString *)str isXingshi:(BOOL)isXingshi {
    NSArray * tokens = [HanziToPinyin getPinyin:str];
    NSMutableString * sb = [[NSMutableString alloc] init];
    NSMutableString * sb2 = [[NSMutableString alloc] init];

    if ([tokens count] > 0) {
        int i = 0;

        for (PinyinToken * token in tokens) {
            if (token.type == PINYIN_TOKEN_PINYIN) {
                NSString * pinyin = token.target;
                if (isXingshi && i == 0) {
                    pinyin = aliasFullLetters[token.source];
                    if (pinyin == nil || pinyin.length == 0) {
                        pinyin = token.target;
                    }
                }

                [sb appendString:pinyin.capitalizedString];
                [sb2 appendString:[pinyin substringToIndex:1]];
            }
            else {
                [sb appendString:token.source.capitalizedString];
                [sb2 appendString:[token.source substringToIndex:1]];
            }

            i++;
        }
    }

    return @[sb, sb2];
}


@end