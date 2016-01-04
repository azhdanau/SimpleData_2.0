// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMDepartment.m instead.

#import "_DMDepartment.h"

const struct DMDepartmentAttributes DMDepartmentAttributes = {
	.departmentID = @"departmentID",
	.status = @"status",
	.title = @"title",
};

const struct DMDepartmentRelationships DMDepartmentRelationships = {
	.employees = @"employees",
};

@implementation DMDepartmentID
@end

@implementation _DMDepartment

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DMDepartment" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DMDepartment";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DMDepartment" inManagedObjectContext:moc_];
}

- (DMDepartmentID*)objectID {
	return (DMDepartmentID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"departmentIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"departmentID"];
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

@dynamic departmentID;

- (int32_t)departmentIDValue {
	NSNumber *result = [self departmentID];
	return [result intValue];
}

- (void)setDepartmentIDValue:(int32_t)value_ {
	[self setDepartmentID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveDepartmentIDValue {
	NSNumber *result = [self primitiveDepartmentID];
	return [result intValue];
}

- (void)setPrimitiveDepartmentIDValue:(int32_t)value_ {
	[self setPrimitiveDepartmentID:[NSNumber numberWithInt:value_]];
}

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

@dynamic title;

@dynamic employees;

- (NSMutableSet*)employeesSet {
	[self willAccessValueForKey:@"employees"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"employees"];

	[self didAccessValueForKey:@"employees"];
	return result;
}

@end

