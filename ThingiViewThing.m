//
//  ThingiViewThing.m
//  ThingiView
//
//  Created by Vishal Patil on 1/21/13.
//  Copyright (c) 2013 Vishal Patil. All rights reserved.
//

#import "ThingiViewThing.h"
#import "ThingiViewPart.h"
#import "ThingiViewJSONGrabber.h"
#import "ThingiViewHTTPUtils.h"

@interface ThingiViewThing() {
    BOOL partsLoaded;
}

@end

@implementation ThingiViewThing
@synthesize name = _name;
@synthesize uid = _uid;
@synthesize url = _url;
@synthesize zipURL = _zipURL;
@synthesize thumbnailURL = _thumbnailURL;
@synthesize thumbnail = _thumbnail;

-(id)initWithName:(NSString*)name
              UID:(NSString*)strUID
              URL:(NSString*)strURL
     thumbnailURL:(NSString*)thumbnailURL
{
    self = [super init];
    
    if (self) {
        _name = name;
        _uid = strUID;
        _url = strURL;
        _thumbnailURL = thumbnailURL;
        partsLoaded = YES;        
    }
    
    return self;
}

-(BOOL)loadParts
{
    NSString *path = [[NSString alloc] initWithFormat:@"things/%@/files", _uid];
    NSData *data = [ThingiViewJSONGrabber getDataObjects:path];
        
    if (data && [data isKindOfClass:[NSArray class]]) {
        _parts = [[NSMutableArray alloc] initWithCapacity:[(NSArray *)data count]];
        NSDictionary *part;
        
        for (part in (NSArray *)data) {
            NSString *name = part[@"name"];
            
            if ([[name pathExtension] caseInsensitiveCompare:@"stl"] != NSOrderedSame) {
                continue;
            }
            
            NSString *thumbnailURL = part[@"thumbnail"];
           
            [(NSMutableArray*)_parts addObject:[[ThingiViewPart alloc]
                                                 initWithName:part[@"name"]
                                                UID:part[@"id"]
                                                URL:part[@"public_url"]
                                                thumbnailURL:thumbnailURL]];
        }
    }
    
    NSString *zipURL = [NSString stringWithFormat:@"%@thing:%@/zip", thingiverseURL, _uid];
    NSError *error = nil;
    NSString *zipLocation = [ThingiViewHTTPUtils getRedirectURL:zipURL error:error];
    
    if (error == nil && zipLocation) {
        _zipURL = zipLocation;
    } else {
        NSLog(@"Unable to get the zip file for %@", _uid);
    }

    return partsLoaded;
}

-(NSError *)like
{
    NSError *error;
    NSString *likeStr = [NSString stringWithFormat:@"things/%@/likes", _uid];
    
    [ThingiViewJSONGrabber httpPOST:likeStr error:error];
    
    return error;
}

-(NSError *)unlike
{
    NSError *error;
    NSString *likeStr = [NSString stringWithFormat:@"things/%@/likes", _uid];
    
    error = [ThingiViewJSONGrabber httpDELETE:likeStr];
    
    return error;
}

+(NSString *)getThingDescription:(int)thingID
{
    NSString *thingURL = [NSString stringWithFormat:@"things/%d", thingID];
    NSData *thingData = [ThingiViewJSONGrabber getDataObjects:thingURL];
    NSString *description = @"";
    
    if (thingData && [thingData isKindOfClass:[NSDictionary class]]) {
        NSDictionary *thingKeyVal = (NSDictionary *)thingData;
        description = thingKeyVal[@"description"];
    }
    
    return  description;
}

+(ThingiViewThing *)loadThing:(int)thingID
{
    NSString *thingURL = [NSString stringWithFormat:@"things/%d", thingID];
    NSData *thingData = [ThingiViewJSONGrabber getDataObjects:thingURL];
    ThingiViewThing *thing = nil;
    
    if (thingData && [thingData isKindOfClass:[NSDictionary class]]) {
        NSDictionary *thingKeyVal = (NSDictionary *)thingData;
        
        thing = [[ThingiViewThing alloc] initWithName:thingKeyVal[@"name"]
                                                  UID:thingKeyVal[@"id"]
                                                  URL:thingKeyVal[@"url"]
                                         thumbnailURL:thingKeyVal[@"thumbnail"]];
    }

    NSString *zipURL = [NSString stringWithFormat:@"%@thing:%d/zip", thingiverseURL, thingID];
    NSError *error = nil;
    NSString *zipLocation = [ThingiViewHTTPUtils getRedirectURL:zipURL error:error];
    
    if (error == nil && zipLocation) {
        thing.zipURL = zipLocation;
    } else {
        NSLog(@"Unable to get the zip file for %@, %@", thing.uid, zipLocation);
    }
     
    return thing;
}

@end
