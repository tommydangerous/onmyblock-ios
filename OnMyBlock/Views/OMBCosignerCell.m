//
//  OMBCosignerCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCosignerCell.h"

#import "OMBCosigner.h"
#import "NSString+PhoneNumber.h"
#import "UIColor+Extensions.h"

@implementation OMBCosignerCell

#pragma mark - Initialize

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{ 
  if (!(self = [super initWithStyle: style 
    reuseIdentifier: reuseIdentifier])) return nil;

  CGRect screen     = [[UIScreen mainScreen] bounds];
  float screenWidth = screen.size.width;

  float padding = 20.0f;
  self.contentView.frame = CGRectMake(0, 0, 
    screenWidth, padding + (22 * 3) + padding);

  nameLabel = [[UILabel alloc] init];
  nameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  nameLabel.frame = CGRectMake(padding, padding, 
    screenWidth - (padding * 2), 22);
  nameLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: nameLabel];

  emailLabel = [[UILabel alloc] init];
  emailLabel.font = nameLabel.font;
  emailLabel.frame = CGRectMake(nameLabel.frame.origin.x,
    nameLabel.frame.origin.y + nameLabel.frame.size.height,
      nameLabel.frame.size.width, nameLabel.frame.size.height);
  emailLabel.textColor = nameLabel.textColor;
  [self.contentView addSubview: emailLabel];

  phoneLabel = [[UILabel alloc] init];
  phoneLabel.font = nameLabel.font;
  phoneLabel.frame = CGRectMake(nameLabel.frame.origin.x,
    emailLabel.frame.origin.y + emailLabel.frame.size.height,
      nameLabel.frame.size.width, nameLabel.frame.size.height);
  phoneLabel.textColor = nameLabel.textColor;
  [self.contentView addSubview: phoneLabel];

  return self;
}

#pragma mark - Override

#pragma mark - Override UITableViewCell

- (void) setSelected: (BOOL) selected animated: (BOOL) animated
{
  [super setSelected:selected animated:animated];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadData: (OMBCosigner *) object
{
  _cosigner = object;
  nameLabel.text = [NSString stringWithFormat: @"%@ %@",
    [_cosigner.firstName capitalizedString], 
      [_cosigner.lastName capitalizedString]];
  emailLabel.text = [_cosigner.email lowercaseString];
  if ([[_cosigner.phone phoneNumberString] length] > 0)
    phoneLabel.text = [_cosigner.phone phoneNumberString];
  else
    phoneLabel.text = @"no phone number";
}

@end
