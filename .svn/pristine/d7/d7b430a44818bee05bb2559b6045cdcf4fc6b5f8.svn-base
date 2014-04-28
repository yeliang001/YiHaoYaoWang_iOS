//
//  NSString+Common.m
//  HappyShare
//
//  Created by Lin Pan on 13-3-20.
//  Copyright (c) 2013年 Lin Pan. All rights reserved.
//

#import "NSString+Common.h"

@implementation NSString (Common)

+ (NSString *)stringWithNowDate
{
    NSDate *nowDate = [NSDate date];
    NSString *formatter = @"yyyy-MM-dd";
    
    return [NSString stringWithDate:nowDate formater:formatter];
    
}

+ (NSString *)stringWithDate:(NSDate *)date formater:(NSString *)formater
{
    if (!date) {
        return  nil;
    }
    if (!formater) {
        formater = @"yyyy-MM-dd";
    }
    
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formater];
    return [formatter stringFromDate:date];
}

+ (NSString *)stringWithSize:(float)fileSize
{
    NSString *sizeStr;
    if(fileSize/1024.0/1024.0/1024.0 > 1)
    {
        sizeStr = [NSString stringWithFormat:@"%0.1fGB",fileSize/1024.0/1024.0/1024.0];
    }
    else if(fileSize/1024.0/1024.0 > 1 && fileSize/1024.0/1024.0 < 1024 )
    {
        sizeStr = [NSString stringWithFormat:@"%0.1fMB",fileSize/1024.0/1024.0];
    }
    else
    {
        sizeStr = [NSString stringWithFormat:@"%0.1fKB",fileSize/1024.0];
    }
    
    
    return sizeStr;

}


- (NSString *) md5HexDigest
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash uppercaseString];
}
@end
