//
//  OMBUser+Groups.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 8/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBUser+Groups.h"

// Models
#import "OMBGroup.h"

@implementation OMBUser (Groups)

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public

- (void)addGroup:(OMBGroup *)group
{
  [self.groups setObject:group forKey:@(group.uid)];
}

- (void)fetchGroupsWithAccessToken:(NSString *)accessToken
delegate:(id<OMBUserGroupsDelegate>)delegate
{
  [[self sessionManager] GET:@"groups" parameters:@{ 
    @"access_token": accessToken
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    [self readFromGroupsDictionary:responseObject];
    if ([delegate respondsToSelector:@selector(groupsFetchedSucceeded)]) {
      [delegate groupsFetchedSucceeded];
    }
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    if ([delegate respondsToSelector:@selector(groupsFetchedFailed:)]) {
      [delegate groupsFetchedFailed:error];
    }
  }];
}

- (void)fetchPrimaryGroupWithAccessToken:(NSString *)accessToken
delegate:(id<OMBUserGroupsDelegate>)delegate
{
  NSString *urlString = [NSString stringWithFormat:@"users/%i/primary-group",
    self.uid];
  [[self sessionManager] GET:urlString parameters:@{
    @"access_token": accessToken
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    [self readFromGroupsDictionary:responseObject];
    if ([delegate respondsToSelector:@selector(primaryGroupFetchedSucceeded)]) {
      [delegate primaryGroupFetchedSucceeded];
    }
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    if ([delegate respondsToSelector:@selector(primaryGroupFetchedFailed:)]) {
      [delegate primaryGroupFetchedFailed:error];
    }
  }];
}

- (OMBGroup *)primaryGroup
{
  return [[self.groups allValues] firstObject];
}

#pragma mark - Private

- (void)readFromGroupsDictionary:(id)dictionary
{
  for (NSDictionary *dict in [dictionary objectForKey:@"objects"]) {
    OMBGroup *group = [[OMBGroup alloc] init];
    [group readFromDictionary:dict];
    [self addGroup:group];
  }
}

@end
