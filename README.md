# AppStoreMark
AppStore评分的三种方式
1、直接跳转到App Store，注意在iOS7.0之前和之后URL的差别
 if ([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0f)
    {
        urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8", ApplicationAppStoreIdentifier];
    } else {
        urlStr = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", ApplicationAppStoreIdentifier];
    }
 2、在应用内部，SKStoreProductViewController是苹果提供的StoreKit.framework内的控制器，添加StoreKit.framework,并导入 #import <StoreKit/StoreKit.h>，遵循SKStoreProductViewControllerDelegate方法。初始化后调用- (void)loadProductWithParameters:(NSDictionary<NSString *, id> *)parameters completionBlock:(nullable void(^)(BOOL result, NSError * __nullable error))block 方法，parameters中的参数是APPID，该参数可以从ituns上获取。调用Block方法，模态弹出评分控制器
3、StoreKit.framework提供了SKStoreReviewController，在调用+ (void)requestReview后会弹出评分框，可以选择评分星级，该方法只能应用在iOS10.3之上，且不能写评论
