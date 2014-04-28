//
//  AppDelegate.h
//  yhd
//
//  Created by  on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class ProvinceVO;

@interface AppDelegate : UIResponder
<UIApplicationDelegate
, CLLocationManagerDelegate
, MKReverseGeocoderDelegate
, UIAlertViewDelegate>
{
    CLLocationManager *locationManager;
    MKReverseGeocoder *m_Geocoder;
    //ProvinceVO *province;
    BOOL isGetlocation;
    BOOL isAlertViewShowing;
    BOOL isGpsAlertDisAble;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
//@property (nonatomic, retain) ProvinceVO *province;
@property (nonatomic, retain) UIImage   *defaultProductImg;
@property BOOL      isVersionUpdate;
@property BOOL      isFirstLaunchCart;
@property BOOL      isGpsAlertDisAble;

-(void)getCurrentProvinceId;
- (void)enterCart;
-(void)goSearch:(id)sender;
-(void)insertAppErrorLog:(NSString *)errorLog methodName:(NSString *)methodName;
-(void)clearCartNum;
-(void)syncMyStoreBadge;
-(void)logout;
-(void)goSearchWithKeyWords:(NSString*)str productListType:(NSUInteger)ListType;
@end

#define SharedPadDelegate   ((AppDelegate *)[UIApplication sharedApplication].delegate)
