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
#import "NSString+OnMyBlock.h"
#import "OMBActivityViewFullScreen.h"
#import "OMBApplyResidenceViewController.h"
#import "OMBRenterApplication.h"
#import "OMBRenterInfoAddViewController.h"
#import "OMBObject.h"
#import "OMBUser.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

@interface OMBRenterInfoSectionViewController ()
{
  UIActionSheet *deleteActionSheet;
  NSIndexPath *selectedIndexPath;
}

@end

@implementation OMBRenterInfoSectionViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super init])) return nil;

  user = object;
  tagSection = 0;
  
  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen        = [self screen];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;

  [self setupForTable];
  self.table.tableFooterView = [[UIView alloc] initWithFrame:
    CGRectMake(0.0f, 0.0f, screenWidth, OMBStandardButtonHeight)];

  addButtonMiddle = [UIButton new];
  addButtonMiddle.backgroundColor = [UIColor blue];
  addButtonMiddle.clipsToBounds = YES;
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
  
  UIFont *boldFont = [UIFont boldSystemFontOfSize: 17];
  doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Done"
    style: UIBarButtonItemStylePlain target: self action: @selector(done)];
  [doneBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];
  
  self.navigationItem.rightBarButtonItem = doneBarButtonItem;
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  self.delegate.nextSection = 0;
  
  if(self.delegate){
    /*NSString *barButtonTitle =
      [OMBRenterInfoSectionViewController incompleteSections] > 0 ? @"Next": @"Done";
    
    if([OMBRenterInfoSectionViewController incompleteSections] == 1 &&
       [OMBRenterInfoSectionViewController lastIncompleteSection] == tagSection){
      barButtonTitle = @"Done";
    }*/
  
    NSString *barButtonTitle = @"Next";
    self.navigationItem.rightBarButtonItem.title = barButtonTitle;
  }
  
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  // Set YES if there is any object a the section
  BOOL haveObjects = [self objects].count > 0 ? YES : NO;
  [self saveKeyUserDefaults: haveObjects];
  
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

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
  return [[self objects] count];
}

#pragma mark - Protocol UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  selectedIndexPath = indexPath;
  [deleteActionSheet showInView: self.view];
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark - Methods

#pragma mark - Class Methods

/*+ (int)incompleteSections
{
  int incompletes = 0;
  
  if (![[[OMBRenterInfoSectionViewController renterapplicationUserDefaults] objectForKey:
         OMBUserDefaultsRenterApplicationCheckedCosigners] boolValue])
    incompletes += 1;
  
  if (![[[OMBRenterInfoSectionViewController renterapplicationUserDefaults] objectForKey:
         OMBUserDefaultsRenterApplicationCheckedRentalHistory] boolValue])
    incompletes += 1;
  
  if (![[[OMBRenterInfoSectionViewController renterapplicationUserDefaults] objectForKey:
         OMBUserDefaultsRenterApplicationCheckedWorkHistory] boolValue])
    incompletes += 1;
  
  if (![[[OMBRenterInfoSectionViewController renterapplicationUserDefaults] objectForKey:
         OMBUserDefaultsRenterApplicationCheckedLegalQuestions] boolValue])
    incompletes += 1;
  
  return incompletes;
}

+ (int)lastIncompleteSection
{
  
  if (![[[self renterapplicationUserDefaults] objectForKey:
         OMBUserDefaultsRenterApplicationCheckedCosigners] boolValue])
    return 2;
  
  if (![[[self renterapplicationUserDefaults] objectForKey:
         OMBUserDefaultsRenterApplicationCheckedRentalHistory] boolValue])
    return 3;
  
  if (![[[self renterapplicationUserDefaults] objectForKey:
         OMBUserDefaultsRenterApplicationCheckedWorkHistory] boolValue])
    return 4;
  
  if (![[[self renterapplicationUserDefaults] objectForKey:
         OMBUserDefaultsRenterApplicationCheckedLegalQuestions] boolValue])
    return 5;
  
  return 0;
  
}*/

+ (NSMutableDictionary *) renterapplicationUserDefaults
{
  NSMutableDictionary *dictionary =
   [[NSUserDefaults standardUserDefaults] objectForKey:
     OMBUserDefaultsRenterApplication];
  if (!dictionary)
    dictionary = [NSMutableDictionary dictionary];
  return dictionary;
}

#pragma mark - Instance Methods

- (void) addButtonSelected
{
  // Subclassess implement this
}

- (void) deleteModelObjectAtIndexPath: (NSIndexPath *) indexPath
{
  OMBObject *object = [[self objects] objectAtIndex: indexPath.row];
  [[self renterApplication] deleteModelConnection: object delegate: nil
    completion: nil];

  [self.table beginUpdates];
  [[self renterApplication] removeModel: object];
  [self.table deleteRowsAtIndexPaths: @[indexPath]
    withRowAnimation: UITableViewRowAnimationFade];
  [self.table endUpdates];

  [self hideEmptyLabel: [[self objects] count]];
}

- (void) done
{
  [self nextSection];
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

- (void) fetchObjectsForResourceName: (NSString *) resourceName
{
  [[self renterApplication] fetchListForResourceName: resourceName
    userUID: user.uid delegate: self completion: ^(NSError *error) {
      [self hideEmptyLabel: [[self objects] count]];
      [self stopSpinning];
    }];
  [self startSpinning];
}

- (void) nextSection
{
  BOOL animated = YES;
  if(self.delegate){ // && [OMBRenterInfoSectionViewController incompleteSections] > 0
    animated = NO;
    self.delegate.nextSection = tagSection;
  }
  
  [self.navigationController popViewControllerAnimated: animated];
}

- (NSArray *) objects
{
  // Subclasses implement this
  return [NSArray array];
}

- (OMBRenterApplication *) renterApplication
{
  return [OMBUser currentUser].renterApplication;
}

- (void) saveKeyUserDefaults: (BOOL)save
{
  NSMutableDictionary *dictionary =
    [NSMutableDictionary dictionaryWithDictionary:
      [OMBRenterInfoSectionViewController renterapplicationUserDefaults]];
  [dictionary setObject: [NSNumber numberWithBool: save] forKey: key];
  [[NSUserDefaults standardUserDefaults] setObject: dictionary
    forKey: OMBUserDefaultsRenterApplication];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) setEmptyLabelText: (NSString *) string
{
  CGRect screen = [self screen];

  // button centered
  CGRect buttonRect = addButtonMiddle.frame;
  buttonRect.origin.y = (screen.size.height - buttonRect.size.height) * .5f;
  addButtonMiddle.frame = buttonRect;
  
  emptyLabel.attributedText = [string attributedStringWithFont: 
    emptyLabel.font lineHeight: 27.0f];
  CGRect rect = [emptyLabel.attributedText boundingRectWithSize: 
    CGSizeMake(screen.size.width - (OMBPadding * 2), 9999.0f)
      options: NSStringDrawingUsesLineFragmentOrigin context: nil];
  
  // Text more toward top.
  CGFloat originY = addButtonMiddle.frame.origin.y - 
    rect.size.height - 2 * OMBPadding;
  emptyLabel.frame = CGRectMake(OMBPadding, originY,
      screen.size.width - (OMBPadding * 2), rect.size.height);
  emptyLabel.textAlignment = NSTextAlignmentCenter;

}

- (void) startSpinning
{
  if(!activityViewFullScreen){
    activityViewFullScreen = [[OMBActivityViewFullScreen alloc] init];
    [self.view addSubview:activityViewFullScreen];
  }
  
  [activityViewFullScreen startSpinning];
}

- (void) stopSpinning
{
  if(activityViewFullScreen)
    [activityViewFullScreen stopSpinning];
}


@end
