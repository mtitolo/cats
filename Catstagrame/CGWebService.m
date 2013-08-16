//
//  CGWebService.m
//  Catstagrame
//
//  Created by Michele Titolo on 6/18/13.
//  Copyright (c) 2013 Michele Titolo.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "CGWebService.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"

@interface CGWebService ()

@property (strong, nonatomic) NSString* clientID;

@end

@implementation CGWebService

+ (CGWebService*)defaultService
{
    static CGWebService* s_webservice = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_webservice = [[CGWebService alloc] init];
        NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [configuration setHTTPAdditionalHeaders:@{@"Accept": @"application/json"}];
        s_webservice.client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.instagram.com"] sessionConfiguration:configuration];
        NSError* error = nil;
        s_webservice.clientID = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"key" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
        
        if (!s_webservice.clientID || s_webservice.clientID.length == 0) {
            [[NSException exceptionWithName:@"Catstagrame Error" reason:@"Missing Instagram API Key" userInfo:@{@"error":error}] raise];
        }
    });
    
    return s_webservice;
}

- (NSURLSessionDataTask*)getCatsWithNextMaxID:(NSNumber *)maxID success:(void (^)(NSHTTPURLResponse *, id))success failure:(void (^)(NSError *))failure
{
    NSString* requestURLString = [NSString stringWithFormat:@"/v1/tags/kittens/media/recent?client_id=%@", self.clientID];
    
    if (maxID) {
        requestURLString = [requestURLString stringByAppendingFormat:@"&max_tag_id=%@", maxID];
    }
    
    NSLog(@"Making request with path: %@", requestURLString);
    
    NSURLSessionDataTask* task = [self.client GET:requestURLString parameters:nil success:^(NSHTTPURLResponse *response, id responseObject) {
        success(response, responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];

    
    return task;
}

@end
