//
//  NSMutableArray+SMKAdditions.m
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-25.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import "NSMutableArray+SMKAdditions.h"

@implementation NSMutableArray (SMKAdditions)
- (void)SMK_processWithSortDescriptors:(NSArray *)sortDescriptors predicate:(NSPredicate*)predicate fetchLimit:(NSUInteger)fetchLimit
{
    if (predicate)
        [self filterUsingPredicate:predicate];
    if ([sortDescriptors count])
        [self sortUsingDescriptors:sortDescriptors];
    if (fetchLimit > [self count])
        [self removeObjectsInRange:NSMakeRange(fetchLimit, [self count] - fetchLimit)];
}
@end
