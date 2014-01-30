//
//  OMBRenterApplicationUpdateConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/6/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBRenterApplication;

@interface OMBRenterApplicationUpdateConnection : OMBConnection
{
  OMBRenterApplication *renterApplication;
}

#pragma mark - Initializer

- (id) initWithRenterApplication: (OMBRenterApplication *) object
dictionary: (NSDictionary *) dictionary;

@end
