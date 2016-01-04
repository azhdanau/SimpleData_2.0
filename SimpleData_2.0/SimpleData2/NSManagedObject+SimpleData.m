//
//  NSManagedObject+SimpleData2.m
//  CheapTrip
//
//  Created by Sergey on 18.07.13.
//  Copyright (c) 2013 ITM House. All rights reserved.
//

#import "NSManagedObject+SimpleData.h"
#import "SDCoreDataCache.h"

@implementation NSManagedObject (SimpleData)

#pragma mark - Creating entities

+ (id)create {
	return [NSEntityDescription insertNewObjectForEntityForName: NSStringFromClass([self class])
                                         inManagedObjectContext: [self contextForCurrentThread]];
}

+ (id)findOrCreate:(id)objectId forKey:(NSString *)key {
    SDRequestParams *params = [SDRequestParams find:objectId byParam:key];
    NSManagedObject *object = [self findFirstWithRequestParams:params];
    if (object == nil) {
        object = [self create];
        [object setValue:objectId forKey:key];
    }
    return object;
}

+ (NSArray *)findOrCreateMultiple:(NSArray *)newObjects byKey:(NSString *)key dbKey:(NSString *)dbKey process:(SimpleDataFindOrCreateProcessBlock)processBlock {
    if (newObjects.count == 0) {
        return nil;
    }
    
    NSArray *sortedNewObjects = [newObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 valueForKey:key] compare:[obj2 valueForKey:key]];
    }];
    NSMutableArray *objectsIds = [NSMutableArray array];
    for (id obj in sortedNewObjects) {
        [objectsIds addObject:[obj valueForKey:key]];
    }
    NSArray *newObjectsIds = [objectsIds copy];
    
    NSFetchRequest *request = [self fetchRequestFromCurrentClass];
    request.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ IN %%@", dbKey], newObjectsIds];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:dbKey ascending:YES]];
    
    NSArray *results = [[self contextForCurrentThread] executeFetchRequest:request error:nil];
    
    NSInteger resultsIndex = 0;
    for (NSInteger objectIndex = 0; objectIndex < sortedNewObjects.count; objectIndex++) {
        id objectNode = sortedNewObjects[objectIndex];
        if  (resultsIndex < results.count && [[objectNode valueForKey:key] compare:[results[resultsIndex] valueForKey:dbKey]] == NSOrderedSame) {
            if (processBlock) {
                processBlock(results[resultsIndex++], objectNode, objectIndex);
            }
        } else {
            NSManagedObject *object = [self create];
            [object setValue:[objectNode valueForKey:key] forKey:dbKey];
            if (processBlock) {
                processBlock(object, objectNode, objectIndex);
            }
        }
    }
    return results;
}

#pragma mark - Deleting entities

+ (void)deleteObject:(id)obj {
	[[self contextForCurrentThread] deleteObject:obj];
}

+ (void)deleteObjects:(NSArray *)array {
    for (NSManagedObject *object in array) {
        [[self contextForCurrentThread] deleteObject:object];
    }
}

+ (void)deleteObjectsSet:(id<NSFastEnumeration>)set {
    for (NSManagedObject *object in set) {
        [[self contextForCurrentThread] deleteObject:object];
    }
}

+ (void)deleteAllObjects {
    NSArray *allObjects = [self findWithRequestParams:[SDRequestParams findAll]];
    [self deleteObjects:allObjects];
}

#pragma mark - Saving

+ (void)save {
    [[[SDCoreDataStack sharedStack] contextForCurrentThread] save:nil];
}

+ (void)closeCurrentContext {
    [[SDCoreDataStack sharedStack] closeContextForCurrentThread];
}

#pragma mark - Getting first entity

+ (NSArray *)findWithRequestParams:(SDRequestParams *)params {
    NSFetchRequest *request = [self fetchRequestFromCurrentClass];
    request.predicate = params.predicate;
    request.sortDescriptors = [params sortDescriptors];
    request.includesSubentities = params.includeSubentities;
    
    if (params.offset != -1) {
        request.fetchOffset = params.offset;
    }
    if (params.limit != -1) {
        request.fetchLimit = params.limit;
    }
    
    return [[self contextForCurrentThread] executeFetchRequest:request error:nil];
}

+ (id)findFirstWithRequestParams:(SDRequestParams *)params {
    NSFetchRequest *request = [self fetchRequestFromCurrentClass];
    request.predicate = params.predicate;
    request.sortDescriptors = [params sortDescriptors];
    request.includesSubentities = params.includeSubentities;
    request.fetchLimit = 1;
    
    return [[self contextForCurrentThread] executeFetchRequest:request error:nil].firstObject;
}

+ (NSInteger)countWithRequestParams:(SDRequestParams *)params {
    NSFetchRequest *request = [self fetchRequestFromCurrentClass];
    request.predicate = params.predicate;
    request.includesSubentities = params.includeSubentities;
    
    NSUInteger count = [[self contextForCurrentThread] countForFetchRequest:request error:nil];
    return count;
}

#pragma mark - Helpers

+ (NSFetchRequest *)fetchRequestFromCurrentClass {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [[SDCoreDataStack sharedStack] entityDescriptionForClass:[self class]];
    [fetchRequest setEntity:entity];
    return fetchRequest;
}

#pragma mark - Proxy

+ (NSManagedObjectContext *)contextForCurrentThread {
    return [[SDCoreDataStack sharedStack] contextForCurrentThread];
}

@end
