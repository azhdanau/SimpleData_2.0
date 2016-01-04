//
//  SDCoreDataStack.h
//  SimpleData_2.0
//
//  Created by Andrew Zhdanov on 17.12.15.
//  Copyright © 2015 Andrew Zhdanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SDCoreDataStack : NSObject

/**
 *  First method you should call to start work with CoreData.
 *
 *  @param modelName        name of your .xcdatamodeld file
 *  @param dataBaseFileName name of file, where all data should be stored
 *      This param can be used, if you need to store separate dataBase file for each user (example).
 *
 *  @return initialized Coredata stack.
 */
+ (void)initializeStackWithModelName:(NSString *)modelName dataBaseFileName:(NSString *)dataBaseFileName;

/**
 *  Use this method to refer CoreData stack
 *
 *  @return shared instance of the CoreData stack
 */
+ (instancetype)sharedStack;

/**
 *  Return context for current thread
 *  Please pay ATTENTION, that all private contexts will be DELETED after calling SAVE
 *  We need to delete them, to avoid situation, 
 *  when some context appears in long-living thread and when this context wouldn't know about changes made in other private contexts
 *
 *  All changes from private contextxs are merged in mainContext
 *  Feel free for fetching objects in background, you may also call closeCurrentContext when you finish you operation.
 *  When creating some objects in background, context will be deleted after saving
 *  For next operation in this thread context will be recreated automatically
 */
- (NSManagedObjectContext *)contextForCurrentThread;

/**
 *  Reset changes and close context for current thread.
 *  Context may be recreated in fufutre.
 */
- (void)closeContextForCurrentThread;

/**
 *  Return Core Data entity description
 *
 *  @param aClass - class to return entetity description for
 */
- (NSEntityDescription *)entityDescriptionForClass:(Class)aClass;

@end
