//
//  SDCoreDataCache.h
//  SimpleData_2.0
//
//  Created by Andrew Zhdanov on 21.12.15.
//  Copyright © 2015 Andrew Zhdanov. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This class provide simple key-value saving mechanism
 *  It is used internally, so if you use SimpleData AsIs you don't need even know about this class
 */
@interface SDCoreDataCache : NSObject

+ (instancetype)sharedCache;

- (void)addCacheentities:(NSArray *)entities forKey:(NSString *)key;
- (void)removeCachedentitiesForKey:(NSString *)key;
- (NSArray *)cachedentitiesForKey:(NSString *)key;

@end
