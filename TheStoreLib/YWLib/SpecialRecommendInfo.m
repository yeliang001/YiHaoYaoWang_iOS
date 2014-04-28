//
//  SpecialRecommendInfo.m
//  TheStoreApp
//
//  Created by LinPan on 13-7-17.
//
//

#import "SpecialRecommendInfo.h"

@implementation SpecialRecommendInfo

- (void)dealloc
{
    [_specialId release];
    [_imageUrl release];
    [_name release];
    [super dealloc];
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_specialId forKey:@"specialId"];
    [aCoder encodeObject:_imageUrl forKey:@"imageUrl"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeInt:_type forKey:@"type"];
    [aCoder encodeInt:_sindex forKey:@"sindex"];
    [aCoder encodeInt:_specialType forKey:@"specialType"];
    [aCoder encodeInteger:_productId forKey:@"productId"];
    [aCoder encodeInteger:_catalogId forKey:@"categoryId"];
    [aCoder encodeInteger:_brandId forKey:@"brandId"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.specialId = [aDecoder decodeObjectForKey:@"specialId"];
    self.imageUrl = [aDecoder decodeObjectForKey:@"imageUrl"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.type = [aDecoder decodeIntForKey:@"type"];
    self.sindex = [aDecoder decodeIntForKey:@"sindex"];
    self.specialType = [aDecoder decodeIntForKey:@"specialType"];
    
    self.productId = [aDecoder decodeObjectForKey:@"productId"];
    self.catalogId = [aDecoder decodeObjectForKey:@"categoryId"];
    self.brandId = [aDecoder decodeObjectForKey:@"brandId"];
    
    return self;
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"\nspecialId %@\nimageUrl %@\nname %@\ntype %d\nsindex %d\nspecialType %d",_specialId,_imageUrl,_name,_type,_sindex,_specialType];
    return desc;
}

@end
