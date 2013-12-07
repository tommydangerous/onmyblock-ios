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
@property (nonatomic, strong) NSString *landlordPhone;
@property (nonatomic) int leaseMonths;
@property (nonatomic) float rent;
@property (nonatomic, strong) NSString *state;
@property (nonatomic) int uid;
@property (nonatomic, strong) NSString *zip;

@end
