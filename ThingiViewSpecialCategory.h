//
//  ThingiViewSpecialCategory.h
//  ThingiView
//
//  Created by Vishal Patil on 2/2/14.
//  Copyright (c) 2014 Vishal Patil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThingiViewSpecialCategory : NSObject
+(int)getPageCount:(NSString*)category;
+(int)getThingsPerPageForCategory:(NSString *)category;
+(NSArray*)getThingsForCategory:(NSString*)category startingIndex:(int)startingIndex EndingIndex:(int)endingIndex;
@end
