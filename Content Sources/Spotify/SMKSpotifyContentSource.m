//
//  SMKSpotifyContentSource.m
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-24.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import "SMKSpotifyContentSource.h"
#import "NSObject+SMKSpotifyAdditions.h"
#import "SMKSpotifyConstants.h"

@implementation SMKSpotifyContentSource
#pragma mark - SMKContentSource

- (NSString *)name { return @"Spotify"; }
+ (BOOL)supportsBatching { return NO; }

- (NSArray *)playlistsWithSortDescriptors:(NSArray *)sortDescriptors
                                batchSize:(NSUInteger)batchSize
                               fetchLimit:(NSUInteger)fetchLimit
                                predicate:(NSPredicate *)predicate
                                withError:(NSError **)error
{
    [self SMK_spotifyWaitUntilLoaded];
    return [self _allPlaylistsWithSortDescriptors:sortDescriptors
                                       fetchLimit:fetchLimit
                                        predicate:predicate];
    
}

- (void)fetchPlaylistsWithSortDescriptors:(NSArray *)sortDescriptors
                                batchSize:(NSUInteger)batchSize
                               fetchLimit:(NSUInteger)fetchLimit
                                predicate:(NSPredicate *)predicate
                        completionHandler:(void(^)(NSArray *playlists, NSError *error))handler
{
    if (!self.loaded) {
        [SPAsyncLoading waitUntilLoaded:self timeout:SMKSpotifyDefaultLoadingTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
            handler([self _allPlaylistsWithSortDescriptors:sortDescriptors
                                                fetchLimit:fetchLimit
                                                 predicate:predicate], nil);
        }];
    } else {
        handler([self _allPlaylistsWithSortDescriptors:sortDescriptors
                                            fetchLimit:fetchLimit
                                             predicate:predicate], nil);
    }
}

#pragma mark - Private

- (NSArray *)_allPlaylistsWithSortDescriptors:(NSArray *)sortDescriptors fetchLimit:(NSUInteger)fetchLimit predicate:(NSPredicate *)predicate
{
    NSMutableArray *playlists = [NSMutableArray arrayWithObjects:self.inboxPlaylist, self.starredPlaylist, nil];
    [playlists addObjectsFromArray:[self.userPlaylists flattenedPlaylists]];
    if (predicate)
        [playlists filterUsingPredicate:predicate];
    if (sortDescriptors)
        [playlists sortUsingDescriptors:sortDescriptors];
    if (fetchLimit)
        [playlists removeObjectsInRange:NSMakeRange(fetchLimit, [playlists count] - fetchLimit)];
    return playlists;
}
@end
