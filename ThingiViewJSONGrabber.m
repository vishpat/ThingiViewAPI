//
//  ThingiViewJSONGrabber.m
//  ThingiView
//
//  Created by Vishal Patil on 1/21/13.
//  Copyright (c) 2013 Vishal Patil. All rights reserved.
//

#import "ThingiViewHTTPUtils.h"
#import "ThingiViewJSONGrabber.h"

@interface ThingiViewJSONGrabber() {
    
}
@end

@implementation ThingiViewJSONGrabber

-(id)init {
    
    self = [super init];
    return self;
}

+(ThingiViewJSONGrabber*)getJSONGrabber {
    static ThingiViewJSONGrabber* JSONGrabber = nil;
    
    if (JSONGrabber == nil) {
        JSONGrabber = [[self alloc] init];
    }
    
    return JSONGrabber;
}

+(NSData *)httpGET:(NSString *)path error:(NSError *)error
{
    NSString *authHeader = [ThingiViewHTTPUtils getAuthHeader];
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@", thingiverseAPIBaseURL, path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];

    if (error != nil) {
        NSLog(@"Error in getting the response for url %@: %@", url, [error localizedDescription]);
        return nil;
    }
    
    return response;
}

+(NSData *)httpPOST:(NSString *)path error:(NSError *)error
{
    NSString *authHeader = [ThingiViewHTTPUtils getAuthHeader];
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@", thingiverseAPIBaseURL, path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if (error != nil) {
        NSLog(@"Error in getting the response for url %@: %@", url, [error localizedDescription]);
        return nil;
    }
    
    return response;
}

+(NSError *)httpDELETE:(NSString *)path
{
    NSError *error = nil;
    NSString *authHeader = [ThingiViewHTTPUtils getAuthHeader];
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@", thingiverseAPIBaseURL, path];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"DELETE"];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if (error != nil) {
        NSLog(@"Error in getting the DELETE response for url %@: %@", url, [error localizedDescription]);
        return nil;
    }
    
    return error;
}

+(NSData*)getDataObjects:(NSString*)path
{
    NSError *error = nil;
    NSData *data = nil;
    NSData *response = nil;
    
    response = [ThingiViewJSONGrabber httpGET:path error:error];
    
    if (error != nil) {
        NSLog(@"Error in parsing the response for %@: %@", path, [error localizedDescription]);
        return nil;
    }
    
    error = nil;
    data = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error: &error];
    
    if (error != nil) {
        NSLog(@"Error in parsing the response : %@", [error localizedDescription]);
        return nil;
    }
    
    return data;
}


@end
