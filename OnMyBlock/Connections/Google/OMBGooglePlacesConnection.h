//
//  OMBGooglePlacesConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@interface OMBGooglePlacesConnection : OMBConnection

#pragma mark - Initializer

- (id) initWithString: (NSString *) string citiesOnly: (BOOL) citiesOnly;

@end
