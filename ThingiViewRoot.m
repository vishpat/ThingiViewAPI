//
//  ThingiViewRoot.m
//  ThingiView
//
//  Created by Vishal Patil on 1/21/13.
//  Copyright (c) 2013 Vishal Patil. All rights reserved.
//

#import "ThingiViewRoot.h"
#import "ThingiViewCategory.h"
#import "ThingiViewThing.h"
#import "ThingiViewJSONGrabber.h"
#import "ThingiViewHTTPUtils.h"

@interface ThingiViewRoot() {
    BOOL categoriesLoaded;
}
@end

@implementation ThingiViewRoot
@synthesize categories = _categories;

-(id)init {
    
    self = [super init];
    
    if (self) {
        categoriesLoaded = NO;
    }
    
    return self;
}

-(BOOL)isAuthorized
{
    BOOL authorized = YES;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if ([prefs stringForKey:@"token"] == nil ||
        [prefs stringForKey:@"tokenType"] == nil) {
        authorized = NO;
    }
    
    return authorized;
}

+(NSString*)getToken
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs stringForKey:@"token"];
}


-(NSArray*)getCategories
{
    if (categoriesLoaded) {
        return _categories;
    }
    
    NSData *data = [ThingiViewJSONGrabber getDataObjects:@"categories"];
    
    if (data == nil) {
        NSLog(@"Unable to get the categories");
        return _categories;
    }
    
    NSDictionary *categoryInfo = nil;
    _categories = [[NSMutableArray alloc] init];
    ThingiViewCategory *category = nil;
    
    if (data && ([data isKindOfClass:[NSArray class]] == YES)) {
        
        for (categoryInfo in (NSArray*)data) {
            NSString *url = categoryInfo[@"url"];
            NSString *uid = [ThingiViewCategory uidFromURL:url];
            category = [ThingiViewCategory getCategoryObj:uid];
            [(NSMutableArray *)_categories addObject:category];
            //[category loadSubCategories];
        }
        categoriesLoaded = YES;
    }

    return _categories;
}

+(int)getPageCount:(NSString*)strURL
{
    int pageCount = 0;
    NSError *error;
    NSDictionary *properties = [ThingiViewHTTPUtils getHeaderFields:strURL error:error];
    
    if (error == nil && properties && [properties objectForKey:@"Link"]) {
        NSString *linkString = [properties objectForKey:@"Link"];
        NSError  *error  = NULL;
        
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:@"page=[0-9]+"
                                      options:0
                                      error:&error];
        
        if (error == nil) {
            NSArray *matches = [regex matchesInString:linkString
                                              options:0
                                                range:NSMakeRange(0, [linkString length])];
            
            for (NSTextCheckingResult *match in matches) {
                NSRange range = [match range];
                NSString *pageString = [linkString substringWithRange:range];
                NSError *numberError = nil;
                NSRegularExpression *numberRegex = [NSRegularExpression
                                                    regularExpressionWithPattern:@"[0-9]+"
                                                    options:0
                                                    error:&error];
                
                if (numberError == nil) {
                    range   = [numberRegex rangeOfFirstMatchInString:pageString
                                                             options:0
                                                               range:NSMakeRange(0, [pageString length])];
                    NSString *result = [pageString substringWithRange:range];
                    if ([result intValue] > pageCount) {
                        pageCount = [result intValue];
                    }
                }
            }
        }
        
    }
    
    return pageCount;    
}

-(int)getSearchPageCount:(NSString *)term
{
    NSString *searchURL = [NSString stringWithFormat:@"%@search/%@",
                           thingiverseAPIBaseURL, term];
    
    return [ThingiViewRoot getPageCount:searchURL];
}

-(NSArray*)search:(NSString*)term page:(int)page
{
    NSMutableArray *things = [[NSMutableArray alloc] init];
    
    NSString* escapedUrlString = [term stringByAddingPercentEscapesUsingEncoding:
                                  NSASCIIStringEncoding];
    NSString *searchURL = [NSString stringWithFormat:@"search/%@?page=%d", escapedUrlString, page];
    
    NSData *data = [ThingiViewJSONGrabber getDataObjects:searchURL];
    
    if (data && ([data isKindOfClass:[NSArray class]] == YES)) {
        
        for (NSDictionary *thingInfo in (NSArray*)data) {
            
            ThingiViewThing *thing = [[ThingiViewThing alloc]
                                    initWithName:thingInfo[@"name"]
                                                UID:thingInfo[@"id"]
                                                URL:thingInfo[@"url"]
                                      thumbnailURL:thingInfo[@"thumbnail"]];
            
            [things addObject:thing];
        }
    }

    return things;
}

-(void)printCategories
{
    ThingiViewCategory *category;
    
    for (category in _categories) {
        [category printCategory];
    }
}

@end
