//
//  OMBResidenceLeaseAgreementViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceLeaseAgreementViewController.h"

#import "NSString+Extensions.h"

@implementation OMBResidenceLeaseAgreementViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = self.title = @"Lease Agreement";

  UIFont *font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  CGFloat lineHeight = 22.0f;

  NSString *string1 =
  @"For a full refund, cancellation must be made five full days prior to "
  @"listing's local check in time (or 3:00 PM if not specified) on the day "
  @"of check in. For example, if check-in is on Friday, cancel by the "
  @"previous Sunday before check in time.";
  text1 = [string1 attributedStringWithFont: font lineHeight: lineHeight];

  NSString *string2 =
  @"If the guest cancels less than 5 days in advance, the first night "
  @"is non-refundable but the remaining nights will be 50% refunded";
  text2 = [string2 attributedStringWithFont: font lineHeight: lineHeight];

  NSString *string3 =
  @"If the guest arrives and decides to leave early, the nights not spent "
  @"24 hours after the cancellation occurs are 50% refunded.";
  text3 = [string3 attributedStringWithFont: font lineHeight: lineHeight];

  NSString *string4 =
  @"Cleaning fees are always refunded if the guest did not check in. "
  @"The OnMyBlock service fee is non-refundable.";
  text4 = [string4 attributedStringWithFont: font lineHeight: lineHeight];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  self.table.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  return 1;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[UITableViewCell alloc] initWithStyle:
      UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.textLabel.numberOfLines = 0;
  NSAttributedString *text = @"";
  if (indexPath.row == 0) {
    text = text1;
  }
  else if (indexPath.row == 1) {
    text = text2;
  }
  else if (indexPath.row == 2) {
    text = text3;
  }
  else if (indexPath.row == 3) {
    text = text4;
  }

  cell.textLabel.attributedText = text;
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return 4;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGFloat padding = 20.0f;
  CGFloat maxWidth = tableView.frame.size.width - 
    (tableView.separatorInset.left * 2);
  NSAttributedString *text = @"";
  if (indexPath.row == 0) {
    text = text1;
  }
  else if (indexPath.row == 1) {
    text = text2;
  }
  else if (indexPath.row == 2) {
    text = text3;
  }
  else if (indexPath.row == 3) {
    text = text4;
  }
  return padding + [text boundingRectWithSize: 
    CGSizeMake(maxWidth, 9999) options: NSStringDrawingUsesLineFragmentOrigin 
      context: nil].size.height + padding;
}

@end
