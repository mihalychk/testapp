//
//  RecordModelTest.m
//  calories
//
//  Created by Michael on 11/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import <XCTest/XCTest.h>
#import "RecordModel.h"
#import "Common.h"





@interface RecordModelTest : XCTestCase

@property (nonatomic, strong) RecordModel * model1;
@property (nonatomic, strong) RecordModel * model2;

@end




@implementation RecordModelTest


- (void)setUp {
	[super setUp];
	
	self.model1			= [[RecordModel alloc] initWithDictionary:@{
																	@"Record" : @{
																			@"id" : @15,
																			@"user_id" : @10,
																			@"text" : @"Tasty Burger",
																			@"datetime" : @"2016-03-10T21:00:00+00:00",
																			@"calories" : @220.7f
																			}
																	}];
	
	self.model2			= [[RecordModel alloc] initWithDictionary:@{
																	@"Record" : @{
																			@"id" : @"15",
																			@"user_id" : @"10",
																			@"text" : @"Tasty Burger 2",
																			@"datetime" : @"2016-03-10T21:00:00Z",
																			@"calories" : @"220,7"
																			}
																	}];
}


- (void)tearDown {
	// Put teardown code here. This method is called after the invocation of each test method in the class.
	[super tearDown];
}


- (void)testIdentifierField {
	XCTAssertTrue(VALID_UINT_1(self.model1.identifier), @"Identifier should be NSNumber with unsigned int value");
	XCTAssertTrue(VALID_UINT_1(self.model2.identifier), @"Identifier should be NSNumber with unsigned int value");
	
	XCTAssertTrue(self.model1.identifier.unsignedIntegerValue == 15, @"Identifier was parsed wrong");
	XCTAssertTrue(self.model2.identifier.unsignedIntegerValue == 15, @"Identifier was parsed wrong");
	
	XCTAssertTrue(VALID_UINT_1(self.model1.toOutput[@"Record"][@"id"]), @"Identifier output should be NSNumber with unsigned int value");
	XCTAssertTrue(VALID_UINT_1(self.model2.toOutput[@"Record"][@"id"]), @"Identifier output should be NSNumber with unsigned int value");
	
	XCTAssertTrue([self.model1.toOutput[@"Record"][@"id"] unsignedIntegerValue] == 15, @"Identifier was output wrong");
	XCTAssertTrue([self.model2.toOutput[@"Record"][@"id"] unsignedIntegerValue] == 15, @"Identifier was output wrong");
}


- (void)testUserIdField {
	XCTAssertTrue(VALID_UINT_1(self.model1.userId), @"UserId should be NSNumber with unsigned int value");
	XCTAssertTrue(VALID_UINT_1(self.model2.userId), @"UserId should be NSNumber with unsigned int value");
	
	XCTAssertTrue(self.model1.userId.unsignedIntegerValue == 10, @"UserId was parsed wrong");
	XCTAssertTrue(self.model2.userId.unsignedIntegerValue == 10, @"UserId was parsed wrong");
	
	XCTAssertFalse(self.model1.toOutput[@"Record"][@"user_id"], @"UserId should not be in output");
	XCTAssertFalse(self.model2.toOutput[@"Record"][@"user_id"], @"UserId should not be in output");
}


- (void)testTextField {
	XCTAssertTrue(VALID_STRING_1(self.model1.text), @"Text should be NSString with text in it");
	XCTAssertTrue(VALID_STRING_1(self.model2.text), @"Text should be NSString with text in it");
	
	XCTAssertTrue([self.model1.text isEqualToString:@"Tasty Burger"], @"Text was parsed wrong");
	XCTAssertTrue([self.model2.text isEqualToString:@"Tasty Burger 2"], @"Text was parsed wrong");
	
	XCTAssertTrue(VALID_STRING_1(self.model1.toOutput[@"Record"][@"text"]), @"Text output should be NSString with text in it");
	XCTAssertTrue(VALID_STRING_1(self.model2.toOutput[@"Record"][@"text"]), @"Text output should be NSString with text in it");
	
	XCTAssertTrue([self.model1.toOutput[@"Record"][@"text"] isEqualToString:@"Tasty Burger"], @"Text was output wrong");
	XCTAssertTrue([self.model2.toOutput[@"Record"][@"text"] isEqualToString:@"Tasty Burger 2"], @"Text was output wrong");
}


- (void)testCalories {
	XCTAssertTrue(VALID_NUMBER(self.model1.calories), @"Calories should be NSNumber with float value");
	XCTAssertTrue(VALID_NUMBER(self.model2.calories), @"Calories should be NSNumber with float value");
	
	XCTAssertTrue(self.model1.calories.floatValue == 220.7f, @"Calories was parsed wrong");
	XCTAssertTrue(self.model2.calories.floatValue == 220.7f, @"Calories was parsed wrong");
	
	XCTAssertTrue(VALID_NUMBER(self.model1.toOutput[@"Record"][@"calories"]), @"Calories output should be NSNumber with float value");
	XCTAssertTrue(VALID_NUMBER(self.model2.toOutput[@"Record"][@"calories"]), @"Calories output should be NSNumber with float value");
	
	XCTAssertTrue([self.model1.toOutput[@"Record"][@"calories"] floatValue] == 220.7f, @"Calories was output wrong");
	XCTAssertTrue([self.model2.toOutput[@"Record"][@"calories"] floatValue] == 220.7f, @"Calories was output wrong");
}


- (void)testPerformanceExample {
	// This is an example of a performance test case.
	[self measureBlock:^{
		[self.model1 toOutput];
		[self.model2 toOutput];
	}];
}

@end