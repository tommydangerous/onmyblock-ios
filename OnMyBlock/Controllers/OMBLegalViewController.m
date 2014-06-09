//
//  OMBLegalViewController.m
//  OnMyBlock
//
//  Created by Morgan Schwanke on 12/2/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBLegalViewController.h"

#import "NSString+Extensions.h"
#import "NSString+OnMyBlock.h"
#import "OMBActivityViewFullScreen.h"
#import "OMBLegalAnswer.h"
#import "OMBLegalAnswerCreateOrUpdateConnection.h"
#import "OMBLegalAnswerListConnection.h"
#import "OMBLegalQuestion.h"
#import "OMBLegalQuestionCell.h"
#import "OMBLegalQuestionStore.h"
#import "OMBRenterInfoSectionViewController.h"
#import "UIColor+Extensions.h"

@implementation OMBLegalViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super initWithUser: object])) return nil;

  legalAnswers = [NSMutableDictionary dictionary];

  self.title = @"Legal Questions";
  
  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  UIFont *boldFont = [UIFont boldSystemFontOfSize: 17];
  [doneBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];
  [saveBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];
  self.navigationItem.rightBarButtonItem = saveBarButtonItem;

  activityViewFullScreen = [[OMBActivityViewFullScreen alloc] init];
  [self.view addSubview:activityViewFullScreen];
  
  [self setupForTable];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  
  [[OMBLegalQuestionStore sharedStore] fetchLegalQuestionsWithCompletion:
    ^(NSError *error) {
      OMBLegalAnswerListConnection *connection =
        [[OMBLegalAnswerListConnection alloc] initWithUser: user];
      connection.completionBlock = ^(NSError *error) {
        legalAnswers = [NSMutableDictionary dictionaryWithDictionary:
          user.renterApplication.legalAnswers];
        [self.table reloadData];
        [activityViewFullScreen stopSpinning];
      };
      [connection start];
      [self.table reloadData];
    }
  ];
  [activityViewFullScreen startSpinning];
  [self.table reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  [self checkComplete];
  
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  return 2;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  if (indexPath.section == 0) {
    OMBLegalQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:
      CellIdentifier];
    if (!cell)
      cell = [[OMBLegalQuestionCell alloc] initWithStyle:
        UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    cell.delegate = self;
    cell.explanationTextView.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OMBLegalQuestion *legalQuestion = [[[OMBLegalQuestionStore sharedStore]
      questionsSortedByQuestion] objectAtIndex: indexPath.row];
    // Load the question
    [cell loadData: legalQuestion atIndexPath: indexPath];
    // Load the answer
    OMBLegalAnswer *legalAnswer = [legalAnswers objectForKey:
      [NSNumber numberWithInt: legalQuestion.uid]];
    [cell loadLegalAnswer: legalAnswer];
    cell.clipsToBounds = YES;
    return cell;
  }
  UITableViewCell *emptyCell = [[UITableViewCell alloc] init];
  emptyCell.clipsToBounds = YES;
  emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
  return emptyCell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  if (section == 0)
    return [[[OMBLegalQuestionStore sharedStore]
      questionsSortedByQuestion] count];
  else if (section == 1)
    return 1;
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (indexPath.section == 0) {
    OMBLegalQuestion *legalQuestion = [[[OMBLegalQuestionStore sharedStore]
      questionsSortedByQuestion] objectAtIndex: indexPath.row];
    NSString *text = [NSString stringWithFormat: @"%i. %@",
      indexPath.row + 1, legalQuestion.question];
    CGRect rect = [text boundingRectWithSize:
      CGSizeMake([OMBLegalQuestionCell widthForQuestionLabel], 9999)
        options: NSStringDrawingUsesLineFragmentOrigin
          attributes: @{ NSFontAttributeName:
          [OMBLegalQuestionCell fontForQuestionLabel] }
            context: nil];
    float padding = 20.0f;
    float height  = padding + rect.size.height + padding +
      [OMBLegalQuestionCell buttonSize] + padding;
    // If the answer is yes, show explain
    OMBLegalAnswer *legalAnswer = [legalAnswers objectForKey:
      [NSNumber numberWithInt: legalQuestion.uid]];
    if (legalAnswer && legalAnswer.answer)
      height += padding + [OMBLegalQuestionCell textViewHeight] + padding;
    return height;
  }
  else if (indexPath.section == 1) {
    if (isEditing)
      return 216.0f;
  }
  return 0.0f;
}

#pragma mark - Protocol UITextViewDelegate

- (void) textViewDidBeginEditing: (UITextView *) textView
{
  isEditing = YES;
  [self.table beginUpdates];
  [self.table endUpdates];
  if ([textView.text isEqualToString: LegalAnswerTextViewPlaceholder]) {
    textView.text = @"";
    textView.textColor = [UIColor textColor];
  }
  [self.navigationItem setRightBarButtonItem: doneBarButtonItem
    animated: YES];
  [self.table scrollToRowAtIndexPath:
    [NSIndexPath indexPathForRow: textView.tag inSection: 0]
      atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

- (void) textViewDidChange: (UITextView *) textView
{
  OMBLegalQuestionCell *cell = (OMBLegalQuestionCell *)
    [self.table cellForRowAtIndexPath:
      [NSIndexPath indexPathForRow: textView.tag inSection: 0]];
  cell.legalAnswer.explanation = textView.text;
  [self setLegalAnswer: cell.legalAnswer];
}

- (void) textViewDidEndEditing: (UITextView *) textView
{
  isEditing = NO;
  [self.table beginUpdates];
  [self.table endUpdates];
  if ([[textView.text stripWhiteSpace] length] == 0) {
    textView.text = LegalAnswerTextViewPlaceholder;
    textView.textColor = [UIColor grayMedium];
  }
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) checkComplete
{
  BOOL allAnswered = YES;
  
  for(OMBLegalQuestion *legalQuestion in
      [[OMBLegalQuestionStore sharedStore] questionsSortedByQuestion]){
    
    if(![legalAnswers objectForKey:
        [NSNumber numberWithInt: legalQuestion.uid]]){
      allAnswered = NO;
      NSLog(@"not exits");
    }
  }
  
  // Set YES if all questions have been answered
  [self saveKeyUserDefaults: allAnswered];
  
}

- (void) done
{
  [self.view endEditing: YES];
  [self.navigationItem setRightBarButtonItem: saveBarButtonItem
    animated: YES];
}

- (void) endEditingIfEditing
{
  if (isEditing)
    [self done];
}

- (void) nextSection
{
  
  [self.navigationController popViewControllerAnimated: YES];
}

- (NSMutableDictionary *) renterapplicationUserDefaults
{
  NSMutableDictionary *dictionary =
    [[NSUserDefaults standardUserDefaults] objectForKey:
      OMBUserDefaultsRenterApplication];
  if (!dictionary)
    dictionary = [NSMutableDictionary dictionary];
  return dictionary;
}

- (void) setLegalAnswer: (OMBLegalAnswer *) object
{
  if (object) {
    NSNumber *key = [NSNumber numberWithInt: object.legalQuestionID];
    OMBLegalAnswer *legalAnswer = [legalAnswers objectForKey: key];
    if (!legalAnswer) {
      legalAnswer = [[OMBLegalAnswer alloc] init];
      [legalAnswers setObject: object forKey: key];
    }
    legalAnswer.answer      = object.answer;
    legalAnswer.explanation = object.explanation;
  }
}

- (void) save
{
  for (OMBLegalAnswer *legalAnswer in [legalAnswers allValues]) {
    [[OMBUser currentUser] addLegalAnswer: legalAnswer];
    [[[OMBLegalAnswerCreateOrUpdateConnection alloc] initWithLegalAnswer:
      legalAnswer] start];
  }
  
  [self nextSection];
  
}

- (void) saveKeyUserDefaults: (BOOL)save
{
  NSMutableDictionary *dictionary =
    [NSMutableDictionary dictionaryWithDictionary:
      [self renterapplicationUserDefaults]];
  [dictionary setObject: [NSNumber numberWithBool: save]
    forKey: OMBUserDefaultsRenterApplicationCheckedLegalQuestions];
  [[NSUserDefaults standardUserDefaults] setObject: dictionary
    forKey: OMBUserDefaultsRenterApplication];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
