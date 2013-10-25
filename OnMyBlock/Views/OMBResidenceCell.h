//
//  OMBResidenceCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMBResidence;

@interface OMBResidenceCell : UITableViewCell
{
  UILabel *addressLabel;
  UIImageView *imageView;
}

@property (nonatomic, strong) OMBResidence *residence;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadResidence: (OMBResidence *) object;

@end
