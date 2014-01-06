//
//  OMBLegalQuestionCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/10/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBLegalQuestionCell.h"

#import "NSString+Extensions.h"
#import "OMBLegalAnswer.h"
#import "OMBLegalQuestion.h"
#import "OMBLegalViewController.h"

NSString *const LegalAnswerTextViewPlaceholder = @"Please explain...";

@implementation OMBLegalQuestionCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{ 
  if (!(self = [super initWithStyle: style 
    reuseIdentifier: reuseIdentifier])) return nil;

  _legalAnswer = [[OMBLegalAnswer alloc] init];

  CGRect screen = [[UIScreen mainScreen] bounds];
  float screenWidth = screen.size.width;

  float padding = 20.0f;

  questionLabel = [[UILabel alloc] init];
  questionLabel.font = [OMBLegalQuestionCell fontForQuestionLabel];
  questionLabel.frame = CGRectMake(padding, padding, 
    [OMBLegalQuestionCell widthForQuestionLabel], 22.0f);
  questionLabel.numberOfLines = 0;
  questionLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: questionLabel];

  float buttonSize = [OMBLegalQuestionCell buttonSize];
  // Yes
  yesButton = [[UIButton alloc] init];
  yesButton.frame = CGRectMake((screenWidth - (buttonSize * 2)) / 3.0, 
    questionLabel.frame.origin.y + questionLabel.frame.size.height,
      buttonSize, buttonSize);
  yesButton.layer.borderColor = [UIColor grayMedium].CGColor;
  yesButton.layer.borderWidth = 1.5f;
  yesButton.layer.cornerRadius = yesButton.frame.size.width * 0.5;
  yesButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 18];
  [yesButton addTarget: self action: @selector(toggleButton:)
    forControlEvents: UIControlEventTouchDown];
  [yesButton setTitle: @"Yes" forState: UIControlStateNormal];
  [yesButton setTitleColor: [UIColor grayMedium] 
    forState: UIControlStateNormal];
  [self.contentView addSubview: yesButton];
  // No
  noButton = [[UIButton alloc] init];
  noButton.frame = CGRectMake(yesButton.frame.origin.x + 
    yesButton.frame.size.width + yesButton.frame.origin.x, 
      yesButton.frame.origin.y, yesButton.frame.size.width,
        yesButton.frame.size.height);
  noButton.layer.borderColor = [UIColor grayMedium].CGColor;
  noButton.layer.borderWidth = yesButton.layer.borderWidth;
  noButton.layer.cornerRadius = yesButton.layer.cornerRadius;
  noButton.titleLabel.font = yesButton.titleLabel.font;
  [noButton addTarget: self action: @selector(toggleButton:)
    forControlEvents: UIControlEventTouchDown];
  [noButton setTitle: @"No" forState: UIControlStateNormal];
  [noButton setTitleColor: [UIColor grayMedium] forState: UIControlStateNormal];
  [self.contentView addSubview: noButton];

  lineView = [[UIView alloc] init];
  lineView.backgroundColor = [UIColor grayLight];
  lineView.frame = CGRectMake(padding, 
    yesButton.frame.origin.y + yesButton.frame.size.height + padding,
      screenWidth - padding, 0.5f);
  [self.contentView addSubview: lineView];

  // Explanation text view
  _explanationTextView = [[UITextView alloc] init];
  _explanationTextView.autocorrectionType = UITextAutocorrectionTypeYes;
  _explanationTextView.contentInset = UIEdgeInsetsMake(0, -2, 0, 0);
  _explanationTextView.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 15];
  _explanationTextView.frame = CGRectMake(padding,
    lineView.frame.origin.y + padding,
      screenWidth - (padding * 2), [OMBLegalQuestionCell textViewHeight]);
  _explanationTextView.keyboardAppearance = UIKeyboardAppearanceLight;
  _explanationTextView.text = LegalAnswerTextViewPlaceholder;
  _explanationTextView.textColor = [UIColor grayMedium];
  [self.contentView addSubview: _explanationTextView];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) buttonSize
{
  return 70.0f;
}

+ (UIFont *) fontForQuestionLabel
{
  return [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
}

+ (CGFloat) textViewHeight
{
  return 22.0f * 3.0f;
}

+ (CGFloat) widthForQuestionLabel
{
  CGRect screen     = [[UIScreen mainScreen] bounds];
  float screenWidth = screen.size.width;
  float padding     = 20.0f;
  return screenWidth - (padding * 2);
}

#pragma mark - Instance Methods

- (void) loadData: (OMBLegalQuestion *) object 
atIndexPath: (NSIndexPath *) indexPath
{
  _legalQuestion = object;

  float padding = 20.0f;

  NSString *text = [NSString stringWithFormat: @"%i. %@",
    indexPath.row + 1, _legalQuestion.question];
  questionLabel.text = text;
  CGRect rect1 = [questionLabel.text boundingRectWithSize:
    CGSizeMake(questionLabel.frame.size.width, 9999)
      options: NSStringDrawingUsesLineFragmentOrigin
        attributes: @{ NSFontAttributeName: questionLabel.font }
          context: nil];
  questionLabel.frame = CGRectMake(questionLabel.frame.origin.x,
    questionLabel.frame.origin.y, questionLabel.frame.size.width,
      rect1.size.height);

  yesButton.frame = CGRectMake(yesButton.frame.origin.x, 
    questionLabel.frame.origin.y + questionLabel.frame.size.height + padding, 
      yesButton.frame.size.width, yesButton.frame.size.height);
  noButton.frame = CGRectMake(noButton.frame.origin.x,
    yesButton.frame.origin.y, noButton.frame.size.width, 
      noButton.frame.size.height);

  lineView.frame = CGRectMake(lineView.frame.origin.x,
    yesButton.frame.origin.y + yesButton.frame.size.height + padding,
      lineView.frame.size.width, lineView.frame.size.height);

  if ([[_legalAnswer.explanation stripWhiteSpace] length] > 0) {
    _explanationTextView.text = _legalAnswer.explanation;
    _explanationTextView.textColor = [UIColor textColor];
  }
  else {
    _explanationTextView.text = LegalAnswerTextViewPlaceholder;
    _explanationTextView.textColor = [UIColor grayMedium];
  }
  _explanationTextView.frame = CGRectMake(_explanationTextView.frame.origin.x,
    lineView.frame.origin.y + padding,
      _explanationTextView.frame.size.width,
        _explanationTextView.frame.size.height);
  _explanationTextView.tag = indexPath.row;
}

- (void) loadLegalAnswer: (OMBLegalAnswer *) object
{  
  if (object) {
    _legalAnswer.answer      = object.answer;
    _legalAnswer.explanation = object.explanation;
    _legalAnswer.legalQuestionID = _legalQuestion.uid;
    if (_legalAnswer.answer)
      [self yesButtonHighlighted];
    else
      [self noButtonHighlighted];
    if ([[_legalAnswer.explanation stripWhiteSpace] length] > 0) {
      _explanationTextView.text      = _legalAnswer.explanation;
      _explanationTextView.textColor = [UIColor textColor];
    }
    else {
      [self resetExplanationTextViewText];
    }
  }
  else {
    _legalAnswer                 = [[OMBLegalAnswer alloc] init];
    _legalAnswer.explanation     = @"";
    _legalAnswer.legalQuestionID = _legalQuestion.uid;
    [self noButtonNotHighlighted];
    [self yesButtonNotHighlighted];
    [self resetExplanationTextViewText];
  }
}

- (void) noButtonHighlighted
{
  noButton.layer.borderColor = [UIColor red].CGColor;
  [noButton setTitleColor: [UIColor red] forState: UIControlStateNormal];
  [self yesButtonNotHighlighted];
}

- (void) noButtonNotHighlighted
{
  noButton.layer.borderColor = [UIColor grayMedium].CGColor;
  [noButton setTitleColor: [UIColor grayMedium]
    forState: UIControlStateNormal];
}

- (void) resetExplanationTextViewText
{
  _explanationTextView.text = LegalAnswerTextViewPlaceholder;
  _explanationTextView.textColor = [UIColor grayMedium];
}

- (void) toggleButton: (UIButton *) button
{
  if (button == noButton) {
    _legalAnswer.answer = NO;
    [self noButtonHighlighted];
  }
  else if (button == yesButton) {
    _legalAnswer.answer = YES;
    [self yesButtonHighlighted];
  }
  [_delegate setLegalAnswer: _legalAnswer];
  [_delegate.table beginUpdates];
  [_delegate.table endUpdates];
  [_delegate endEditingIfEditing];
}

- (void) yesButtonHighlighted
{ 
  [self noButtonNotHighlighted]; 
  yesButton.layer.borderColor = [UIColor green].CGColor;
  [yesButton setTitleColor: [UIColor green] 
    forState: UIControlStateNormal];
}

- (void) yesButtonNotHighlighted
{
  yesButton.layer.borderColor = [UIColor grayMedium].CGColor;
  [yesButton setTitleColor: [UIColor grayMedium]
    forState: UIControlStateNormal];
}

@end
