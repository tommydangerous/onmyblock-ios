//
//  OMBWelcomeView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/7/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMBPaddleView;
@class OMBStopwatchView;

@interface OMBWelcomeView : UIView

@property (nonatomic, strong) OMBPaddleView *paddleView;
@property (nonatomic, strong) OMBStopwatchView *stopwatchView;

@end
