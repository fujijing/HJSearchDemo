
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "CSPPrecompile.h"
#pragma mark -

@interface UIView(TapGesture)

extern NSString *const TAPPED;

typedef void (^TapBlock)(UIView *view);

@property (nonatomic, assign) BOOL							tappable;	// same as tapEnabled
@property (nonatomic, assign) BOOL							tapEnabled;
@property (nonatomic, retain) NSString *					tapSignal;
@property (nonatomic, retain) NSObject *					tapObject;
@property (nonatomic, readonly) UITapGestureRecognizer *	tapGesture;
@property (nonatomic, strong) TapBlock tapBlock;

- (void)makeTappable;
- (void)makeTappable:(NSString *)signal;
- (void)makeTappable:(NSString *)signal withObject:(NSObject *)obj;
- (void)makeUntappable;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
