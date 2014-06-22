//
//  OMBSentApplication.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 5/19/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBObject.h"

@class OMBResidence;

@interface OMBSentApplication : OMBObject

@property (nonatomic) BOOL accepted;
@property (nonatomic) NSTimeInterval acceptedDate;
@property (nonatomic) BOOL cancelled;
@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic) BOOL declined;
@property (nonatomic) NSUInteger landlordUserID;
@property (nonatomic) NSTimeInterval moveInDate;
@property (nonatomic) NSTimeInterval moveOutDate;
@property (nonatomic) NSUInteger renterApplicationID;
@property (nonatomic) NSUInteger residenceID;
@property (nonatomic) BOOL sent;
@property (nonatomic) NSTimeInterval updatedAt;

// iOS
@property (nonatomic) BOOL paid;
@property (strong, nonatomic) OMBResidence *residence;

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public

- (NSInteger) numberOfMonthsBetweenMovingDates;

@end
