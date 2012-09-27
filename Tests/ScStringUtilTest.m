//
//  ScStringUtilTest.m
//  sincere.ios.lib
//
//  Created by Masamoto Miyata on 2012/09/27.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScStringUtilTest.h"

@implementation ScStringUtilTest

-(void)testIsEqualAsQueryString
{
    [self _assertNotEqual:@"foo=1&bar=2" and:@"foo=1" description:@"クエリの数が違うのにYES"];
    [self _assertNotEqual:@"foo=1&bar=2" and:@"foo=1&bar=3" description:@"クエリの数は一緒だが値が違うのにYES"];
    [self _assertEqual:@"foo=1&bar=2" and:@"foo=1&bar=2" description:@"全く同じクエリなのにNO"];
    [self _assertEqual:@"foo=1&bar=2" and:@"bar=2&foo=1" description:@"順番が違うだけなのにNO"];
    [self _assertNotEqual:@"foo[]=1" and:@"foo%5B%5D=1" description:@"URLエンコードしたものとしてないものはNOにします"];
}

-(void) _assertNotEqual:(NSString *) query1 and:(NSString *) query2 description:(NSString *)description
{
    GHAssertFalse([query1 isEqualAsQueryString:query2], description);
}

-(void) _assertEqual:(NSString *) query1 and:(NSString *) query2 description:(NSString *)description
{
    GHAssertTrue([query1 isEqualAsQueryString:query2], description);
}

@end
