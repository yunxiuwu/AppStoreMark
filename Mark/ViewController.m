//
//  ViewController.m
//  Mark
//
//  Created by apple on 2018/4/24.
//  Copyright © 2018年 wyx. All rights reserved.
//

#import "ViewController.h"
#import <StoreKit/StoreKit.h>

#define ApplicationAppStoreIdentifier @"760171159"
@interface ViewController ()<SKStoreProductViewControllerDelegate>

@end

@implementation ViewController
{
    UIButton *button;
    UIButton *button2;
    UIButton *button3;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 75, self.view.frame.size.height/2 - 150, 150, 60)];
    button.backgroundColor = [UIColor brownColor];
    [button setTitle:@"去评分(AppStore)" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goToMark:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button2 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 75, CGRectGetMaxY(button.frame)+10, 150, 60)];
    button2.backgroundColor = [UIColor purpleColor];
    [button2 setTitle:@"去评分(内嵌)" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(goToMark:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    button3 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 75, CGRectGetMaxY(button2.frame)+10, 150, 60)];
    button3.backgroundColor = [UIColor magentaColor];
    [button3 setTitle:@"去评分(星级)" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(goToMark:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
}
- (void)goToMark:(id)sender
{
    if ([sender isEqual:button]) {
       
        [self goToAppStore];
    }else if ([sender isEqual:button2]){
        [self storeProductViewController];
       
    }else if ([sender isEqual:button3]){
        
        [self storeReviewController];
    }
}

//跳转到App Store，注意在iOS7.0之前和之后URL的差别，ApplicationAppStoreIdentifier替换为自己应用的APPID
- (void)goToAppStore
{
    NSString *urlStr = @"";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0f)
    {
        urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8", ApplicationAppStoreIdentifier];
    } else {
        urlStr = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", ApplicationAppStoreIdentifier];
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

//在应用内部，SKStoreProductViewController是苹果提供的StoreKit.framework内的控制器，添加StoreKit.framework,并导入 #import <StoreKit/StoreKit.h>，遵循SKStoreProductViewControllerDelegate方法。初始化后调用- (void)loadProductWithParameters:(NSDictionary<NSString *, id> *)parameters completionBlock:(nullable void(^)(BOOL result, NSError * __nullable error))block 方法，parameters中的参数是APPID，该参数可以从ituns上获取。调用Block方法，模态弹出评分控制器
- (void)storeProductViewController
{
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc]init];
    storeProductViewContorller.delegate=self;
    [storeProductViewContorller loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:ApplicationAppStoreIdentifier}completionBlock:^(BOOL result,NSError *error)   {
        
        if(error)  {
            NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
            
        }else{
            [self presentViewController:storeProductViewContorller animated:YES completion:nil];
        }
    }];
}

//代理方法必须实现，监听storeProductViewContorller的取消按钮
- (void)productViewControllerDidFinish:(SKStoreProductViewController*)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//StoreKit.framework提供了SKStoreReviewController，在调用+ (void)requestReview后会弹出评分框，可以选择评分星级，该方法只能应用在iOS10.3之上，且不能写评论
- (void)storeReviewController
{
    if (@available(iOS 10.3, *)) {
        [SKStoreReviewController requestReview];
    } else {
        NSLog(@"该方法只对iOS 10.3以上有效");
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
