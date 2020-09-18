//
//  Header.h
//  fotocase
//
//  Created by 宮田　雅元 on 2020/09/17.
//  Copyright © 2020 Masamoto Miyata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScUtil : NSObject

+ (void) fixButtonLabelConstraints: (UIButton *) button;
+ (UIAlertController *) createSimpleAlert: (NSString *)message;
+ (UIAlertController *) createSimpleAlert: (NSString *)message withTitle: (NSString *)title;
@end
