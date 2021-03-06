//
//  CatstagrameTests.m
//  CatstagrameTests
//
//  Created by Michele Titolo on 6/13/13.
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

#import <XCTest/XCTest.h>
#import "CGWebService.h"

@interface CatstagrameTests : XCTestCase

@end

@implementation CatstagrameTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testGetCats
{
    [[CGWebService defaultService] getCatsWithNextMaxID:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        XCTAssertNotNil(JSON, @"Did not get cats");
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        XCTFail(@"Failed to get cats");
    }];
}

- (void)testGetNextCats
{
    [[CGWebService defaultService] getCatsWithNextMaxID:@1373317731618 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        XCTAssertNotNil(JSON, @"Did not get next cats");
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        XCTFail(@"Failed to get next cats");
    }];
}

@end
