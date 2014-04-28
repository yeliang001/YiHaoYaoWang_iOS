//
//  CategoryInfo.h
//  TheStoreApp
//
//  Created by LinPan on 13-7-24.
//
//

#import <Foundation/Foundation.h>

@interface CategoryInfo : NSObject<NSCoding>

@property(copy,nonatomic)NSString *cid;
@property(copy,nonatomic)NSString *parentId;
@property(copy,nonatomic)NSString *type;
@property(copy,nonatomic)NSString *name;
@property(copy,nonatomic)NSString *imageUrl;

@end
