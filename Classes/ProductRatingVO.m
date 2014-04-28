//
//  ProductRatingVO.m
//  ProtocolDemo
//
//  Created by vsc on 11-1-19.
//  Copyright 2011 vsc. All rights reserved.
//

#import "ProductRatingVO.h"


@implementation ProductRatingVO

@synthesize badExperiencesCount;
@synthesize badRating;
@synthesize goodExperiencesCount;
@synthesize goodRating;
@synthesize middleExperiencesCount;
@synthesize middleRating;
@synthesize top5Experience;
@synthesize totalExperiencesCount;

-(ProductRatingVO*)clone
{
    ProductRatingVO *clone = [[[ProductRatingVO alloc] init] autorelease];
    
    clone.badExperiencesCount = self.badExperiencesCount;
    clone.badRating = self.badRating;
    clone.goodExperiencesCount = self.goodExperiencesCount;
    clone.goodRating = self.goodRating;
    clone.middleExperiencesCount = self.middleExperiencesCount;
    clone.middleRating = self.middleRating;
    clone.top5Experience = self.top5Experience;
    clone.totalExperiencesCount = self.totalExperiencesCount;
    
    return clone;
}

-(void)dealloc{
    if(badExperiencesCount!=nil){
        [badExperiencesCount release];
    }
    if(badRating!=nil){
        [badRating release];
    }
    if(goodExperiencesCount!=nil){
        [goodExperiencesCount release];
    }
    if(goodRating!=nil){
        [goodRating release];
    }
    if(middleExperiencesCount!=nil){
        [middleExperiencesCount release];
    }
    if(middleRating!=nil){
        [middleRating release];
    }
    if(top5Experience!=nil){
        [top5Experience release];
    }
    if(totalExperiencesCount!=nil){
        [totalExperiencesCount release];
    }
    [super dealloc];
}

-(NSMutableDictionary *)dictionaryFromVO
{
    NSMutableDictionary *mDictionary=[[[NSMutableDictionary alloc] init] autorelease];
    if (badExperiencesCount!=nil) {
        [mDictionary setObject:badExperiencesCount forKey:@"badExperiencesCount"];
    }
    if (badRating!=nil) {
        [mDictionary setObject:badRating forKey:@"badRating"];
    }
    if (goodExperiencesCount!=nil) {
        [mDictionary setObject:goodExperiencesCount forKey:@"goodExperiencesCount"];
    }
    if (goodRating!=nil) {
        [mDictionary setObject:goodRating forKey:@"goodRating"];
    }
    if (middleExperiencesCount!=nil) {
        [mDictionary setObject:middleExperiencesCount forKey:@"middleExperiencesCount"];
    }
    if (middleRating!=nil) {
        [mDictionary setObject:middleRating forKey:@"middleRating"];
    }
    if (top5Experience!=nil) {
        [mDictionary setObject:top5Experience forKey:@"top5Experience"];
    }
    if (totalExperiencesCount!=nil) {
        [mDictionary setObject:totalExperiencesCount forKey:@"totalExperiencesCount"];
    }
    return mDictionary;
}

+(id)voFromDictionary:(NSMutableDictionary *)mDictionary
{
    ProductRatingVO *vo=[[ProductRatingVO alloc] autorelease];
    id object=[mDictionary objectForKey:@"badExperiencesCount"];
    if (object!=nil) {
        vo.badExperiencesCount=object;
    }
    object=[mDictionary objectForKey:@"badRating"];
    if (object!=nil) {
        vo.badRating=object;
    }
    object=[mDictionary objectForKey:@"goodExperiencesCount"];
    if (object!=nil) {
        vo.goodExperiencesCount=object;
    }
    object=[mDictionary objectForKey:@"goodRating"];
    if (object!=nil) {
        vo.goodRating=object;
    }
    object=[mDictionary objectForKey:@"middleExperiencesCount"];
    if (object!=nil) {
        vo.middleExperiencesCount=object;
    }
    object=[mDictionary objectForKey:@"middleRating"];
    if (object!=nil) {
        vo.middleRating=object;
    }
    object=[mDictionary objectForKey:@"top5Experience"];
    if (object!=nil) {
        vo.top5Experience=object;
    }
    object=[mDictionary objectForKey:@"totalExperiencesCount"];
    if (object!=nil) {
        vo.totalExperiencesCount=object;
    }
    return vo;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:badExperiencesCount forKey:@"badExperiencesCount"];
    [aCoder encodeObject:badRating forKey:@"badRating"];
    [aCoder encodeObject:goodExperiencesCount forKey:@"goodExperiencesCount"];
    [aCoder encodeObject:goodRating forKey:@"goodRating"];
    [aCoder encodeObject:middleExperiencesCount forKey:@"middleExperiencesCount"];
    [aCoder encodeObject:middleRating forKey:@"middleRating"];
    [aCoder encodeObject:top5Experience forKey:@"top5Experience"];
    [aCoder encodeObject:totalExperiencesCount forKey:@"totalExperiencesCount"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self.badExperiencesCount=[aDecoder decodeObjectForKey:@"badExperiencesCount"];
    self.badRating=[aDecoder decodeObjectForKey:@"badRating"];
    self.goodExperiencesCount=[aDecoder decodeObjectForKey:@"goodExperiencesCount"];
    self.goodRating=[aDecoder decodeObjectForKey:@"goodRating"];
    self.middleExperiencesCount=[aDecoder decodeObjectForKey:@"middleExperiencesCount"];
    self.middleRating=[aDecoder decodeObjectForKey:@"middleRating"];
    self.top5Experience=[aDecoder decodeObjectForKey:@"top5Experience"];
    self.totalExperiencesCount=[aDecoder decodeObjectForKey:@"totalExperiencesCount"];
    return self;
}
@end
