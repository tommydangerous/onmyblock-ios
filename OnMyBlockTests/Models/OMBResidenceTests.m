//
//  OMBResidenceTests.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/29/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "OMBResidence.h"

@interface OMBResidenceTests : XCTestCase
{
  OMBResidence *residence;
  NSDictionary *residenceDictionary;
}

@end

@implementation OMBResidenceTests

#pragma mark - Setup and Teardown

- (void) setUp
{
  [super setUp];
  residence           = [[OMBResidence alloc] init];
  residenceDictionary = @{
    @"address":       @"1234 Fun Way",
    @"available_on":  @"2013-11-14 00:00:00 +0000",
    @"bathrooms":     @"2.0",
    @"bedrooms":      @"4.0",
    @"city":          @"San Diego",
    @"created_at":    @"2012-10-15 00:12:13 +0000",
    @"description":   @"Best place on earth!",
    @"email":         @"elon_musk@gmail.com",
    @"id":            @"1234",
    @"landlord_name": @"Elon Musk",
    @"latitude":      @"32.815",
    @"lease_months":  @"6",
    @"longitude":     @"-117.168",
    @"phone":         @"(858) 695-9400",
    @"sqft":          @"1466",
    @"state":         @"CA",
    @"updated_at":    @"2013-01-09 00:00:01 +0000",
    @"zip":           @"92101"
  };
}

- (void) tearDown
{
  [super tearDown];
  residence           = nil;
  residenceDictionary = nil;
}

#pragma mark - Tests

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) testReadFromResidenceDictionary
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat       = @"yyyy-MM-dd HH:mm:ss ZZZ";
  [residence readFromResidenceDictionary: residenceDictionary];
  XCTAssertEqual(residence.address, 
    [residenceDictionary objectForKey: @"address"], 
      @"Residence should parse address correctly");
  XCTAssertEqual(residence.availableOn, [[dateFormatter dateFromString:
    [residenceDictionary objectForKey: @"available_on"]] timeIntervalSince1970],
      @"Residence should parse available_on correctly");
  XCTAssertEqual(residence.bathrooms, 
    [[residenceDictionary objectForKey: @"bathrooms"] floatValue], 
      @"Residence should parse bathrooms correctly");
  XCTAssertEqual(residence.bedrooms, 
    [[residenceDictionary objectForKey: @"bedrooms"] floatValue], 
      @"Residence should parse bedrooms correctly");
  XCTAssertEqual(residence.city, 
    [residenceDictionary objectForKey: @"city"], 
      @"Residence should parse city correctly");
  XCTAssertEqual(residence.createdAt, [[dateFormatter dateFromString:
    [residenceDictionary objectForKey: @"created_at"]] timeIntervalSince1970],
      @"Residence should parse created_at correctly");
  XCTAssertEqual(residence.desc, 
    [residenceDictionary objectForKey: @"description"], 
      @"Residence should parse description correctly");
  XCTAssertEqual(residence.email, 
    [residenceDictionary objectForKey: @"email"], 
      @"Residence should parse email correctly");
  XCTAssertEqual(residence.uid, 
    [[residenceDictionary objectForKey: @"id"] intValue], 
      @"Residence should parse id correctly");
  XCTAssertEqual(residence.landlordName, 
    [residenceDictionary objectForKey: @"landlord_name"], 
      @"Residence should parse landlord_name correctly");
  XCTAssertEqual(residence.latitude, 
    [[residenceDictionary objectForKey: @"latitude"] floatValue], 
      @"Residence should parse latitude correctly");
  XCTAssertEqual(residence.leaseMonths, 
    [[residenceDictionary objectForKey: @"lease_months"] intValue], 
      @"Residence should parse lease_months correctly");
  XCTAssertEqual(residence.longitude, 
    [[residenceDictionary objectForKey: @"longitude"] floatValue], 
      @"Residence should parse longitude correctly");
  XCTAssertEqual(residence.phone, 
    [residenceDictionary objectForKey: @"phone"], 
      @"Residence should parse phone correctly");
  XCTAssertEqual(residence.squareFeet, 
    [[residenceDictionary objectForKey: @"sqft"] intValue], 
      @"Residence should parse sqft correctly");
  XCTAssertEqual(residence.state, 
    [residenceDictionary objectForKey: @"state"], 
      @"Residence should parse state correctly");
  XCTAssertEqual(residence.updatedAt, [[dateFormatter dateFromString:
    [residenceDictionary objectForKey: @"updated_at"]] timeIntervalSince1970],
      @"Residence should parse updated_at correctly");
  XCTAssertEqual(residence.zip, 
    [residenceDictionary objectForKey: @"zip"], 
      @"Residence should parse zip correctly");
}

- (void) testavailableOnString :(NSString *) expectedString : (OMBResidence *) testResidence
{
  XCTAssertTrue(([expectedString isEqualToString: testResidence.availableOnString],
                 @"Supposed to be correct"));
}

- (void) testcoverPhoto : (UIImage *) indexZeroPhoto : (OMBResidence *) testResidence
{
  XCTAssertEqualObjects([[testResidence imagesArray] objectAtIndex:0], indexZeroPhoto,
                @"If the image and given image are same then it returns true and assertion success");
}

- (void) testcoverPhotoWithSize: (CGSize) testSize : (OMBResidence *) testResidence
{
  //what to test??
  
}

- (void) testdictionaryKey : (NSString *) testFormatedString : (OMBResidence *) testResidence
{
  XCTAssertEqualObjects( testFormatedString, [testResidence dictionaryKey],
                        @"Supposed to be -- latitude,longitude,-address format");
}

- (void) testimagesArray
{
  
}

- (void) testReadFromPropertyDictionary: (NSDictionary *) dictionary
{
  // Sample JSON
  //   {
  //     ad: 8550 fun street,  // Address
  //     available_on: "Soon", // Available on
  //     ba: 0,                // Bathrooms
  //     bd: 0,                // Bedrooms
  //     id: 10,               // ID
  //     lat: 32.79383,        // Latitude
  //     lease_months: null,   // Lease months
  //     lng: -117.07943,      // Longitude
  //     rt: 0                 // Rent
  //   }
}

- (void) testReadFromResidenceDictionary: (NSDictionary *) dictionary
{
  
}

- (void) testrentToCurrencyString
{
  
}

@end
