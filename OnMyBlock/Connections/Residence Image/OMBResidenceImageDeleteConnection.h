//
//  OMBResidenceImageDeleteConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/8/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

#import "OMBResidenceImage.h"

@interface OMBResidenceImageDeleteConnection : OMBConnection

#pragma mark - Initializer

- (id) initWithResidenceImage: (OMBResidenceImage *) object;

@end
