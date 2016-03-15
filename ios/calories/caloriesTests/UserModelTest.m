//
//  UserModelTest.m
//  calories
//
//  Created by Michael on 11/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import <XCTest/XCTest.h>
#import "UserModel.h"
#import "Common.h"





@interface UserModelTest : XCTestCase

@property (nonatomic, strong) UserModel * model1;
@property (nonatomic, strong) UserModel * model2;

@end




@implementation UserModelTest


- (void)setUp {
	[super setUp];
	
	self.model1			= [[UserModel alloc] initWithDictionary:@{
																  @"User" : @{
																		  @"id" : @15,
																		  @"name" : @"Jonathan",
																		  @"email" : @"john@test.com",
																		  @"calories_per_day" : @125.5f
																		  }
																  }];
	
	self.model2			= [[UserModel alloc] initWithDictionary:@{
																  @"User" : @{
																		  @"id" : @"26",
																		  @"name" : @"Harold",
																		  @"email" : @"harold@test.com",
																		  @"calories_per_day" : @"125,5"
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
	XCTAssertTrue(self.model2.identifier.unsignedIntegerValue == 26, @"Identifier was parsed wrong");
	
	XCTAssertTrue(VALID_UINT_1(self.model1.toOutput[@"User"][@"id"]), @"Identifier output should be NSNumber with unsigned int value");
	XCTAssertTrue(VALID_UINT_1(self.model2.toOutput[@"User"][@"id"]), @"Identifier output should be NSNumber with unsigned int value");
	
	XCTAssertTrue([self.model1.toOutput[@"User"][@"id"] unsignedIntegerValue] == 15, @"Identifier was output wrong");
	XCTAssertTrue([self.model2.toOutput[@"User"][@"id"] unsignedIntegerValue] == 26, @"Identifier was output wrong");
}


- (void)testNameField {
	XCTAssertTrue(VALID_STRING_1(self.model1.name), @"Name should be NSString with text in it");
	XCTAssertTrue(VALID_STRING_1(self.model2.name), @"Name should be NSString with text in it");
	
	XCTAssertTrue([self.model1.name isEqualToString:@"Jonathan"], @"Name was parsed wrong");
	XCTAssertTrue([self.model2.name isEqualToString:@"Harold"], @"Name was parsed wrong");
	
	XCTAssertTrue(VALID_STRING_1(self.model1.toOutput[@"User"][@"name"]), @"Name output should be NSString with text in it");
	XCTAssertTrue(VALID_STRING_1(self.model2.toOutput[@"User"][@"name"]), @"Name output should be NSString with text in it");
	
	XCTAssertTrue([self.model1.toOutput[@"User"][@"name"] isEqualToString:@"Jonathan"], @"Name was output wrong");
	XCTAssertTrue([self.model2.toOutput[@"User"][@"name"] isEqualToString:@"Harold"], @"Name was output wrong");
}


- (void)testEmailField {
	XCTAssertTrue(VALID_STRING_1(self.model1.email), @"Email should be NSString with text in it");
	XCTAssertTrue(VALID_STRING_1(self.model2.email), @"Email should be NSString with text in it");
	
	XCTAssertTrue([self.model1.email isEqualToString:@"john@test.com"], @"Email was parsed wrong");
	XCTAssertTrue([self.model2.email isEqualToString:@"harold@test.com"], @"Email was parsed wrong");
	
	XCTAssertTrue(VALID_STRING_1(self.model1.toOutput[@"User"][@"email"]), @"Email output should be NSString with text in it");
	XCTAssertTrue(VALID_STRING_1(self.model2.toOutput[@"User"][@"email"]), @"Email output should be NSString with text in it");
	
	XCTAssertTrue([self.model1.toOutput[@"User"][@"email"] isEqualToString:@"john@test.com"], @"Email was output wrong");
	XCTAssertTrue([self.model2.toOutput[@"User"][@"email"] isEqualToString:@"harold@test.com"], @"Email was output wrong");
}


- (void)testCaloriesPerDayField {
	XCTAssertTrue(VALID_NUMBER(self.model1.caloriesPerDay), @"Calories should be NSNumber with float value");
	XCTAssertTrue(VALID_NUMBER(self.model2.caloriesPerDay), @"Calories should be NSNumber with float value");
	
	XCTAssertTrue(self.model1.caloriesPerDay.floatValue == 125.5f, @"Calories was parsed wrong");
	XCTAssertTrue(self.model2.caloriesPerDay.floatValue == 125.5f, @"Calories was parsed wrong");
	
	XCTAssertTrue(VALID_NUMBER(self.model1.toOutput[@"User"][@"calories_per_day"]), @"Calories output should be NSNumber with float value");
	XCTAssertTrue(VALID_NUMBER(self.model2.toOutput[@"User"][@"calories_per_day"]), @"Calories output should be NSNumber with float value");
	
	XCTAssertTrue([self.model1.toOutput[@"User"][@"calories_per_day"] floatValue] == 125.5f, @"Calories was output wrong");
	XCTAssertTrue([self.model2.toOutput[@"User"][@"calories_per_day"] floatValue] == 125.5f, @"Calories was output wrong");
}


- (void)testPerformanceExample {
	// This is an example of a performance test case.
	[self measureBlock:^{
		[self.model1 toOutput];
		[self.model2 toOutput];
	}];
}

@end