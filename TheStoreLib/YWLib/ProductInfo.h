//
//  ProductInfo.h
//  TheStoreApp
//
//  Created by LinPan on 13-8-5.
//
//

#import <Foundation/Foundation.h>
#import "PromotionInfo.h"

//系列品
@interface SeriesProductInfo : NSObject

@property (copy, nonatomic) NSString *seriesFlag; //eg: "红色,-1.00" 几个属性通过逗号组合起来的字段 作为tag
@property (assign, nonatomic) NSInteger itemId;
@property (copy, nonatomic) NSString *pno;
@property (assign, nonatomic) NSInteger stock;
@end



@interface ProductInfo : NSObject

@property (copy,nonatomic)NSString *productId;  //对应数据中 “id” 字段  ->.-> 尼玛的，傻逼系统啊，数据字段乱七八糟的，id，itemtd，productno，cnmsb。。。
@property (copy,nonatomic)NSString *itemId;
@property (copy,nonatomic)NSString *currentStore; //当前仓库下的库存信息  //商品列表中没有该信息，商品详细里面有
@property (copy,nonatomic)NSString *name;
@property (copy,nonatomic)NSString *category;
@property (copy,nonatomic)NSString *brandId;
@property (copy,nonatomic)NSString *brandName;
@property (copy,nonatomic)NSString *productImageUrl; 
@property (copy,nonatomic)NSString *time;         //上市时间
@property (copy,nonatomic)NSString *price;        //价格
@property (copy,nonatomic)NSString *marketPrice;  //市场价
@property (copy,nonatomic)NSString *status;       //8上架  4下架
@property (copy,nonatomic)NSString *store;        //各个仓对应库存  "1_0,2_0,3_0,4_0,5_0"
@property (copy,nonatomic)NSString *saleType;     //销售类型
@property (copy,nonatomic)NSString *showPic;      //左上角显示图标类型
@property (copy,nonatomic)NSString *subTotalScore;//综合得分
@property (copy,nonatomic)NSString *littlePic;    //商品下方小图标
@property (copy,nonatomic)NSString *userGrade;    //用户好评等级
@property (copy,nonatomic)NSString *userGradeCount;
@property (copy,nonatomic)NSString *comments;     //总评论数
@property (retain,nonatomic)NSArray *commentList; //评论列表
@property (copy,nonatomic)NSString *salesCount;   //销售数
@property (copy,nonatomic)NSString *attribute;    //属性列表
@property (copy,nonatomic)NSString *filter;       //过滤 eg:2_6,3_4,3_16,1_9
@property (copy,nonatomic)NSString *prescription; //药品类型（1普通药 12器械 14处方药可购买 16处方药）
@property (copy,nonatomic)NSString *morePrice;    //一品多价
     
//商品详细页中新增
@property (copy,nonatomic)NSString *categoryId;   //对应catalogid
@property (copy,nonatomic)NSString *categoryName;
@property (copy,nonatomic)NSString *color;
@property (copy,nonatomic)NSString *count;
@property (copy,nonatomic)NSString *gift;
@property (copy,nonatomic)NSString *mainImg1;
@property (copy,nonatomic)NSString *mainImg2;
@property (copy,nonatomic)NSString *mainImg3;
@property (copy,nonatomic)NSString *mainImg4;
@property (copy,nonatomic)NSString *mainImg5;
@property (copy,nonatomic)NSString *mainImg6;
@property (copy,nonatomic)NSString *mainInfo;
@property (copy,nonatomic)NSString *mainPush;
@property (copy,nonatomic)NSString *productNO;
@property (copy,nonatomic)NSString *recommendPrice;
@property (copy,nonatomic)NSString *saleInfo;
@property (copy,nonatomic)NSString *saleService; //eg:批准文号1000006
@property (copy,nonatomic)NSString *sellType;
//@property (copy,nonatomic)NSString *seriesId;
//@property (copy,nonatomic)NSString *seriesName;
@property (copy,nonatomic)NSString *size;
@property (copy,nonatomic)NSString *sellerId;  //卖家id号 
@property (retain,nonatomic)NSArray *taocanList;
@property (copy,nonatomic)NSString *unit;
@property (copy,nonatomic)NSString *desc;
@property (copy, nonatomic)NSString *weight;

@property (assign,nonatomic)CGFloat goodComment; //好评率
@property (assign,nonatomic)CGFloat midComment; //中评率
@property (assign,nonatomic)CGFloat badComment; //差评率
@property (assign,nonatomic)CGFloat totalScore; //总评分

@property (copy,nonatomic)NSArray *middleDetailImgList; //中辅图
@property (copy,nonatomic)NSArray *largeDetailImgList;  //大辅图




//group 团购商品中用到
@property (assign, nonatomic)NSInteger soldAmmont; //已经购买的数量
@property (copy, nonatomic) NSString *startTime;
@property (copy, nonatomic) NSString *endTime;
@property (assign, nonatomic) NSInteger groupStatus;
@property (copy, nonatomic) NSString *groupTitle;
@property (assign, nonatomic) CGFloat priceGroup;
@property (assign, nonatomic) CGFloat priceOriginal; //原价

//限购 起购
@property (assign, nonatomic) NSUInteger limitCount; //限制的购买件数
@property (assign, nonatomic) NSUInteger leastCount; //最少购买件数

//系列品
@property (copy, nonatomic) NSArray *seriesNames; //系列品名字数组
@property (retain, nonatomic) NSDictionary *seriesValues; //每个名字对应的值，对应数组
@property (copy, nonatomic) NSArray *seriesProducts; //所有系列品的数组
@property (assign,nonatomic)NSInteger specialStatus;//是否系列品  再商品列表＝3 标示系列品  在商品详情＝2 或者 ＝3 表示时系列品   fuck。。。

//促销 商品列表中的信息
@property (copy, nonatomic) NSString *activityDesc; //活动字段 "55_3_ABC,53_1_ABC"  元素：id_type_desc
@property (assign, nonatomic) BOOL hasGift; //是否有赠品  通过activityDesc来判断， 不是取的值
@property (assign, nonatomic) BOOL hasReduce;//是不是有满减
//商品详情页中的促销
@property (retain, nonatomic) NSMutableArray *promotions; //促销信息
//购物车中的商品所满足的促销id
//满减的促销id
@property (assign, nonatomic) NSInteger promotionIdOfReduce;
//满赠的促销id
@property (assign, nonatomic) NSInteger promotionIdOfGift;
@property (assign, nonatomic) NSInteger bigCatalogId; //促销结算时用



//是不是上架商品
- (BOOL)isOnSale;
//当前的库存
- (NSInteger)stockNum; //在商品列表中 通过这个获取库存， 在商品详细中通过另外接口获取stock 然后付值给currentStock
- (BOOL)isOTC;//是不是处方药
- (NSString *)getGroupImage;

//系列品操作
//获取每个分类名字对应的内容
- (NSArray *)getSeriesValueByName:(NSString *)name;
- (BOOL)isSeriesProductInProductList; //在商品列表页面，specialStatus ＝＝2 就是系列品
- (BOOL)isSeriesProductInProductDetail; //在商品详细页， specicalStatus ＝＝2 或者 ＝＝ 3 就是系列品   //不知道能不能再傻逼点。。。。。。

//用于结算时判断这个商品是不是有参加促销 -1没有参加 1参加
//- (BOOL)isJoinPromotion;





@end
