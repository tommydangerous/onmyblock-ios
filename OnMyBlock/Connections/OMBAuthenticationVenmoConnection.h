//
//  OMBAuthenticationVenmoConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@interface OMBAuthenticationVenmoConnection : OMBConnection

#pragma mark - Initializer

- (id) initWithCode: (NSString *) code;

@end
