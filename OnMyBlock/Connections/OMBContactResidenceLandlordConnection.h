//
//  OMBContactResidenceLandlordConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBResidence;

@interface OMBContactResidenceLandlordConnection : OMBConnection

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) residence 
message: (NSString *) message;

@end
