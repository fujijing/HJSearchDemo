//
// Created by 罗宋汤 on 14-1-18.
// Copyright (c) 2014 chanjet. All rights reserved.
//


#import <Foundation/Foundation.h>

#pragma mark -

#undef	AS_PACKAGE
#define AS_PACKAGE( __parentClass, __class, __propertyName ) \
		@class __class; \
		@interface __parentClass (AutoLoad_##__propertyName) \
		@property (nonatomic, readonly) __class * __propertyName; \
		@end

#undef	DEF_PACKAGE
#define DEF_PACKAGE( __parentClass, __class, __propertyName ) \
		@implementation __parentClass (AutoLoad_##__propertyName) \
		@dynamic __propertyName; \
		- (__class *)__propertyName \
		{ \
			return [__class sharedInstance]; \
		} \
		@end

#undef	AS_PACKAGE_INSTANCE
#define AS_PACKAGE_INSTANCE( __parentClass, __class, __propertyName ) \
		@class __class; \
		@interface __parentClass (AutoLoad_##__propertyName) \
		@property (nonatomic, readonly) __class * __propertyName; \
		@end \
		@interface __class : NSObject \
		AS_SINGLETON( __class ); \
		@end

#undef	DEF_PACKAGE_INSTANCE
#define DEF_PACKAGE_INSTANCE( __parentClass, __class, __propertyName ) \
		@implementation __parentClass (AutoLoad_##__propertyName) \
		@dynamic __propertyName; \
		- (__class *)__propertyName \
		{ \
			return [__class sharedInstance]; \
		} \
		@end \
		@implementation __class \
		DEF_SINGLETON( __class ); \
		@end

#pragma mark -

@interface NSObject(AutoLoading)
+ (BOOL)autoLoad;
@end

@interface CSPPackage : NSObject
@property (nonatomic, readonly) NSArray * loadedPackages;
@end