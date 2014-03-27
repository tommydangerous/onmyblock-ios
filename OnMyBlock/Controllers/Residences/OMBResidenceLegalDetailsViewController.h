//
//  OMBResidenceLegalDetailsViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/24/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class OMBResidence;

typedef NS_ENUM(NSUInteger, OMBResidenceLegalDetailsDocumentType) {
  OMBResidenceLegalDetailsDocumentTypeLeaseAgreement,
  OMBResidenceLegalDetailsDocumentTypeMemoOfDisclosure,
  OMBResidenceLegalDetailsDocumentTypeCosignerAgreement
};

@interface OMBResidenceLegalDetailsViewController : OMBViewController
 <UIScrollViewDelegate>

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

@end
