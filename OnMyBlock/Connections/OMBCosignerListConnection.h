//
//  OMBCosignerListConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@interface OMBCosignerListConnection : OMBConnection
{
  OMBUser *user;
}

- (id) initWithUser: (OMBUser *) object;

@end
