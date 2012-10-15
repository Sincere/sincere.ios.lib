//
//  ScPopverControllerHelper.h
//  sincere.ios.lib
//
//  Created by Masamoto Miyata on 2012/10/15.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ScPopverControllerHelper;
@protocol ScPopoverControllerHelperDelegate
- (void)popoverControllerDidDismissHelper:(ScPopverControllerHelper *)helper;
@end

@interface ScPopverControllerHelper : NSObject<UIPopoverControllerDelegate>
{
    @private
    UIPopoverController *_forPadController;
    UIViewController *_forPhoneController;
}

@property (nonatomic, strong) id<ScPopoverControllerHelperDelegate> delegate;

- (id)initWithInnerView:(UIView *)innerView;

- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;

- (void)dismissPopoverAnimated:(BOOL)animated;

- (BOOL)isModalController;

#pragma mark - protected methods
- (UIViewController *) _createViewController;
- (UIPopoverController *) _createPopoverControllerWithContentViewController:(UIViewController *) contentViewController;
@end
