//
//  OMBFavoriteResidenceConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/1/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBResidence;

@interface OMBFavoriteResidenceConnection : OMBConnection

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) residence;

@end
