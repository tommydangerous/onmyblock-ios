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

  NSString *string = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";

  NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
  pStyle.maximumLineHeight = 23.0f;
  pStyle.minimumLineHeight = 23.0f;
  NSMutableAttributedString *aString = 
    [[NSMutableAttributedString alloc] initWithString: string attributes: @{
      NSParagraphStyleAttributeName: pStyle
    }
  ];
  _descriptionLabel.attributedText = aString;
  CGRect rect = [_descriptionLabel.attributedText boundingRectWithSize:
    CGSizeMake(_descriptionLabel.frame.size.width, 9999.0f)
      options: NSStringDrawingUsesLineFragmentOrigin context: nil];
  _descriptionLabel.frame = CGRectMake(_descriptionLabel.frame.origin.x,
    _descriptionLabel.frame.origin.y, _descriptionLabel.frame.size.width,
      rect.size.height);
  _descriptionLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: _descriptionLabel];

  return self;
}

@end


