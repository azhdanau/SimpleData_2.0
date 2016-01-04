//
//  SDRequestParams.m
//  SimpleData_2.0
//
//  Created by Andrew Zhdanov on 22.12.15.
//  Copyright © 2015 Andrew Zhdanov. All rights reserved.
//

#import "SDRequestParams.h"

@interface SDRequestParams ()

@property (nonatomic, strong) NSPredicate *predicate;

@end

@implementation SDRequestParams

+ (instancetype)findAll {
    SDRequestParams *params = [SDRequestParams new];
    params.predicate = [self predicateForValue:nil key:nil];
    return params;
    
}

+ (instancetype)find:(id)value byParam:(NSString *)param {
    SDRequestParams *params = [SDRequestParams new];
    params.predicate = [self predicateForValue:value key:param];
    return params;
}

+ (instancetype)findValues:(NSArray *)values byParam:(NSString *)param {
    SDRequestParams *params = [SDRequestParams new];
    params.predicate = [NSPredicate predicateWithFormat:@"%K IN %@", param, values];
    return params;
}

+ (instancetype)findWithPredicate:(NSPredicate *)predicate {
    SDRequestParams *params = [SDRequestParams new];
    params.predicate = predicate;
    return params;
}

- (instancetype)init {
    if (self = [super init]) {
        _limit = -1;
        _offset = -1;
        _includeSubentities = YES;
    }
    return self;
}

#pragma mark - Getters

- (NSArray *)sortDescriptors {
    return [SDRequestParams sortDescriptorsFromString:self.sort];
}

#pragma mark - Predicate

+ (NSPredicate *)predicateForValue:(id)param key:(NSString *)fieldName {
    if (fieldName.length == 0) {
        return nil;
    }
    
    NSString *stringForPredicate = nil;
    if (param == nil) {
        stringForPredicate = [NSString stringWithFormat:@"%@ = nil", fieldName];
    } else if ([param isKindOfClass:[NSString class]]) {
        stringForPredicate = [NSString stringWithFormat:@"%@ = '%@'", fieldName, param];
    } else {
        stringForPredicate = [NSString stringWithFormat:@"%@ = %@", fieldName, param];
    }
    
    return [NSPredicate predicateWithFormat:stringForPredicate];
}

#pragma mark - Sort Descriptors

+ (NSArray *)sortDescriptorsFromString:(NSString *)string {
    if (string.length == 0) {
        return nil;
    }
    
    NSMutableArray *sortDescriptors = [NSMutableArray array];
    NSArray *fields = [string componentsSeparatedByString:@", "];
    
    NSArray *lastFieldComponents = [((NSString *)fields.lastObject) componentsSeparatedByString:@" "];
    BOOL isAscending = lastFieldComponents.count > 1 ? [self isAscendingString:lastFieldComponents[1]] : YES;
    
    for (NSString *sortField in fields) {
        NSArray *components = [sortField componentsSeparatedByString:@" "];
        [sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:components[0] ascending:components.count > 1 ? [self isAscendingString:components[1]] : isAscending]];
    }
    
    return sortDescriptors;
}

+ (BOOL)isAscendingString:(NSString *)str {
    static NSString *ascString = @"asc";
    static NSString *descString = @"desc";
    
    if ([str isEqualToString:ascString]) {
        return YES;
    } else if ([str isEqualToString:descString]) {
        return NO;
    }
    @throw [[NSException alloc] initWithName:@"Argument Exception" reason:@"Unknown sort param." userInfo:nil];
}


@end
