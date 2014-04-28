//
//  OTSOperationEngine.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-8-20.
//
//  DISCRIPTION：This class is designed for management of multithreading by using NSOperation.

#import <Foundation/Foundation.h>

#import "OTSInvocationOperation.h"

@class OTSInvocationOperation;

@interface OTSOperationEngine : NSObject

@property(nonatomic, retain)NSOperationQueue*   theQueue;

+ (OTSOperationEngine *)sharedInstance;

-(int)doOperationForSelector:(SEL)aSelector target:(id)aTarget object:(id)aObject caller:(id)aCaller;
-(int)addOperation:(OTSInvocationOperation*)aOperation;
-(BOOL)cancelOperation:(int)aOperationID;
@end

#define OTS_NOTIFY_OPERATION_QUEUE_FINISHED     @"OTS_NOTIFY_OPERATION_QUEUE_FINISHED"  // operation queue finished notification
