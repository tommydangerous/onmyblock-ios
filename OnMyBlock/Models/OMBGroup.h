//
// Created by Tommy DANGerous on 8/4/14.
// Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBObject.h"

@class OMBUser;

@protocol OMBGroupDelegate <NSObject>

@optional

- (void)deleteUserFailed:(NSError *)error;
- (void)deleteUserSucceeded;
- (void)saveUserFailed:(NSError *)error;
- (void)saveUserSucceeded;

@end

@interface OMBGroup : OMBObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSUInteger ownerId;
@property (nonatomic, strong) NSMutableDictionary *users;

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public

- (void)addUser:(OMBUser *)user;
- (void)createUserWithDictionary:(NSDictionary *)dictionary 
accessToken:(NSString *)accessToken delegate:(id<OMBGroupDelegate>)delegate;
- (void)deleteUser:(OMBUser *)user accessToken:(NSString *)accessToken
delegate:(id<OMBGroupDelegate>)delegate;

@end
