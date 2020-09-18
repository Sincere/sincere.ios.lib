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
+ (void) showAlert: (NSString *)message;
+ (void) showAlert: (NSString *)message withTitle: (NSString *)title;
@end
