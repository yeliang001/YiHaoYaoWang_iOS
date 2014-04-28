//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

#define AliAppID @"2013112000002146"
//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088501903418573"
//收款支付宝账号
#define SellerID  @"etao@111.com.cn"

#define AliNotifyURL @"http://203.110.175.178:30500/mobile-web/JointLoginNotifyReceiver"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"g53sn7qk0dkpoo2omfj4f15zaxjyp0jq"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBANQo2eucTXLde3fwHyg7EsfoVG/GeAKB2/pqaboL2kwFtsqfBsA+u+MUCe1es7PiOCyGuBIPiKqrEpIOKpkIGy6N57IskNUgSzuRMSN/BVTBXaerUbdUN3i6AOBra/4t8/QRfCBXT4Ntxm0IQERHcgPWQuwfK7Ujd2JQ//vRyaOxAgMBAAECgYEA0PYPdV10ds8ovb/2oCRW4ii1iYX8S9Ple2Z2DfWAo+H44ObyukTPv9/Ly0y8SE9mroxeHgPIwvhOCScE08dFJLCmDBp+Ws/THSw/KEj2iDHgrMCFMwSB+X+kpH0ZEQFq19ZOe9n6rhm4jB7QQZCxMIg+qyMiaUT/I657RYIMyDUCQQD0psdCURDjtU9F+9eoAD9R4MVf/mjXGtXtWWh2RJ7o/SyDb5eY+fRmjan1SkjYVkJ0DzQA1NPPwACsLi2FHj0nAkEA3gA7xnZVT7zWVCl8x5XCEKVaslaEU/sQW27OXY5WJEnz+ScmMu+Uxvx0uYbLX949/zXb/NQh0/2HatVJvEBPZwJALAI4Q9CrVhrOWMt1vq3UthjVyG/OUitsohZ8ORIc99JbCIWxYn5MHYqMMSics/XIXHJDq4adV3i1ZkOkQpbu7wJAQQ/idOSjVg4q5lmOV1P9nzFG5nNSruYqwhE0a9jWSCZgWUnu+QicGsFMWD84BW21z8DyKyPkkiOAd3/w7zoNywJAJPVWgRSQMT/O0A91QAXHEJI6tbae9CLjUt+9uxSZbp9HvzUpGctxKUKB1JxAcKAeNCdpMky+Fk9YbLJsybFpAQ=="


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCdSPjTxQgR3f6ulWaSp3etJIeNYLzrq+em/vNVbbpvdIAB8mQ+Mv4BiMiSeBG3h5q3HDd/jxbcbC3p8OIv88cuvtSZp0at2rqmlb3jQcMKfP2TfLbQBFd44NXCKyVYWGL/j9GSNcuEaxhMoVU10bqXMn7AtyqUKltNACPZ0P3ThwIDAQAB"

#endif
