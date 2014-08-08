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

- (void)fetchGroupsWithDelegate:(id<OMBUserGroupsDelegate>)delegate
{
  OMBSessionManager *manager = [OMBSessionManager sharedManager];
  [manager GET:@"groups" parameters:@{ 
    @"access_token": [OMBUser currentUser].accessToken
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

- (OMBGroup *)primaryGroup
{
  OMBGroup *group = [[self.groups allValues] firstObject];
  if (!group) {
    [self fetchGroupsWithDelegate:nil];
    group = [[OMBGroup alloc] init];
  }
  return group;
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
