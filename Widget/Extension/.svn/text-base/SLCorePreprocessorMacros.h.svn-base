//
//  SLCorePreprocessorMacros.h
//  UMPClient
//
//  Created by 宋永强 on 12-8-18.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Add this macro before each category implementation, so we don't have to use
 * -all_load or -force_load to load object files from static libraries that only contain
 * categories and no classes.
 * See http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html for more info.
 */
#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name:NSObject @end \
@implementation TT_FIX_CATEGORY_BUG_##name @end


///////////////////////////////////////////////////////////////////////////////////////////////////
// Flags

/**
 * For when the flag might be a set of bits, this will ensure that the exact set of bits in
 * the flag have been set in the value.
 */
#define IS_MASK_SET(value, flag)  (((value) & (flag)) == (flag))
