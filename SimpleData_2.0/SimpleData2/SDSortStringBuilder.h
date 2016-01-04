//
//  SDSortStringBuilder.h
//  SimpleData_2.0
//
//  Created by Andrew Zhdanov on 21.12.15.
//  Copyright © 2015 Andrew Zhdanov. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  You can use this class to build sort string for request.
 *  Please see details in NSManagedObject+SimpleData.h file
 */
@interface SDSortStringBuilder : NSObject

@property (nonatomic, copy, readonly) NSString *sortString;

- (void)addSortField:(NSString *)field ascending:(BOOL)ascending;

@end
