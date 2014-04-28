//
//  ProductRatingVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-1-19.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ProductRatingVO : NSObject {
@private
	NSNumber * badExperiencesCount;
	NSNumber * badRating;
	NSNumber * goodExperiencesCount;
	NSNumber * goodRating;
	NSNumber * middleExperiencesCount;
	NSNumber * middleRating;
	NSMutableArray * top5Experience;
	NSNumber * totalExperiencesCount;
}
@property(retain,nonatomic)NSNumber * badExperiencesCount;
@property(retain,nonatomic)NSNumber * badRating;
@property(retain,nonatomic)NSNumber * goodExperiencesCount;
@property(retain,nonatomic)NSNumber * goodRating;
@property(retain,nonatomic)NSNumber * middleExperiencesCount;;
@property(retain,nonatomic)NSNumber * middleRating;
@property(retain,nonatomic)NSMutableArray * top5Experience;
@property(retain,nonatomic)NSNumber * totalExperiencesCount;

@end
