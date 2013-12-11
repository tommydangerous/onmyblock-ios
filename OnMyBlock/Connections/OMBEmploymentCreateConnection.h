//
//  OMBEmploymentCreateConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/10/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@interface OMBEmploymentCreateConnection : OMBConnection
{
  OMBEmployment *employment;
}

#pragma mark - Initializer

- (id) initWithEmployment: (OMBEmployment *) object;

@end
