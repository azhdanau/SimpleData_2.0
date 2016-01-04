//
//  SDCoreDataCache.m
//  SimpleData_2.0
//
//  Created by Andrew Zhdanov on 21.12.15.
//  Copyright © 2015 Andrew Zhdanov. All rights reserved.
//

#import "SDCoreDataCache.h"

static SDCoreDataCache *_instance;

@interface SDCoreDataCache()

@property (nonatomic, strong) NSMutableDictionary *coreDataCache;

@end

@implementation SDCoreDataCache

+ (instancetype)sharedCache {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [SDCoreDataCache new];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _coreDataCache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addCacheentities:(NSArray *)entities forKey:(NSString *)key {
    NSParameterAssert(key);
    NSParameterAssert(entities.count > 0);
    
    [self.coreDataCache setObject:entities forKey:key];
}

- (void)removeCachedentitiesForKey:(NSString *)key {
    NSParameterAssert(key);
    
    [self.coreDataCache removeObjectForKey:key];
}

- (NSArray *)cachedentitiesForKey:(NSString *)key {
    NSParameterAssert(key);
    
    return [self.coreDataCache objectForKey:key];
}

@end
