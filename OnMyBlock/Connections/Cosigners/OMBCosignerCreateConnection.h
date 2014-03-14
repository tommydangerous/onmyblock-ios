//
//  OMBCosignerCreateConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBCosigner;

@interface OMBCosignerCreateConnection : OMBConnection

#pragma mark - Initializer

- (id) initWithCosigner: (OMBCosigner *) object;

@end
