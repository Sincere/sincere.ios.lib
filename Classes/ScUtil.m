//
//  ScUtil.m
//  fotocase
//
//  Created by 宮田　雅元 on 2020/09/17.
//  Copyright © 2020 Masamoto Miyata. All rights reserved.
//

#import "ScUtil.h"

@implementation ScUtil

+ (void)fixButtonLabelConstraints: (UIButton *) button{
    if (@available(iOS 11.0, *)) {
        UILayoutGuide* guide = button.superview.safeAreaLayoutGuide;
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor].active = YES;
        [button.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor].active = YES;
        [button.topAnchor constraintEqualToAnchor:guide.topAnchor].active = YES;
        [button.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor].active = YES;
    }
}

@end
