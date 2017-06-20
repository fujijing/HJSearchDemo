//
// Created by wow on 13-12-14.
// Copyright (c) 2013 chanjet. All rights reserved.
//


#import <Foundation/Foundation.h>

#pragma mark -

typedef NSString *			(^NSStringAppendBlock)( id format, ... );
typedef NSString *			(^NSStringReplaceBlock)( NSString * string, NSString * string2 );

typedef NSMutableString *	(^NSMutableStringAppendBlock)( id format, ... );
typedef NSMutableString *	(^NSMutableStringReplaceBlock)( NSString * string, NSString * string2 );

#pragma mark -

@interface NSString(CSPExtension)

@property (nonatomic, readonly) NSStringAppendBlock		APPEND;
@property (nonatomic, readonly) NSStringAppendBlock		LINE;
@property (nonatomic, readonly) NSStringReplaceBlock	REPLACE;

@property (nonatomic, readonly) NSData *				data;
@property (nonatomic, readonly) NSDate *				date;

@property (nonatomic, readonly) NSString *				MD5;
@property (nonatomic, readonly) NSData *				MD5Data;

// thanks to @uxyheaven
@property (nonatomic, readonly) NSString *				SHA1;

@property (nonatomic, readonly) BOOL                empty;

- (NSString *)URLEncodingUTF8;

- (NSArray *)allURLs;

- (NSString *)urlByAppendingDict:(NSDictionary *)params;
- (NSString *)urlByAppendingArray:(NSArray *)params;
- (NSString *)urlByAppendingKeyValues:(id)first, ...;

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict;
+ (NSString *)queryStringFromArray:(NSArray *)array;
+ (NSString *)queryStringFromKeyValues:(id)first, ...;

- (NSString *)URLEncoding;
- (NSString *)URLDecoding;

- (NSString *)trim;

- (NSString *)ltrim;

- (NSString *)rtrim;

- (NSString *)unwrap;

- (BOOL)match:(NSString *)expression;
- (BOOL)matchAnyOf:(NSArray *)array;

- (BOOL)notEmpty;

- (BOOL)is:(NSString *)other;
- (BOOL)isNot:(NSString *)other;

- (BOOL)isValueOf:(NSArray *)array;
- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens;

- (BOOL)isTelephone;
- (BOOL)isMobilePhone;
- (BOOL)isMobilePhone2;
- (BOOL)isUserName;
- (BOOL)isPassword;
- (BOOL)isEmail;
- (BOOL)isEmail2;
- (BOOL)isUrl;
- (BOOL)isUrl2;
- (BOOL)isUrl3;

- (NSUInteger)numberOccurrences:(NSString *)str;

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width;
- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

@end

#pragma mark -

@interface NSMutableString(CSPExtension)

@property (nonatomic, readonly) NSMutableStringAppendBlock	APPEND;
@property (nonatomic, readonly) NSMutableStringAppendBlock	LINE;
@property (nonatomic, readonly) NSMutableStringReplaceBlock	REPLACE;

@end
