//
//  CGWebService.m
//  Catstagrame
//
//  Created by Michele Titolo on 6/18/13.
//  Copyright (c) 2013 Michele Titolo. All rights reserved.
//

#import "CGWebService.h"
#import <AFNetworking/AFNetworking.h>

@implementation CGWebService

+ (CGWebService*)defaultService
{
    static CGWebService* s_webservice = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_webservice = [[CGWebService alloc] init];
        s_webservice.client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.instagram.com"]];
    });
    
    return s_webservice;
}

@end
