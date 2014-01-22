//
//  OMBPayoutMethod.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMBPayoutMethod : NSObject

@property (nonatomic) BOOL active;
@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic) BOOL deposit;
@property (nonatomic, strong) NSString *paypalEmail;
@property (nonatomic) BOOL primary;
@property (nonatomic, strong) NSString *payoutType;
@property (nonatomic) NSTimeInterval updatedAt;

@property (nonatomic) NSInteger uid;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) readFromDictionary: (NSDictionary *) dictionary;

@end
