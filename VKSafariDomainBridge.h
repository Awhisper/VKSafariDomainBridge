//
//  VKSafariDomainBridge.h
//  VKSafariDomainBridge
//
//  Created by Awhisper on 16/5/11.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^VKSafariReturn)(BOOL success,NSString *info);
static NSString * VKSafariInfoReceivedNotification = @"VKSafariInfoReceivedNotification";

@interface VKSafariDomainBridge : NSObject

@property (nonatomic,readonly) NSURL *safariUrl;

@property (nonatomic,strong) NSString *safariKey;

@property (nonatomic,assign) float timeOut;

+ (void)VKSetupSafariBridgeUrl:(NSURL *)url AndKey:(NSString *)key;

+ (instancetype)VKSingleton;

-(void)VKGetSafariInfo:(VKSafariReturn)rtBlock;

@end
