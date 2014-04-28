//
//  DataController.m
//  TheStoreApp
//
//  Created by jiming huang on 12-2-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataController.h"

@implementation DataController

//将数据写入文件
+(BOOL)writeApplicationData:(NSData *)data name:(NSString *)fileName
{
    @synchronized(self)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        if (!documentsDirectory) {
            return NO;
        }
        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
        return ([data writeToFile:appFile atomically:NO]);
    }
}
//从文件读取数据
+(NSData *)applicationDataFromFile:(NSString *)fileName
{
	@synchronized(self)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
        NSData *data = [[[NSData alloc] initWithContentsOfFile:appFile] autorelease];
        return data;
    }
}

@end
