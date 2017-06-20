//
// Created by wow on 13-12-17.
// Copyright (c) 2013 chanjet. All rights reserved.
//


#import "UIImage+Theme.h"
#import "SLCorePreprocessorMacros.h"
#import "NSString+CSPExtension.h"

TT_FIX_CATEGORY_BUG(UIView_Theme)


#pragma mark -

@interface UIImage(ThemePrivate)
- (void)addCircleRectToPath:(CGRect)rect context:(CGContextRef)context;
@end

#pragma mark -

@implementation UIImage(Theme)

- (UIImage *)transprent
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo( self.CGImage );

    if ( kCGImageAlphaFirst == alpha ||
            kCGImageAlphaLast == alpha ||
            kCGImageAlphaPremultipliedFirst == alpha ||
            kCGImageAlphaPremultipliedLast == alpha )
    {
        return self;
    }

    CGImageRef	imageRef = self.CGImage;
    size_t		width = CGImageGetWidth(imageRef);
    size_t		height = CGImageGetHeight(imageRef);

    CGContextRef context = CGBitmapContextCreate( NULL, width, height, 8, 0, CGImageGetColorSpace(imageRef), kCGBitmapByteOrderDefault|kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage( context, CGRectMake(0, 0, width, height), imageRef );

    CGImageRef	resultRef = CGBitmapContextCreateImage( context );
    UIImage *	result = [UIImage imageWithCGImage:resultRef];

    CGContextRelease( context );
    CGImageRelease( resultRef );

    return result;
}

- (UIImage *)resize:(CGSize)newSize
{
    CGImageRef imgRef = self.CGImage;

    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);

    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if ( width > newSize.width || height > newSize.height )
    {
        CGFloat ratio = width/height;
        if ( ratio > 1 )
        {
            bounds.size.width = newSize.width;
            bounds.size.height = bounds.size.width / ratio;
        }
        else
        {
            bounds.size.height = newSize.height;
            bounds.size.width = bounds.size.height * ratio;
        }
    }

    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = self.imageOrientation;
    switch(orient) {

        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;

        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;

        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;

        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];

    }

    UIGraphicsBeginImageContext(bounds.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    if ( orient == UIImageOrientationRight || orient == UIImageOrientationLeft )
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }

    CGContextConcatCTM(context, transform);

    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage * imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return imageCopy;
}

// Adds a rectangular path to the given context and rounds its corners by the given extents
// Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/

- (void)addCircleRectToPath:(CGRect)rect context:(CGContextRef)context
{
    CGContextSaveGState( context );
    CGContextTranslateCTM( context, CGRectGetMinX(rect), CGRectGetMinY(rect) );
    CGContextSetShouldAntialias( context, true );
    CGContextSetAllowsAntialiasing( context, true );
    CGContextAddEllipseInRect( context, rect );
    CGContextClosePath( context );
    CGContextRestoreGState( context );
}

- (UIImage *)rounded
{
    UIImage * image = [self transprent];
    if ( nil == image )
        return nil;

    CGSize imageSize = image.size;
    imageSize.width = floorf( imageSize.width );
    imageSize.height = floorf( imageSize.height );

    CGFloat imageWidth = fminf(imageSize.width, imageSize.height);
    CGFloat imageHeight = imageWidth;

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate( NULL,
            imageWidth,
            imageHeight,
            CGImageGetBitsPerComponent(image.CGImage),
            imageWidth * 4,
            colorSpace,
            kCGImageAlphaPremultipliedLast );

    CGContextBeginPath(context);
    CGRect circleRect;
    circleRect.origin.x = 0;
    circleRect.origin.y = 0;
    circleRect.size.width = imageWidth;
    circleRect.size.height = imageHeight;
    [self addCircleRectToPath:circleRect context:context];
    CGContextClosePath(context);
    CGContextClip(context);

    CGRect drawRect;
    drawRect.origin.x = 0;
    drawRect.origin.y = 0;
    drawRect.size.width = imageWidth;
    drawRect.size.height = imageHeight;
    CGContextDrawImage(context, drawRect, image.CGImage);

    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease( colorSpace );

    UIImage * roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);

    return roundedImage;
}

- (UIImage *)rounded:(CGRect)circleRect
{
    UIImage * image = [self transprent];
    if ( nil == image )
        return nil;

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate( NULL,
            circleRect.size.width,
            circleRect.size.height,
            CGImageGetBitsPerComponent( image.CGImage ),
            circleRect.size.width * 4,
            colorSpace,
            kCGImageAlphaPremultipliedLast );

    CGContextBeginPath(context);
    [self addCircleRectToPath:circleRect context:context];
    CGContextClosePath(context);
    CGContextClip(context);

    CGRect drawRect;
    drawRect.origin.x = 0; //(imageSize.width - imageWidth) / 2.0f;
    drawRect.origin.y = 0; //(imageSize.height - imageHeight) / 2.0f;
    drawRect.size.width = circleRect.size.width;
    drawRect.size.height = circleRect.size.height;
    CGContextDrawImage(context, drawRect, image.CGImage);

    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    UIImage * roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);

    return roundedImage;
}

- (UIImage *)stretched
{
    CGFloat leftCap = floorf(self.size.width / 2.0f);
    CGFloat topCap = floorf(self.size.height / 2.0f);
    return [self stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}

- (UIImage *)stretched:(UIEdgeInsets)capInsets
{
    return [self resizableImageWithCapInsets:capInsets];
}

- (UIImage *)grayscale
{
    CGSize size = self.size;
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);

    CGContextDrawImage(context, rect, [self CGImage]);
    CGImageRef grayscale = CGBitmapContextCreateImage(context);
    CGContextRelease(context);

    UIImage * image = [UIImage imageWithCGImage:grayscale];
    CFRelease(grayscale);

    return image;
}

- (UIColor *)patternColor
{
    return [UIColor colorWithPatternImage:self];
}

+ (UIImage *)imageFromString:(NSString *)name
{
    NSArray *	array = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *	imageName = [array objectAtIndex:0];

    imageName = [imageName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];

    BOOL grayed = NO;
    BOOL rounded = NO;
    BOOL streched = NO;

    if ( array.count > 1 )
    {
        for (__strong NSString * attr in [array subarrayWithRange:NSMakeRange(1, array.count - 1)] )
        {
            attr = attr.trim.unwrap;

            if ( NSOrderedSame == [attr compare:@"stretch" options:NSCaseInsensitiveSearch] ||
                    NSOrderedSame == [attr compare:@"stretched" options:NSCaseInsensitiveSearch] )
            {
                streched = YES;
            }
            else if ( NSOrderedSame == [attr compare:@"round" options:NSCaseInsensitiveSearch] ||
                    NSOrderedSame == [attr compare:@"rounded" options:NSCaseInsensitiveSearch] )
            {
                rounded = YES;
            }
            else if ( NSOrderedSame == [attr compare:@"gray" options:NSCaseInsensitiveSearch] ||
                    NSOrderedSame == [attr compare:@"grayed" options:NSCaseInsensitiveSearch] ||
                    NSOrderedSame == [attr compare:@"grayScale" options:NSCaseInsensitiveSearch] ||
                    NSOrderedSame == [attr compare:@"gray-scale" options:NSCaseInsensitiveSearch] )
            {
                grayed = YES;
            }
        }
    }

    UIImage * image = [UIImage imageNamed:imageName];
    if ( image )
    {
        if ( rounded )
        {
            image = image.rounded;
        }

        if ( grayed )
        {
            image = image.grayscale;
        }

        if ( streched )
        {
            image = image.stretched;
        }
    }

    return image;
}

+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)imageFromString:(NSString *)name stretched:(UIEdgeInsets)capInsets
{
    UIImage * image = [self imageFromString:name];
    if ( nil == image )
        return nil;

    return [image resizableImageWithCapInsets:capInsets];
}

- (UIImage *)merge:(UIImage *)image
{
    CGSize canvasSize;
    canvasSize.width = fmaxf( self.size.width, image.size.width );
    canvasSize.height = fmaxf( self.size.height, image.size.height );

//	UIGraphicsBeginImageContext( canvasSize );
    UIGraphicsBeginImageContextWithOptions( canvasSize, NO, self.scale );

    CGPoint offset1;
    offset1.x = (canvasSize.width - self.size.width) / 2.0f;
    offset1.y = (canvasSize.height - self.size.height) / 2.0f;

    CGPoint offset2;
    offset2.x = (canvasSize.width - image.size.width) / 2.0f;
    offset2.y = (canvasSize.height - image.size.height) / 2.0f;

    [self drawAtPoint:offset1 blendMode:kCGBlendModeNormal alpha:1.0f];
    [image drawAtPoint:offset2 blendMode:kCGBlendModeNormal alpha:1.0f];

    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return result;
}

- (NSData *)dataWithExt:(NSString *)ext
{
    if ( [ext compare:@"png" options:NSCaseInsensitiveSearch] )
    {
        return UIImagePNGRepresentation(self);
    }
    else if ( [ext compare:@"jpg" options:NSCaseInsensitiveSearch] )
    {
        return UIImageJPEGRepresentation(self, 0);
    }
    else
    {
        return nil;
    }
}

- (UIImage *)scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark Effects
- (UIImage *)applyLightEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [self applyBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyExtraLightEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
    return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyDarkEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
    return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor
{
    const CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    size_t componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
    if (componentCount == 2) {
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    }
    else {
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return [self applyBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}


- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        PLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        PLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        PLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }

    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;

    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);

        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);

        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);

        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            uint32_t radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }

    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);

    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);

    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }

    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }

    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return outputImage;
}

@end

#pragma mark
