//
//  OMBPropertyImageDownloader.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBImageDownloader.h"

@class OMBProperty;

@interface OMBPropertyImageDownloader : OMBImageDownloader

@property (nonatomic, weak) OMBProperty *property;

#pragma mark - Initializer

- (id) initWithProperty: (OMBProperty *) object;

@end
