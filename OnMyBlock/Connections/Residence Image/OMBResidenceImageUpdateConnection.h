//
//  OMBResidenceImageUpdateConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBResidenceImage;

@interface OMBResidenceImageUpdateConnection : OMBConnection

#pragma mark - Initializer

- (id) initWithResidenceImage: (OMBResidenceImage *) object;

@end
