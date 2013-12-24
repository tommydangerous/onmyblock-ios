//
//  OMBResidenceMonthlyPaymentScheduleViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceMonthlyPaymentScheduleViewController.h"

#import "NSString+Extensions.h"
#import "OMBResidence.h"
#import "UIColor+Extensions.h"

@implementation OMBResidenceMonthlyPaymentScheduleViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  residence = object;

  self.screenName = self.title = @"Monthly Payment Schedule";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setupForTable];

  CGRect screen        = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;

  CGFloat padding = 20.0f;

  UILabel *headerLabel = [[UILabel alloc] init];
  headerLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
  headerLabel.frame = CGRectMake(0.0f, padding, 
    screenWidth - (padding * 2), padding + (27.0f * 2) + padding);
  headerLabel.numberOfLines = 0;
  NSString *string1 = @"This is how you will\n"
    @"be billed during your stay.";
  headerLabel.attributedText = [string1 attributedStringWithLineHeight: 27.0f];
  headerLabel.textAlignment = NSTextAlignmentCenter;
  headerLabel.textColor = [UIColor grayMedium];
  self.table.tableHeaderView = headerLabel;

  UILabel *footerLabel = [[UILabel alloc] init];
  footerLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  footerLabel.frame = CGRectMake(padding, padding, 
    screenWidth - (padding * 2), (22 * 5));
  footerLabel.numberOfLines = 0;
  NSString *string2 = @"The 1st month's rent is due only after the seller "
    @"accepts your offer and you confirm the charge. After the first payment, "
    @"we will automatically charge the rent you agreed to pay on the 3rd of "
    @"every month.";
  footerLabel.attributedText = [string2 attributedStringWithLineHeight: 22.0f];
  footerLabel.textAlignment = NSTextAlignmentCenter;
  footerLabel.textColor = [UIColor grayMedium];
  UIView *footerView = [[UIView alloc] init];
  footerView.frame = CGRectMake(0.0f, 0.0f, 
    screenWidth, padding + footerLabel.frame.size.height + padding);
  [footerView addSubview: footerLabel];
  self.table.tableFooterView = footerView;
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[UITableViewCell alloc] initWithStyle:
      UITableViewCellStyleValue1 reuseIdentifier: CellIdentifier];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.detailTextLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" 
    size: 18];
  cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 18];
  if (indexPath.row == 0) {
    cell.detailTextLabel.text = @"$2,500";
    cell.detailTextLabel.textColor = 
      cell.textLabel.textColor = [UIColor blueDark];
    cell.textLabel.text = @"Due Upfront";
    CALayer *topBorder = [CALayer layer];
    topBorder.backgroundColor = self.table.separatorColor.CGColor;
    topBorder.frame = CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 0.5f);
    [cell.contentView.layer addSublayer: topBorder];
  }
  else {
    cell.detailTextLabel.textColor = 
      cell.textLabel.textColor = [UIColor textColor];
    if (indexPath.row == 1) {
      cell.textLabel.attributedText = 
        [@"Jan 3, 14 " attributedStringWithString: @"- Monday"
          primaryColor: [UIColor textColor] 
            secondaryColor: [UIColor grayMedium]];
    }
    else if (indexPath.row == 2) {
      cell.textLabel.attributedText = 
        [@"Feb 3, 14 " attributedStringWithString: @"- Tuesday"
          primaryColor: [UIColor textColor] 
            secondaryColor: [UIColor grayMedium]];
    }
    else if (indexPath.row == 3) {
      cell.textLabel.attributedText = 
        [@"Mar 3, 14 " attributedStringWithString: @"- Friday"
          primaryColor: [UIColor textColor] 
            secondaryColor: [UIColor grayMedium]];
    }
    cell.detailTextLabel.text = @"$2,500";
    if (indexPath.row == 
      [tableView numberOfRowsInSection: indexPath.section] - 1) {
      CALayer *bottomBorder = [CALayer layer];
      bottomBorder.backgroundColor = self.table.separatorColor.CGColor;
      bottomBorder.frame = CGRectMake(0.0f, (20.0f + 27.0f + 20.0f) - 0.5f, 
        tableView.frame.size.width, 0.5f);
      [cell.contentView.layer addSublayer: bottomBorder];
    }
  }
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
  return padding + 27.0f + padding;
}

@end
