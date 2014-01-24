//
//  OMBPayoutTransaction.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/23/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMBOffer;
@class OMBResidence;
@class OMBUser;

@interface OMBPayoutTransaction : NSObject

@property (nonatomic) CGFloat amount;
@property (nonatomic) BOOL charged;
@property (nonatomic) BOOL expired;
@property (nonatomic, weak) OMBOffer *offer;
@property (nonatomic) BOOL paid;
@property (nonatomic, weak) OMBUser *payee;
@property (nonatomic, weak) OMBUser *payer;
@property (nonatomic, weak) OMBResidence *residence;
@property (nonatomic) BOOL verified;

@property (nonatomic) NSInteger uid;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) readFromDictionary: (NSDictionary *) dictionary;

@end
