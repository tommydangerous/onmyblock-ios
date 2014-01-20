//
//  OMBHomebaseRenterAddRemoveRoommatesRoommateCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseRenterAddRemoveRoommatesRoommateCell.h"

#import "OMBUser.h"

@implementation OMBHomebaseRenterAddRemoveRoommatesRoommateCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];

  _removeButton = [UIButton new];
  _removeButton.contentHorizontalAlignment = 
    UIControlContentHorizontalAlignmentLeft;
  _removeButton.frame = CGRectMake(
    screen.size.width - (50.0f + objectImageView.frame.origin.x), 
      topLabel.frame.origin.y, 50.0f, topLabel.frame.size.height);
  _removeButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 13];
  [_removeButton setTitle: @"Remove" forState: UIControlStateNormal];
  [_removeButton setTitleColor: [UIColor red] forState: UIControlStateNormal];
  [self.contentView addSubview: _removeButton];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadData
{
  CGFloat imageSize = objectImageView.frame.size.width;

  if (arc4random_uniform(100) % 2) {
    NSString *sizeKey = [NSString stringWithFormat: @"%f,%f",
      imageSize, imageSize];
    objectImageView.image = [[OMBUser fakeUser] imageForSizeKey: sizeKey];
    topLabel.text = [[OMBUser fakeUser] fullName];
  }
  else {
    objectImageView.image = [UIImage imageNamed: @"tommy_d.png"];
    topLabel.text = @"Tommy Dang";
  }
}

@end
