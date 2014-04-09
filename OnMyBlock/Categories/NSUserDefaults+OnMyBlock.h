//
//  NSUserDefaults+OnMyBlock.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 4/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (OnMyBlock)

#pragma mark - Methods

#pragma mark - Instance Methods

- (CGFloat) offerPriceThreshold;
- (void) offerPriceThresholdSet: (CGFloat) price;
- (NSMutableDictionary *) permissionDictionary;
- (BOOL) permissionCurrentLocation;
- (void) permissionCurrentLocationSet: (BOOL) allow;
- (BOOL) permissionPushNotifications;
- (void) permissionPushNotificationsSet: (BOOL) allow;

@end
