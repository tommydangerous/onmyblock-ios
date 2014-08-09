//
//  OMBGroup+Users.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 8/9/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBGroup.h"

// Models
@class OMBUser;

@protocol OMBGroupUsersDelegate <NSObject>

@optional

- (void)deleteUserFailed:(NSError *)error;
- (void)deleteUserSucceeded;
- (void)saveUserFailed:(NSError *)error;
- (void)saveUserSucceeded;

@end

@interface OMBGroup (Users)

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public

- (void)createUserWithDictionary:(NSDictionary *)dictionary 
accessToken:(NSString *)accessToken 
delegate:(id<OMBGroupUsersDelegate>)delegate;
- (void)deleteUser:(OMBUser *)user accessToken:(NSString *)accessToken
delegate:(id<OMBGroupUsersDelegate>)delegate;
- (NSArray *)otherUsersSortedByFirstName:(OMBUser *)user;
- (NSArray *)usersSortedByFirstName;

@end
