//
// Created by wow on 13-12-16.
// Copyright (c) 2013 chanjet. All rights reserved.
//


#import <Foundation/Foundation.h>

#undef	__ON__
#define __ON__		(1)

#undef	__OFF__
#define __OFF__		(0)

#define __CSP_DEVELOPMENT__         (__OFF__)

#define __CSP_LOG__					(__CSP_DEVELOPMENT__)	// Whether enable logging?
#define __CSP_ASSERT__				(__CSP_DEVELOPMENT__)	// Whether enable assertion?
#define __CSP_PERFORMANCE__			(__CSP_DEVELOPMENT__)	// Whether enable performance testing?

#define __CSP_SELECTOR_STYLE1__		(__ON__)				// handle_{ClassName}
#define __CSP_SELECTOR_STYLE2__		(__ON__)				// handle_{ClassName}_{MethodName}
#define __CSP_SELECTOR_STYLE3__		(__ON__)				// handle_{namespace}_{tag} or handle_{tag}
#define __CSP_SELECTOR_STYLE4__		(__ON__)				// handle_{signal}

#undef	UNUSED
#define	UNUSED( __x ) \
		{ \
			id __unused_var__ __attribute__((unused)) = (__x); \
		}


//#if defined(__CSP_LOG__) && __CSP_LOG__
//#undef	NSLog
//#define	NSLog	CSPLog
//#endif	// #if (__ON__ == __CSPLOG__)


#ifdef __IPHONE_6_0

#define UILineBreakModeWordWrap			NSLineBreakByWordWrapping
#define UILineBreakModeCharacterWrap	NSLineBreakByCharWrapping
#define UILineBreakModeClip				NSLineBreakByClipping
#define UILineBreakModeHeadTruncation	NSLineBreakByTruncatingHead
#define UILineBreakModeTailTruncation	NSLineBreakByTruncatingTail
#define UILineBreakModeMiddleTruncation	NSLineBreakByTruncatingMiddle

#define UITextAlignmentLeft				NSTextAlignmentLeft
#define UITextAlignmentCenter			NSTextAlignmentCenter
#define UITextAlignmentRight			NSTextAlignmentRight

#endif	// #ifdef __IPHONE_6_0
