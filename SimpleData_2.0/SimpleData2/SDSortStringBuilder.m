//
//  SDSortStringBuilder.m
//  SimpleData_2.0
//
//  Created by Andrew Zhdanov on 21.12.15.
//  Copyright © 2015 Andrew Zhdanov. All rights reserved.
//

#import "SDSortStringBuilder.h"

@interface SDSortStringBuilder ()

@property (nonatomic, strong) NSMutableString *string;

@end

@implementation SDSortStringBuilder

- (instancetype)init {
    if (self = [super init]) {
        _string = [NSMutableString string];
    }
    return self;
}

- (void)addSortField:(NSString *)field ascending:(BOOL)ascending {
    NSString *stringToAppend;
    NSString *modifier = ascending ? @"asc" : @"desc";
    if (self.string.length == 0) {
        stringToAppend = [NSString stringWithFormat:@"%@ %@", field, modifier];
    } else {
        stringToAppend = [NSString stringWithFormat:@", %@ %@", field, modifier];
    }
    [self.string appendString:stringToAppend];
}

- (NSString *)sortString {
    return [self.sortString copy];
}

@end
