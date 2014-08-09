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

@optional

- (void)groupsFetchedFailed:(NSError *)error;
- (void)groupsFetchedSucceeded;
- (void)primaryGroupFetchedFailed:(NSError *)error;
- (void)primaryGroupFetchedSucceeded;

@end

@interface OMBUser (Groups)

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public

- (void)addGroup:(OMBGroup *)group;
- (void)fetchGroupsWithAccessToken:(NSString *)accessToken
delegate:(id<OMBUserGroupsDelegate>)delegate;
- (void)fetchPrimaryGroupWithAccessToken:(NSString *)accessToken
delegate:(id<OMBUserGroupsDelegate>)delegate;
- (OMBGroup *)primaryGroup;

@end
