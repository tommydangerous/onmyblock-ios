//
//  OMBRenterInfoSectionViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/10/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoSectionViewController.h"

#import "AMBlurView.h"
#import "NSString+Extensions.h"
#import "OMBRenterInfoAddViewController.h"
#import "OMBUser.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

@interface OMBRenterInfoSectionViewController ()
{
  UIActionSheet *deleteActionSheet;
  NSIndexPath *selectedIndexPath;
  OMBUser *user;
}

@end

@implementation OMBRenterInfoSectionViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super init])) return nil;

  user = object;

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  self.navigationItem.rightBarButtonItem = doneBarButtonItem;

  CGRect screen        = [self screen];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;

  [self setupForTable];
  self.table.tableFooterView = [[UIView alloc] initWithFrame:
    CGRectMake(0.0f, 0.0f, screenWidth, OMBStandardButtonHeight)];

  addButtonMiddle = [UIButton new];
  addButtonMiddle.backgroundColor = [UIColor blue];
  addButtonMiddle.frame = CGRectMake(OMBPadding, 0.0f, 
    screenWidth - (OMBPadding * 2), OMBStandardButtonHeight);
  addButtonMiddle.hidden = YES;
  addButtonMiddle.layer.cornerRadius = OMBCornerRadius;
  addButtonMiddle.titleLabel.font = [UIFont mediumTextFontBold];
  [addButtonMiddle addTarget: self action: @selector(addButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [addButtonMiddle setBackgroundImage: 
    [UIImage imageWithColor: [UIColor blueHighlighted]] 
      forState: UIControlStateHighlighted];
  [addButtonMiddle setTitle: @"Add" forState: UIControlStateNormal];
  [addButtonMiddle setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  [self.view addSubview: addButtonMiddle];

  // Bottom blur view
  bottomBlurView = [[AMBlurView alloc] init];
  bottomBlurView.blurTintColor = [UIColor blue];
  bottomBlurView.hidden = YES;
  bottomBlurView.frame = CGRectMake(0.0f, 
    screenHeight - OMBStandardButtonHeight, 
      screenWidth, OMBStandardButtonHeight);
  [self.view addSubview: bottomBlurView];
  // Add button
  addButton = [UIButton new];
  addButton.frame = bottomBlurView.bounds;
  addButton.titleLabel.font = [UIFont mediumTextFontBold];
  [addButton addTarget: self action: @selector(addButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [addButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor blueHighlighted]] 
      forState: UIControlStateHighlighted];
  [addButton setTitle: @"Add" forState: UIControlStateNormal];
  [addButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateNormal];
  [bottomBlurView addSubview: addButton];

  // Empty label
  emptyLabel = [UILabel new];
  emptyLabel.font = [UIFont mediumTextFont];
  emptyLabel.hidden = YES;
  emptyLabel.numberOfLines = 0;
  emptyLabel.textColor = [UIColor grayMedium];
  [self.view addSubview: emptyLabel];

  deleteActionSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self
    cancelButtonTitle: @"Cancel" destructiveButtonTitle: @"Delete"
      otherButtonTitles: nil];
  [self.view addSubview: deleteActionSheet];
}

#pragma mark - Protocol

#pragma mark - Protocol UIActionSheetDelegate

- (void) actionSheet: (UIActionSheet *) actionSheet 
clickedButtonAtIndex: (NSInteger) buttonIndex
{
  if (buttonIndex == 0) {
    [self deleteModelObjectAtIndexPath: selectedIndexPath];
    selectedIndexPath = nil;
  }
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  selectedIndexPath = indexPath;
  [deleteActionSheet showInView: self.view];
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addButtonSelected
{
  // Subclassess implement this
}

- (void) deleteModelObjectAtIndexPath: (NSIndexPath *) indexPath
{
  // Subclasses implement this
}

- (void) done
{
  [self.navigationController popViewControllerAnimated: YES];
}

- (void) hideEmptyLabel: (BOOL) hide
{
  if (hide) {
    addButtonMiddle.hidden = YES;
    emptyLabel.hidden      = YES;
    bottomBlurView.hidden  = NO;
  }
  else {
    addButtonMiddle.hidden = NO;
    emptyLabel.hidden      = NO;
    bottomBlurView.hidden  = YES;
  }
}

- (OMBRenterApplication *) renterApplication
{
  return [OMBUser currentUser].renterApplication;
}

- (void) setEmptyLabelText: (NSString *) string
{
  CGRect screen        = [self screen];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;

  emptyLabel.attributedText = [string attributedStringWithFont: 
    emptyLabel.font lineHeight: 27.0f];
  CGRect rect = [emptyLabel.attributedText boundingRectWithSize: 
    CGSizeMake(screenWidth - (OMBPadding * 2), 9999.0f)
      options: NSStringDrawingUsesLineFragmentOrigin context: nil];
  emptyLabel.frame = CGRectMake(OMBPadding, (screenHeight - 
    (rect.size.height + addButtonMiddle.frame.size.height)) * 0.5f, 
      screenWidth - (OMBPadding * 2), rect.size.height);
  emptyLabel.textAlignment = NSTextAlignmentCenter;

  CGRect buttonRect = addButtonMiddle.frame;
  buttonRect.origin.y = emptyLabel.frame.origin.y + 
    emptyLabel.frame.size.height + (OMBPadding * 2);
  addButtonMiddle.frame = buttonRect;
}

@end
