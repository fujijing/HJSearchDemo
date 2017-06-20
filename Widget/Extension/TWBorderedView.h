//
// Created by wow on 13-12-29.
// Copyright (c) 2013 chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Simple UIView for drawing top and bottom borders with optional insets in a view.
 */
@interface TWBorderedView : UIView

///--------------------------
/// @name Drawing the Borders
///--------------------------

/**
 The top border color. The default is `nil`.

 @see topInsetColor
 */
@property (nonatomic, strong) UIColor *topBorderColor;

/**
 The top inset color. The default is `nil`.

 @see topBorderColor
 */
@property (nonatomic, strong) UIColor *topInsetColor;

/**
 The right border color. The default is `nil`.

 @see rightInsetColor
 */
@property (nonatomic, strong) UIColor *rightBorderColor;

/**
 The right inset color. The default is `nil`.

 @see rightBorderColor
 */
@property (nonatomic, strong) UIColor *rightInsetColor;

/**
 The bottom border color. The default is `nil`.

 @see bottomInsetColor
 */
@property (nonatomic, strong) UIColor *bottomBorderColor;

/**
 The bottom inset color. The default is `nil`.

 @see bottomBorderColor
 */
@property (nonatomic, strong) UIColor *bottomInsetColor;

/**
 The left border color. The default is `nil`.

 @see leftInsetColor
 */
@property (nonatomic, strong) UIColor *leftBorderColor;

/**
 The left inset color. The default is `nil`.

 @see leftBorderColor
 */
@property (nonatomic, strong) UIColor *leftInsetColor;

@end