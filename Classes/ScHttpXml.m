//
//  FcnApi.m
//  fotocase_note
//
//  Created by Miyata Keizo on 2012/08/18.
//  Copyright (c) 2012年 Miyata Keizo. All rights reserved.
//

#import "ScHttpXml.h"



@implementation ScHttpXml

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(_progressView)
    {
        [_progressView setProgress:1.0];
    }
    
    NSString *xmlString = [[NSString alloc]initWithData:_receivedData encoding:NSUTF8StringEncoding];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil];
    [self.delegate http:self connection:connection didFinishLoading:[doc rootElement]];
}

@end
