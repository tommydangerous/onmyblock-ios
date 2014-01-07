//
//  OMBUserStore.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMBUser;

@interface OMBUserStore : NSObject
{
  NSMutableDictionary *users;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBUserStore *) sharedStore;

#pragma mark Instance Methods

- (void) addUser: (OMBUser *) object;
- (OMBUser *) userWithUID: (int) uid;

@end
