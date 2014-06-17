//
//  OMBResidenceListConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/16/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@interface OMBResidenceListConnection : OMBConnection

#pragma mark - Initializer

- (id) initWithParameters: (NSDictionary *) dictionary;
- (id) initWithParametersForMap: (NSDictionary *) dictionary;

@end
