//
//  ShareToSinaMicroBlog.h
//  TheStoreApp
//
//  Created by linyy on 11-6-13.
//  Copyright 2011年 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MicroBlogService;

@interface ShareToSinaMicroBlog : NSObject <UITextFieldDelegate,UITextViewDelegate>{
    UITextField *userPassword;						//输入秘密框
	UITextField *userName;							//输入用户名框
	UIAlertView *sinaAlert;							//新浪警告框
    NSString * cnName;
    NSString * priced;
    NSString * productIded;
    int orderStatus;
    MicroBlogService * blogService;
    NSString * content;
    UITextView *shareText;
	UILabel *contentLength;
}

-(void)shareSina:(NSString *)pName price:(NSString *)pPrice productId:(NSString *)pId;
-(void)shareSinaOrder:(NSString *)pName price:(NSString *)pPrice productId:(NSString *)pId;
-(void)shareSinaMessage:(NSString *)messageContent;

@end

@interface ShareToSinaMicroBlog(private)

-(BOOL)landUser:(NSString *)name pass:(NSString *)password;
-(void)showSina;
-(void)doShareSina:(NSString *)pName price:(NSString *)pPrice productId:(NSString *)pId;

@end
