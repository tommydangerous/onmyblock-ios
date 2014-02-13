//
//  OMBInformationHowItWorksViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/13/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBCollectionViewController.h"

@interface OMBInformationHowItWorksViewController : OMBCollectionViewController
<UICollectionViewDataSource, UICollectionViewDelegate>
{
  NSMutableArray *informationSizeArray;
  UIFont *fontForInformationText;
}

@property (nonatomic, strong) NSArray *informationArray;

#pragma mark - Initializer

- (id) initWithInformationArray: (NSArray *) array;

@end
