//
//  OMBEditablePhotoView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/28/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCenteredImageView.h"

@interface OMBEditablePhotoView : OMBCenteredImageView
<UIGestureRecognizerDelegate>
{
  UIView *backSlash;
  UIView *forwardSlash;
  UILongPressGestureRecognizer *longPressRecognizer;
  UIPanGestureRecognizer *moveRecognizer;
}

@property (nonatomic) int currentIndex;
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIView *deleteButtonView;
@property (nonatomic) BOOL isEditing;
@property (nonatomic) CGSize largeSize;
@property (nonatomic) CGSize smallSize;

@end
