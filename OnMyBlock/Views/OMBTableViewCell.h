//
//  OMBTableViewCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/6/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSString+Extensions.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"

@interface OMBTableViewCell : UITableViewCell
{
  float leftPadding;
}

@property (nonatomic, strong) UILabel *basicTextLabel;

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell;
+ (CGSize) sizeForImage;

@end
