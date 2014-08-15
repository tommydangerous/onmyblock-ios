//
//  OMBGroup+Users.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 8/9/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBGroup+Users.h"

// Models
#import "OMBUser.h"

@implementation OMBGroup (Users)

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Private

- (NSArray *)otherUsers:(OMBUser *)user
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K != %i",
    @"uid", user.uid];
  return [[self.users allValues] filteredArrayUsingPredicate:predicate];
}

- (void)removeUser:(OMBUser *)user
{
  [self.users removeObjectForKey:@(user.uid)];
}

#pragma mark - Public

- (void)createUserWithDictionary:(NSDictionary *)dictionary 
accessToken:(NSString *)accessToken delegate:(id<OMBGroupUsersDelegate>)delegate
{
  NSString *email = [dictionary objectForKey:@"email"] ?
    [dictionary objectForKey:@"email"] : @"";
  NSString *firstName = [dictionary objectForKey:@"firstName"] ?
    [dictionary objectForKey:@"firstName"] : @"";
  NSString *lastName = [dictionary objectForKey:@"lastName"] ?
    [dictionary objectForKey:@"lastName"] : @"";
  NSString *providerId = [dictionary objectForKey:@"providerId"] ?
    [dictionary objectForKey:@"providerId"] : @"";
  NSString *username = [dictionary objectForKey:@"username"] ?
    [dictionary objectForKey:@"username"] : @"";
    
  [[self sessionManager] POST:@"groups/add_user" parameters:@{
    @"access_token":   accessToken,
    @"created_source": @"ios",
    @"email":          email,
    @"first_name":     firstName,
    @"last_name":      lastName,
    @"provider_id":    providerId,
    @"username":       username
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    [self readFromDictionary:responseObject];
    if ([delegate respondsToSelector:@selector(saveUserSucceeded)]) {
      [delegate saveUserSucceeded];
    }
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    if ([delegate respondsToSelector:@selector(saveUserFailed:)]) {
      [delegate saveUserFailed:error];
    }
  }];
}

- (void)deleteUser:(OMBUser *)user accessToken:(NSString *)accessToken
delegate:(id<OMBGroupUsersDelegate>)delegate
{
  [[self sessionManager] POST:@"groups/remove_user" parameters:@{
    @"access_token": accessToken,
    @"user_id":      @(user.uid)
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    if ([delegate respondsToSelector:@selector(deleteUserSucceeded)]) {
      [self removeUser:user];
      [delegate deleteUserSucceeded];
    }
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    if ([delegate respondsToSelector:@selector(deleteUserFailed:)]) {
      [delegate deleteUserFailed:error];
    }
  }];
}

- (NSArray *)otherUsersSortedByFirstName:(OMBUser *)user
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"firstName"
    ascending:YES];
  return [[self otherUsers:user] sortedArrayUsingDescriptors:@[sort]];
}

- (NSArray *)usersSortedByFirstName
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"firstName"
    ascending:YES];
  return [[self.users allValues] sortedArrayUsingDescriptors:@[sort]];
}

@end
