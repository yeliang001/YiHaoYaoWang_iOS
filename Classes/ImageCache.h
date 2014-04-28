//
//  ImageCache.h
//  TheStoreApp
//
//  Created by zhengchen on 11-11-30.
//  Copyright (c) 2011年 yihaodian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YHD_IMAGE_MIDDLE_1   1
#define YHD_IMAGE_MIDDLE_2   2
#define YHD_IMAGE_MIDDLE_3   3
#define YHD_IMAGE_MINI       4

@protocol ImageCacheDelegate;

@interface ImageCache : NSObject{
    id<ImageCacheDelegate> delegate;
    NSString * imageUrl;
    NSInteger imageId;
    NSInteger imageType ;
    NSInteger tag;
}

@property (nonatomic, assign) id <ImageCacheDelegate> delegate;

+(BOOL) writeApplicationData:(NSData *)data name:(NSString *)fileName;
+(NSData *)applicationDataFromFile:(NSString *)fileName;
+(UIImage*) getImageFromUrl:(NSString *)url withName:(NSString*) name;
+(UIImage*) getImageFromFile:(NSString*) name;
+(void) cacheImageFromUrl:(NSString *)url imageid:(NSInteger) imageid type:(NSInteger) type;
+(void) cacheImageFromUrl:(NSString *)url imageid:(NSInteger)imageid type:(NSInteger)type delegate:(id<ImageCacheDelegate>) delegate tag:(NSInteger)tag;
+(UIImage*) getImageFromFile:(NSInteger) imageid type:(NSInteger) type;
@end

@protocol ImageCacheDelegate <NSObject>
-(void) cacheImageFinished:(NSInteger) tag;
-(void) cacheImageFailed:(NSInteger) tag;
@end