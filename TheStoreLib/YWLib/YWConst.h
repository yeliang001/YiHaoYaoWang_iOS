//
//  YWConst.h
//  TheStoreApp
//
//  Created by LinPan on 13-9-22.
//
//

#import <Foundation/Foundation.h>


#define KYaoSchemeURL @"yhyw"
#define kYaoNitifyAlipayLogin @"AlipyLoginResultNotify"

#define ValidValue(value)\
({id tmp;\
    if ([value isKindOfClass:[NSNull class]])\
        tmp = nil;\
    else\
        tmp = value;\
    tmp;\
})\
    


//#define kYWChannel @"yaodian"
//#define kYWChannel @"91"
#define kYWChannel @"App Store"

//发票抬头类型
typedef enum
{
    kYaoInvoiceHeadPerson = 0, //个人
    kYaoInvoiceHeadCompany = 1, //单位
    kYaoInvoiceHeadNone = 3  //不开发票
}kYaoInvoiceHeadType;

//支付方式
typedef enum
{
    kYaoPaymentReachPay = 0, //货到付款
    kYaoPaymentAlipay = 1,   //支付宝客户端
    kYaoPaymentPosPay = 2    //货到刷卡
}kYaoPaymentType;

//促销类型
typedef enum
{
    // 满减 */
    kYaoPromotion_MJ = 1,
    /** 满返 */
    kYaoPromotion_MF = 2,
    /** 满赠 **/
    kYaoPromotion_MZ = 3,
    /** 换购 **/
    kYaoPromotion_HG = 4,
    /** 满额包邮 **/
    kYaoPromotion_BY = 5,
    /** 满额减 */
    kYaoPromotion_MEJ = 11,
    /** 满件减 */
    kYaoPromotion_MJJ = 12,
    /** 每满额减 */
    kYaoPromotion_MMEJ = 13,
    /** 每满件减 */
    kYaoPromotion_MMJJ = 14,
    /** 满额返 */
    kYaoPromotion_MEF = 21,
    /** 满件返 */
    kYaoPromotion_MJF = 22,
    /** 每满额返 */
    kYaoPromotion_MMEF = 23,
    /** 满额赠 **/
    kYaoPromotion_MEZ = 31,
    /** 满件赠 **/
    kYaoPromotion_MJZ = 32,
    /** 换购 **/
    kYaoPromotion_HG_ALL = 41,
    kYaoPromotion_HG_SPEC = 42
    
}kYaoPromotionType;



//百分点的参数
#define kRCSeason  @"rec_58BE7DB6_B1D9_725C_E0FF_85BCBFD25D05"  //   1、“当季推荐”的推荐类型ID：rec_58BE7DB6_B1D9_725C_E0FF_85BCBFD25D05
#define kRCComment @"rec_9B60838C_E66D_C0F4_6B6A_F35CCC3323E1" //2、“热评商品”的推荐类型ID：rec_9B60838C_E66D_C0F4_6B6A_F35CCC3323E1
#define kRCDoctor  @"rec_5BE4799D_CC1E_2A9B_6F16_A556F6D817B8"  //3、“药师推荐”的推荐类型ID：rec_5BE4799D_CC1E_2A9B_6F16_A556F6D817B8
#define kRCNew     @"rec_2E6E7467_CE96_F80C_3D44_A8B9983913F4"  //4、“新品上架”的推荐类型ID：rec_2E6E7467_CE96_F80C_3D44_A8B9983913F4

#define kRCLike    @"rec_52F5B495_9D33_0CBA_3C3B_5893D9DDDEC0" // 浏览过还浏览
#define kRCPartner @"rec_AE8138DE_05DF_8EE2_DE01_44D899B66FFC" //最佳搭配
#define kRCSearch  @"rec_94578C8A_8064_8438_06FF_92E2F2F918DC" //搜索推荐
#define kRCScan    @"rec_77773BBE_C502_72BF_E415_A22DAF53BF46" //扫描推荐




