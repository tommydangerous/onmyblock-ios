//
//  OMBTableParallaxViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 4/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@interface OMBTableParallaxViewController : OMBTableViewController

@property (nonatomic) BOOL parallaxEnabled;
@property (nonatomic) BOOL scalingEnabled;

#pragma mark - Methods

#pragma mark - Instance Methods

// Use this method to setup everything
- (void) setupBackgroundWithView: (UIView *) view
startingOffsetY: (NSUInteger) offsetY;

@end
