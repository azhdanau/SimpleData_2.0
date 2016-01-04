// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMDepartment.h instead.

#import <CoreData/CoreData.h>

extern const struct DMDepartmentAttributes {
	__unsafe_unretained NSString *departmentID;
	__unsafe_unretained NSString *status;
	__unsafe_unretained NSString *title;
} DMDepartmentAttributes;

extern const struct DMDepartmentRelationships {
	__unsafe_unretained NSString *employees;
} DMDepartmentRelationships;

@class DMEmployee;

@interface DMDepartmentID : NSManagedObjectID {}
@end

@interface _DMDepartment : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) DMDepartmentID* objectID;

@property (nonatomic, strong) NSNumber* departmentID;

@property (atomic) int32_t departmentIDValue;
- (int32_t)departmentIDValue;
- (void)setDepartmentIDValue:(int32_t)value_;

//- (BOOL)validateDepartmentID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* status;

@property (atomic) int32_t statusValue;
- (int32_t)statusValue;
- (void)setStatusValue:(int32_t)value_;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *employees;

- (NSMutableSet*)employeesSet;

@end

@interface _DMDepartment (EmployeesCoreDataGeneratedAccessors)
- (void)addEmployees:(NSSet*)value_;
- (void)removeEmployees:(NSSet*)value_;
- (void)addEmployeesObject:(DMEmployee*)value_;
- (void)removeEmployeesObject:(DMEmployee*)value_;

@end

@interface _DMDepartment (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveDepartmentID;
- (void)setPrimitiveDepartmentID:(NSNumber*)value;

- (int32_t)primitiveDepartmentIDValue;
- (void)setPrimitiveDepartmentIDValue:(int32_t)value_;

- (NSNumber*)primitiveStatus;
- (void)setPrimitiveStatus:(NSNumber*)value;

- (int32_t)primitiveStatusValue;
- (void)setPrimitiveStatusValue:(int32_t)value_;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSMutableSet*)primitiveEmployees;
- (void)setPrimitiveEmployees:(NSMutableSet*)value;

@end
