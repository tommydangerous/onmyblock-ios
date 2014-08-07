//
//  OMBUser+Groups.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 8/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBUser.h"

@class OMBGroup;

@protocol OMBUserGroupsDelegate <NSObject>

- (void)groupsFetchedFailed:(NSError *)error;
- (void)groupsFetchedSucceeded;

@end

@interface OMBUser (Groups)

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public

- (void)addGroup:(OMBGroup *)group;
- (void)fetchGroupsWithDelegate:(id<OMBUserGroupsDelegate>)delegate;

@end
