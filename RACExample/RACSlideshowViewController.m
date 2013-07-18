//
//  RACSlideshowViewController.m
//  RACExample
//
//  Created by Terry Lewis II on 7/15/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import "RACSlideshowViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <EXTScope.h>
@interface RACSlideshowViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation RACSlideshowViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    ///We are going to load four images, each will be loaded when the preceeding one completes, giving us a slideshow effect. These are all random images from a google search for "piping plover".
    RACSignal *firstSignal = [RACSignal start:^id(BOOL *success, NSError *__autoreleasing *error) {
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.fws.gov/plover/graphics/piping_plover.jpg"]];
        *success = (data != nil);
        return [UIImage imageWithData:data];
    }];

    RACSignal *firstSignalMapped = [firstSignal catch:^RACSignal *(NSError *error) {
        return [RACSignal empty];
    }];
    
    RACSignal *secondSignal = [firstSignalMapped sequenceNext:^RACSignal *{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.jkcassady.com/images/1PIPL707.jpg"]];
        return [RACSignal return:[UIImage imageWithData:data]];
    }];
    
    RACSignal *thirdSignal = [secondSignal sequenceNext:^RACSignal *{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://m4.i.pbase.com/o6/21/832521/1/126531614.sfZPR2Eb.PipingPloverBaby.jpg"]];
        return [RACSignal return:[UIImage imageWithData:data]];
    }];
    
    RACSignal *fourthSignal = [thirdSignal sequenceNext:^RACSignal *{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://maineaudubon.org/wp-content/uploads/2013/04/Amanda_Reed__PipingPlover_Chick_3.jpg"]];
        return [RACSignal return:[UIImage imageWithData:data]];
    }];
    ///Now we merge all of the signals into a single signal, and then call `-replay` in order to make sure that the images are available when we call `-images.collect` in order to start the slideshow. This ensures that we don't hit the network again once all the request complete.
    RACSignal *images = [[[RACSignal merge:@[firstSignalMapped,secondSignal,thirdSignal,fourthSignal]]deliverOn:[RACScheduler mainThreadScheduler]]replay];
    
    RAC(self.imageView.image) = images;
    @weakify(self)
    ///When the signal completes we want to gather all of the images into an array and start the slideshow over again.
    RAC(self.imageView.animationImages) = [images.collect doCompleted:^{
        @strongify(self)
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        self.imageView.animationDuration = 4;
        [self.imageView performSelector:@selector(startAnimating) withObject:nil afterDelay:1.5];
    }];
}
-(void)viewDidDisappear:(BOOL)animated {
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
}
@end
