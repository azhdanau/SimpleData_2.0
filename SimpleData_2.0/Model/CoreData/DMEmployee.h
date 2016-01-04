#import "_DMEmployee.h"
#import "NSManagedObject+SimpleData.h"

typedef NS_ENUM(NSInteger, EmployeeStatus) {
    EmployeeStatusUndefined = 0,
    EmployeeStatusOffline = 1,
    EmployeeStatusOnline = 2
};

@interface DMEmployee : _DMEmployee {}
// Custom logic goes here.
@end
