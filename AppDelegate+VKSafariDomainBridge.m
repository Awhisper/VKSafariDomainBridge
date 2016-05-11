//
//  AppDelegate+VKSafariDomainBridge.m
//  VKSafariDomainBridge
//
//  Created by Awhisper on 16/5/11.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "AppDelegate+VKSafariDomainBridge.h"
#import <objc/runtime.h>
#import "VKSafariDomainBridge.h"

@implementation AppDelegate (VKSafariDomainBridge)

+(void)load
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        Class class = [self class];
        
        SEL origSelector = @selector(application:openURL:options:);
        SEL newSelector = @selector(vkApplication:openURL:options:);
        
        Method origMethod = class_getInstanceMethod(class,origSelector);
        
        if (!origMethod) {
            SEL emptySelector = @selector(vkEmptyApplication:openURL:options:);
            Method emptyMethod = class_getInstanceMethod(class,emptySelector);
            IMP emptyImp = method_getImplementation(emptyMethod);
            class_addMethod(self, origSelector, emptyImp,
                            method_getTypeEncoding(emptyMethod));
        }
        
        origMethod = class_getInstanceMethod(class,origSelector);
        Method newMethod = class_getInstanceMethod(class,newSelector);
        if (origMethod && newMethod) {
            method_exchangeImplementations(origMethod, newMethod);
        }
    }
}

-(BOOL)vkEmptyApplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return NO;
}

-(BOOL)vkApplication:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    NSString *safariInfoKey = [VKSafariDomainBridge VKSingleton].safariKey;
    if ([[url absoluteString]containsString:safariInfoKey]) {
        if (url) {
            NSDictionary *userInfoDic = @{@"schemeUrl":url};
            [[NSNotificationCenter defaultCenter]postNotificationName:VKSafariInfoReceivedNotification object:self userInfo:userInfoDic];
        }
        return YES;
    }else
    {
        return [self vkApplication:application openURL:url options:options];
    }
}
@end
