//
//  ImageCache.m
//  TheStoreApp
//
//  Created by zhengchen on 11-11-30.
//  Copyright (c) 2011年 yihaodian. All rights reserved.
//

#import "ImageCache.h"

@implementation ImageCache
@synthesize delegate;

-(id)init :(id<ImageCacheDelegate>) theDelegate  tag:(NSInteger) t{
    self = [super init];
    if (self) {
        self.delegate  = theDelegate;
        tag = t;
    }
    return self;
}

+(UIImage*) getImageFromUrl:(NSString *)url withName:(NSString*) name{
    
    NSData * data = [ImageCache applicationDataFromFile:name];
    if (data == nil) {
        NSURL * imageUrl=[NSURL URLWithString:url];
        data=[NSData dataWithContentsOfURL:imageUrl];
    }
    
    if (data == nil) {
        return nil;
    }
    
    UIImage *image=[UIImage imageWithData:data];
    [ImageCache writeApplicationData:data name:name];
    
    return image;
}
+(void)cacheImageFromUrl:(NSString *)url imageid:(NSInteger) imageid type:(NSInteger) type{
    NSString * name;
    switch (type) {
        case 1:
            name = [NSString stringWithFormat:@"middle_%d_1",imageid];
            break;
        case 2:
            name = [NSString stringWithFormat:@"middle_%d_2",imageid];
            break;
        case 3:
            name = [NSString stringWithFormat:@"middle_%d_3",imageid];
            break;
        default:
            name = [NSString stringWithFormat:@"mini_%d",imageid];
            break;
    }
    [ImageCache getImageFromUrl:url withName:name];
}

-(void)doCacheImage {
    NSString *name;
    switch (imageType) {
        case 1:
            name = [NSString stringWithFormat:@"middle_%d_1",imageId];
            break;
        case 2:
            name = [NSString stringWithFormat:@"middle_%d_2",imageId];
            break;
        case 3:
            name = [NSString stringWithFormat:@"middle_%d_3",imageId];
            break;
        default:
            name = [NSString stringWithFormat:@"mini_%d",imageId];
            break;
    }
    UIImage *image = [ImageCache getImageFromUrl:imageUrl withName:name];
    if (delegate) {
        if (image != nil) {
            [self.delegate cacheImageFinished:tag];
        } else {
            [self.delegate cacheImageFailed:tag];
        }
        
    }
}

-(void)cacheImageFromUrlEx:(NSString *)url imageid:(NSInteger) imageid type:(NSInteger) type{
    imageUrl = url;
    imageId = imageid;
    imageType = type;
    [self otsDetatchMemorySafeNewThreadSelector:@selector(doCacheImage) toTarget:self withObject:nil];  
}


+(void) cacheImageFromUrl:(NSString *)url imageid:(NSInteger)imageid type:(NSInteger)type delegate:(id<ImageCacheDelegate>) delegate tag:(NSInteger)tag{
    ImageCache * cache = [[[ImageCache alloc] init:delegate tag:tag] autorelease];
    [cache cacheImageFromUrlEx:url imageid:imageid type:type];
    

}

+(UIImage*) getImageFromFile:(NSString*) name {
    NSData * data = [ImageCache applicationDataFromFile:name];
    if (data == nil) {
        return nil;
    }
    UIImage *image=[UIImage imageWithData:data];
    return image;
}


+(UIImage*) getImageFromFile:(NSInteger) imageid type:(NSInteger) type{
    NSString * name;
    switch (type) {
        case 1:
            name = [NSString stringWithFormat:@"middle_%d_1",imageid];
            break;
        case 2:
            name = [NSString stringWithFormat:@"middle_%d_2",imageid];
            break;
        case 3:
            name = [NSString stringWithFormat:@"middle_%d_3",imageid];
            break;
        default:
            name = [NSString stringWithFormat:@"mini_%d",imageid];
            break;
    }
    return [ImageCache getImageFromFile:name];
}

+(BOOL) writeApplicationData:(NSData *)data name:(NSString *)fileName{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	if (!documentsDirectory) {
		return NO;
	}
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
	return ([data writeToFile:appFile atomically:NO]);
}

+(NSData *)applicationDataFromFile:(NSString *)fileName
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSData *data = [[[NSData alloc] initWithContentsOfFile:appFile] autorelease];
	return data;
}

@end
