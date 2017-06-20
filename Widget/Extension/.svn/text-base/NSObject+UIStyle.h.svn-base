//
// Created by wow on 13-12-14.
// Copyright (c) 2013 wow. All rights reserved.
//


#import <Foundation/Foundation.h>

#undef	SUPPORT_STYLING
#define SUPPORT_STYLING( __flag ) \
		+ (BOOL)supportForUIStyling { return __flag; }

@interface NSObject (UIStyle)

+ (BOOL)supportForUIStyling;
- (void)resetUIStyleProperties;
- (void)applyUIStyleProperties:(NSDictionary *)properties;

@end