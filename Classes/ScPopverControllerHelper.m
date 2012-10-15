//
//  ScPopverControllerHelper.m
//  sincere.ios.lib
//
//  Created by Masamoto Miyata on 2012/10/15.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScPopverControllerHelper.h"

@implementation ScPopverControllerHelper

- (id)initWithInnerView:(UIView *)innerView
{
    self = [super init];
    if (self != nil)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            UIViewController *contents = [self _createViewController];
            [contents.view addSubview: innerView];
            _forPadController = [self _createPopoverControllerWithContentViewController:contents];
            _forPadController.delegate = self;
            [_forPadController setPopoverContentSize:innerView.bounds.size];
        }
        else
        {
            _forPhoneController = [self _createViewController];
            _forPhoneController.view.backgroundColor = [UIColor blackColor];
            [_forPhoneController.view addSubview: innerView];
        }
    }
    
    return self;
}

- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated
{
    if(_forPadController)
    {
        if(!_forPadController.isPopoverVisible)
        {
            [_forPadController presentPopoverFromRect:rect inView:view permittedArrowDirections:arrowDirections animated:animated];
        }
    }
    else if(_forPhoneController)
    {
        [view.window.rootViewController presentModalViewController:_forPhoneController animated:animated];
    }
}

- (void)dismissPopoverAnimated:(BOOL)animated
{
    if(_forPadController)
    {
        if(_forPadController.isPopoverVisible)
        {
            [_forPadController dismissPopoverAnimated:animated];
            [self.delegate popoverControllerDidDismissHelper:self];
        }
    }
    else if(_forPhoneController)
    {
        [_forPhoneController dismissModalViewControllerAnimated:animated];
        [self.delegate popoverControllerDidDismissHelper:self];
    }
}

- (BOOL)isModalController
{
    return _forPhoneController != nil ? YES : NO;
}

#pragma mark - protected methods
- (UIViewController *) _createViewController
{
    return [[UIViewController alloc] init];
}

- (UIPopoverController *) _createPopoverControllerWithContentViewController:(UIViewController *) contentViewController
{
    return [[UIPopoverController alloc] initWithContentViewController:contentViewController];
}

#pragma UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self.delegate popoverControllerDidDismissHelper:self];
}

@end
