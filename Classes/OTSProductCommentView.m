//
//  OTSProductCommentView.m
//  TheStoreApp
//
//  Created by jiming huang on 12-11-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "OTSProductCommentView.h"
#import "ProductVO.h"
#import "ProductRatingVO.h"
#import "ProductExperienceVO.h"
#import "OTSNaviAnimation.h"
#import "ProductInfo.h"
#import "CommentInfo.h"
@implementation OTSProductCommentView

-(id)initWithFrame:(CGRect)frame productVO:(ProductInfo *)productVO
{
    self=[super initWithFrame:frame];
    if (self!=nil) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [imageView setImage:[UIImage imageNamed:@"title_bg.png"]];
        [self addSubview:imageView];
        [imageView release];
        
        UIButton *returnBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 61, 44)];
        [returnBtn setBackgroundImage:[UIImage imageNamed:@"title_left_btn.png"] forState:UIControlStateNormal];
        [returnBtn setBackgroundImage:[UIImage imageNamed:@"title_left_btn_sel.png"] forState:UIControlStateHighlighted];
        [returnBtn addTarget:self action:@selector(returnBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:returnBtn];
        [returnBtn release];
        
        UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 44)];
        [title setBackgroundColor:[UIColor clearColor]];
        [title setText:@"商品评价"];
        [title setTextColor:[UIColor whiteColor]];
        [title setFont:[UIFont boldSystemFontOfSize:20.0]];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setShadowColor:[UIColor darkGrayColor]];
        [title setShadowOffset:CGSizeMake(1, -1)];
        [self addSubview:title];
        [title release];
        
        UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, self.frame.size.height-44.0)];
        [self addSubview:scrollView];
        [scrollView release];
        
        //商品名称
        UILabel *name=[[UILabel alloc] initWithFrame:CGRectMake(10, 6, 300, 40)];
        [name setText:productVO.name];
        [name setFont:[UIFont systemFontOfSize:15.0]];
        [scrollView addSubview:name];
        [name release];
        
        //1号价
        UILabel *priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 46, 100, 20)];
        [priceLabel setText:@"1号药店价："];
        [priceLabel setFont:[UIFont systemFontOfSize:15.0]];
        [scrollView addSubview:priceLabel];
        [priceLabel release];
        
        UILabel *price=[[UILabel alloc] initWithFrame:CGRectMake(90, 46, 120, 20)];
//        if (productVO.promotionId!=nil && ![productVO.promotionId isEqualToString:@""])
//        {
//            [price setText:[NSString stringWithFormat:@"￥%.2f",[productVO.promotionPrice doubleValue]]];
//        } else {
            [price setText:[NSString stringWithFormat:@"￥%.2f",[productVO.price doubleValue]]];
//        }
        [price setFont:[UIFont boldSystemFontOfSize:17.0]];
        [price setTextColor:[UIColor colorWithRed:213.0/255.0 green:0.0 blue:17.0/255.0 alpha:1.0]];
        [scrollView addSubview:price];
        [price release];
        
        //横线
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 75, 320, 1)];
        [line setBackgroundColor:[UIColor colorWithRed:167.0/255.0 green:32.0/255.0 blue:36.0/255.0 alpha:1.0]];
        [scrollView addSubview:line];
        [line release];
        
        //评价
        CGFloat padingDownValue=0.0;
        scrollView.contentSize=CGSizeMake(320,170+66*([productVO.commentList/*.rating.top5Experience*/ count]));
        float gRate= 0; //[productVO.rating.goodRating floatValue];
        float mRate= 0; //[productVO.rating.middleRating floatValue];
        float bRate= 0;   //[productVO.rating.badRating floatValue];
        
//        if(productVO.rating.top5Experience==nil)
//        {
//            gRate=0.0;
//            mRate=0.0;
//            bRate=0.0;
//        }
        
        gRate = productVO.goodComment;
        mRate = productVO.midComment;
        bRate = productVO.badComment;
        
        float gResultRate=  productVO.goodComment * 100;  //gRate/(gRate+mRate+bRate)*100;
        float mResultRate=  productVO.midComment * 100;// mRate/(gRate+mRate+bRate)*100;
        float bResultRate=  productVO.badComment * 100; //bRate/(gRate+mRate+bRate)*100;
        float resultRate=gResultRate;
        UILabel * gRPercentValueLabel;
        UILabel * gRLabel=[[UILabel alloc]initWithFrame:CGRectMake(41,138+padingDownValue,80,15)];//标签字：“好评”或“中评”或“差评”
        if((gRate==0 && mRate==0 && bRate==0)/* || productVO.rating.top5Experience==nil*/)
        {
            gRLabel.text=@"暂无评价";
            [gRLabel setBackgroundColor:[UIColor clearColor]];
        }
        else
        {
            if(mResultRate>gResultRate && mResultRate>bResultRate)
            {
                resultRate=mResultRate;
                gRLabel.text=@"中评";
            }
            else if(bResultRate>gResultRate && bResultRate>mResultRate)
            {
                resultRate=bResultRate;
                gRLabel.text=@"差评";
            }
            else
            {
                gRLabel.text=@"好评";
            }
        }
        gRLabel.font=[UIFont systemFontOfSize:12.0];
        gRLabel.textColor=[UIColor orangeColor];
        [scrollView addSubview:gRLabel];
        [gRLabel release];
        
        gRPercentValueLabel=[[UILabel alloc]initWithFrame:CGRectMake(23,103+padingDownValue,80,30)];//评价率的值
        gRPercentValueLabel.font=[UIFont systemFontOfSize:24.0];
        gRPercentValueLabel.textColor=[UIColor orangeColor];
        if(resultRate>=99.95 /*&& productVO.rating.top5Experience!=nil*/){
            gRPercentValueLabel.text=@"100%";
        }
        else if(resultRate<=0.04/* || productVO.rating.top5Experience==nil*/){
            gRPercentValueLabel.text=@" 0%";
        }
        else{
            gRPercentValueLabel.text=[NSString stringWithFormat:@"%.1f%%",resultRate];
        }
        if(gRate==0 && mRate==0 && bRate==0){
            gRPercentValueLabel.text=@" 0%";
        }
        [scrollView addSubview:gRPercentValueLabel];
        [gRPercentValueLabel release];
        
        UILabel * slashView=[[UILabel alloc]initWithFrame:CGRectMake(110,88+padingDownValue,1,81)];//中间的一杠
        slashView.backgroundColor=[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.7];
        [scrollView addSubview:slashView];
        [slashView release];
        
        UILabel * staticGRLabel=[[UILabel alloc]initWithFrame:CGRectMake(121,92+padingDownValue,32,14)];//标签字：“好评”
        staticGRLabel.text=@"好评";
        staticGRLabel.font=[UIFont systemFontOfSize:12.0];
        [scrollView addSubview:staticGRLabel];
        [staticGRLabel release];
        
        UIProgressView * goodRateBar=[[UIProgressView alloc]initWithFrame:CGRectMake(156,94+padingDownValue,105,11)];//好评状态栏
        goodRateBar.progress=gRate;
        [scrollView addSubview:goodRateBar];
        [goodRateBar release];
        
        UILabel * gRValueLabel=[[UILabel alloc]initWithFrame:CGRectMake(265,92+padingDownValue,38,16)];//好评率的值
        if((float)(gRate*100)>=99.95)
        {
            [gRValueLabel setText:@"100%"];
        }
        else if((float)(gRate*100)==0.0 /*|| productVO.rating.top5Experience==nil*/)
        {
            [gRValueLabel setText:@"0%"];
        }
        else
        {
            [gRValueLabel setText:[NSString stringWithFormat:@"%.1f%%",gRate*100]];
        }
        gRValueLabel.font=[UIFont systemFontOfSize:11.0];
        [scrollView addSubview:gRValueLabel];
        [gRValueLabel release];
        
        UILabel * staticMRLabel=[[UILabel alloc]initWithFrame:CGRectMake(121,115+padingDownValue,32,14)];//标签字：“中评”
        staticMRLabel.text=@"中评";
        staticMRLabel.font=[UIFont systemFontOfSize:12.0];
        [scrollView addSubview:staticMRLabel];
        [staticMRLabel release];
        
        UIProgressView * midRateBar=[[UIProgressView alloc]initWithFrame:CGRectMake(156,117+padingDownValue,105,11)];//中评状态栏
        midRateBar.progress=mRate;
        [scrollView addSubview:midRateBar];
        [midRateBar release];
        
        UILabel * mRValueLabel=[[UILabel alloc]initWithFrame:CGRectMake(265,115+padingDownValue,38,16)];//中评率的值
        if((float)(mRate*100)>=99.95)
        {
            [mRValueLabel setText:@"100%"];
        }
        else if((float)(mRate*100)<=0.04/* || productVO.rating.top5Experience==nil*/)
        {
            [mRValueLabel setText:@"0%"];
            midRateBar.progress=0;
        }
        else{
            [mRValueLabel setText:[NSString stringWithFormat:@"%.1f%%",mRate*100]];
        }
        mRValueLabel.font=[UIFont systemFontOfSize:11.0];
        [scrollView addSubview:mRValueLabel];
        [mRValueLabel release];
        
        UILabel * staticBRLabel=[[UILabel alloc]initWithFrame:CGRectMake(121,140+padingDownValue,32,14)];//标签字：“差评”
        staticBRLabel.text=@"差评";
        staticBRLabel.font=[UIFont systemFontOfSize:12.0];
        [scrollView addSubview:staticBRLabel];
        [staticBRLabel release];
        
        UIProgressView * badRateBar=[[UIProgressView alloc]initWithFrame:CGRectMake(156,142+padingDownValue,105,11)];//差评状态栏
        badRateBar.progress=bRate;
        [scrollView addSubview:badRateBar];
        [badRateBar release];
        
        UILabel * bRValueLabel=[[UILabel alloc]initWithFrame:CGRectMake(265,140+padingDownValue,38,16)];//差评率的值
        if((float)(bRate*100)>=99.95)
        {
            bRValueLabel.text=@"100%";
        }
        else if((float)(bRate*100)<=0.04 /*|| productVO.rating.top5Experience==nil*/)
        {
            [bRValueLabel setText:@"0%"];
            badRateBar.progress=0;
        }
        else
        {
            [bRValueLabel setText:[NSString stringWithFormat:@"%.1f%%",bRate*100]];
        }
        bRValueLabel.font=[UIFont systemFontOfSize:11.0];
        [scrollView addSubview:bRValueLabel];
        [bRValueLabel release];
        
        UIImageView * lineImgView1=[[UIImageView alloc]initWithFrame:CGRectMake(10,174+padingDownValue,300,1)];//下划线1
        lineImgView1.image = [UIImage imageNamed:@"dottedline.png"];
        [scrollView addSubview:lineImgView1];
        [lineImgView1 release];
        
        if ( productVO.commentList.count == 0   /*productVO.rating.top5Experience==nil*/)
        {
            UILabel *messageLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,100,88,40)];
            messageLabel.text=@"暂无评价";
            messageLabel.textColor=UIColorFromRGB(0xa72024);
            messageLabel.font=[UIFont systemFontOfSize:20.0];
            [messageLabel setTextAlignment:NSTextAlignmentCenter];
            [scrollView addSubview:messageLabel];
            [messageLabel release];
        }
        else
        {
            int columns=0;
            int rowCount=0;//记录有多少评论是多行的
            int kDefaultColumH = 66; //每行默认高度
            
//            for (ProductExperienceVO *experience in productVO.rating.top5Experience)
            for (CommentInfo *comment in productVO.commentList)
            {
                //"优点"
                int cellRowCount=0;
                UILabel *staticSP=[[UILabel alloc]initWithFrame:CGRectMake(23,216+padingDownValue+rowCount*15+kDefaultColumH*columns,30,15)];//“优点”标签
                staticSP.text=@"优点:";
                staticSP.font=[UIFont systemFontOfSize:12.0];
//                [scrollView addSubview:staticSP];
                [staticSP release];
                //优点
                UILabel *strongPointLabel;
                CGSize strongPointLabelSize=[comment.content /*experience.contentGood*/ sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(MAXFLOAT,15)];
                if (strongPointLabelSize.width>236)
                {
                    int labelRowCount=ceil(strongPointLabelSize.width/236.0);//至少是2
                    strongPointLabel=[[UILabel alloc]initWithFrame:CGRectMake(23 /*60*/,216+padingDownValue+rowCount*15+kDefaultColumH*columns,236,15*labelRowCount)];
                    cellRowCount = cellRowCount + labelRowCount - 1;
                }
                else
                    strongPointLabel=[[UILabel alloc]initWithFrame:CGRectMake(23 /*60*/,216+padingDownValue+rowCount*15+kDefaultColumH*columns,236,15)];//优点内容标签
                strongPointLabel.textColor=UIColorFromRGB(0x999999);
                strongPointLabel.text=comment.content;//experience.contentGood;
                int length = [comment.content /*experience.contentGood*/ length];
                DebugLog(@"the length is: %d", length);
                strongPointLabel.font=[UIFont systemFontOfSize:12.0];
                strongPointLabel.numberOfLines=0;
                strongPointLabel.lineBreakMode=UILineBreakModeWordWrap;
                [scrollView addSubview:strongPointLabel];
                [strongPointLabel release];
                //"缺点"
//                UILabel * staticWP=[[UILabel alloc]initWithFrame:
//                                    CGRectMake(23,216+padingDownValue+rowCount*15+106*columns+strongPointLabel.frame.size.height+2,30,15)];//“缺点”标签
//                staticWP.text=@"缺点:";
//                staticWP.font=[UIFont systemFontOfSize:12.0];
//                [scrollView addSubview:staticWP];
//                [staticWP release];
//                //缺点
//                UILabel* weakPointLabel;
//                CGSize weakPointLabelSize = [experience.contentFail sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
//                if (weakPointLabelSize.width > 236 )  {
//                    int labelRowCount = ceil(weakPointLabelSize.width/236.0);//至少是2
//                    weakPointLabel=[[UILabel alloc]initWithFrame:CGRectMake(60,216+padingDownValue+rowCount*15+106*columns+strongPointLabel.frame.size.height+2,236,15*labelRowCount)];
//                    cellRowCount = cellRowCount + labelRowCount - 1;
//                }else
//                    weakPointLabel=[[UILabel alloc]initWithFrame:
//                                    CGRectMake(60,216+padingDownValue+rowCount*15+106*columns+strongPointLabel.frame.size.height+2,236,15)];	//缺点内容标签
//                weakPointLabel.textColor=UIColorFromRGB(0x999999);
//                weakPointLabel.text=experience.contentFail;
//                weakPointLabel.font=[UIFont systemFontOfSize:12.0];
//                weakPointLabel.numberOfLines=0;
//                weakPointLabel.lineBreakMode=UILineBreakModeWordWrap;
//                [scrollView addSubview:weakPointLabel];
//                [weakPointLabel release];
                //"总结"
//                UILabel *staticContent=[[UILabel alloc]initWithFrame:
//                                        CGRectMake(23,216+padingDownValue+rowCount*15+106*columns+strongPointLabel.frame.size.height+
//                                                   weakPointLabel.frame.size.height+4,30,15)];//“总结”标签
//                staticContent.text=@"总结:";
//                staticContent.font=[UIFont systemFontOfSize:12.0];
//                [scrollView addSubview:staticContent];
//                [staticContent release];
//                UILabel * contentLabel;
//                CGSize contentLabelSize = [experience.content sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
//                if (contentLabelSize.width > 236 )  {
//                    int labelRowCount = ceil(contentLabelSize.width/236.0);			//至少是2
//                    contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(60,216+padingDownValue+rowCount*15+106*columns+strongPointLabel.frame.size.height+
//                                                                          weakPointLabel.frame.size.height+4,236,15*labelRowCount)];
//                    cellRowCount = cellRowCount + labelRowCount - 1;
//                } else {
//                    contentLabel=[[UILabel alloc]initWithFrame:
//                                  CGRectMake(60,216+padingDownValue+rowCount*15+106*columns+strongPointLabel.frame.size.height+
//                                             weakPointLabel.frame.size.height+4,236,15)];												//总结内容标签
//                }
//                contentLabel.textColor=UIColorFromRGB(0x999999);
//                contentLabel.text=experience.content;
//                contentLabel.font=[UIFont systemFontOfSize:12.0];
//                contentLabel.lineBreakMode=UILineBreakModeWordWrap;
//                contentLabel.numberOfLines=0;
//                [scrollView addSubview:contentLabel];
//                [contentLabel release];
                //虚线
                UIImageView * lineImgColumView=[[UIImageView alloc]initWithFrame:
                                                CGRectMake(10,216+padingDownValue+rowCount*15+kDefaultColumH*columns+strongPointLabel.frame.size.height /* +
                                                           weakPointLabel.frame.size.height+contentLabel.frame.size.height*/+16,300,1)];					//下划线1
                lineImgColumView.image = [UIImage imageNamed:@"dottedline.png"];
                [scrollView addSubview:lineImgColumView];
                [lineImgColumView release];
                
//                NSString * userNameStr = @"";																				//评论用户名字符串
//                if(experience.userName==nil){
//                    userNameStr=@"";
//                }
//                else if([experience.userName rangeOfString:@"@"].length!=0){
//                    userNameStr=[NSString stringWithString:[experience.userName
//                                                            substringToIndex:[experience.userName rangeOfString:@"@"].location]];
//                }
//                else{
//                    userNameStr=[NSString stringWithString:experience.userName];
//                }
//                if([userNameStr length]>16){
//                    userNameStr=[userNameStr substringToIndex:15];
//                }
//                UILabel * userNameLabel=[[UILabel alloc]initWithFrame:
//                                         CGRectMake(23,190+padingDownValue+rowCount*15+106*columns,[userNameStr length]*8,18)];						//显示评论的用户名label
//                userNameLabel.font=[UIFont systemFontOfSize:14.0];
//                userNameLabel.textColor=UIColorFromRGB(0xa72024);
//                userNameLabel.text=userNameStr;
//                [scrollView addSubview:userNameLabel];
//                [userNameLabel release];
                
                NSString * dateStr= [comment.issuedDate isKindOfClass:[NSNull class]]?@"":comment.issuedDate; /*[[NSString alloc]initWithString:[ [experience.createtime description] substringToIndex:[[experience.createtime description] rangeOfString:@" "].location]];*/
                UILabel * dateLable=[[UILabel alloc]initWithFrame:
                                     CGRectMake(/*[userNameStr length]*8+26*/23,192+padingDownValue+rowCount*15+kDefaultColumH*columns,68,14)];					//显示评论日期label
                dateLable.font=[UIFont systemFontOfSize:12.0];
                dateLable.text= comment.covernedUsername;//  dateStr;
                [scrollView addSubview:dateLable];
                [dateLable release];
                
                UILabel * ratingLogStrLabel=[[UILabel alloc]initWithFrame:
                                             CGRectMake(/*[userNameStr length]*8+94*/68,190+padingDownValue+rowCount*15+kDefaultColumH*columns,30,15)];					//“评分”label
                ratingLogStrLabel.text=@"评分";
                ratingLogStrLabel.font=[UIFont systemFontOfSize:12.0];
                [scrollView addSubview:ratingLogStrLabel];
                [ratingLogStrLabel release];
                
                int iStarNum=[comment.grade intValue];//  [experience.ratingLog intValue];		//评论五角星的星级个数
                for(int i=0;i<5;i++)
                {
                    UIImageView * starImgView=[[UIImageView alloc]initWithFrame:
                                               CGRectMake(/*[userNameStr length]*8+127*/98+11*i,192+padingDownValue+rowCount*15+kDefaultColumH*columns,10,10)];			//五角星
                    if(i<iStarNum)
                    {
                        starImgView.image = [UIImage imageNamed:@"pentagon_Yellow.png"];
                    }
                    else
                    {
                        starImgView.image = [UIImage imageNamed:@"pentagon_Gray.png"];
                    }
                    [scrollView addSubview:starImgView];
                    [starImgView release];
                }
                if ((strongPointLabelSize.width > 236 )/*||(weakPointLabelSize.width > 236 )||(contentLabelSize.width > 236 )*/)
                    rowCount = rowCount + cellRowCount;
                columns++;
            }
            [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width,scrollView.contentSize.height + rowCount*15)];
        }
    }
    return self;
}

-(void)returnBtnClicked:(id)sender
{
    [self.superview.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
    [self removeFromSuperview];
}

@end
