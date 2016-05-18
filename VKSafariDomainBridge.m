//
//  VKSafariDomainBridge.m
//  VKSafariDomainBridge
//
//  Created by Awhisper on 16/5/11.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "VKSafariDomainBridge.h"
#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>
@interface VKSafariDomainBridge ()<SFSafariViewControllerDelegate>

@property (nonatomic,copy) VKSafariReturn rtblock;
@property (nonatomic,strong) SFSafariViewController *safari;
@property (nonatomic,strong) NSURL *safariUrl;
@property (nonatomic,weak) UIViewController *currentVC;

@end

@implementation VKSafariDomainBridge

static VKSafariDomainBridge *__vksingleton__;


+(void)VKSetupSafariBridgeUrl:(NSURL *)url AndKey:(NSString *)key
{
    if (url && key) {
        [self VKSingleton];
        [[self VKSingleton]setSafariUrl:url];
        [[self VKSingleton]setSafariKey:key];
    }
}

+ (instancetype)VKSingleton
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        __vksingleton__ = [[self alloc] init];
    });
    return __vksingleton__;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.timeOut = 10.0f;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(VKSafariInfoRecieved:) name:VKSafariInfoReceivedNotification object:nil];
        }
        
    }
    return self;
}


-(void)VKGetSafariInfo:(VKSafariReturn)rtBlock
{
    if (__vksingleton__.safariUrl && __vksingleton__.safariKey) {
        
    }else
    {
        rtBlock(NO,nil);
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        if (rtBlock) {
            self.rtblock = rtBlock;
            
            SFSafariViewController *safari = [[SFSafariViewController alloc]initWithURL:self.safariUrl];
            safari.delegate = self;
            safari.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            safari.view.alpha = 0.0f;
            safari.view.userInteractionEnabled = NO;
            self.safari = safari;
            
            UIViewController *currentVC = [self getCurrentVC];
            self.currentVC = currentVC;
            [self.currentVC.view addSubview:safari.view];
            
        }
    }else
    {
        if (rtBlock) {
            rtBlock(NO,nil);
        }
    }
    
}

-(void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully{
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.timeOut * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.currentVC dismissViewControllerAnimated:NO completion:^{
            weakself.safari = nil;
            weakself.currentVC = nil;
        }];
        [weakself VKTimeOut];
    });
    
}


-(void)VKSafariInfoRecieved:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    NSURL *schemeurl = [userInfo objectForKey:@"schemeUrl"];
    NSString *encodeUrl = schemeurl.absoluteString;
    NSString *decodeUrl = [encodeUrl stringByRemovingPercentEncoding];
    if (self.rtblock) {
        self.rtblock(YES,decodeUrl);
        self.rtblock = nil;
    }
}

-(void)VKTimeOut
{
    if (self.rtblock) {
        self.rtblock(NO,nil);
        self.rtblock = nil;
    }
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
