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

@end

@implementation RACSlideshowViewController

- (void)viewDidLoad{
    [super viewDidLoad];
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
    ///Now we merge all of the images into a single signal, and then when all of them are complete, we log recognition of this to the console.
    RACSignal *images = [[[RACSignal merge:@[firstSignalMapped,secondSignal,thirdSignal,fourthSignal]]deliverOn:[RACScheduler mainThreadScheduler]]doCompleted:^{
        NSLog(@"Finished");
    }];
    
    RAC(self.imageView.image) = images;
}

@end
