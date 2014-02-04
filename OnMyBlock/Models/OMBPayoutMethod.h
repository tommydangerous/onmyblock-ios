//
//  OMBPayoutMethod.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  OMBPayoutMethodPayoutTypePayPal,
  OMBPayoutMethodPayoutTypeVenmo
} OMBPayoutMethodPayoutType;

@interface OMBPayoutMethod : NSObject

@property (nonatomic) BOOL active;
@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic) BOOL deposit;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *payoutType;
@property (nonatomic) BOOL payment;
@property (nonatomic) BOOL primary;
@property (nonatomic) NSInteger providerID;
@property (nonatomic) NSTimeInterval updatedAt;

@property (nonatomic) NSInteger uid;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) readFromDictionary: (NSDictionary *) dictionary;
- (OMBPayoutMethodPayoutType) type;

@end
