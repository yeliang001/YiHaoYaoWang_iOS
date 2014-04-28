//
//  RemoteNotify.h
//  TheStoreApp
//
//  Created by yuan jun on 13-1-14.
//
//

#import <Foundation/Foundation.h>

@interface RemoteNotify : NSObject{
    NSDictionary* notifyDic;
    BOOL isCurrentAccount;
}
@property(nonatomic,retain)NSDictionary* notifyDic;
+(id)sharedRemoteNotify;
@end
