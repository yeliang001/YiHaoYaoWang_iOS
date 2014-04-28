//
//  CommentInfo.m
//  TheStoreApp
//
//  Created by LinPan on 13-8-13.
//
//

#import "CommentInfo.h"

@implementation CommentInfo

- (void)dealloc
{
    [_adminName release];
    [_allUserSocre release];
    [_allUserStatus release];
    [_auditMode release];
    [_auditMode release];
    [_commentScore release];
    [_commentScoreStatus release];
    [_consultationType release];
    [_content release];
    [_goodsId release];
    [_grade release];
    [_commentId release];
    [_isEmail release];
    [_issuedDate release];
    [_mainimg4 release];
    [_nay release];
    [_orderDate release];
    [_orderId release];
    [_pId release];
    [_priority release];
    [_productName release];
    [_putTopDate release];
    [_putTopScore release];
    [_putTopStatus release];
    [_recommendedDate release];
    [_recommendedScore release];
    [_recommendedStatus release];
    [_releaseDate release];
    [_replyCount release];
    [_replys release];
    [_reviewType release];
    [_rewardScore release];
    [_rewardScoreStatus release];
    [_scoreDate release];
    [_status release];
    [_subcatalog release];
    [_subject release];
    [_top5Score release];
    [_top5Status release];
    [_userImg release];
    [_userIp release];
    [_userLevelId release];
    [_userName release];
    [_yes release];
    
    [super dealloc];
}


- (NSString *)covernedUsername
{
    if (_userName.length >= 4)
    {
        NSString *preName = [_userName substringWithRange:NSMakeRange(0,2)];
        NSString *lastName = [_userName substringWithRange:NSMakeRange(_userName.length-2, 2)];
        return [NSString stringWithFormat:@"%@**%@",preName,lastName];
    }
    else
    {
        return _userName;
    }
}



@end
