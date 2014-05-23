//
//  ThingiViewCategory.h
//  ThingiView
//
//  Created by Vishal Patil on 1/21/13.
//  Copyright (c) 2013 Vishal Patil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThingiViewCategory : NSObject
@property NSString *name;
@property NSString *thumbnailURL;
@property UIImage *thumbnail;
@property NSString *uid;
@property NSString *url;
@property NSArray *subCategories;
@property NSArray *things;
@property NSInteger thingCount;

-(id)initWithUID:(NSString*)strUID
            name:(NSString*)strName
             url:(NSString*)strURL
    thumbnailURL:(NSString*)thumbnailURL
      thingCount:(NSInteger)thingCount;

-(BOOL)loadSubCategories;
-(NSArray*)getSubCategories;
-(NSArray*)getThingsFromStartingIndex:(int)startingIndex EndingIndex:(int)endingIndex;
+(NSString*)uidFromURL:(NSString *)url;
-(void)printCategory;
+(ThingiViewCategory*)getCategoryObj:(NSString*)uid;
+(int)getThingsPerPage;
-(void)freeObjects;
@end
