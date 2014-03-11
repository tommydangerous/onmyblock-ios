//
//  OMBRenterInfoSectionViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/10/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBUser;

@interface OMBRenterInfoSectionViewController : OMBTableViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object;

@end
