//
//  OTSInvocationOperation.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-8-20.
//
//

#import <Foundation/Foundation.h>

#pragma mark - operation class
@interface OTSInvocationOperation : NSOperation

@property(nonatomic, retain)    NSMutableDictionary     *userInfo; // element should be a OTSInvocationOperationInfo class
@property(nonatomic)            int                     operationID;    // operation id
@property(nonatomic, assign)    id                      caller;         // caller of the operation

// NOTICE: the return value of the sel param should be an object, although BOOL and int are surpported, other types may return nil
- (id)initWithTarget:(id)target selector:(SEL)sel object:(id)arg;
-(id)result;
@end

#define OTS_OPERATION_USER_INFO_KEY         @"OTS_OPERATION_USER_INFO_KEY"      // key for user info
#define OTS_OPERATION_RESULT_KEY            @"OTS_OPERATION_RESULT_KEY"         // key for result

#define OTS_NOTIFY_OPERATION_FINISHED       @"OTS_NOTIFY_OPERATION_FINISHED"    // operation finished notification name


#pragma mark - operation infomation class
@interface OTSInvocationOperationInfo : NSObject
@property(nonatomic)            int operationID;    // operation id
@property(nonatomic, assign)    id  caller;         // caller of the operation

-(id)initWithCaller:(id)aCaller;
@end

#define OTS_INVALID_OPERATION_ID        -1      // invaid operation id