//
//  SimpleDataErrorTests.m
//  JSONModelDemo
//
//  Created by Marin Todorov on 13/12/2012.
//  Copyright (c) 2012 Underplot ltd. All rights reserved.
//

#import "SimpleDataErrorTests.h"
#import "PrimitivesModel.h"
#import "NestedModel.h"
#import "CopyrightModel.h"

@implementation SimpleDataErrorTests

-(void)testMissingKeysError
{    
    NSString* filePath = [[NSBundle bundleForClass:[JSONModel class]].resourcePath stringByAppendingPathComponent:@"primitivesWithErrors.json"];
    NSString* jsonContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    STAssertNotNil(jsonContents, @"Can't fetch test data file contents.");
    
    NSError* err;
    PrimitivesModel* p = [[PrimitivesModel alloc] initWithString: jsonContents error:&err];
    STAssertNil(p, @"Model is not nil, when input is invalid");
    STAssertNotNil(err, @"No error when keys are missing.");
    
    STAssertTrue(err.code == kJSONModelErrorInvalidData, @"Wrong error for missing keys");
    NSArray* missingKeys = err.userInfo[kJSONModelMissingKeys];
    missingKeys = [missingKeys sortedArrayUsingSelector:@selector(compare:)];
    STAssertTrue(missingKeys, @"error does not have kJSONModelMissingKeys keys in user info");
    STAssertTrue([missingKeys[0] isEqualToString:@"intNumber"],@"missing field intNumber not found in missingKeys");
    STAssertTrue([missingKeys[1] isEqualToString:@"longNumber"],@"missing field longNumber not found in missingKeys");
}

-(void)testBrokenJSON
{
    NSString* jsonContents = @"{[1,23,4],\"123\":123,}";

    NSError* err;
    PrimitivesModel* p = [[PrimitivesModel alloc] initWithString: jsonContents error:&err];
    STAssertNil(p, @"Model is not nil, when input is invalid");
    STAssertNotNil(err, @"No error when keys are missing.");
    
    STAssertTrue(err.code == kJSONModelErrorBadJSON, @"Wrong error for missing keys");
}

-(void)testErrorsInNestedModels
{
    NSString* filePath = [[NSBundle bundleForClass:[JSONModel class]].resourcePath stringByAppendingPathComponent:@"nestedDataWithErrors.json"];
    NSString* jsonContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    STAssertNotNil(jsonContents, @"Can't fetch test data file contents.");
    
    NSError* err;
    NestedModel* n = [[NestedModel alloc] initWithString: jsonContents error:&err];
    STAssertNotNil(err, @"No error thrown when loading invalid data");
    
    STAssertNil(n, @"Model is not nil, when invalid data input");
    STAssertTrue(err.code == kJSONModelErrorInvalidData, @"Wrong error for missing keys");
}

-(void)testForNilInputFromString
{
    JSONModelError* err = nil;
    
    //test for nil string input
    CopyrightModel* cpModel = [[CopyrightModel alloc] initWithString:nil
                                                               error:&err];
    cpModel=nil;
    
    STAssertTrue(err!=nil, @"No error returned when initialized with nil string");
    STAssertTrue(err.code == kJSONModelErrorNilInput, @"Wrong error for nil string input");
}

-(void)testForNilInputFromDictionary
{
    JSONModelError* err = nil;
    
    //test for nil string input
    CopyrightModel* cpModel = [[CopyrightModel alloc] initWithDictionary:nil
                                                                   error:&err];
    cpModel=nil;
    
    STAssertTrue(err!=nil, @"No error returned when initialized with nil dictionary");
    STAssertTrue(err.code == kJSONModelErrorNilInput, @"Wrong error for nil dictionary input");
}

@end
