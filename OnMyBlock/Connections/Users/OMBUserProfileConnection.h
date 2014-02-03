//
//  OMBUserProfileConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/3/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@interface OMBUserProfileConnection : OMBConnection
{
  OMBUser *user;
}

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object;

@end
