//
//  SDRequestParams.h
//  SimpleData_2.0
//
//  Created by Andrew Zhdanov on 22.12.15.
//  Copyright © 2015 Andrew Zhdanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  You should use this class to build params for fetch request
 *  1) Create request params object with one of static methods
 *  2) Setup additional params via properties
 */
@interface SDRequestParams : NSObject

/**
 *  Create params to return array of all objects of some class
 */
+ (instancetype)findAll;

/**
 *  Create params to return array of objects, where
 *  provided field(param) value isEqual to provided value
 */
+ (instancetype)find:(id)value byParam:(NSString *)param;

/**
 *  Create params to return array of objects, where
 *  provided field(param) value IN provided values
 *  It is the same like executing with predicate @"field IN values"
 */
+ (instancetype)findValues:(NSArray *)values byParam:(NSString *)param;

/**
 *  Create params to return array of objects that corresponds to provided predicate
 */
+ (instancetype)findWithPredicate:(NSPredicate *)predicate;

/**
 *  Additional params to add in fetch request
 */
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger offset;
/**
 *  SORTING STRING
 *
 *  You can sort object using multiple params
 *  Ex. @"field1, field2 asc" -  will sort objects by field1 ascending and field2 ascending
 *  Ex. @"field1 desc, field2 asc" -  will sort objects by field1 descending and field2 ascending
 *  Please pay attention to SPACES
 *
 *  You can also use SDSortStringBuilder to simplify the process
 */
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, assign) BOOL includeSubentities;

/**
 *  Output
 */
@property (nonatomic, strong, readonly) NSPredicate *predicate;
@property (nonatomic, strong, readonly) NSArray *sortDescriptors;

@end
