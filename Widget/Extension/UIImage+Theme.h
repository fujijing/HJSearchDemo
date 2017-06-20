//
// Created by wow on 13-12-17.
// Copyright (c) 2013 chanjet. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>

@interface UIImage (Theme)

- (UIImage *)transprent;

- (UIImage *)rounded;
- (UIImage *)rounded:(CGRect)rect;

- (UIImage *)stretched;
- (UIImage *)stretched:(UIEdgeInsets)capInsets;

- (UIImage *)grayscale;

- (UIColor *)patternColor;

+ (UIImage *)imageFromString:(NSString *)name;
+ (UIImage *)imageFromColor:(UIColor *)color;
+ (UIImage *)imageFromString:(NSString *)name stretched:(UIEdgeInsets)capInsets;

- (UIImage *)merge:(UIImage *)image;
- (UIImage *)resize:(CGSize)newSize;

- (NSData *)dataWithExt:(NSString *)ext;

#pragma mark -
- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end