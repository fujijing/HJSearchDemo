//
// Created by wow on 13-12-17.
// Copyright (c) 2013 chanjet. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "NSObject+CSPProperty.h"
#import "CSPUIMetrics.h"
#import "NSObject+UIStyle.h"
#import "NSDictionary+CSPExtension.h"
#import "NSString+CSPExtension.h"

#pragma mark -

@class CSPUIStyle;
@class CSPUIMetrics;

typedef	CSPUIStyle *	(^CSPUIStyleBlock)( void );
typedef	CSPUIStyle *	(^CSPUIStyleBlockN)( id first, ... );
typedef CSPUIStyle *	(^CSPUIStyleBlockS)( NSString * tag );
typedef CSPUIStyle *	(^CSPUIStyleBlockB)( BOOL flag );
typedef CSPUIStyle *	(^CSPUIStyleBlockCS)( Class clazz, NSString * tag );


@interface CSPUIStyle : NSObject

AS_STRING( COMPOSITION_ABSOLUTE )
AS_STRING( COMPOSITION_RELATIVE )
AS_STRING( COMPOSITION_LINEAR )		// default
AS_STRING( COMPOSITION_GRID )		//
AS_STRING( COMPOSITION_DOCK )		//
AS_STRING( COMPOSITION_FRAME )		//

AS_STRING( ORIENTATION_HORIZONAL )
AS_STRING( ORIENTATION_VERTICAL )	// default

@property (nonatomic, retain) NSString *				name;
@property (nonatomic, retain) NSMutableDictionary *		properties;

@property (nonatomic, readonly) CSPUIStyleBlockN		PROPERTY;

@property (nonatomic, readonly) NSString *				css;
@property (nonatomic, readonly) CSPUIStyleBlockN		CSS;

@property (nonatomic, readonly) CSPUIStyleBlockN		APPLY_FOR;

@property (nonatomic, readonly) CSPUIStyleBlockN		X;
@property (nonatomic, readonly) CSPUIStyleBlockN		Y;
@property (nonatomic, readonly) CSPUIStyleBlockN		W;
@property (nonatomic, readonly) CSPUIStyleBlockN		H;
@property (nonatomic, readonly) CSPUIStyleBlockN		GRAVITY;
@property (nonatomic, readonly) CSPUIStyleBlockN		COMPOSITION;
@property (nonatomic, readonly) CSPUIStyleBlockN		MARGIN;
@property (nonatomic, readonly) CSPUIStyleBlockN		MARGIN_TOP;
@property (nonatomic, readonly) CSPUIStyleBlockN		MARGIN_BOTTOM;
@property (nonatomic, readonly) CSPUIStyleBlockN		MARGIN_LEFT;
@property (nonatomic, readonly) CSPUIStyleBlockN		MARGIN_RIGHT;
@property (nonatomic, readonly) CSPUIStyleBlockN		MIN_WIDTH;
@property (nonatomic, readonly) CSPUIStyleBlockN		MAX_WIDTH;
@property (nonatomic, readonly) CSPUIStyleBlockN		MIN_HEIGHT;
@property (nonatomic, readonly) CSPUIStyleBlockN		MAX_HEIGHT;
@property (nonatomic, readonly) CSPUIStyleBlockN		PADDING;
@property (nonatomic, readonly) CSPUIStyleBlockN		PADDING_TOP;
@property (nonatomic, readonly) CSPUIStyleBlockN		PADDING_BOTTOM;
@property (nonatomic, readonly) CSPUIStyleBlockN		PADDING_LEFT;
@property (nonatomic, readonly) CSPUIStyleBlockN		PADDING_RIGHT;
@property (nonatomic, readonly) CSPUIStyleBlockN		ORIENTATION;
@property (nonatomic, readonly) CSPUIStyleBlockB		VISIBLE;

@property (nonatomic, readonly) CSPUIMetrics *			x;
@property (nonatomic, readonly) CSPUIMetrics *			y;
@property (nonatomic, readonly) CSPUIMetrics *			w;
@property (nonatomic, readonly) CSPUIMetrics *			h;
@property (nonatomic, readonly) NSString *			    gravity;
@property (nonatomic, readonly) NSString *				position;
@property (nonatomic, readonly) NSString *				composition;
@property (nonatomic, readonly) CSPUIMetrics *			margin_top;
@property (nonatomic, readonly) CSPUIMetrics *			margin_bottom;
@property (nonatomic, readonly) CSPUIMetrics *			margin_left;
@property (nonatomic, readonly) CSPUIMetrics *			margin_right;
@property (nonatomic, readonly) CSPUIMetrics *			min_width;
@property (nonatomic, readonly) CSPUIMetrics *			max_width;
@property (nonatomic, readonly) CSPUIMetrics *			min_height;
@property (nonatomic, readonly) CSPUIMetrics *			max_height;
@property (nonatomic, readonly) CSPUIMetrics *			padding_top;
@property (nonatomic, readonly) CSPUIMetrics *			padding_bottom;
@property (nonatomic, readonly) CSPUIMetrics *			padding_left;
@property (nonatomic, readonly) CSPUIMetrics *			padding_right;
@property (nonatomic, readonly) NSString *				align;
@property (nonatomic, readonly) NSString *				v_align;
@property (nonatomic, readonly) NSString *				floating;
@property (nonatomic, readonly) NSString *				v_floating;
@property (nonatomic, readonly) NSString *				orientation;

#pragma mark relative params
@property (nonatomic, readonly) NSString *				aboveOf;
@property (nonatomic, readonly) NSString *				belowOf;
@property (nonatomic, readonly) NSString *				leftOf;
@property (nonatomic, readonly) NSString *				rightOf;
@property (nonatomic, readonly) NSString *				alignTop;
@property (nonatomic, readonly) NSString *				alignLeft;
@property (nonatomic, readonly) NSString *				alignRight;
@property (nonatomic, readonly) NSString *				alignBottom;
@property (nonatomic, readonly) NSString *				alignParentLeft;
@property (nonatomic, readonly) NSString *				alignParentTop;
@property (nonatomic, readonly) NSString *				alignParentRight;
@property (nonatomic, readonly) NSString *				alignParentBottom;
@property (nonatomic, readonly) NSString *				alginCenter;
@property (nonatomic, readonly) NSString *				centerHorizontal;
@property (nonatomic, readonly) NSString *				centerVertical;

- (void)applyFor:(id)object;

- (void)mergeToStyle:(CSPUIStyle *)style;

@end