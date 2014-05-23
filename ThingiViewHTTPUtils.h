//
//  ThingiViewHTTPUtils.h
//  ThingiView
//
//  Created by Vishal Patil on 9/6/13.
//  Copyright (c) 2013 Vishal Patil. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const thingiverseAPIBaseURL = @"https://api.thingiverse.com/";
static NSString *const thingiverseURL = @"http://www.thingiverse.com/";

@interface ThingiViewHTTPUtils : NSObject
+(NSDictionary*)getHeaderFields:(NSString*)path error:(NSError *)error;
+(NSString*)getRedirectURL:(NSString *)path error:(NSError*)error;
+(NSString *)getAuthHeader;
@end
