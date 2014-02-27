//
//  OMBRateFeedbackViewController.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 2/26/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRateFeedbackViewController.h"

#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

@implementation OMBRateFeedbackViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;
  
  self.screenName = self.title = @"Rate Us";
  
  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  
  self.table.backgroundColor = [UIColor grayUltraLight];
  self.table.separatorColor  = [UIColor grayLight];
  self.table.separatorInset  = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f);
  self.table.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
  self.table.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
}

#pragma mark - Protocol

#pragma mark - Protocol MFMailComposeViewController

- (void) mailComposeController:(MFMailComposeViewController *)controller
  didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
  switch (result)
  {
    case MFMailComposeResultCancelled:
      NSLog(@"Mail cancelled");
      break;
    case MFMailComposeResultSaved:
      NSLog(@"Mail saved");
      break;
    case MFMailComposeResultSent:
      NSLog(@"Mail sent");
      break;
    case MFMailComposeResultFailed:
      NSLog(@"Mail sent failure: %@", [error localizedDescription]);
      break;
    default:
      break;
  }
  
  // Close the Mail Interface
  [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Protocol UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if(buttonIndex == 1){
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:
      @"https://itunes.apple.com/us/app/onmyblock/id737199914?mt=8"]];
  }
  else if(buttonIndex == 2){
    [self showEmail];
  }
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // Rate our app, Feedback
  return 1;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  float borderHeight = 0.5f;
  
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:
                           UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  // If first row, it is the blank row used for spacing
  if (indexPath.row == 0) {
    cell.contentView.backgroundColor = self.table.backgroundColor;
    cell.selectedBackgroundView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"";
    cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
  }
  // Cells with text
  else {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:
                                   [UIImage imageWithColor: [UIColor grayLight]]];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
                                          size: 15];
    cell.textLabel.textColor = [UIColor textColor];
    if (indexPath.section == 0) {
      if (indexPath.row == 1) {
        cell.textLabel.text = @"Rate our App";
      }
      else if (indexPath.row == 2) {
        cell.textLabel.text = @"Send us Feedback";
      }
    }
  }
  // If it is the first or last row in the section
  if (indexPath.row == 0 || indexPath.row ==
      [self.table numberOfRowsInSection: indexPath.section] - 1) {
    if (indexPath.section !=
        [self numberOfSectionsInTableView: self.table] - 1) {
      // Bottom border
      CALayer *border = [CALayer layer];
      border.backgroundColor = [UIColor grayLight].CGColor;
      border.frame = CGRectMake(0.0f,
        cell.contentView.frame.size.height - borderHeight,
        cell.contentView.frame.size.width, borderHeight);
      [cell.layer addSublayer: border];
    }
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
  // The 1 is for the spacing
  if (section == 0) {
    return 1 + 2;
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (indexPath.section == 0) {
    // Rate our app
    if (indexPath.row == 1) {
      [self showRate];
    }
    // Send us feedback
    else if (indexPath.row == 2) {
      [self showEmail];
    }
  }
  [self.table deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return 44.0f;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) showEmail
{
  // device is able to send an email
  //if ([MFMailComposeViewController canSendMail]) {
  MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
  controller.mailComposeDelegate = self;
  [controller setMessageBody:@"" isHTML:NO];
  [controller setSubject:@"OnMyBlock for iPhone Feedback"];
  [controller setToRecipients:@[@"feedback@onmyblock.com"]];
  if(controller)
    [self presentViewController:controller animated:YES completion:nil];
  
}

- (void) showRate
{
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:
    @"Love the OnMyBlock App?" message: nil delegate: self
      cancelButtonTitle: @"Cancel" otherButtonTitles:
        @"Yes! It’s awesome!", @"No, It has problems.", nil];
  
  [alertView show];
}

@end
