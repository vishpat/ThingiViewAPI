//
//  ThingiViewPart.m
//  ThingiView
//
//  Created by Vishal Patil on 1/22/13.
//  Copyright (c) 2013 Vishal Patil. All rights reserved.
//

#import "ThingiViewPart.h"

@implementation ThingiViewPart
@synthesize uid = _uid;
@synthesize name = _name;
@synthesize url = _url;
@synthesize thumbnailURL = _thumbnailURL;
@synthesize thumbnail = _thumbnail;

-(id)initWithName:(NSString *)strName
              UID:(NSString *)strUID
              URL:(NSString *)strURL
     thumbnailURL:(NSString *)thumbnailURL
{
    self = [super init];
    
    if (self) {
        _name = strName;
        _uid = strUID;
        _url = strURL;
        _thumbnailURL = thumbnailURL;
    }

    return self;
}

-(NSString*)getSTLURL
{
    NSString *STLURL = nil;
    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *error;
    NSHTTPURLResponse *response;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error == nil) {
        STLURL = [[response URL] absoluteString];
    }
    
    return STLURL;
}

@end
