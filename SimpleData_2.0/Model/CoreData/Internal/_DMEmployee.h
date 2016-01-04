// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMEmployee.h instead.

#import <CoreData/CoreData.h>

extern const struct DMEmployeeAttributes {
	__unsafe_unretained NSString *employeeId;
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *lastName;
	__unsafe_unretained NSString *status;
} DMEmployeeAttributes;

extern const struct DMEmployeeRelationships {
	__unsafe_unretained NSString *department;
} DMEmployeeRelationships;

@class DMDepartment;

@interface DMEmployeeID : NSManagedObjectID {}
@end

@interface _DMEmployee : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) DMEmployeeID* objectID;

@property (nonatomic, strong) NSNumber* employeeId;

@property (atomic) int32_t employeeIdValue;
- (int32_t)employeeIdValue;
- (void)setEmployeeIdValue:(int32_t)value_;

//- (BOOL)validateEmployeeId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* firstName;

//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* lastName;

//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* status;

@property (atomic) int32_t statusValue;
- (int32_t)statusValue;
- (void)setStatusValue:(int32_t)value_;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) DMDepartment *department;

//- (BOOL)validateDepartment:(id*)value_ error:(NSError**)error_;

@end

@interface _DMEmployee (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveEmployeeId;
- (void)setPrimitiveEmployeeId:(NSNumber*)value;

- (int32_t)primitiveEmployeeIdValue;
- (void)setPrimitiveEmployeeIdValue:(int32_t)value_;

- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;

- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;

- (NSNumber*)primitiveStatus;
- (void)setPrimitiveStatus:(NSNumber*)value;

- (int32_t)primitiveStatusValue;
- (void)setPrimitiveStatusValue:(int32_t)value_;

- (DMDepartment*)primitiveDepartment;
- (void)setPrimitiveDepartment:(DMDepartment*)value;

@end
