// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMEmployee.m instead.

#import "_DMEmployee.h"

const struct DMEmployeeAttributes DMEmployeeAttributes = {
	.employeeId = @"employeeId",
	.firstName = @"firstName",
	.lastName = @"lastName",
	.status = @"status",
};

const struct DMEmployeeRelationships DMEmployeeRelationships = {
	.department = @"department",
};

@implementation DMEmployeeID
@end

@implementation _DMEmployee

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DMEmployee" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DMEmployee";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DMEmployee" inManagedObjectContext:moc_];
}

- (DMEmployeeID*)objectID {
	return (DMEmployeeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"employeeIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"employeeId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"statusValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"status"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic employeeId;

- (int32_t)employeeIdValue {
	NSNumber *result = [self employeeId];
	return [result intValue];
}

- (void)setEmployeeIdValue:(int32_t)value_ {
	[self setEmployeeId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveEmployeeIdValue {
	NSNumber *result = [self primitiveEmployeeId];
	return [result intValue];
}

- (void)setPrimitiveEmployeeIdValue:(int32_t)value_ {
	[self setPrimitiveEmployeeId:[NSNumber numberWithInt:value_]];
}

@dynamic firstName;

@dynamic lastName;

@dynamic status;

- (int32_t)statusValue {
	NSNumber *result = [self status];
	return [result intValue];
}

- (void)setStatusValue:(int32_t)value_ {
	[self setStatus:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveStatusValue {
	NSNumber *result = [self primitiveStatus];
	return [result intValue];
}

- (void)setPrimitiveStatusValue:(int32_t)value_ {
	[self setPrimitiveStatus:[NSNumber numberWithInt:value_]];
}

@dynamic department;

@end

