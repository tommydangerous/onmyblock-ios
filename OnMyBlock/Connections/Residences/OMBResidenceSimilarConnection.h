//
//  OMBResidenceSimilarConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/29/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBResidence;

@interface OMBResidenceSimilarConnection : OMBConnection

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) residence;

@end
