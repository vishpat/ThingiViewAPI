//
//  ThingiViewHTTPUtils.m
//  ThingiView
//
//  Created by Vishal Patil on 9/6/13.
//  Copyright (c) 2013 Vishal Patil. All rights reserved.
//

#import "ThingiViewHTTPUtils.h"

static NSString *token;
static NSString *token_type;

@implementation ThingiViewHTTPUtils

+(NSString *)getAuthHeader
{
    if (token == nil || token_type == nil) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        token = [prefs stringForKey:@"token"];
        token_type = [prefs stringForKey:@"tokenType"];
    }

    NSString *authHeader = [[NSString alloc] initWithFormat:@"%@ %@", token_type, token];
    return authHeader;
}

+(NSDictionary*)getHeaderFields:(NSString*)path error:(NSError *)error
{
    NSString *authHeader = [ThingiViewHTTPUtils getAuthHeader];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSHTTPURLResponse *urlResponse = nil;
    
    [urlRequest setHTTPMethod:@"HEAD"];
    [urlRequest setValue:authHeader forHTTPHeaderField:@"Authorization"];
    [NSURLConnection sendSynchronousRequest:urlRequest
                          returningResponse:&urlResponse
                                      error:&error];
    
    NSDictionary *properties = [urlResponse allHeaderFields];
    return properties;
}

+(NSString*)getRedirectURL:(NSString *)path error:(NSError *)error
{
    NSString *authHeader = [ThingiViewHTTPUtils getAuthHeader];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSHTTPURLResponse *urlResponse = nil;
    
    [urlRequest setHTTPMethod:@"HEAD"];
    [urlRequest setValue:authHeader forHTTPHeaderField:@"Authorization"];
    [NSURLConnection sendSynchronousRequest:urlRequest
                          returningResponse:&urlResponse
                                      error:&error];
    
    return [[urlResponse URL] absoluteString];
}

@end
