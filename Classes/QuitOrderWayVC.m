//
//  QuitOrderWayVC.m
//  TheStoreApp
//
//  Created by yuan jun on 13-4-15.
//
//

#import "QuitOrderWayVC.h"

@interface QuitOrderWayVC ()

@end

@implementation QuitOrderWayVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView* nav=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    nav.userInteractionEnabled=YES;
    nav.image=[UIImage imageNamed:@"title_bg.png"];
    [self.view addSubview:nav];
    [nav release];
    //    CGFloat height=0;
    UIButton* back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0, 0, 61, 44);
    
    [back setImage:[UIImage imageNamed:@"title_left_btn.png"] forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"title_left_btn_sel.png"] forState:UIControlStateHighlighted];
    
    [back addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:back];

    self.view.backgroundColor=[UIColor colorWithRed:(240.0/255) green:(240.0/255) blue:(240.0/255) alpha:1];
    UILabel* tit=[[UILabel alloc] initWithFrame:CGRectMake(61, 0, 320-122, 44)];
    tit.text=@"退换货方式";
    tit.textAlignment=NSTextAlignmentCenter;
    tit.textColor=[UIColor whiteColor];
    tit.font=[UIFont boldSystemFontOfSize:20];
    tit.shadowOffset=CGSizeMake(1, -1);
    tit.backgroundColor=[UIColor clearColor];
    [nav addSubview:tit];
    [tit release];
    
    UIButton* submit=[UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame=CGRectMake(320-61, 0, 61, 44);
    [submit addTarget:self action:@selector(selectWay) forControlEvents:UIControlEventTouchUpInside];
    [submit setTitle:@"确定" forState:UIControlStateNormal];
//    [submit setImage:[UIImage imageNamed:@"cameraPhotoToTrash.png"] forState:UIControlStateNormal];
//    [submit setImage:[UIImage imageNamed:@"cameraPhotoToTrash_sel.png"] forState:UIControlStateHighlighted];
    [nav addSubview:submit];
    UITableView*tableV=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44) style:UITableViewStyleGrouped];
    tableV.backgroundColor=[UIColor clearColor];
    tableV.backgroundView=nil;
    tableV.delegate=self;
    tableV.dataSource=self;
    [self.view addSubview:tableV];
    [tableV release];

}


-(void)cancelClick{
    [self popSelfAnimated:YES];
}

-(void)selectWay{
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0) {
        UIView* v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        UILabel* l=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 40)];
        l.backgroundColor=[UIColor clearColor];
        l.textColor=[UIColor darkGrayColor];
        l.text=@"由您自行寄回仓库，然后为您退款（申请核准后会告知您寄回的地址）";
        l.font=[UIFont systemFontOfSize:14];
        l.numberOfLines=2;
        [v addSubview:l];
        [l release];
        return [v autorelease];
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 50;
    }
    return 0.01;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ident=@"cell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident] autorelease];
    }
    if (indexPath.section==0) {
        cell.textLabel.text=@"自行寄回";
    }else{
        if (indexPath.row==0) {
            cell.textLabel.text=@"上门取货";
        }
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
