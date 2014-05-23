//
//  ThingiViewPart.h
//  ThingiView
//
//  Created by Vishal Patil on 1/22/13.
//  Copyright (c) 2013 Vishal Patil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThingiViewPart : NSObject
@property NSString *uid;
@property NSString *name;
@property NSString *url;
@property NSString *thumbnailURL;
@property UIImage *thumbnail;

-(id)initWithName:(NSString*)strName
              UID:(NSString*)strUID
              URL:(NSString*)strURL
     thumbnailURL:(NSString *)thumbnailURL;

-(NSString*)getSTLURL;
@end
