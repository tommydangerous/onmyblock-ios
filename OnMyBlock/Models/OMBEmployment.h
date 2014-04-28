//
//  OMBEmployment.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/9/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBObject.h"

@interface OMBEmployment : OMBObject

@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *companyWebsite;
@property (nonatomic) NSTimeInterval endDate;
@property (nonatomic) float income;
@property (nonatomic) NSTimeInterval startDate;
@property (nonatomic, strong) NSString *title;

#pragma mark - Methods

#pragma mark - Instance Methods

- (NSString *) companyWebsiteString;
- (NSString *) numberOfMonthsEmployedString;
- (NSString *) shortCompanyWebsiteString;

@end
