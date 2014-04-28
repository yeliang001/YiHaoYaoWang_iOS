//
//  GpsUtil.h
//  TheStoreApp
//
//  Created by towne on 13-3-4.
//
//

#import <Foundation/Foundation.h>

@class ProvinceVO;

@interface GPSUtil : NSObject

@property(retain)ProvinceVO * provinceVO;
@property(retain)ProvinceVO * gpsProvinceVO;

+ (GPSUtil *)sharedInstance;

-(NSDictionary *)getProvinceDic;

-(NSString *)getProvinceFromPlist;
-(void)saveProvinceToPlist:(NSMutableArray *) userArray;

+(NSString *)checkNetWorkType;

@end
