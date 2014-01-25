//
//  OMBUserStore.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBUserStore.h"

#import "OMBUser.h"

@implementation OMBUserStore

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  users = [NSMutableDictionary dictionary];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBUserStore *) sharedStore
{
  static OMBUserStore *store = nil;
  if (!store)
    store = [[OMBUserStore alloc] init];
  return store;
}

#pragma mark Instance Methods

- (void) addUser: (OMBUser *) object
{
  [users setObject: object forKey: [NSNumber numberWithInt: object.uid]];
}

- (void) removeUser: (OMBUser *) object
{
  [users removeObjectForKey: [NSNumber numberWithInt: object.uid]];
}

- (NSDictionary *) users
{
  return (NSDictionary *) users;
}

- (OMBUser *) userWithUID: (int) uid
{
  return [users objectForKey: [NSNumber numberWithInt: uid]];
}

@end
