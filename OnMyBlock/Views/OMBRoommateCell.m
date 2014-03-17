//
//  OMBRoommateCell.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 3/17/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRoommateCell.h"

#import "OMBRoommate.h"

@implementation OMBRoommateCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style
     reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style
                    reuseIdentifier: reuseIdentifier])) return nil;
  
  CGRect screen     = [[UIScreen mainScreen] bounds];
  float screenWidth = screen.size.width;
  
  float padding = 20.0f;
  self.contentView.frame = CGRectMake(0, 0,
    screenWidth, padding + (22 * 2) + padding);
  
  nameLabel = [[UILabel alloc] init];
  nameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  nameLabel.frame = CGRectMake(padding, padding,
    screenWidth - (padding * 2), 22);
  nameLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: nameLabel];
  
  emailLabel = [[UILabel alloc] init];
  emailLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  emailLabel.frame = CGRectMake(nameLabel.frame.origin.x,
    nameLabel.frame.origin.y + nameLabel.frame.size.height,
      nameLabel.frame.size.width, nameLabel.frame.size.height);
  emailLabel.textColor = [UIColor blue];
  [self.contentView addSubview: emailLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  return 20.0f + (22.0f * 2.0f) + 20.0f;
}

#pragma mark - Instance Methods

- (void) loadData: (OMBRoommate *) object
{
  self.roommate = object;
  NSString *fullName = [NSString stringWithFormat: @"%@ %@",
    [self.roommate.firstName capitalizedString],
      [self.roommate.lastName capitalizedString]];
  
  nameLabel.text = fullName;
  emailLabel.text = [self.roommate.email lowercaseString];
  
}

@end
