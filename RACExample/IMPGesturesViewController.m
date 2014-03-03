//
//  IMPGesturesViewController.m
//  RACExample
//
//  Created by Terry Lewis II on 3/2/14.
//  Copyright (c) 2014 Terry Lewis. All rights reserved.
//

#import "IMPGesturesViewController.h"

@interface IMPGesturesViewController ()
@property(strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property(nonatomic) CGPoint originalCenter;
@property(weak, nonatomic) IBOutlet UILabel *translationLabel;
@property(weak, nonatomic) IBOutlet UILabel *stateLabel;
@property(weak, nonatomic) IBOutlet UILabel *pinchLabel;
@property(strong, nonatomic) NSDictionary *colorDict;

@end

@implementation IMPGesturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doPan:)];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    self.originalCenter = self.view.center;

    self.translationLabel.text = [NSString stringWithFormat:@"Y Translation = %f", self.originalCenter.y];

    self.colorDict = @{@(UIGestureRecognizerStateEnded)   : [UIColor blueColor],
                       @(UIGestureRecognizerStateChanged) : [UIColor purpleColor]};

    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(doPinch:)];
    [self.view addGestureRecognizer:pinchGesture];
}

- (void)doPinch:(UIPinchGestureRecognizer *)recognizer {
    self.view.layer.transform = CATransform3DMakeScale(recognizer.scale, recognizer.scale, 1.0);
    [self updatePinchLabelWithRecognizer:recognizer];
    if(recognizer.state == UIGestureRecognizerStateEnded) [self updateViewTransform];
}

- (void)doPan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:recognizer.view];
    CGFloat yBoundary = MIN(recognizer.view.center.y + translation.y, self.originalCenter.y);
    self.view.center = CGPointMake(recognizer.view.center.x, yBoundary);
    [recognizer setTranslation:CGPointZero inView:self.view];

    [self updateTranslationLabelWithPoint:self.view.center];
    [self updateStateLabelWithState:recognizer.state];
    [self updateBackgroundColorFromState:recognizer.state];
}

- (void)updatePinchLabelWithRecognizer:(UIPinchGestureRecognizer *)recognizer {
    self.pinchLabel.text = [NSString stringWithFormat:@"Scale %f velocity %f", recognizer.scale, recognizer.velocity];
}

- (void)updateViewTransform {
    CABasicAnimation *resetTransform = [CABasicAnimation animationWithKeyPath:@"transform"];
    [resetTransform setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    resetTransform.delegate = self;
    resetTransform.fillMode = kCAFillModeForwards;
    resetTransform.duration = .227;
    resetTransform.removedOnCompletion = NO;
    [self.view.layer addAnimation:resetTransform forKey:@"transform"];
}

- (void)updateTranslationLabelWithPoint:(CGPoint)point {
    self.translationLabel.text = [NSString stringWithFormat:@"Y Translation = %f", point.y];
}

- (void)updateStateLabelWithState:(UIGestureRecognizerState)state {
    self.stateLabel.text = [self stateFromState:state];
}

- (void)updateBackgroundColorFromState:(UIGestureRecognizerState)state {
    UIColor *color = self.colorDict[@(state)];
    if(color) {
        self.view.backgroundColor = color;
    }
}

- (NSString *)stateFromState:(UIGestureRecognizerState)state {
    NSString *stateString;
    switch(state) {
        case UIGestureRecognizerStateBegan:
            stateString = @"Began";
            break;
        case UIGestureRecognizerStateChanged:
            stateString = @"Gesture is Changed";
            break;
        case UIGestureRecognizerStateEnded:
            stateString = @"Gesture is Ended";
            break;
        default:
            break;
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStateFailed:
            break;
    }
    return stateString;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if(flag) {
        self.view.layer.transform = CATransform3DIdentity;
        [self.view.layer removeAllAnimations];
    }
}

@end
