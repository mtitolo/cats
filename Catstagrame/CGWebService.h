//
//  CGWebService.h
//  Catstagrame
//
//  Created by Michele Titolo on 6/18/13.
//  Copyright (c) 2013 Michele Titolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPClient;

@interface CGWebService : NSObject

@property (strong, nonatomic) AFHTTPClient* client;

+ (CGWebService*)defaultService;

@end
