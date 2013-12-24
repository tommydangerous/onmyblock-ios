//
//  OMBMapFilterBathroomsCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/20/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@interface OMBMapFilterBathroomsCell : OMBTableViewCell

@property (nonatomic, strong) NSMutableArray *buttons;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) deselectAllButtons;

@end
