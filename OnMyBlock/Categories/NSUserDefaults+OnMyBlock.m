//
//  NSUserDefaults+OnMyBlock.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 4/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "NSUserDefaults+OnMyBlock.h"

#import "NSString+OnMyBlock.h"

@implementation NSUserDefaults (OnMyBlock)

#pragma mark - Methods

#pragma mark - Instance Methods

- (NSMutableDictionary *) permissionDictionary
{
  NSDictionary *dictionary = [self objectForKey: OMBUserDefaultsPermission];
  if (!dictionary) {
    dictionary = [NSDictionary dictionary];
    [self updateObject: dictionary forKey: OMBUserDefaultsPermission];
  }
  return [NSMutableDictionary dictionaryWithDictionary: dictionary];
}

- (BOOL) permissionCurrentLocation
{
  return [self permissionForKey: OMBUserDefaultsPermissionCurrentLocation];
}

- (void) permissionCurrentLocationSet: (BOOL) allow
{
  [self permissionSet: allow forKey: OMBUserDefaultsPermissionCurrentLocation];
}

- (BOOL) permissionForKey: (id) key
{
  NSMutableDictionary *mDictionary = [self permissionDictionary];
  NSNumber *number = [mDictionary objectForKey: key];
  if (!number) {
    number = [NSNumber numberWithBool: NO];
    [mDictionary setObject: number forKey: key];
    [self updateObject: mDictionary forKey: OMBUserDefaultsPermission];
  }
  return [number boolValue];
}

- (BOOL) permissionPushNotifications
{
  return [self permissionForKey: OMBUserDefaultsPermissionPushNotifications];
}

- (void) permissionPushNotificationsSet: (BOOL) allow
{
  [self permissionSet: allow
    forKey: OMBUserDefaultsPermissionPushNotifications];
}

- (void) permissionSet: (BOOL) allow forKey: (id) key
{
  NSMutableDictionary *mDictionary = [self permissionDictionary];
  [mDictionary setObject: [NSNumber numberWithBool: allow] forKey: key];
  [self updateObject: mDictionary forKey: OMBUserDefaultsPermission];
}

- (void) updateObject: (id) object forKey: (id) key
{
  [[NSUserDefaults standardUserDefaults] setObject: object forKey: key];
  [self synchronize];
}

@end
