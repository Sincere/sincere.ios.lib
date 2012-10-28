//
//  ScPopverControllerHelper.h
//  sincere.ios.lib
//
//  Created by Masamoto Miyata on 2012/10/15.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+KNSemiModal.h"

@class ScUniversalPopverController;
@protocol ScUniversalPopoverControllerDelegate
- (void)popoverControllerDidDismissController:(ScUniversalPopverController *)controller;
@end

@interface ScUniversalPopverController : NSObject<UIPopoverControllerDelegate>
{
    @private
    UIPopoverController *_forPadController;
    UIViewController *_forPhoneController;
}

@property (nonatomic, strong) id<ScUniversalPopoverControllerDelegate> delegate;

- (id)initWithViewController:(UIViewController *)viewController;

- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;

- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;

- (void)dismissPopoverAnimated:(BOOL)animated;

- (BOOL)isModalController;

#pragma mark - protected methods
- (UIPopoverController *) _createPopoverControllerWithContentViewController:(UIViewController *) contentViewController;
@end
