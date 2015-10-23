//
//  SMKArtworkCache.h
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-25.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMKPlatformImports.h"

//
// Cross platform artwork cache that handles on disk and in memory caching
// This class is largely inspired by JMImageCache by Jake Marsh (who is incredibly awesome)
// <https://github.com/jakemarsh/JMImageCache>
//

@interface SMKArtworkCache : NSCache
/**
 @return The shared instance of SMKArtworkCache
 */
+ (instancetype)sharedCache;

/**
 Asynchronously fetches a cached image and calls the completion handler
 @param key The cached image key
 @param handler Hander block called with the fetched image
 */
- (void)fetchImageForKey:(NSString *)key completionHandler:(void (^)(SMKPlatformNativeImage *image))handler;

/**
 Saves an image in the cache with the specified key
 @param key The key to save the cached image under
 @param image The image to save
 */
- (void)setCachedImage:(SMKPlatformNativeImage *)image forKey:(NSString *)key;

/**
 Removes the image with the specified key from the cache
 @param key The key of the image to remove from the cache
 */
- (void)removeCachedImageForKey:(NSString *)key;
@end
