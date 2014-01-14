//
//  OMBResidenceDetailDescriptionCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/17/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceDetailDescriptionCell.h"

@implementation OMBResidenceDetailDescriptionCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];

  float screeWidth = screen.size.width;

  float padding = 20.0f;

  self.titleLabel.text = @"Description";

  _descriptionLabel = [[UILabel alloc] init];
  _descriptionLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  _descriptionLabel.frame = CGRectMake(padding,
    self.titleLabel.frame.origin.y + 
    self.titleLabel.frame.size.height + padding, 
      screeWidth - (padding * 2), 0.0f);
  _descriptionLabel.numberOfLines = 0;
  _descriptionLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: _descriptionLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadData: (NSString *) string
{
  _descriptionLabel.attributedText = [string attributedStringWithFont:
    _descriptionLabel.font lineHeight: 23.0f];
  CGRect rect = [_descriptionLabel.attributedText boundingRectWithSize:
    CGSizeMake(_descriptionLabel.frame.size.width, 9999.0f)
      options: NSStringDrawingUsesLineFragmentOrigin context: nil];
  _descriptionLabel.frame = CGRectMake(_descriptionLabel.frame.origin.x,
    _descriptionLabel.frame.origin.y, _descriptionLabel.frame.size.width,
      rect.size.height);
}

@end


