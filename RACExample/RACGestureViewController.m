//
//  RACGestureViewController.m
//  RACExample
//
//  Created by Terry Lewis II on 7/14/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import "RACGestureViewController.h"

@interface RACGestureViewController ()
@property(weak, nonatomic) IBOutlet UILabel *translationLabel;
@property(weak, nonatomic) IBOutlet UILabel *stateLabel;
@property(strong, nonatomic) RACSubject *animationDelegate;
@property(weak, nonatomic) IBOutlet UILabel *pinchLabel;

@end

@implementation RACGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]init];
    [self.view addGestureRecognizer:panGesture];
    CGPoint originalCenter = self.view.center;
    ///The value we really care about is the translation value, so that is what we return.
    RACSignal *panGestureSignal = [panGesture.rac_gestureSignal map:^id(UIPanGestureRecognizer *recognizer) {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        CGFloat yBoundary = MIN(recognizer.view.center.y + translation.y, originalCenter.y);
        [recognizer setTranslation:CGPointZero inView:self.view];
        return [NSValue valueWithCGPoint:CGPointMake(recognizer.view.center.x, yBoundary)];
    }];
    ///We bind the center of the view to the values that are sent from the signal.
    RAC(self.view, center) = panGestureSignal;
    ///We want to keep track of the y value of the translation and display it in real time to the user, so we transform the value into a String and return that.
    RACSignal *panGestureString = [panGestureSignal map:^id(NSValue *value) {
        return [NSString stringWithFormat:@"Y Translation = %f", value.CGPointValue.y];
    }];
    ///We also want real time information about the state of the gesture, so we transform that into a String as well. You have to move very slowly if you want to see the label update when the Gesture begins.
    RACSignal *panGestureState = [panGesture.rac_gestureSignal map:^id(UIPanGestureRecognizer *recognizer) {
        NSString *state;
        switch(recognizer.state) {
            case UIGestureRecognizerStateBegan:
                state = @"Began";
                break;
            case UIGestureRecognizerStateChanged:
                state = @"Gesture is Changed";
                break;
            case UIGestureRecognizerStateEnded:
                state = @"Gesture is Ended";
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
        return state;
    }];
    ///We want a different color to represent the state of the gesture, so we use the states as keys.
    NSDictionary *colors = @{@(UIGestureRecognizerStateEnded)   : [UIColor blueColor],
                             @(UIGestureRecognizerStateChanged) : [UIColor purpleColor]};
    ///Here we filter the values, and only return a color from our dictionary when the state is one of the ones we care about.
    RACSignal *colorSignal = [[panGesture.rac_gestureSignal filter:^BOOL(UIPanGestureRecognizer *recognizer) {
        return (recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded);
    }]map:^id(UIPanGestureRecognizer *recognizer) {
        return colors[@(recognizer.state)];
    }];
    ///We want the starting point displayed when the view loads.
    NSString *initialPoint = [NSString stringWithFormat:@"Y Translation = %f", originalCenter.y];
    ///+[RACSignal merge] takes an array of signals and returns a value each time one of the signals fires. Here the initialPoint immediately returns, thus the label is set when the view loads. Then afterwards, the panGestureSignal will be sending its values when it is activated.
    RAC(self.translationLabel, text) = [RACSignal merge:@[panGestureString, [RACSignal return:initialPoint]]];
    ///The label will always reflect the current state of the recognizer.
    RAC(self.stateLabel, text) = panGestureState;
    ///The color will be updated each time the signal returns a value.
    RAC(self.view, backgroundColor) = colorSignal;

    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]init];
    [self.view addGestureRecognizer:pinchGesture];
    ///We simply send the value as a transform.
    RACSignal *pinchSignal = [pinchGesture.rac_gestureSignal map:^id(UIPinchGestureRecognizer *value) {
        return [NSValue valueWithCATransform3D:CATransform3DMakeScale(value.scale, value.scale, 1.0)];
    }];
    ///Show the velocity and scale of the pinch gesture.
    RAC(self.pinchLabel, text) = [pinchGesture.rac_gestureSignal map:^id(UIPinchGestureRecognizer *value) {
        return [NSString stringWithFormat:@"Scale %f velocity %f", value.scale, value.velocity];
    }];
    @weakify(self) //We need to weaken self in order to not retain it when it is used in the upcoming blocks.
    ///We want to animate the view back to its original position after the gesture completes, so we filter and then return an animation object.
    RACSignal *originalTransform = [[pinchGesture.rac_gestureSignal filter:^BOOL(UIPinchGestureRecognizer *value) {
        return value.state == UIGestureRecognizerStateEnded;
    }]map:^id(id value) {
        @strongify(self)
        CABasicAnimation *resetTransform = [CABasicAnimation animationWithKeyPath:@"transform"];
        [resetTransform setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        resetTransform.delegate = self;
        resetTransform.fillMode = kCAFillModeForwards;
        resetTransform.duration = .227;
        resetTransform.removedOnCompletion = NO;
        return resetTransform;
    }];
    ///Adds the animation to the layer each time the gesture ends.
    [self.view.layer rac_liftSelector:@selector(addAnimation:forKey:) withSignals:originalTransform, [RACSignal return:@"transform"], nil];
    ///Used to bring the animation delegate into the RAC world.
    self.animationDelegate = [RACSubject subject];
    ///When the signal sends a YES value, return the identity transform.
    RACSignal *resetSignal = [[self.animationDelegate filter:^BOOL(NSNumber *value) {
        return value.boolValue;
    }]map:^id(id value) {
        return [NSValue valueWithCATransform3D:CATransform3DIdentity];
    }];
    RAC(self.view.layer, transform) = [RACSignal merge:@[pinchSignal, resetSignal]];
    ///This side effect needs to be performed each time the signal sends a value.
    [resetSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.view.layer removeAllAnimations];
    }];

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.animationDelegate sendNext:@(flag)];
}


@end
