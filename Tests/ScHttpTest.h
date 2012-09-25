//
//  MyTest.h
//  sincere.ios.lib
//
//  Created by Masamoto Miyata on 2012/09/22.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "ScHttp.h"
#import "ScHttpXml.h"
#import "DDXML.h"

@interface ScHttpTest : GHAsyncTestCase<ScHttpDelegate>
{
    @private
    SEL _assertFunc;
    double _timeout;
}

@end
