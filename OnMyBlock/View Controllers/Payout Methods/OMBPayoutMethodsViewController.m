//
//  OMBPaymentMethodsViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/11/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPayoutMethodsViewController.h"

#import "AMBlurView.h"
#import "OMBPayoutMethod.h"
#import "OMBPayoutMethodEditViewController.h"
#import "OMBPayoutMethodListCell.h"
#import "OMBSelectPayoutMethodViewController.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Color.h"

@implementation OMBPayoutMethodsViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.title = @"Your Payout Methods";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  // Add is not being used
  addBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Add"
    style: UIBarButtonItemStylePlain target: self action: @selector(add)];
  [addBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: [UIFont boldSystemFontOfSize: 17]
  } forState: UIControlStateNormal];
  cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Close"
    style: UIBarButtonItemStylePlain target: self action: @selector(cancel)];

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth = screen.size.width;
  CGFloat padding = OMBPadding;

  [self setupForTable];
  self.table.tableFooterView = [[UIView alloc] initWithFrame: CGRectMake(0.0f,
    0.0f, screenWidth, padding + OMBStandardButtonHeight + padding)];

  noPayoutMethodsView = [[UIView alloc] init];
  noPayoutMethodsView.alpha = 0.0f;
  noPayoutMethodsView.frame = CGRectMake(0.0f, 0.0f, 
    screenWidth, screenHeight);
  [self.view addSubview: noPayoutMethodsView];

  label2 = [[UILabel alloc] init];
  label2.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  label2.frame = CGRectMake(padding, 
    (screenHeight - (22.0f * 3)) * 0.5, 
      screenWidth - (padding * 2), 22.0f * 4);
  label2.numberOfLines = 0;
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  style.maximumLineHeight = 22.0f;
  style.minimumLineHeight = 22.0f;
  NSString *text = @"Your payout method is how you pay and receive money. "
    @"Funds are transferred within 48 hours after offers are accepted and "
    @"the lease has been signed.";
  NSMutableAttributedString *aString = 
    [[NSMutableAttributedString alloc] initWithString: text attributes: @{
      NSParagraphStyleAttributeName: style
    }
  ];
  label2.attributedText = aString;
  label2.textAlignment = NSTextAlignmentCenter;
  label2.textColor = [UIColor grayMedium];
  [noPayoutMethodsView addSubview: label2];

  label1 = [[UILabel alloc] init];
  label1.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 27];
  label1.frame = CGRectMake(padding, 
    label2.frame.origin.y - ((padding * 2) + (33.0f * 2)), 
      screenWidth - (padding * 2), 33.0f * 2);
  label1.numberOfLines = 0;
  label1.text = @"Set up your\n"
    @"payout methods.";
  label1.textAlignment = NSTextAlignmentCenter;
  label1.textColor = [UIColor blue];
  [noPayoutMethodsView addSubview: label1];

  // Add Payout Method
  selectPayoutMethodButton = [[UIButton alloc] init];
  // selectPayoutMethodButton.backgroundColor = [UIColor colorWithWhite: 1.0f
  //   alpha: 0.8f];
  selectPayoutMethodButton.backgroundColor = [UIColor blue];
  selectPayoutMethodButton.clipsToBounds = YES;
  // selectPayoutMethodButton.frame = CGRectMake(padding, 
  //   screenHeight - (OMBStandardButtonHeight + padding), 
  //     screenWidth - (padding * 2), OMBStandardButtonHeight);
  selectPayoutMethodButton.frame = CGRectMake(padding, 
    label2.frame.origin.y + label2.frame.size.height + (padding * 2), 
      screenWidth - (padding * 2), OMBStandardButtonHeight);
  // selectPayoutMethodButton.layer.borderColor = [UIColor blue].CGColor;
  // selectPayoutMethodButton.layer.borderWidth = 1.0f;
  // selectPayoutMethodButton.layer.cornerRadius = 
  //   selectPayoutMethodButton.frame.size.height * 0.5f;
  selectPayoutMethodButton.layer.cornerRadius = 5.0f;
  selectPayoutMethodButton.titleLabel.font = [UIFont mediumTextFont];
  [selectPayoutMethodButton addTarget: self 
    action: @selector(selectPayoutMethod) 
      forControlEvents: UIControlEventTouchUpInside];
  [selectPayoutMethodButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor blueHighlighted]] 
      forState: UIControlStateHighlighted];
  [selectPayoutMethodButton setTitle: @"Add Payout Method"
    forState: UIControlStateNormal];
  [selectPayoutMethodButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  // [selectPayoutMethodButton setTitleColor: [UIColor whiteColor]
  //   forState: UIControlStateHighlighted];
  [self.view addSubview: selectPayoutMethodButton];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  // Fetch payout methods
  [[OMBUser currentUser] fetchPayoutMethodsWithCompletion: ^(NSError *error) {
    if ([[self payoutMethods] count]) {
      // [UIView animateWithDuration: 0.25f animations: ^{
      //   noPayoutMethodsView.alpha = 0.0f;
      // }];
      // [self.navigationItem setRightBarButtonItem: addBarButtonItem
      //   animated: YES];
      noPayoutMethodsView.alpha = 0.0f;
    }
    else {
      noPayoutMethodsView.alpha = 1.0f;
    }
    [self.table reloadData];
  }];
  [self updateSelectPayoutMethodButton];
}

- (void) updateSelectPayoutMethodButton
{
  CGRect rect = selectPayoutMethodButton.frame;
  if ([[self payoutMethods] count]) {
    rect.origin.y = self.view.frame.size.height - 
      (rect.size.height + rect.origin.x);
  }
  else {
    rect.origin.y = label2.frame.origin.y + label2.frame.size.height + 
      (rect.origin.x * 2);
  }
  selectPayoutMethodButton.frame = rect;
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  OMBPayoutMethodListCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[OMBPayoutMethodListCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  OMBPayoutMethod *payoutMethod = [[self payoutMethods] objectAtIndex: 
    indexPath.row];
  [cell loadPayoutMethod: payoutMethod];
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return [[self payoutMethods] count];
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return [OMBPayoutMethodListCell heightForCell];
}

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  [self.navigationController pushViewController:
    [[OMBPayoutMethodEditViewController alloc] initWithPayoutMethod: 
      [[self payoutMethods] objectAtIndex: indexPath.row]] animated: YES];
  [self.table deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) add
{
  [self selectPayoutMethod];
}

- (void) cancel
{
  [self.navigationController dismissViewControllerAnimated: YES
    completion: ^{
      [self.navigationController popToRootViewControllerAnimated: YES];
    }
  ];
}

- (NSArray *) payoutMethods
{
  // Return only PayPal payout methods... for now
  NSArray *array =
    [[OMBUser currentUser] sortedPayoutMethodsWithKey: @"createdAt"
      ascending: NO];
  return [array filteredArrayUsingPredicate: [NSPredicate predicateWithBlock: 
    ^BOOL (id evaluatedObject, NSDictionary *bindings) {
      return [(OMBPayoutMethod *) evaluatedObject isPayPal];
    }
  ]];
}

- (void) selectPayoutMethod
{
  [self.navigationController pushViewController:
    [[OMBSelectPayoutMethodViewController alloc] init] animated: YES];
}

- (void) showCancelBarButtonItem
{
  self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
}

@end
