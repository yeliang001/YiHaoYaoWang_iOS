//
//  OTSChachedImageView.m
//  TheStoreApp
//
//  Created by yiming dong on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSChachedImageView.h"
#import <CommonCrypto/CommonHMAC.h>
#import "ProductService.h"
#import "GlobalValue.h"
#import "OTSMfImageCache.h"

@implementation OTSChachedImageView
@synthesize url;
@synthesize defaultImage;

-(id)initWithFrame:(CGRect)aFrame url:(NSString*)aUrlString defaultImage:(UIImage*)aDefaultImage
{
    self = [self initWithFrame:aFrame];
    if (self)
    {
        url = [aUrlString copy];
        defaultImage = [aDefaultImage retain];
        self.image = defaultImage;
        
        [self loadImage];
    }
    
    return self;
}

-(void)dealloc
{
    [url release];
    [defaultImage release];
    
    [super dealloc];
}

#pragma mark -
+(NSString*)imageCachedPathWithKey:(NSString*)aKey
{
    if (aKey)
    {
        NSMutableString* path = [NSMutableString stringWithString:NSHomeDirectory()];
        [path appendString:@"/imageCache/"];
        [path appendString:aKey];
        return path;
    }
    
    return nil;
}


+ (NSString *)keyForURL:(NSURL *)url
{
	NSString *urlString = [url absoluteString];
	if ([urlString length] == 0) {
		return nil;
	}
    
	// Strip trailing slashes so http://allseeing-i.com/ASIHTTPRequest/ is cached the same as http://allseeing-i.com/ASIHTTPRequest
	if ([[urlString substringFromIndex:[urlString length]-1] isEqualToString:@"/"]) {
		urlString = [urlString substringToIndex:[urlString length]-1];
	}
    
	// Borrowed from: http://stackoverflow.com/questions/652300/using-md5-hash-on-a-string-in-cocoa
	const char *cStr = [urlString UTF8String];
	unsigned char result[16];
	CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
	return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]]; 	
}

+ (void)ensurePathExists:(NSString*)pathName
{
    BOOL bisDir;
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:pathName isDirectory:&bisDir];
	if (!fileExist) {
		[[NSFileManager defaultManager] createDirectoryAtPath:pathName withIntermediateDirectories:YES attributes:nil error:nil];
	}
}

-(void)updateImageInMainThread:(UIImage*)aImage
{
    if (aImage)
    {
        self.image = aImage;
    }
    else
    {
        self.image = defaultImage;
    }
}

-(void)downloadRemoteImage
{
        UIImage* image = nil;
        
        NSURL *imgUrl = [NSURL URLWithString:url];
        NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
        if(imgData)
        {
            image = [UIImage imageWithData:imgData];
        }
        
        if (imgData && image)
        {
            // 将imgData写入缓存
            NSURL* urlObj = [NSURL URLWithString:url];
            NSString* imagePath = [OTSChachedImageView imageCachedPathWithKey:[OTSChachedImageView keyForURL:urlObj]];
            
            [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];  //删原文件
            NSString *fileDir = [imagePath stringByDeletingLastPathComponent];
            [OTSChachedImageView ensurePathExists:fileDir];    // 创建目录
            [imgData writeToFile:imagePath atomically:YES]; // 写文件
        }
        
    [self performSelectorOnMainThread:@selector(updateImageInMainThread:) withObject:image waitUntilDone:YES];
}

-(void)loadImage
{
    UIImage* theImage = nil;
    
    // 查找缓存数据
    NSURL* urlObj = [NSURL URLWithString:url];
    NSString* imagePath = [OTSChachedImageView imageCachedPathWithKey:[OTSChachedImageView keyForURL:urlObj]];
    
    if (imagePath && [imagePath length] > 0)
    {
        theImage = [UIImage imageWithContentsOfFile:imagePath];
    }
    
    if (theImage)
    {
        self.image = theImage;
    }
    else
    {
        self.image = defaultImage;
        // 文件未缓存，启动网络请求
        [self otsDetatchMemorySafeNewThreadSelector:@selector(downloadRemoteImage) 
                                           toTarget:self 
                                         withObject:nil];
    }
}

@end




//======================= OTSProductImageView ============================
#pragma mark - 
@interface OTSProductImageView ()
-(void)threadMainRequestProductDetail;
@end

@implementation OTSProductImageView
@synthesize prodctId;


-(id)initWithFrame:(CGRect)aFrame productId:(NSNumber*)aProductId defaultImage:(UIImage*)aDefaultImage
{
    self = [self initWithFrame:aFrame];
    if (self)
    {
        self.defaultImage = [aDefaultImage retain];
        self.image = self.defaultImage;
        prodctId = [aProductId retain];
        
        [self otsDetatchMemorySafeNewThreadSelector:@selector(threadMainRequestProductDetail) toTarget:self withObject:nil];
    }
    
    return self;
}

-(void)dealloc
{
    [prodctId release];
    
    [super dealloc];
}


-(void)threadMainRequestProductDetail
{
    if (prodctId)
    {
        UIImage* cachedImage = [OTSMfImageCache imageForKey:prodctId];
        if (cachedImage)
        {
            self.image = cachedImage;
        }
        else
        {
            ProductService *service = [[[ProductService alloc] init] autorelease];
            ProductVO *product = [service getProductDetail:[GlobalValue getGlobalValueInstance].trader productId:prodctId provinceId:[GlobalValue getGlobalValueInstance].provinceId];
            
            if (product)
            {
                self.url = product.miniDefaultProductUrl;
                [self performSelectorOnMainThread:@selector(loadImage) withObject:nil waitUntilDone:NO];
            } 
        }
    }
}

-(void)loadImage
{
    [super loadImage];
    
    if (self.image != self.defaultImage)
    {
        [OTSMfImageCache addImage:self.image forKey:prodctId];
    }
}

@end
