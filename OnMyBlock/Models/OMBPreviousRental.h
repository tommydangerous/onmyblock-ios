//
//  OMBPreviousRental.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/6/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMBPreviousRental : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *landlordEmail;
@property (nonatomic, strong) NSString *landlordName;
@property (nonatomic, strong) NSString *landlordLastName;
@property (nonatomic, strong) NSString *landlordPhone;
@property (nonatomic) int leaseMonths;
@property (nonatomic) NSTimeInterval moveInDate;
@property (nonatomic) NSTimeInterval moveOutDate;
@property (nonatomic) float rent;
@property (nonatomic, strong) NSString *school;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zip;

@property (nonatomic) int uid;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) readFromDictionary: (NSDictionary *) dictionary;

@end
