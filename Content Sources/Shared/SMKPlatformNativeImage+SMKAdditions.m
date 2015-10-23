//
//  SMKPlatformNativeImage+SMKAdditions.m
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-26.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import "SMKPlatformNativeImage+SMKAdditions.h"

@implementation SMKPlatformNativeImage (SMKAdditions)

- (SMKPlatformNativeImage *)imageScaledToFitSize:(CGSize)size
{
    return [self imageToFitSize:size method:SMKImageResizeScale];
}

- (SMKPlatformNativeImage *)imageCroppedToFitSize:(CGSize)size
{
    return [self imageToFitSize:size method:SMKImageResizeCrop];
}

- (SMKPlatformNativeImage *)imageToFitSize:(CGSize)size method:(SMKImageResizingMethod)resizeMethod
{
    #if TARGET_OS_MAC
    #else
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    #endif
    CGRect destRect = CGRectMake(0.f, 0.f, size.width, size.height);
    CGFloat sourceWidth = [self size].width;
    CGFloat sourceHeight = [self size].height;
    CGFloat targetWidth = destRect.size.width;
    CGFloat targetHeight = destRect.size.height;
    BOOL cropping = !(resizeMethod == SMKImageResizeScale);
    
    // Calculate aspect ratios
    CGFloat sourceRatio = sourceWidth / sourceHeight;
    CGFloat targetRatio = targetWidth / targetHeight;
    
    // Determine what side of the source image to use for proportional scaling
    BOOL scaleWidth = (sourceRatio <= targetRatio);
    // Deal with the case of just scaling proportionally to fit, without cropping
    scaleWidth = (cropping) ? scaleWidth : !scaleWidth;

    // Proportionally scale source image
    CGFloat scalingFactor, scaledWidth, scaledHeight;
    if (scaleWidth) {
        scalingFactor = 1.0 / sourceRatio;
        scaledWidth = targetWidth;
        scaledHeight = round(targetWidth * scalingFactor);
    } else {
        scalingFactor = sourceRatio;
        scaledWidth = round(targetHeight * scalingFactor);
        scaledHeight = targetHeight;
    }
    CGFloat scaleFactor = scaledHeight / sourceHeight;
    // Calculate compositing rectangles
    CGRect sourceRect;
    if (cropping) {
        float destX, destY;
        if (resizeMethod == SMKImageResizeCrop) {
            // Crop center
            destX = round((scaledWidth - targetWidth) / 2.0);
            destY = round((scaledHeight - targetHeight) / 2.0);
        } else if (resizeMethod == SMKImageResizeCropStart) {
            // Crop top or left (prefer top)
            if (scaleWidth) {
				// Crop top
				destX = round((scaledWidth - targetWidth) / 2.0);
				destY = round(scaledHeight - targetHeight);
            } else {
				// Crop left
                destX = 0.0;
				destY = round((scaledHeight - targetHeight) / 2.0);
            }
        } else if (resizeMethod == SMKImageResizeCropEnd) {
            // Crop bottom or right
            if (scaleWidth) {
				// Crop bottom
				destX = 0.0;
				destY = 0.0;
            } else {
				// Crop right
				destX = round(scaledWidth - targetWidth);
				destY = round((scaledHeight - targetHeight) / 2.0);
            }
        }
        sourceRect = CGRectMake(destX / scaleFactor, destY / scaleFactor,
                                targetWidth / scaleFactor, targetHeight / scaleFactor);
    } else {
        sourceRect = CGRectMake(0, 0, sourceWidth, sourceHeight);
        destRect = CGRectMake(0, 0, scaledWidth, scaledHeight);
    }
#if TARGET_OS_MAC
    NSImage *result = [[NSImage alloc] initWithSize:NSSizeFromCGSize(size)];
    [result lockFocus];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    [self drawInRect:destRect fromRect:sourceRect operation:NSCompositeSourceOver fraction:1.0];
    [result unlockFocus];
    return result;
#else
    UIGraphicsBeginImageContextWithOptions(destRect.size, YES, 0.0); // 0.0 for scale means "correct scale for device's main screen".
    CGImageRef sourceImg = CGImageCreateWithImageInRect([self CGImage], sourceRect); // cropping happens here.
    image = [UIImage imageWithCGImage:sourceImg scale:0.0 orientation:self.imageOrientation]; // create cropped UIImage.
    [image drawInRect:destRect]; // the actual scaling happens here, and orientation is taken care of automatically.
    CGImageRelease(sourceImg);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
#endif
}
@end
