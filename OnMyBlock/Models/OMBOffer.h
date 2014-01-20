//
//  OMBOffer.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMBResidence;
@class OMBUser;

@interface OMBOffer : NSObject

@property (nonatomic) BOOL accepted;
@property (nonatomic) CGFloat amount;
@property (nonatomic) BOOL confirmed;
@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic) BOOL declined;
@property (nonatomic) BOOL rejected;
@property (nonatomic) NSTimeInterval updatedAt;

@property (nonatomic, strong) OMBUser *landlordUser;
@property (nonatomic, strong) OMBResidence *residence;
@property (nonatomic) NSInteger uid;
@property (nonatomic, strong) OMBUser *user;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) readFromDictionary: (NSDictionary *) dictionary;

@end
