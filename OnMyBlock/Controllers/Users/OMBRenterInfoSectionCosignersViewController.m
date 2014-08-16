//
//  OMBRenterInfoSectionCosignersViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoSectionCosignersViewController.h"

#import "NSString+OnMyBlock.h"
#import "OMBCosignerCell.h"
#import "OMBNavigationController.h"
#import "OMBRenterApplication.h"
#import "OMBRenterInfoAddCosignerViewController.h"

// Models
#import "OMBCosigner.h"

@interface OMBRenterInfoSectionCosignersViewController ()
<MFMailComposeViewControllerDelegate>

@end

@implementation OMBRenterInfoSectionCosignersViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super initWithUser: object])) return nil;

  self.title = @"Co-signers";
  tagSection = 2;

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  
  [self setEmptyLabelText: @"Some landlords require a co-signer \n"
    @"If you have one, add them here."];

  [addButton setTitle: @"Add Co-signer" forState: UIControlStateNormal];
  [addButtonMiddle setTitle: @"Add Co-signer" forState: UIControlStateNormal];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  
  key = OMBUserDefaultsRenterApplicationCheckedCosigners;
  
  [[self renterApplication] fetchCosignersForUserUID: [OMBUser currentUser].uid 
    delegate: self completion: ^(NSError *error) {
      [self stopSpinning];
      [self hideEmptyLabel: [[self objects] count]];
    }];
  [self startSpinning];

  [self reloadTable];
}

#pragma mark - Protocol

#pragma mark - Protocol MFMailComposeViewControllerDelegate

- (void) mailComposeController: (MFMailComposeViewController *) controller
didFinishWithResult: (MFMailComposeResult) result error: (NSError *) error
{
  [controller dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Protocol OMBConnectionProtocol

- (void) JSONDictionary: (NSDictionary *) dictionary
{
  [[self renterApplication] readFromCosignerDictionary: dictionary];
  [self reloadTable];
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSUInteger row     = indexPath.row;
  NSUInteger section = indexPath.section;

  static NSString *CosignerID = @"CosignerID";
  OMBCosignerCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CosignerID];
  if (!cell) {
    cell = [[OMBCosignerCell alloc] initWithStyle: UITableViewCellStyleDefault
      reuseIdentifier: CosignerID];
  }
  [cell loadData: [[self objects] objectAtIndex: row]];
  cell.emailButton.tag = row;
  cell.phoneButton.tag = row;
  [cell.emailButton addTarget: self action: @selector(emailCosigner:)
    forControlEvents: UIControlEventTouchUpInside];
  [cell.phoneButton addTarget: self action: @selector(phoneCallCosigner:)
    forControlEvents: UIControlEventTouchUpInside];
  // Last row
  if (row == [self tableView: tableView numberOfRowsInSection: section] - 1) {
    cell.separatorInset = UIEdgeInsetsMake(0.0f, tableView.frame.size.width,
      0.0f, 0.0f);
  }
  else {
    cell.separatorInset = tableView.separatorInset;
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return [[self objects] count];
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return [OMBCosignerCell heightForCell];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addButtonSelected
{
  [self presentViewController: 
    [[OMBNavigationController alloc] initWithRootViewController: 
      [[OMBRenterInfoAddCosignerViewController alloc] init]] animated: YES 
        completion: nil];
}

- (void) deleteModelObjectAtIndexPath: (NSIndexPath *) indexPath
{
  OMBCosigner *cosigner = [[self objects] objectAtIndex: indexPath.row];
  [[self renterApplication] deleteCosignerConnection: cosigner delegate: nil
    completion: nil];

  [self.table beginUpdates];
  [[self renterApplication] removeCosigner: cosigner];
  [self.table deleteRowsAtIndexPaths: @[indexPath]
    withRowAnimation: UITableViewRowAnimationFade];
  [self.table endUpdates];
  
  [self hideEmptyLabel: [[self objects] count]];
}

- (void) email: (NSArray *) recipients
{
  if ([MFMailComposeViewController canSendMail]) {
    MFMailComposeViewController *mailer =
      [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    // Subject
    [mailer setSubject: @"Hello"];
    // Recipients
    [mailer setToRecipients: recipients];
    // Body
    NSString *emailBody = @"";
    [mailer setMessageBody: emailBody isHTML: NO];
    if (mailer) {
      [self presentViewController: mailer animated: YES completion: nil];
    }
  }
}

- (void) emailCosigner: (id) sender
{
  OMBCosigner *cosigner = [[self objects] objectAtIndex: 
    ((UIButton *) sender).tag];
  [self email: @[cosigner.email]];
}

- (NSArray *) objects
{
  return [[self renterApplication] cosignersSortedByFirstName];
}

- (void) phoneCall: (NSString *) phone
{
  if ([phone length]) {
    NSString *string = [@"telprompt:" stringByAppendingString: phone];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: string]];
  }
}

- (void) phoneCallCosigner: (id) sender
{
  OMBCosigner *cosigner = [[self objects] objectAtIndex: 
    ((UIButton *) sender).tag];
  [self phoneCall: cosigner.phone];
}

- (void) reloadTable
{
  [self.table reloadData];
}

@end
