
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import <objc/runtime.h>
#import "UIView+TapGesture.h"

#pragma mark -

@interface __SingleTapGestureRecognizer : UITapGestureRecognizer
{
//	NSString *	_signalName;
//    __unsafe_unretained NSObject *	_signalObject;
}

@property (nonatomic, retain) NSString *	signalName;
@property (nonatomic, strong) NSObject *	signalObject;

@end

#pragma mark -

@implementation __SingleTapGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action
{
	self = [super initWithTarget:target action:action];
	if ( self )
	{
		self.numberOfTapsRequired = 1;
		self.numberOfTouchesRequired = 1;
		self.cancelsTouchesInView = YES;
		self.delaysTouchesBegan = YES;
		self.delaysTouchesEnded = YES;		
	}
	return self;
}

@end

#pragma mark -

@interface UIView(TapGesturePrivate)
- (void)didSingleTapped:(UITapGestureRecognizer *)tapGesture;
@end

#pragma mark -

@implementation UIView(TapGesture)

NSString *const TAPPED = @"evan.TAPPED";

static char block_key = 'b';

@dynamic tappable;
@dynamic tapEnabled;
@dynamic tapGesture;
@dynamic tapSignal;
@dynamic tapObject;


- (void)makeTappable
{
	[self makeTappable:nil];
}

- (void)makeTappable:(NSString *)signal
{
	[self makeTappable:signal withObject:nil];
}

- (void)makeTappable:(NSString *)signal withObject:(NSObject *)obj
{
	self.userInteractionEnabled = YES;
	
	__SingleTapGestureRecognizer * singleTapGesture = (__SingleTapGestureRecognizer *)self.tapGesture;
	if ( singleTapGesture )
	{
		singleTapGesture.signalName = signal;
		singleTapGesture.signalObject = obj;
	}
}

- (void)makeUntappable
{
	for ( UIGestureRecognizer * gesture in self.gestureRecognizers )
	{
		if ( [gesture isKindOfClass:[__SingleTapGestureRecognizer class]] )
		{
			[self removeGestureRecognizer:gesture];
		}
	}
}

- (BOOL)tappable
{
	return self.tapEnabled;
}

- (void)setTappable:(BOOL)flag
{
	self.tapEnabled = flag;
}

- (BOOL)tapEnabled
{
	for ( UIGestureRecognizer * gesture in self.gestureRecognizers )
	{
		if ( [gesture isKindOfClass:[__SingleTapGestureRecognizer class]] )
		{
			return gesture.enabled;
		}
	}
	
	return NO;
}

- (void)setTapEnabled:(BOOL)flag
{
	__SingleTapGestureRecognizer * singleTapGesture = (__SingleTapGestureRecognizer *)self.tapGesture;
	if ( singleTapGesture )
	{
		if ( flag )
		{
			self.userInteractionEnabled = YES;
		}
		else
		{
			self.userInteractionEnabled = NO;
        }
		
		singleTapGesture.enabled = flag;
	}
}

- (UITapGestureRecognizer *)tapGesture
{
	__SingleTapGestureRecognizer * tapGesture = nil;
	
	for ( UIGestureRecognizer * gesture in self.gestureRecognizers )
	{
		if ( [gesture isKindOfClass:[__SingleTapGestureRecognizer class]] )
		{
			tapGesture = (__SingleTapGestureRecognizer *)gesture;
		}
	}
	
	if ( nil == tapGesture )
	{
		tapGesture = [[__SingleTapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTapped:)];
		[self addGestureRecognizer:tapGesture];
	}
	
	return tapGesture;
}

- (NSString *)tapSignal
{
	__SingleTapGestureRecognizer * singleTapGesture = (__SingleTapGestureRecognizer *)self.tapGesture;
	if ( singleTapGesture )
	{
		return singleTapGesture.signalName;
	}
	
	return nil;
}

- (void)setTapSignal:(NSString *)signal
{
	__SingleTapGestureRecognizer * singleTapGesture = (__SingleTapGestureRecognizer *)self.tapGesture;
	if ( singleTapGesture )
	{
		singleTapGesture.signalName = signal;
	}
}

- (NSObject *)tapObject
{
	__SingleTapGestureRecognizer * singleTapGesture = (__SingleTapGestureRecognizer *)self.tapGesture;
	if ( singleTapGesture )
	{
		return singleTapGesture.signalObject;
	}
	
	return nil;
}

- (void)setTapObject:(NSObject *)object
{
	__SingleTapGestureRecognizer * singleTapGesture = (__SingleTapGestureRecognizer *)self.tapGesture;
	if ( singleTapGesture )
	{
		singleTapGesture.signalObject = object;
	}
}

- (void)didSingleTapped:(UITapGestureRecognizer *)tapGesture
{
	if ( [tapGesture isKindOfClass:[__SingleTapGestureRecognizer class]] )
	{
		__SingleTapGestureRecognizer * singleTapGesture = (__SingleTapGestureRecognizer *)tapGesture;
        
		if ( UIGestureRecognizerStateEnded == singleTapGesture.state )
		{
//			if ( singleTapGesture.signalName )
//			{
//				[[NSNotificationCenter defaultCenter] postNotificationName:singleTapGesture.signalName object:self];
//
//			}
//			else
//			{
//                [[NSNotificationCenter defaultCenter] postNotificationName:TAPPED object:self];
//            }

            if (self.tapBlock)
                self.tapBlock(self);
		}
	}
}

- (void)setTapBlock:(TapBlock)tapBlock
{
    objc_setAssociatedObject(self, &block_key, tapBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TapBlock)tapBlock
{
    TapBlock __tapBlock = objc_getAssociatedObject(self, &block_key);
    return __tapBlock;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
