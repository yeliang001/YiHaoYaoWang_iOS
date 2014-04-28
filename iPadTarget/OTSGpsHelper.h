//
//  OTSGpsHelper.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-9-26.
//
//

#import <Foundation/Foundation.h>

@class ProvinceVO;

@interface OTSGpsHelper : NSObject

@property(retain)ProvinceVO * provinceVO;
@property(retain)ProvinceVO * gpsProvinceVO;

+ (OTSGpsHelper *)sharedInstance;

-(NSDictionary*)provinceNameValueDic;
-(NSDictionary*)provinceSetDic;

-(void)saveProvince;
-(void)saveProvince:(ProvinceVO*)aProvinceVO;
-(void)saveProvinceWithName:(NSString*)aProvinceName provinceID:(NSNumber*)aProvinceID;
@end
