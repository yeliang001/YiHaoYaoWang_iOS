/*==============================================================================
 Copyright (c) 2012 % Baifendian Corporation.
 All Rights Reserved.
 
 mobile Baifendian Recommendation Engine 2.0
 Personalize the Internet
 
 % Confidential and Proprietary
 
 @file 
 mobidea4ec.h
 
 @brief
 Header file for interface of % mobile BRE 2.0.
 
 ==============================================================================*/



#import <Foundation/Foundation.h>


//
//
//
@protocol mobideaRecProtocol


//
/**
 *
 *
 **/
#pragma mark  -- conform / adopt --  

@required       //


//
/**
 *
 *
 **/
#pragma mark  -- mobiBRE 2.0 Response --  

@optional


/** Called when the request receives some data
 - 
 - 
 - 
 Method is called directly or indirectly
 \error [out] status NSError* that indicates success or failure.
 \returns None
 \author %
 \version 1.0a
 \date 08/15/2012
 \since Available in mobiBRE SDK v1.0a 
 \see mobiBRE 2.0 API method calls
 */
-(void) mobidea_Recs:(NSError*) error feedback:(id)feedback;
//
//
//
@end

//
//
#define MB_CALLBACK \
        (id <mobideaRecProtocol>)



//
//
//

@interface BfdAgent : NSObject {
    
}

//
//
//
//
+ (void) appWillResignActive;
+ (void) appDidBecomeActive;
+ (void) bfdAgentDeInit;


//
+ (NSError*) visit:            MB_CALLBACK delegate itemId:(NSString*)itemId options:(NSDictionary*)options;
+ (NSError*) addCart:          MB_CALLBACK delegate lst:(NSArray*)lst options:(NSDictionary*)options;
+ (NSError*) rmCart:           MB_CALLBACK delegate itemId:(NSString*)itemId options:(NSDictionary*)options;
+ (NSError*) order:            MB_CALLBACK delegate lst:(NSArray*)lst orderId:(NSString*)orderId options:(NSDictionary*)options;
+ (NSError*) search:           MB_CALLBACK delegate queryString:(NSString*)queryString options:(NSDictionary*)options;
+ (NSError*) position:         MB_CALLBACK delegate latitude:(double)latitude longitude:(double)longitude options:(NSDictionary*)options;
//
+ (NSError*) recommend:         MB_CALLBACK delegate recommendType:(NSString*)recommendType options:(NSDictionary*)options;
+ (NSError*) feedback:          MB_CALLBACK delegate recommendId:(NSString*)recommendId itemId:(NSString*)itemId options:(NSDictionary*)options;
//
+ (NSError*) multi:             MB_CALLBACK delegate requests:(NSArray*)requests options:(NSDictionary*)options;
+ (NSError*) event:             MB_CALLBACK delegate options:(NSDictionary*)options;
//
@end

//
#define     __MOBIDEA_       @"BfdAgent"