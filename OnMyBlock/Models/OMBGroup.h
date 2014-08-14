//
// Created by Tommy DANGerous on 8/4/14.
// Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBObject.h"

@class OMBUser;

@protocol OMBGroupDelegate <NSObject>

@optional

- (void)createSentApplicationFailed:(NSError *)error;
- (void)createSentApplicationSucceeded;
- (void)fetchSentApplicationsFailed:(NSError *)error;
- (void)fetchSentApplicationsSucceeded;

@end

@interface OMBGroup : OMBObject

@property (nonatomic, strong) NSMutableDictionary *invitations;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSUInteger ownerId;
@property (nonatomic, strong) NSMutableDictionary *sentApplications;
@property (nonatomic, strong) NSMutableDictionary *users;

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public

- (void)addUser:(OMBUser *)user;
- (void)createSentApplicationWithDictionary:(NSDictionary *)dictionary
accessToken:(NSString *)accessToken delegate:(id<OMBGroupDelegate>)delegate;
- (void)fetchSentApplicationsWithAccessToken:(NSString *)accessToken
delegate:(id<OMBGroupDelegate>)delegate;
- (NSArray *)sentApplicationsSortedByCreatedAt;

@end
