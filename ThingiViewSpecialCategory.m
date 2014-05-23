//
//  ThingiViewSpecialCategory.m
//  ThingiView
//
//  Created by Vishal Patil on 2/2/14.
//  Copyright (c) 2014 Vishal Patil. All rights reserved.
//

#import "ThingiViewRoot.h"
#import "ThingiViewJSONGrabber.h"
#import "ThingiViewThing.h"
#import "ThingiViewHTTPUtils.h"

#import "ThingiViewSpecialCategory.h"

static const int thingsPerPage = 30;
static int pageCount = 0;

@implementation ThingiViewSpecialCategory

+(int)getPageCount:(NSString *)category {
    
    if (pageCount == 0) {
        NSString *specialCategoryURL = [NSString stringWithFormat:@"%@%@",
                                                    thingiverseAPIBaseURL,
                                                    category];
        NSLog(@"Special category URL %@", specialCategoryURL);
        pageCount = [ThingiViewRoot getPageCount:specialCategoryURL];
    }
    
    return pageCount;
}

+(int)getThingsPerPageForCategory:(NSString *)category
{
    return thingsPerPage;
}

+(NSArray*)getThingsForCategory:(NSString*)category startingIndex:(int)startingIndex EndingIndex:(int)endingIndex
{
    assert(startingIndex % thingsPerPage == 0);
    assert(endingIndex % thingsPerPage == 0);
    assert(endingIndex > startingIndex);
    
    int startPage = (startingIndex / thingsPerPage) + 1;
    int endPage = ((endingIndex - thingsPerPage) / thingsPerPage) + 1;
    int thingCount = endingIndex - startingIndex;
    int pageIndex;
    
    NSArray *things = [[NSMutableArray alloc] initWithCapacity:thingCount];
    
    if (things == nil) {
        return nil;
    }
    
    for (pageIndex = startPage; pageIndex <= endPage ; pageIndex++) {
        
        NSString *path = [[NSString alloc] initWithFormat:@"%@?page=%d", category, pageIndex];
        NSData *data = [ThingiViewJSONGrabber getDataObjects:path];
        
        if (data && [data isKindOfClass:[NSArray class]]) {
            NSDictionary *thing;
            
            for (thing in (NSArray *)data) {
                NSString *thumbnailURL = thing[@"thumbnail"];
                [(NSMutableArray*)things addObject:[[ThingiViewThing alloc]
                                                    initWithName:thing[@"name"]
                                                    UID:thing[@"id"]
                                                    URL:thing[@"public_url"]
                                                    thumbnailURL:thumbnailURL]];
            }
        }
    }
    
    return things;
}

@end
