//
//  SimpleData_2_0Tests.m
//  SimpleData_2.0Tests
//
//  Created by Andrew Zhdanov on 15.12.15.
//  Copyright © 2015 Andrew Zhdanov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SDCoreDataStack.h"
#import "DMDepartment.h"
#import "DMEmployee.h"

@interface SimpleData_2_0Tests : XCTestCase

@end

@implementation SimpleData_2_0Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCoreDataOnMainThread {
    
//    [SDCoreDataStack initializeStackWithModelName:@"SimpleData_2_0" dataBaseFileName:@"test"];
//    [self cleanAll];
//    
//    SDRequestParams *allParam = [SDRequestParams findAll];
//    NSArray *departments = [DMDepartment findWithRequestParams:allParam];
//    NSArray *emplyees = [DMEmployee findWithRequestParams:allParam];
//    XCTAssertEqual(departments.count, 0);
//    XCTAssertEqual(emplyees.count, 0);
//    
//    [self resetContext];
//    [self createDepartments];
//    departments = [DMDepartment findWithRequestParams:allParam];
//    emplyees = [DMEmployee findWithRequestParams:allParam];
//    XCTAssertEqual(departments.count, 9);
//    XCTAssertEqual(emplyees.count, 45);
//    
//    [self resetContext];
//    [self changeEmployeeStatus];
//    SDRequestParams *findParam = [SDRequestParams find:@(EmployeeStatusOnline) byParam:DMEmployeeAttributes.status];
//    emplyees = [DMEmployee findWithRequestParams:findParam];
//    XCTAssertGreaterThanOrEqual(emplyees.count, 9);
//    
//    [self resetContext];
//    SDRequestParams *findParamWithLimit = [SDRequestParams find:@(EmployeeStatusOnline) byParam:DMEmployeeAttributes.status];
//    findParamWithLimit.limit = 3;
//    emplyees = [DMEmployee findWithRequestParams:findParam];
//    XCTAssertGreaterThanOrEqual(emplyees.count, 3);
}

- (void)testCoreDataOnBgThread {
    
    [SDCoreDataStack initializeStackWithModelName:@"SimpleData_2_0" dataBaseFileName:@"test"];
    [self cleanAll];
    /**
     *  Create in Main
     */
    [self createDepartments];
    
    /**
     *  Find in BG
     */
    dispatch_group_t group1 = dispatch_group_create();
    dispatch_group_async(group1, dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        [self findAllCheck];
    });
    
    dispatch_group_wait(group1, DISPATCH_TIME_FOREVER);
    
    /**
     *  Clean in BG
     */
    dispatch_group_t group2 = dispatch_group_create();
    dispatch_group_async(group2, dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        [self cleanAll];
        [self resetContext];
    });
    
    dispatch_group_wait(group2, DISPATCH_TIME_FOREVER);
    /**
     *  Check in MAIN
     */
    SDRequestParams *allParam = [SDRequestParams findAll];
    NSArray *departments = [DMDepartment findWithRequestParams:allParam];
    NSArray *emplyees = [DMEmployee findWithRequestParams:allParam];
    XCTAssertEqual(departments.count, 0);
    XCTAssertEqual(emplyees.count, 0);
    
   
    /**
     *  Create in BG
     */
    dispatch_group_t group3 = dispatch_group_create();
    
    dispatch_group_async(group3, dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        [self createDepartments];
        [self findAllCheck];
    });
    
    dispatch_group_wait(group3, DISPATCH_TIME_FOREVER);
    
    /**
     *  Find in MAIN
     */
    departments = [DMDepartment findWithRequestParams:allParam];
    emplyees = [DMEmployee findWithRequestParams:allParam];
    XCTAssertEqual(departments.count, 9);
    XCTAssertEqual(emplyees.count, 45);
    
    
    [self cleanAll];
    
    /**
     *  Create some in BG, but not save
     */
    dispatch_group_t group4 = dispatch_group_create();
    
    dispatch_group_async(group4, dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        for (NSInteger i = 1; i < 10; i++) {
            DMDepartment *department = [DMDepartment create];
            department.departmentID = @(i);
            department.title = [NSString stringWithFormat:@"Department %ld", (long)i];
            [self createEmployeesForDepartment:department];
        }
        [DMDepartment closeCurrentContext];
    });
    
    dispatch_group_wait(group4, DISPATCH_TIME_FOREVER);
    
    /**
     *  Find in MAIN
     */
    departments = [DMDepartment findWithRequestParams:allParam];
    emplyees = [DMEmployee findWithRequestParams:allParam];
    XCTAssertEqual(departments.count, 0);
    XCTAssertEqual(emplyees.count, 0);
    
}

- (void)findAllCheck {
    SDRequestParams *allParam = [SDRequestParams findAll];
    NSArray *departments = [DMDepartment findWithRequestParams:allParam];
    NSArray *emplyees = [DMEmployee findWithRequestParams:allParam];
    XCTAssertEqual(departments.count, 9);
    XCTAssertEqual(emplyees.count, 45);
}


- (void)createDepartments {
    for (NSInteger i = 1; i < 10; i++) {
        DMDepartment *department = [DMDepartment create];
        department.departmentID = @(i);
        department.title = [NSString stringWithFormat:@"Department %ld", (long)i];
        [self createEmployeesForDepartment:department];
    }
    [DMDepartment save];
}

- (void)createEmployeesForDepartment:(DMDepartment *)department {
    for (NSInteger i = 1; i < 6; i++) {
        DMEmployee *employee = [DMEmployee create];
        employee.employeeId = @(department.departmentIDValue * 100 + i);
        employee.firstName = [NSString stringWithFormat:@"Name%ld", (long)i];
        employee.lastName = [NSString stringWithFormat:@"LastName%ld", (long)i];
        employee.statusValue = EmployeeStatusOffline;
    }
}

- (void)cleanAll {
    [DMDepartment deleteAllObjects];
    [DMEmployee deleteAllObjects];
    [DMDepartment save];
}

- (void)changeEmployeeStatus {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName ENDSWITH[cd] '1'"];
    NSArray *array = [DMEmployee findWithRequestParams:[SDRequestParams findWithPredicate:predicate]];
    for (DMEmployee *employee in array) {
        employee.statusValue = EmployeeStatusOnline;
    }
    [DMEmployee save];
    
}

- (void)resetContext {
    [[[SDCoreDataStack sharedStack] contextForCurrentThread] reset];
}

@end
