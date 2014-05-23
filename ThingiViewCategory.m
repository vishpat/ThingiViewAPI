//
//  ThingiViewCategory.m
//  ThingiView
//
//  Created by Vishal Patil on 1/21/13.
//  Copyright (c) 2013 Vishal Patil. All rights reserved.
//

#import "ThingiViewCategory.h"
#import "ThingiViewJSONGrabber.h"
#import "ThingiViewThing.h"

@interface ThingiViewCategory() {
    BOOL subcategoriesLoaded;
}
-(int)maxThingCount;

@end
@implementation ThingiViewCategory

@synthesize name = _name;
@synthesize uid = _uid;
@synthesize url = _url;
@synthesize subCategories = _subCategories;
@synthesize things = _things;
@synthesize thumbnailURL = _thumbnailURL;
@synthesize thumbnail = _thumbnail;
@synthesize thingCount = _thingCount;

-(id)initWithUID:(NSString *)strUID
            name:(NSString *)strName
             url:(NSString *)strURL
    thumbnailURL:(NSString *)thumbnailURL
    thingCount:(NSInteger)thingCount
{
    self = [super init];
    
    if (self) {
        _uid = strUID;
        _name = strName;
        _url = strURL;
        _thumbnailURL = thumbnailURL;
        _thingCount = thingCount;
        subcategoriesLoaded = NO;
    }
    
    return self;
}
-(int)maxThingCount {
    BOOL iPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
    int maxCount = iPad ? 1000 : 300;
    
    return maxCount;
}

+(ThingiViewCategory*)getCategoryObj:(NSString*)uid
{
    ThingiViewCategory *category = nil;
    NSDictionary *categoryInfo = nil;

    NSString *path = [[NSString alloc] initWithFormat:@"categories/%@", uid];
    NSData *data = [ThingiViewJSONGrabber getDataObjects:path];
    
    if (data == nil) {
        return nil;
    }
    
    if (data && ([data isKindOfClass:[NSDictionary class]] == YES)) {
         categoryInfo = (NSDictionary*)data;
    }
    
    NSString *name = categoryInfo[@"name"];
    NSString *url = categoryInfo[@"url"];
    NSString *thumbnailURL = categoryInfo[@"thumbnail"];
    NSString *thingCount = categoryInfo[@"count"];
    
    category = [[ThingiViewCategory alloc] initWithUID:uid
                                                     name:name
                                                    url:url
                                             thumbnailURL:thumbnailURL
                                            thingCount:[thingCount integerValue]];
    return category;
}

+(NSString*)uidFromURL:(NSString *)url
{
    NSArray *components = [url componentsSeparatedByString:@"/"];
    NSString *uid = nil;
    if ([components count] > 0) {
        uid = components[[components count] - 1];
    }
    return uid;
}

-(BOOL)loadSubCategories
{
    if (subcategoriesLoaded == YES) {
        return subcategoriesLoaded;
    }
    
    NSString *path = [[NSString alloc] initWithFormat:@"categories/%@", _uid];
    NSData *data = [ThingiViewJSONGrabber getDataObjects:path];
    
    if (data == nil) {
        return NO;
    }
    
    if (data && ([data isKindOfClass:[NSDictionary class]] == YES)) {
        
        NSDictionary *categoryInfo = (NSDictionary*)data;
        NSArray *subCategories = categoryInfo[@"children"];
        NSDictionary *subCategoryInfo;
        
        _subCategories = [[NSMutableArray alloc] initWithCapacity:[subCategories count]];
        
        for (subCategoryInfo in subCategories) {
            NSString *url = subCategoryInfo[@"url"];
            NSString *uid = [ThingiViewCategory uidFromURL:url];
            ThingiViewCategory *subCategory = [ThingiViewCategory getCategoryObj:uid];
            [(NSMutableArray *)_subCategories addObject:subCategory];
            [subCategory loadSubCategories];
        }
        
        subcategoriesLoaded = YES;
    }
    
    return subcategoriesLoaded;
}

-(NSArray*)getSubCategories
{
    return subcategoriesLoaded ? _subCategories : nil;
}

+(int)getThingsPerPage {
    BOOL iPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
    return iPad ? 50 : 20;
}

-(NSArray*)getThingsFromStartingIndex:(int)startingIndex EndingIndex:(int)endingIndex
{
    int thingsPerPage = [ThingiViewCategory getThingsPerPage];
    
    assert(startingIndex % thingsPerPage == 0);
    assert(endingIndex % thingsPerPage == 0);
    assert(endingIndex > startingIndex);
    
    int startPage = (startingIndex / thingsPerPage) + 1;
    int endPage = ((endingIndex - thingsPerPage) / thingsPerPage) + 1;
    int thingCount = endingIndex - startingIndex;
    int pageIndex;
   
    _things = [[NSMutableArray alloc] initWithCapacity:thingCount];
    
    if (_things == nil) {
        return nil;
    }
        
    for (pageIndex = startPage; pageIndex <= endPage ; pageIndex++) {
        
        NSString *path = [[NSString alloc] initWithFormat:@"categories/%@/things?page=%d&per_page=%d",
                      _uid, pageIndex, thingsPerPage];
        NSData *data = [ThingiViewJSONGrabber getDataObjects:path];
    
        if (data && [data isKindOfClass:[NSArray class]]) {
            NSDictionary *thing;
        
            for (thing in (NSArray *)data) {
            
                NSString *thumbnailURL = thing[@"thumbnail"];
                [(NSMutableArray*)_things addObject:[[ThingiViewThing alloc]
                                                 initWithName:thing[@"name"]
                                                 UID:thing[@"id"]
                                                 URL:thing[@"public_url"]
                                                 thumbnailURL:thumbnailURL]];
            }
        }
    }
    
    return _things;
}

-(void)freeObjects {
    subcategoriesLoaded = false;
    self.subCategories = nil;
    self.things = nil;
}

-(void)printCategory
{
    ThingiViewCategory *category;
    
    NSLog(@"%@ %@ %@ ", _name, _uid, _url);
    
    NSLog(@"Sub categories for %@:", _name);
    for (category in _subCategories) {
        [category printCategory];
    }
}
@end
