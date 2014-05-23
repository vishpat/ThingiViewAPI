//
//  ThingiViewLikes.m
//  ThingiView
//
//  Created by Vishal Patil on 7/5/13.
//  Copyright (c) 2013 Vishal Patil. All rights reserved.
//

#import "ThingiViewLikes.h"
#import "ThingiViewJSONGrabber.h"
#import "ThingiViewThing.h"

@implementation ThingiViewLikes

+(NSArray*)getLikedThings
{
    NSMutableArray *favThings = [[NSMutableArray alloc] initWithCapacity:128];
    NSData *data;
    int pageIndex = 1;
    
    while (YES) {
        
        NSString *queryStr = [NSString stringWithFormat:@"users/me/likes?page=%d", pageIndex++];
        data = [ThingiViewJSONGrabber getDataObjects:queryStr];
        
        if (data == nil) {
            break;
        }
        
        if (data && [data isKindOfClass:[NSArray class]] == YES) {
            NSArray *things = (NSArray *)data;
            
            if ([things count] == 0) {
                break;
            }
            
            NSDictionary *thing;
            for (thing in (NSArray *)data) {
                
                NSString *thumbnailURL = thing[@"thumbnail"];
                [(NSMutableArray*)favThings addObject:[[ThingiViewThing alloc]
                                                    initWithName:thing[@"name"]
                                                    UID:thing[@"id"]
                                                    URL:thing[@"public_url"]
                                                    thumbnailURL:thumbnailURL]];
            }
        }
    }
    
    return favThings;
}

@end
