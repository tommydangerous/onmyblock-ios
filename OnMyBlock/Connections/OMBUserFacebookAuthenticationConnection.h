//
//  OMBUserFacebookAuthenticationConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/31/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBUser;

@interface OMBUserFacebookAuthenticationConnection : OMBConnection
{
  OMBUser *user;
}

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object;

@end
