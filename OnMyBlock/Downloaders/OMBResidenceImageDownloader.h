//
//  OMBResidenceImageDownloader.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/25/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBImageDownloader.h"

@class OMBResidence;

@interface OMBResidenceImageDownloader : OMBImageDownloader

@property (nonatomic, strong) NSString *originalString;
@property (nonatomic) int position;
@property (nonatomic, weak) OMBResidence *residence;
@property (nonatomic) int residenceImageUID;

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

@end
