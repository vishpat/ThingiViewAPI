//
//  ThingiViewJSONGrabber.h
//  ThingiView
//
//  Created by Vishal Patil on 1/21/13.
//  Copyright (c) 2013 Vishal Patil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThingiViewJSONGrabber : NSObject
+(NSData*)getDataObjects:(NSString*)path;
+(NSData*)httpGET:(NSString *)path error:(NSError *)error;
+(NSData*)httpPOST:(NSString *)path error:(NSError *)error;
+(NSError*)httpDELETE:(NSString *)path;
@end
