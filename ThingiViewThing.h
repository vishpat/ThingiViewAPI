//
//  ThingiViewThing.h
//  ThingiView
//
//  Created by Vishal Patil on 1/21/13.
//  Copyright (c) 2013 Vishal Patil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThingiViewThing : NSObject
@property NSString *name;
@property NSString *uid;
@property NSString *url;
@property NSString *zipURL;
@property NSString *thumbnailURL;
@property UIImage *thumbnail;
@property NSArray *parts;
-(id)initWithName:(NSString*)name
              UID:(NSString*)strUID
              URL:(NSString*)strURL
     thumbnailURL:(NSString*)thumbnailURL;
+(ThingiViewThing *)loadThing:(int)thingID;
+(NSString *)getThingDescription:(int)thingID;
-(BOOL)loadParts;
-(NSError *)like;
-(NSError *)unlike;
@end
