//
//  ThingiViewRoot.h
//  ThingiView
//
//  Created by Vishal Patil on 1/21/13.
//  Copyright (c) 2013 Vishal Patil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThingiViewRoot : NSObject
@property NSArray *categories;
-(NSArray *)getCategories;
-(void)printCategories;
-(BOOL)isAuthorized;
+(int)getPageCount:(NSString*)url;
-(int)getSearchPageCount:(NSString *)term;
-(NSArray*)search:(NSString *)term page:(int)page;
+(NSString*)getToken;
@end
