//
//  AppDelegate.h
//  SimpleData_2.0
//
//  Created by Andrew Zhdanov on 15.12.15.
//  Copyright © 2015 Andrew Zhdanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

