//
//  OMBEmployment.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/9/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMBEmployment : NSObject

@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *companyWebsite;
@property (nonatomic) NSTimeInterval endDate;
@property (nonatomic) float income;
@property (nonatomic) NSTimeInterval startDate;
@property (nonatomic, strong) NSString *title;

@property (nonatomic) int uid;

#pragma mark - Methods

#pragma mark - Instance Methods

- (NSString *) companyWebsiteString;
- (NSString *) numberOfMonthsEmployedString;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (NSString *) shortCompanyWebsiteString;

@end
