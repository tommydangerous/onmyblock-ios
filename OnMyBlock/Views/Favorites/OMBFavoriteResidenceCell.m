//
//  OMBResidenceFavoriteCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFavoriteResidenceCell.h"

#import "OMBFavoriteResidence.h"
#import "OMBUser.h"

@implementation OMBFavoriteResidenceCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style  
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]))
    return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];  

  userNameLabel = [UILabel new];
  userNameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 13];
  userNameLabel.frame = CGRectMake((screen.size.width * 0.5f) - 10.0f, 10.0f,
    screen.size.width * 0.5f, 19.0f);
  userNameLabel.textAlignment = NSTextAlignmentRight;
  userNameLabel.textColor = [UIColor whiteColor];
  [self.contentView addSubview: userNameLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadFavoriteResidenceData: (OMBFavoriteResidence *) object
{
  [super loadResidenceData: object.residence];
  userNameLabel.text = [NSString stringWithFormat: @"added by %@", 
    [object.user shortName]];
}

@end
