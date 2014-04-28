//
//  SearchAttributeVO.h
//  TheStoreApp
//
//  Created by jiming huang on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchAttributeVO : NSObject {
@private
    NSNumber *attrId;//导购属性id
    NSString *attrName;//导购属性名称
    NSArray *attrChilds;//子导购属性
}
@property(retain,nonatomic) NSNumber *attrId;//导购属性id
@property(retain,nonatomic) NSString *attrName;//导购属性名称
@property(retain,nonatomic) NSArray *attrChilds;//子导购属性
@end
