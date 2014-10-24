//
//  OMBTermsPrivacyViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTermsPrivacyViewController.h"

#import "AMBlurView.h"
#import "UIColor+Extensions.h"

@implementation OMBTermsPrivacyViewController

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  self.table.separatorInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f);
  self.table.showsVerticalScrollIndicator = YES;
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  return [_storeArray count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
      reuseIdentifier: CellIdentifier];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.textLabel.numberOfLines = 0;
  cell.textLabel.textColor = [UIColor textColor];
  if (indexPath.row == 0) {
    NSDictionary *dictionary = [_storeArray objectAtIndex: indexPath.section];
    cell.textLabel.attributedText = [dictionary objectForKey: @"content"];
  }
  else {
    cell.textLabel.attributedText = nil;
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Spacing underneath the cell text label
  return 1 + 1;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView 
heightForHeaderInSection: (NSInteger) section
{
  return 44.0f;
}

- (CGFloat) tableView: (UITableView *) tableView 
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (indexPath.row == 0) {
    NSDictionary *dictionary = [_storeArray objectAtIndex: indexPath.section];
    CGSize size = [[dictionary objectForKey: @"size"] CGSizeValue];
    return size.height;
  }
  return 10.0f;
}

- (UIView *) tableView: (UITableView *) tableView 
viewForHeaderInSection: (NSInteger) section
{
  NSDictionary *dictionary = [_storeArray objectAtIndex: section];
  AMBlurView *blurView = [[AMBlurView alloc] init];
  blurView.blurTintColor = [UIColor whiteColor];
  blurView.frame = CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 44.0f);
  UILabel *label = [UILabel new];
  label.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  label.frame = CGRectMake(20.0f, 0.0f, 
    blurView.frame.size.width - (20.0f * 2), blurView.frame.size.height);
  label.text = [dictionary objectForKey: @"title"];
  label.textColor = [UIColor blueDark];
  [blurView addSubview: label];
  return blurView;
}

@end
