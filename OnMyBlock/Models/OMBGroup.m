//
// Created by Tommy DANGerous on 8/4/14.
// Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBGroup.h"

// Models
#import "OMBUser.h"

@implementation OMBGroup

#pragma mark - Accessors

#pragma mark - Getters

- (NSMutableDictionary *)users
{
  if (!_users) {
    _users = [NSMutableDictionary dictionary];
  }
  return _users;
}

#pragma mark - Methods

#pragma mark - Class Methods

#pragma mark - Public

+ (NSString *)modelName
{
  return @"group";
}

+ (NSString *)resourceName
{
  return [NSString stringWithFormat:@"%@s", [OMBGroup modelName]];
}

#pragma mark - Instance Methods

#pragma mark - Public

- (void)addUser:(OMBUser *)user
{
  [self.users setObject:user forKey:@(user.uid)];
}

- (void)readFromDictionary:(NSDictionary *)dictionary
{
  // Name
  id name = [dictionary objectForKey:@"name"];
  if (name != [NSNull null]) {
    self.name = name;
  }

  // Owner ID
  id ownerId = [dictionary objectForKey:@"owner_id"];
  if (ownerId != [NSNull null]) {
    self.ownerId = [ownerId intValue];
  }

  // UID
  id uid = [dictionary objectForKey:@"id"];
  if (uid != [NSNull null]) {
    self.uid = [uid intValue];
  }

  // Users
  id users = [dictionary objectForKey:@"users"];
  if (users != [NSNull null]) {
    for (NSDictionary *dict in users) {
      OMBUser *user = [[OMBUser alloc] init];
      [user readFromDictionary: dict];
      [self addUser:user];
    }
  }
}

- (void)createUserWithDictionary:(NSDictionary *)dictionary 
accessToken:(NSString *)accessToken delegate:(id<OMBGroupDelegate>)delegate
{
  NSString *email = [dictionary objectForKey:@"email"] ?
    [dictionary objectForKey:@"email"] : @"";
  NSString *firstName = [dictionary objectForKey:@"firstName"] ?
    [dictionary objectForKey:@"firstName"] : @"";
  NSString *lastName = [dictionary objectForKey:@"lastName"] ?
    [dictionary objectForKey:@"lastName"] : @"";
  OMBSessionManager *manager = [OMBSessionManager sharedManager];
  [manager POST:@"groups/add_user" parameters:@{
    @"access_token": accessToken,
    @"email":        email,
    @"first_name":   firstName,
    @"last_name":    lastName
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    [self readFromDictionary:responseObject];
    [delegate saveUserSucceeded];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    [delegate saveUserFailed:error];
  }];
}

@end
