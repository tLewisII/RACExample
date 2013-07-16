//
//  RACSlideshowViewController.m
//  RACExample
//
//  Created by Terry Lewis II on 7/15/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import "RACSlideshowViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface RACSlideshowViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(strong,nonatomic)RACSubject *subject;
@property(strong,nonatomic)NSMutableArray *imagesArray;

@end

@implementation RACSlideshowViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.imagesArray = [NSMutableArray array];
    ///We are going to load four images, each will be loaded when the preceeding one completes, giving us a slideshow effect. These are all random images from a google search for "piping plover".
    RACSignal *firstSignal = [RACSignal start:^id(BOOL *success, NSError *__autoreleasing *error) {
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
    ///Now we merge all of the signals into a single signal, and each time a signal sends a 'next' event, we add the value to an array. When all the signals are complete. we set the imageViews animationImages property to the array of images and then start it animating after a delay. Without the delay you would not see that last image, since :doComplete would be executed immediately as it finished and thus the animation would start right away and go back to the first image.
    RACSignal *images = [[[[RACSignal merge:@[firstSignalMapped,secondSignal,thirdSignal,fourthSignal]]deliverOn:[RACScheduler mainThreadScheduler]]doNext:^(UIImage *x) {
        [self.imagesArray addObject:x];
    }] doCompleted:^{
        self.imageView.animationImages = self.imagesArray;
        self.imageView.animationDuration = 4;
        [self.imageView performSelector:@selector(startAnimating) withObject:nil afterDelay:2];
    }];
    
    RAC(self.imageView.image) = images;
}

@end
