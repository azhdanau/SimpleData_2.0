//
//  SDCoreDataStack.m
//  SimpleData_2.0
//
//  Created by Andrew Zhdanov on 17.12.15.
//  Copyright © 2015 Andrew Zhdanov. All rights reserved.
//

#import "SDCoreDataStack.h"

static NSString * const kModelFileExtension = @"momd";
static NSString * const kDataBaseFileExtension = @"sqlite";
static NSString * const kSimpleDataThreadKeyForContext = @"SimpleData_NSManagedObjectContextForThreadKey";

static SDCoreDataStack *_sharedInstance;

@interface SDCoreDataStack ()

//CoreData Stack
@property (nonatomic, strong) NSManagedObjectContext *mainManagedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//Input
@property (nonatomic, copy) NSString *modelName;
@property (nonatomic, copy) NSString *dataBaseFileName;

@end

@implementation SDCoreDataStack

#pragma mark - Init

+ (void)initializeStackWithModelName:(NSString *)modelName dataBaseFileName:(NSString *)dataBaseFileName {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[SDCoreDataStack alloc] initWithModelName:modelName dataBaseFileName:dataBaseFileName];
    });
}

+ (instancetype)sharedStack {
    NSAssert(_sharedInstance != nil, @"You should call initialize method, before refer sharedStack");
    return _sharedInstance;
}

- (instancetype)initWithModelName:(NSString *)modelName dataBaseFileName:(NSString *)dataBaseFileName {
    NSAssert(modelName.length > 0, @"Model name can't be nil");
    NSAssert(dataBaseFileName.length > 0, @"Database file name can't be nil");
    
    if (self = [super init]) {
        _modelName = [modelName copy];
        _dataBaseFileName = [NSString stringWithFormat:@"%@.%@", [dataBaseFileName copy], kDataBaseFileExtension];
    }
    return self;
}

#pragma mark - Public methods

- (NSManagedObjectContext *)contextForCurrentThread {
    if ([NSThread isMainThread]) {
        return self.mainManagedObjectContext;
    } else {
        NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
        NSManagedObjectContext *threadContext = [threadDict objectForKey:kSimpleDataThreadKeyForContext];
        if (threadContext == nil) {
            threadContext = [self createPrivateContext];
            [threadDict setObject:threadContext forKey:kSimpleDataThreadKeyForContext];
        }
        return threadContext;
    }
}

- (void)closeContextForCurrentThread {
    if (![NSThread isMainThread]) {
        NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
        NSManagedObjectContext *threadContext = [threadDict objectForKey:kSimpleDataThreadKeyForContext];
        
        [threadContext reset];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:threadContext];
        [threadDict removeObjectForKey:kSimpleDataThreadKeyForContext];
    }
}


- (NSEntityDescription *)entityDescriptionForClass:(Class)aClass {
    return [[[self managedObjectModel] entitiesByName] objectForKey:NSStringFromClass(aClass)];
}

#pragma mark - Private Methods

- (NSManagedObjectContext *)createPrivateContext {
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.persistentStoreCoordinator = self.persistentStoreCoordinator;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(managedObjectContextDidSave:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:context];
    return context;
}

- (void)managedObjectContextDidSave:(NSNotification *)notification {
    if (notification.object != self.mainManagedObjectContext) {
        /**
         * Merge all changes to main.
         * Delete context
         */
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainManagedObjectContext mergeChangesFromContextDidSaveNotification:notification];
        });
        
        NSManagedObjectContext *contextToDelete = notification.object;
        NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
        NSManagedObjectContext *threadContext = [threadDict objectForKey:kSimpleDataThreadKeyForContext];
        
        if (contextToDelete == threadContext) {
            [self closeContextForCurrentThread];
        } else {
            [NSException raise:@"Something go wrong while deleting private context" format:@"Context in notification doesn't match with thread context"];
        }
    }
}

#pragma mark - Core Data stack

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel == nil) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.modelName withExtension:kModelFileExtension];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator == nil) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:self.dataBaseFileName];
        NSError *error = nil;
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's persistentStoreCoordinator";
            dict[NSUnderlyingErrorKey] = error;
          
            NSException *exception = [NSException exceptionWithName: @"CoreData exception"
                                                             reason: @"There was an error creating or loading the application's saved data."
                                                           userInfo:dict];
            @throw exception;
        }
    }
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)mainManagedObjectContext {
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator == nil) {
        return nil;
    }
    if (_mainManagedObjectContext == nil) {
        _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainManagedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _mainManagedObjectContext;
}

#pragma mark - Core Data Saving

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.mainManagedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            [NSException raise:@"Exception while saving context" format:@""];
        }
    }
}

@end
