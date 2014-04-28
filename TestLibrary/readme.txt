长条形的轮播图调用的是新版促销活动，需要依次调用3个接口。
1、Page<HotPointNewVO> com.yihaodian.mobile.service.PromotionService.getHomeHotPointListNew(Trader trader, Long provinceId, Integer currentPage, Integer pageSize)

 2、Page<CmsPageVO> com.yihaodian.mobile.service.PromotionService.getCmsPageList(Trader trader, Long provinceId, Long activityId, Integer currentPage, Integer pageSize)

3、Page<CmsColumnVO> com.yihaodian.mobile.service.PromotionService.getCmsColumnList(Trader trader, Long provinceId, Long cmsPageId, String type, Integer currentPage, Integer pageSize)


正方形的广告调用旧版的促销活动，需要依次调用两个接口：
1.Page<HotPointVO> com.yihaodian.mobile.centralService.CentralProductService.getHomeHotPointList(Trader trader, Long provinceId, Integer currentPage, Integer pageSize)

2.Page<ProductVO> com.yihaodian.mobile.centralService.CentralProductService.getHotProductByActivityID(Trader trader, Long activityID, Long provinceId, Integer currentPage, Integer pageSize)