//
//  OMBCreateListingConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBTemporaryResidence;

@interface OMBCreateListingConnection : OMBConnection
{
  OMBTemporaryResidence *temporaryResidence;
}

#pragma mark - Initializer

- (id) initWithTemporaryResidence: (OMBTemporaryResidence *) object 
dictionary: (NSDictionary *) dictionary;

@end
