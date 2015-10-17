//
//  SegmentedViewController.m
//  Burning
//
//  Created by Xiang Li on 15/7/30.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "SegmentedViewController.h"

@interface SegmentedViewController ()

@end

@implementation SegmentedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] init];
        _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        self.navigationItem.titleView = _segmentedControl;
    } else {
        [_segmentedControl removeAllSegments];
    }
    _segmentedControl.tintColor= [UIColor whiteColor];
    [_segmentedControl addTarget:self action:@selector(segmentedControlSelected:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles
{
    if ([_segmentedControl numberOfSegments] > 0) {
        return;
    }
    for (int i = 0; i < [viewControllers count]; i++) {
        [self pushViewController:viewControllers[i] title:titles[i]];
    }
    [_segmentedControl setSelectedSegmentIndex:0];
    self.selectedViewControllerIndex = 0;
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    if ([_segmentedControl numberOfSegments] > 0) {
        return;
    }
    for (int i = 0; i < [viewControllers count]; i++) {
        [self pushViewController:viewControllers[i] title:[viewControllers[i] title]];
    }
    [_segmentedControl setSelectedSegmentIndex:0];
    self.selectedViewControllerIndex = 0;
}

- (void)pushViewController:(UIViewController *)viewController
{
    [self pushViewController:viewController title:viewController.title];
}
- (void)pushViewController:(UIViewController *)viewController title:(NSString *)title
{
    [_segmentedControl insertSegmentWithTitle:title atIndex:_segmentedControl.numberOfSegments animated:NO];
    [self addChildViewController:viewController];
    [_segmentedControl sizeToFit];
}

- (void)segmentedControlSelected:(id)sender
{
    //    NSLog(@"_segmentedControl.selectedSegmentIndex:%ld", (long)_segmentedControl.selectedSegmentIndex);
    self.selectedViewControllerIndex = _segmentedControl.selectedSegmentIndex;
}

- (void)setSelectedViewControllerIndex:(NSInteger)index
{
    if (!_selectedViewController) {
        _selectedViewController = self.childViewControllers[index];
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0f) {
            CGFloat deltaTop = 20.0f;
            if (self.navigationController && !self.navigationController.navigationBar.translucent) {
                deltaTop = self.navigationController.navigationBar.frame.size.height;
            }
            CGRect frame = self.view.frame;
            [_selectedViewController view].frame = CGRectMake(frame.origin.x, frame.origin.y - deltaTop, frame.size.width, frame.size.height);
            //            [[_selectedViewController view] sizeToFit];
        } else {
            [_selectedViewController view].frame = self.view.frame;
        }
        [self.view addSubview:[_selectedViewController view]];
        [_selectedViewController didMoveToParentViewController:self];
    } else {
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0f) {
            [self.childViewControllers[index] view].frame = self.view.frame;
        }
        [self transitionFromViewController:_selectedViewController toViewController:self.childViewControllers[index] duration:0.0f options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
            _selectedViewController = self.childViewControllers[index];
            _selectedViewControllerIndex = index;
        }];
    }
}


@end
