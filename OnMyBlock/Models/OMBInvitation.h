//
//  OMBInvitation.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 8/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBObject.h"

@interface OMBInvitation : OMBObject

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic) NSInteger invitableId;
@property (nonatomic, strong) NSString *invitableType;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *providerId;
@property (nonatomic) NSInteger userId;

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public

- (NSString *)fullName;
- (NSURL *)providerImageURL;

@end
