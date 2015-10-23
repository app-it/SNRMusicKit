#import "SMKiTunesAlbum.h"
#import "NSManagedObjectContext+SMKAdditions.h"
#import "SMKiTunesConstants.h"
#import "SMKiTunesTrack.h"

@implementation SMKiTunesAlbum

- (void)fetchTracksWithSortDescriptors:(NSArray *)sortDescriptors
                             predicate:(NSPredicate *)predicate
                             batchSize:(NSUInteger)batchSize
                            fetchLimit:(NSUInteger)fetchLimit
                     completionHandler:(void(^)(NSArray *tracks, NSError *error))handler
{
    NSPredicate *finalPredicate = [self _compoundTrackPredicateWithPredicate:predicate];
    [[self managedObjectContext] SMK_asyncFetchWithEntityName:SMKiTunesEntityNameTrack
                                              sortDescriptors:sortDescriptors
                                                    predicate:finalPredicate
                                                    batchSize:batchSize
                                                   fetchLimit:fetchLimit
                                            completionHandler:handler];
}

+ (NSSet *)supportedSortKeys
{
    return [NSSet setWithObjects:@"name", @"releaseYear", @"artist", @"isCompilation", @"rating", nil];
}

- (NSTimeInterval)duration
{
    return [[self valueForKey:@"tracks.@sum.duration"] floatValue];
}

- (BOOL)isCompilation
{
    return [self cd_isCompilationValue];
}

- (NSUInteger)releaseYear
{
    return [self cd_releaseYearValue];
}

#pragma mark - Private

- (NSPredicate *)_compoundTrackPredicateWithPredicate:(NSPredicate *)predicate
{
    NSPredicate *basePredicate = [NSPredicate predicateWithFormat:@"album == %@", self];
    if (predicate)
        basePredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[basePredicate, predicate]];
    return basePredicate;
}
@end
