//
//  RACLargeDisplayViewController.m
//  RACExample
//
//  Created by Terry Lewis II on 1/20/14.
//  Copyright (c) 2014 Terry Lewis. All rights reserved.
//

#import "RACLargeDisplayViewController.h"
#import "RACSinglePhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface RACLargeDisplayViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>
@property(strong, nonatomic) UIPageViewController *pageViewController;
@property(strong, nonatomic) RACSubject *photoIndexSubject;

@end

@implementation RACLargeDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *hideNavGesture = [[UITapGestureRecognizer alloc]init];
    RACSignal *hiddenSignal = [hideNavGesture.rac_gestureSignal map:^id(id value) {
        return @(!self.navigationController.navigationBarHidden);
    }];
    [self.view addGestureRecognizer:hideNavGesture];
    [self.navigationController rac_liftSelector:@selector(setNavigationBarHidden:animated:) withSignals:hiddenSignal, [RACSignal return:@YES], nil];
    // View controllers
    self.pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey : @(30)}];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    [self addChildViewController:self.pageViewController];

    [self.pageViewController setViewControllers:@[[self photoViewControllerForIndex:self.index]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    // Configure subviews
    self.pageViewController.view.frame = self.view.bounds;

    [self.pageViewController willMoveToParentViewController:self];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (RACSinglePhotoViewController *)photoViewControllerForIndex:(NSInteger)index {
    if(index >= 0 && index < self.photoArray.count) {
        ALAsset *object = self.photoArray[(NSUInteger)index];
        UIImage *image = [UIImage imageWithCGImage:object.defaultRepresentation.fullScreenImage];
        RACSinglePhotoViewController *photoViewController = [[RACSinglePhotoViewController alloc] initWithImage:image index:(NSUInteger)index];
        return photoViewController;
    }

    // Index was out of bounds, return nil
    return nil;
}

#pragma mark - UIPageViewControllerDelegate Methods

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.pageViewController.viewControllers.firstObject photoIndex] inSection:0];
    [self.photoIndexSubject sendNext:indexPath];
}

#pragma mark - UIPageViewControllerDataSource Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(RACSinglePhotoViewController *)viewController {
    return [self photoViewControllerForIndex:viewController.photoIndex - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(RACSinglePhotoViewController *)viewController {
    return [self photoViewControllerForIndex:viewController.photoIndex + 1];
}

- (RACSignal *)photoIndexSignal {
    if(!_photoIndexSubject) {
        _photoIndexSubject = [RACSubject new];
    }
    return _photoIndexSubject;
}
@end
