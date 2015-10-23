//
//  SMKSpotify+Loading.h
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-25.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface SPTrack (Loading)
- (void)SMK_loadHierarchy:(dispatch_group_t)group array:(NSMutableArray *)array;
@end

@interface SPAlbum (Loading)
- (void)SMK_loadHierarchy:(dispatch_group_t)group array:(NSMutableArray *)array;
@end

@interface SPArtist (Loading)
- (void)SMK_loadHierarchy:(dispatch_group_t)group array:(NSMutableArray *)array;
@end

@interface SPPlaylist (Loading)
- (void)SMK_loadHierarchy:(dispatch_group_t)group array:(NSMutableArray *)array;
@end

@interface SPPlaylistItem (Loading)
- (void)SMK_loadHierarchy:(dispatch_group_t)group array:(NSMutableArray *)array;
@end

@interface SPPlaylistContainer (Loading)
- (void)SMK_loadHierarchy:(dispatch_group_t)group array:(NSMutableArray *)array;
@end

@interface SPAlbumBrowse (Loading)
- (void)SMK_loadHierarchy:(dispatch_group_t)group array:(NSMutableArray *)array;
@end

@interface SPArtistBrowse (Loading)
- (void)SMK_loadHierarchy:(dispatch_group_t)group array:(NSMutableArray *)array;
@end