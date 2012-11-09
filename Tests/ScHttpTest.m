//
//  MyTest.m
//  sincere.ios.lib
//
//  Created by Masamoto Miyata on 2012/09/22.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScHttpTest.h"


@implementation ScHttpTest

- (void)setUpClass
{
    _timeout = 10;
    _autoLoadStatus = @"STOP";
}

#pragma mark - Tests

- (void)testAutoLoad
{
    [self prepare];
    
    _assertFunc = @selector(assertAutoLoadRequest:);
    
    ScHttp *http = [[ScHttp alloc] initWithUri:@"http://test.api.fotocase.jp/test/ioslib" delegate: self];
    [http enableAutoLoad: 2];
    GHAssertEqualStrings(_autoLoadStatus, @"STOP", @"Autoloadは止まっているはず");
    [http setParam:@"value" forKey:@"string"];
    GHAssertEqualStrings(_autoLoadStatus, @"WAITING", @"Autoloadは動いた");
    [http setParam:@"plusValue" forKey:@"plus"];
    [http setParam:[NSArray arrayWithObjects:@"1", @"2", nil] forKey:@"array"];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout: _timeout];
    GHAssertEqualStrings(_autoLoadStatus, @"STOP", @"Autoloadは止まっているはず");
    
    [http setParam:@"plusValue" forKey:@"plus"];
    GHAssertEqualStrings(_autoLoadStatus, @"STOP", @"値が同じなのでAutoloadは動かないはず");
    [http setParam:[NSArray arrayWithObjects:@"2", @"1", nil] forKey:@"array"];
    GHAssertEqualStrings(_autoLoadStatus, @"STOP", @"値が同じなのでAutoloadは動かないはず");
    
    [http setParam:[NSArray arrayWithObjects:@"2", nil] forKey:@"array"];
    GHAssertEqualStrings(_autoLoadStatus, @"WAITING", @"Autoloadは動いた");
    [http setParam:[NSArray arrayWithObjects:@"2", @"1", nil] forKey:@"array"];
}

- (void)testPostRequest {
    // 非同期処理が始まる前の準備
    [self prepare];
    
    _assertFunc = @selector(assertPostRequest:);
    
    // 非同期処理を実行する
    [self performSelector:@selector(postRequest) withObject:nil afterDelay:0.0];
    
    //Timeout 3sec
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout: _timeout];
}

- (void)testGetRequest {
    // 非同期処理が始まる前の準備
    [self prepare];
    
    _assertFunc = @selector(assertGetRequest:);
    
    // 非同期処理を実行する
    [self performSelector:@selector(getRequest) withObject:nil afterDelay:0.0];
    
    //Timeout 3sec
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout: _timeout];
}

- (void)testXmlPostRequest {
    // 非同期処理が始まる前の準備
    [self prepare];
    
    _assertFunc = @selector(assertXmlPostRequest:);
    
    // 非同期処理を実行する
    [self performSelector:@selector(postXmlRequest) withObject:nil afterDelay:0.0];
    
    //Timeout 3sec
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout: _timeout];
}

- (void)testXmlGetRequest {
    // 非同期処理が始まる前の準備
    [self prepare];
    
    _assertFunc = @selector(assertXmlGetRequest:);
    
    // 非同期処理を実行する
    [self performSelector:@selector(getXmlRequest) withObject:nil afterDelay:0.0];
    
    //Timeout 3sec
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout: _timeout];
}

#pragma mark - For async

- (void)postXmlRequest
{
    ScHttpXml *http = [[ScHttpXml alloc] initWithUri:@"http://test.api.fotocase.jp/test/ioslib" delegate: self];
    [http setHttpMethod:@"post"];
    [http setParam:@"value" forKey:@"string"];
    [http setParam:[NSArray arrayWithObjects:@"1", @"2", nil] forKey:@"array"];
    [http load];
}

- (void)getXmlRequest
{
    ScHttp *http = [[ScHttpXml alloc] initWithUri:@"http://test.api.fotocase.jp/test/ioslib" delegate: self];
    [http setParam:@"value" forKey:@"string"];
    [http setParam:[NSArray arrayWithObjects:@"1", @"2", nil] forKey:@"array"];
    [http load];
}

- (void)getRequest
{
    ScHttp *http = [[ScHttp alloc] initWithUri:@"http://test.api.fotocase.jp/test/ioslib" delegate: self];
    [http setParam:@"value" forKey:@"string"];
    [http setParam:[NSArray arrayWithObjects:@"1", @"2", nil] forKey:@"array"];
    [http load];
}

- (void)postRequest
{
    ScHttp *http = [[ScHttp alloc] initWithUri:@"http://test.api.fotocase.jp/test/ioslib" delegate: self];
    [http setHttpMethod:@"post"];
    [http setParam:@"value" forKey:@"string"];
    [http setParam:[NSArray arrayWithObjects:@"1", @"2", nil] forKey:@"array"];
    [http load];
}

#pragma mark - assertFunc
- (void)assertAutoLoadRequest: (DDXMLElement *) element
{
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testAutoLoad)];
}


- (void)assertGetRequest: (DDXMLElement *) element
{
    DDXMLElement *get = [[element elementsForName:@"get"] objectAtIndex:0];
    NSArray *array = [get elementsForName:@"array"];
    GHAssertEquals((NSUInteger) 2, [array count], @"arrayの数が合いません");
    GHAssertEqualStrings(@"1", [[array objectAtIndex:0] stringValue], @"arrayの値が合わない");
    GHAssertEqualStrings(@"2", [[array objectAtIndex:1] stringValue], @"arrayの値が合わない");
    
    NSArray *string = [get elementsForName:@"string"];
    GHAssertEquals((NSUInteger) 1, [string count], @"stringの数が合いません");
    GHAssertEqualStrings(@"value", [[string objectAtIndex:0] stringValue], @"stringの値が合わない");
    
    DDXMLElement *post = [[element elementsForName:@"post"] objectAtIndex:0];
    GHAssertEqualStrings(@"", [post stringValue], @"postがカラじゃない");
    
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testGetRequest)];
}

- (void)assertPostRequest: (DDXMLElement *) element
{
    DDXMLElement *post = [[element elementsForName:@"post"] objectAtIndex:0];
    NSArray *array = [post elementsForName:@"array"];
    GHAssertEquals((NSUInteger) 2, [array count], @"arrayの数が合いません");
    GHAssertEqualStrings(@"1", [[array objectAtIndex:0] stringValue], @"arrayの値が合わない");
    GHAssertEqualStrings(@"2", [[array objectAtIndex:1] stringValue], @"arrayの値が合わない");
    
    NSArray *string = [post elementsForName:@"string"];
    GHAssertEquals((NSUInteger) 1, [string count], @"stringの数が合いません");
    GHAssertEqualStrings(@"value", [[string objectAtIndex:0] stringValue], @"stringの値が合わない");
    
    DDXMLElement *get = [[element elementsForName:@"get"] objectAtIndex:0];
    GHAssertEqualStrings(@"", [get stringValue], @"getがカラじゃない");
    
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testPostRequest)];
}

- (void)assertXmlPostRequest: (DDXMLElement *) element
{
    DDXMLElement *post = [[element elementsForName:@"post"] objectAtIndex:0];
    NSArray *array = [post elementsForName:@"array"];
    GHAssertEquals((NSUInteger) 2, [array count], @"arrayの数が合いません");
    GHAssertEqualStrings(@"1", [[array objectAtIndex:0] stringValue], @"arrayの値が合わない");
    GHAssertEqualStrings(@"2", [[array objectAtIndex:1] stringValue], @"arrayの値が合わない");
    
    NSArray *string = [post elementsForName:@"string"];
    GHAssertEquals((NSUInteger) 1, [string count], @"stringの数が合いません");
    GHAssertEqualStrings(@"value", [[string objectAtIndex:0] stringValue], @"stringの値が合わない");
    
    DDXMLElement *get = [[element elementsForName:@"get"] objectAtIndex:0];
    GHAssertEqualStrings(@"", [get stringValue], @"getがカラじゃない");
    
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testXmlPostRequest)];
}

- (void)assertXmlGetRequest: (DDXMLElement *) element
{
    DDXMLElement *get = [[element elementsForName:@"get"] objectAtIndex:0];
    NSArray *array = [get elementsForName:@"array"];
    GHAssertEquals((NSUInteger) 2, [array count], @"arrayの数が合いません");
    GHAssertEqualStrings(@"1", [[array objectAtIndex:0] stringValue], @"arrayの値が合わない");
    GHAssertEqualStrings(@"2", [[array objectAtIndex:1] stringValue], @"arrayの値が合わない");
    
    NSArray *string = [get elementsForName:@"string"];
    GHAssertEquals((NSUInteger) 1, [string count], @"stringの数が合いません");
    GHAssertEqualStrings(@"value", [[string objectAtIndex:0] stringValue], @"stringの値が合わない");
    
    DDXMLElement *post = [[element elementsForName:@"post"] objectAtIndex:0];
    GHAssertEqualStrings(@"", [post stringValue], @"postがカラじゃない");
    
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testXmlGetRequest)];
}

#pragma mark - ScHttpDelegate

- (void)connection:(NSURLConnection *)connection didFinishLoading:(id)response
{
    ScLog(@"%@", [connection currentRequest]);
    
    DDXMLElement *rootElem;
    if([response isKindOfClass:[NSData class]])
    {
        NSString *xmlString = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        DDXMLDocument *doc = [[DDXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil];
        rootElem = [doc rootElement];
    }
    else
    {
        rootElem = response;
    }
    
    
    [self performSelector:_assertFunc withObject:rootElem afterDelay:0.0];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self notify:kGHUnitWaitStatusFailure];
}

- (void)startAutoLoadWait
{
    _autoLoadStatus = @"WAITING";
}
- (void)endAutoLoadWait
{
    _autoLoadStatus = @"STOP";
}

@end
