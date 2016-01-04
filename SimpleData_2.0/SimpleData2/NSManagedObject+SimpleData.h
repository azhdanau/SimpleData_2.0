//
//  NSManagedObject+SimpleData2.h
//  CheapTrip
//
//  Created by Sergey on 18.07.13.
//  Copyright (c) 2013 ITM House. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SDCoreDataStack.h"
#import "SDRequestParams.h"

typedef NSManagedObject*(^SimpleDataMergeArrayBlock)(id node);
typedef NSManagedObject*(^SimpleDataDictionaryBlock)(id key, id value);
typedef void(^SimpleDataFindOrCreateProcessBlock)(id object, id objectNode, NSInteger objectIndex);

/**
 *  You should use this category like [MYDataBaseClass methodXXX]
 */
@interface NSManagedObject (SimpleData)

/**
 *  Return array of objects for provided params
 */
+ (NSArray *)findWithRequestParams:(SDRequestParams *)params;

/**
 *  Return first found object for provided params
 */
+ (id)findFirstWithRequestParams:(SDRequestParams *)params;

/**
 *  Return count of objects for provided params
 */
+ (NSInteger)countWithRequestParams:(SDRequestParams *)params;

/**
 *  Create new instance of object
 *  Need to call SAVE context
 */
+ (id)create;
/**
 *  Try to find object with provided value for key
 *  If found - return, otherwise create new object and set value for key
 *
 *  @return found or new object
 */
+ (id)findOrCreate:(id)objectId forKey:(NSString *)key;

/**
 *  Implements effective database update algoritm, recomended by apple
 *
 *  @param newObjects   array of new objects (NSDictionary for example)
 *  @param key          key for primaryKey value in NSDictionary
 *  @param dbKey        primaryKey name in database
 *  @param processBlock block to fill newly created object or update object that found
 *
 *  @return return array of both updated and created objects
 */
+ (NSArray *)findOrCreateMultiple:(NSArray *)newObjects byKey:(NSString *)key dbKey:(NSString *)dbKey process:(SimpleDataFindOrCreateProcessBlock)processBlock;

/**
 *  Need to save context after any delete operation
 */
+ (void)deleteObject:(id)obj;
+ (void)deleteObjects:(NSArray *)array;
+ (void)deleteAllObjects;

/**
 *  Save context
 *  !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!!
 *  If current context is not mainContext it will be deleted after merging changes to mainContext
 *  !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!!
 */
+ (void)save;

/**
 *  Calling this method on mainThread will not affect mainContext
 *  Calling this method on some other thread will delete context associated with this thread
 *  It may be a good practice to delete context after each batch of operations in thread
 *  Please refer SDCoreDataStack.h for more details
 */
+ (void)closeCurrentContext;

@end
