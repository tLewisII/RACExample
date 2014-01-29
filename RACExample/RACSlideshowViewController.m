//
//  RACSlideshowViewController.m
//  RACExample
//
//  Created by Terry Lewis II on 7/15/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import "RACSlideshowViewController.h"

@interface RACSlideshowViewController ()
@property(weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation RACSlideshowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *firstURL = [NSURL URLWithString:@"http://www.fws.gov/plover/graphics/piping_plover.jpg"];
    NSURL *secondURL = [NSURL URLWithString:@"http://www.jkcassady.com/images/1PIPL707.jpg"];
    NSURL *thirdURL = [NSURL URLWithString:@"http://m4.i.pbase.com/o6/21/832521/1/126531614.sfZPR2Eb.PipingPloverBaby.jpg"];
    NSURL *fourthURL = [NSURL URLWithString:@"http://maineaudubon.org/wp-content/uploads/2013/04/Amanda_Reed__PipingPlover_Chick_3.jpg"];

    ///We are going to load four images, each will be loaded when the preceding one completes, giving us a slideshow effect. These are all random images from a google search for "piping plover".
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    RACSignal *firstSignal = [[[[RACSignal return:firstURL]deliverOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground]]tryMap:^id(id value, NSError **errorPtr) {
        return [NSData dataWithContentsOfURL:value options:0 error:errorPtr];
    }]delay:.227];

    RACSignal *secondSignal = [[firstSignal then:^RACSignal * {
        return [[RACSignal return:secondURL]tryMap:^id(id value, NSError **errorPtr) {
            return [NSData dataWithContentsOfURL:value options:0 error:errorPtr];
        }];
    }]delay:1];

    RACSignal *thirdSignal = [[secondSignal then:^RACSignal * {
        return [[RACSignal return:thirdURL]tryMap:^id(id value, NSError **errorPtr) {
            return [NSData dataWithContentsOfURL:value options:0 error:errorPtr];
        }];
    }]delay:1];

    RACSignal *fourthSignal = [[thirdSignal then:^RACSignal * {
        return [[RACSignal return:fourthURL]tryMap:^id(id value, NSError **errorPtr) {
            return [NSData dataWithContentsOfURL:value options:0 error:errorPtr];
        }];
    }]delay:1];

    ///Now we merge all of the signals into a single signal, and then call `-replay` in order to make sure that the
    ///images are available when we call `-images.collect` in order to start the slideshow.
    ///This ensures that we don't hit the network again once all the request complete. Any errors sent by any of the signals will also be caught here.
    RACSignal *imageData = [[[[RACSignal merge:@[firstSignal, secondSignal, thirdSignal, fourthSignal]]deliverOn:[RACScheduler mainThreadScheduler]]replay]catchTo:[RACSignal empty]];

    /// We map the `imageData` signal and convert all of the data to UIImage's.
    RACSignal *imagesFromData = [imageData map:^id(NSData *value) {
        return [UIImage imageWithData:value];
    }];

    RAC(self.imageView, image) = imagesFromData;
    @weakify(self)
    ///When the signal completes we want to gather all of the images into an array and start the slideshow over again.
    RAC(self.imageView, animationImages) = [imagesFromData.collect doCompleted:^{
        @strongify(self)
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        self.imageView.animationDuration = 4;
        [self.imageView performSelector:@selector(startAnimating) withObject:nil afterDelay:1.5];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
}
@end
