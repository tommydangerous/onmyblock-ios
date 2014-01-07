//
//  OMBEmploymentViewController.h
//  OnMyBlock
//
//  Created by Morgan Schwanke on 12/2/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBRenterApplicationSectionViewController.h"

@class OMBEmployment;

@interface OMBEmploymentListViewController : 
  OMBRenterApplicationSectionViewController

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) showCompanyWebsiteWebViewForEmployment: (OMBEmployment *) employment;

@end
