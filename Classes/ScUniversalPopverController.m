//
//  ScPopverControllerHelper.m
//  sincere.ios.lib
//
//  Created by Masamoto Miyata on 2012/10/15.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScUniversalPopverController.h"

@implementation ScUniversalPopverController

- (id)initWithViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self != nil)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            _forPadController = [self _createPopoverControllerWithContentViewController:viewController];
            _forPadController.delegate = self;
            [_forPadController setPopoverContentSize:viewController.view.bounds.size];
        }
        else
        {
            _forPhoneController = viewController;
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
        [self presentPopOverForPhone];
    }
}

- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated
{
    if(_forPadController)
    {
        if(!_forPadController.isPopoverVisible)
        {
            [_forPadController presentPopoverFromBarButtonItem:item permittedArrowDirections:arrowDirections animated:animated];
        }
    }
    else if(_forPhoneController)
    {
        [self presentPopOverForPhone];
    }
}

- (void)presentPopOverForPhone
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //[window.rootViewController presentViewController:_forPhoneController animated:YES completion:NULL];
    
    [window.rootViewController presentSemiViewController:_forPhoneController withOptions:@{
     KNSemiModalOptionKeys.pushParentBack : @(NO),
     KNSemiModalOptionKeys.parentAlpha : @(0.8),
     KNSemiModalOptionKeys.animationDuration : @(0.2),
	 }];
}

- (void)dismissPopoverAnimated:(BOOL)animated
{
    if(_forPadController)
    {
        if(_forPadController.isPopoverVisible)
        {
            [_forPadController dismissPopoverAnimated:animated];
            [self.delegate popoverControllerDidDismissController:self];
        }
    }
    else if(_forPhoneController)
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window.rootViewController dismissSemiModalViewWithCompletion:^{
            [self.delegate popoverControllerDidDismissController:self];
        }];
        //[_forPhoneController dismissViewControllerAnimated:YES completion:NULL];
        
    }
}

- (BOOL)isModalController
{
    return _forPhoneController != nil ? YES : NO;
}

#pragma mark - protected methods
- (UIPopoverController *) _createPopoverControllerWithContentViewController:(UIViewController *) contentViewController
{
    return [[UIPopoverController alloc] initWithContentViewController:contentViewController];
}

#pragma UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self.delegate popoverControllerDidDismissController:self];
}

@end
