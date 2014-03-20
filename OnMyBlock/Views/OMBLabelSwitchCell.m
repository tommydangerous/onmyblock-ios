//
//  OMBLabelSwitchCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBLabelSwitchCell.h"

#import "OMBViewController.h"

@interface OMBLabelSwitchCell ()
{
  UISwitch *switchButton;
}

@end

@implementation OMBLabelSwitchCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  switchButton = [UISwitch new];
  switchButton.onTintColor = [UIColor blue];
  [self.contentView addSubview: switchButton];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setFrameUsingSize: (CGSize) size
{
  [super setFrameUsingSize: size];

  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = OMBPadding;

  switchButton.frame = CGRectMake(
    screenWidth - (switchButton.frame.size.width + padding), 
      (size.height - switchButton.frame.size.height) * 0.5f,
        switchButton.frame.size.width, switchButton.frame.size.height);

  self.textFieldLabel.frame = CGRectMake(padding, (OMBStandardButtonHeight - OMBStandardHeight) * 0.5f,
    size.width, OMBStandardHeight);
}

- (void) addTarget: (id) target action: (SEL) selector
{
  [switchButton removeTarget: target action: nil
    forControlEvents: UIControlEventTouchUpInside];
  [switchButton addTarget: target action: selector 
    forControlEvents: UIControlEventTouchUpInside];
}

@end
