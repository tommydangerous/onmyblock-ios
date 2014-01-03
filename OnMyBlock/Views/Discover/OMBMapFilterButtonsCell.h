//
//  OMBMapFilterButtonsCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/2/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@interface OMBMapFilterButtonsCell : OMBTableViewCell

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic) int maxButtons;
@property (nonatomic, strong) NSMutableDictionary *selectedButtons;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) resetButtons;
- (void) setupButtons;
- (void) setupButtonTitles;

@end
