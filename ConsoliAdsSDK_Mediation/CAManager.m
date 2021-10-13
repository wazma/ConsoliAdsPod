//
//  CAManager.m
//  ObjectiveC-AdNetworks
//
//  Created by rehmanaslam on 15/10/2018.
//  Copyright © 2018 rehmanaslam. All rights reserved.
//

#import "CAManager.h"
#import "ConsoliAdIOSPlugin.h"
#import "ConsoliSDKAdsDelegate.h"
#import "NSObject+ClassName.h"
#import "CALogManager.h"
#import "ConsoliAds.h"
#import "ConsoliAdsMediationDelegate.h"

@interface CAManager() <ConsoliSDKAdsDelegate> {
    BOOL isFirstRewardedAdRequested;
    NSMutableDictionary *rewardedRequestStatuses;
}

@end

@implementation CAManager

static NSString * const SDK_VERSION = @"9.1.1";

-(instancetype)init {
    if ((self = [super init])) {
        isFirstRewardedAdRequested = NO;
        rewardedRequestStatuses = [NSMutableDictionary new];
    }
    return self;
}

+ (CAManager*)sharedManager {
    static CAManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void)initializeWithAppKey:(NSString *)appKey consent:(BOOL)userConsent delegate:(id)delegate {

    if (delegate && ![self.adNetworkInitializeListeners containsObject:delegate]) {
        [self.adNetworkInitializeListeners addObject:delegate];
    }
    
    if (self.myState == AdNetworkState_None) {

        self.myState = AdNetworkState_Initializing;
        self.userConsent = userConsent;
        [[ConsoliAdIOSPlugin sharedPlugIn] initWithKey:appKey andDelegate:self userConsent:userConsent devMode:[ConsoliAds sharedInstance].isDevMode];
    }
}

- (void)sdkDidInitialized:(BOOL)status {
    
    if (status) {
        self.myState = AdNetworkState_InitSucceeded;
    }
    else {
        self.myState = AdNetworkState_InitFailed;
    }
    [self notifyInitialized];
}

- (void)setRequestState:(PlaceholderName)placeholder networkName:(AdNetworkName)adNetworkName state:(RequestState)state {
    
    if (adNetworkName == CONSOLIADSREWARDEDVIDEO) {
        NSString *key = ENUM_TO_STRING(placeholder);
        [rewardedRequestStatuses setObject:ENUM_TO_STRING(state) forKey:key];
    }
}

- (void)didClickInterstitial:(NSString *)location {
    [[ConsoliAds sharedInstance] onAdClick:CONSOLIADS format:INTERSTITIAL];
}

- (void)didCloseInterstitial:(NSString *)location {
    [[ConsoliAds sharedInstance] onAdClosed:CONSOLIADS format:INTERSTITIAL];
}

- (void)didDisplayInterstitial:(NSString *)location {
    [[ConsoliAds sharedInstance] onAdShowSuccess:CONSOLIADS format:INTERSTITIAL];
}

- (void)onAdError:(NSString *)error {
   // [[ConsoliAds sharedInstance] onAdShowFailed:CONSOLIADS format:INTERSTITIAL];
}

- (void)rewardedVideoAdClicked:(NSString *)sceneId {
    [[ConsoliAds sharedInstance] onAdClick:CONSOLIADSREWARDEDVIDEO format:REWARDED];
}

- (void)rewardedVideoAdClosed:(NSString *)sceneId {
    [[ConsoliAds sharedInstance] onAdClosed:CONSOLIADSREWARDEDVIDEO format:REWARDED];
}

- (void)rewardedVideoAdCompleted:(NSString *)sceneId withReward:(int)reward {
    [[ConsoliAds sharedInstance] onRewardedVideoAdCompleted:CONSOLIADSREWARDEDVIDEO];
}

- (void)rewardedVideoAdDidDisplay:(NSString *)sceneId {
    [[ConsoliAds sharedInstance] onAdShowSuccess:CONSOLIADSREWARDEDVIDEO format:REWARDED];
}

- (void)rewardedVideoAdLoaded:(NSString *)sceneId {
    PlaceholderName placeholderName = (PlaceholderName)[sceneId integerValue];
    [[[ConsoliAds sharedInstance] getMediationManager] changeAdNetworkLoadState:CONSOLIADSREWARDEDVIDEO state:Completed];
    if (Default == placeholderName) {
        [[ConsoliAds sharedInstance] onAdLoadSuccess:CONSOLIADSREWARDEDVIDEO format:REWARDED];
    }
}

- (void)didFailToShowRewardedVideo:(NSString*)sceneID error:(NSString *)error {
    [[ConsoliAds sharedInstance] onAdShowFailed:CONSOLIADSREWARDEDVIDEO format:REWARDED];
}

//- (void)didClickIcon:(NSString *)scene {
//
//    NSScanner *scanner = [NSScanner scannerWithString:scene];
//    int result;
//    BOOL hasInt = [scanner scanInt:&result];
//
//    if (!hasInt) {
//        result = 0;
//    }
//    PlaceholderName placeholder = (PlaceholderName)result;
//
//    [[ConsoliAds sharedInstance] onIconAdClick:CONSOLIADSICON placHolderName:placeholder];
//}

//- (void)didCloseIcon:(NSString *)scene {
//    [[ConsoliAds sharedInstance] onAdClosed:CONSOLIADSICON format:ICONAD];
//}
//
//- (void)didDisplayIcon:(NSString *)scene {
//    NSScanner *scanner = [NSScanner scannerWithString:scene];
//    int result;
//    BOOL hasInt = [scanner scanInt:&result];
//
//    if (!hasInt) {
//        result = 0;
//    }
//    PlaceholderName placeholder = (PlaceholderName)result;
//
//    [[ConsoliAds sharedInstance] onIconAdShowSuccess:CONSOLIADSICON placHolderName:placeholder];
//}

//- (void)didClickBannerAd:(NSString *)scene {
//    [[ConsoliAds sharedInstance] onAdClick:CONSOLIADSBANNER format:BANNER];
//}
//
//- (void)didDisplayBannerAd:(NSString *)scene {
//    [[ConsoliAds sharedInstance] onAdLoadSuccess:CONSOLIADSBANNER format:BANNER];
//}

- (void)didClickNative:(NSString *)sceneId {
    [[ConsoliAds sharedInstance] onAdClick:CONSOLIADSNATIVE format:NATIVE];
}

- (void)didCloseNative:(NSString *)sceneId {

}

- (void)didDisplayNative:(NSString *)sceneId {
    [[ConsoliAds sharedInstance] onAdShowSuccess:CONSOLIADSNATIVE format:NATIVE];
}

- (void)didFailToLoadRewardedVideo:(NSString *)sceneID error:(NSString *)error {
    
    PlaceholderName placeholderName = (PlaceholderName)[sceneID integerValue];
    [[[ConsoliAds sharedInstance] getMediationManager] changeAdNetworkLoadState:CONSOLIADSREWARDEDVIDEO state:Failed];
    if (Default == placeholderName) {
        [[ConsoliAds sharedInstance] onAdLoadFailed:CONSOLIADSREWARDEDVIDEO format:REWARDED];
        [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:error];
    }
}


- (void)didFailedToLoadInterstitialAd:(NSString *)scene error:(NSString *)error {
    
    [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:error];
//    [[ConsoliAds sharedInstance] onAdLoadFailed:CONSOLIADS format:INTERSTITIAL];
}

- (void)didFailedToLoadNativeAd:(NSString *)scene error:(NSString *)error {
    [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:error];
}


- (void)onInAppPurchaseSuccessed:(CAInAppDetails *)product {
    if ([[[ConsoliAds sharedInstance] _inAppDelegate] respondsToSelector:@selector(onInAppPurchaseSuccess:)]) {
        [[[ConsoliAds sharedInstance] _inAppDelegate] onInAppPurchaseSuccess:product];
    }
}
- (void)onInAppPurchaseFailed:(CAInAppError *)error {
    if ([[[ConsoliAds sharedInstance] _inAppDelegate] respondsToSelector:@selector(onInAppPurchaseFailed:)]) {
        [[[ConsoliAds sharedInstance] _inAppDelegate] onInAppPurchaseFailed:error];
    }
}
- (void)onInAppPurchasesRestore:(CAInAppDetails *)product {
    if ([[[ConsoliAds sharedInstance] _inAppDelegate] respondsToSelector:@selector(onInAppPurchaseRestored:)]) {
        [[[ConsoliAds sharedInstance] _inAppDelegate] onInAppPurchaseRestored:product];
    }
}

- (void)staticInterstitialAdClicked:(NSString *)sceneId {
    [[ConsoliAds sharedInstance] onAdClick:CONSOLIADSSTATICINTERSTITIAL format:STATICINTERSTITIAL];
}

- (void)staticInterstitialAdClosed:(NSString *)sceneId {
    [[ConsoliAds sharedInstance] onAdClosed:CONSOLIADSSTATICINTERSTITIAL format:STATICINTERSTITIAL];
}

- (void)staticInterstitialAdFailed:(NSString *)scene error:(NSString *)error {
    [[ConsoliAds sharedInstance] onAdShowFailed:CONSOLIADSSTATICINTERSTITIAL format:STATICINTERSTITIAL];
}

- (void)staticInterstitialAdShown:(NSString *)sceneId {
    [[ConsoliAds sharedInstance] onAdShowSuccess:CONSOLIADSSTATICINTERSTITIAL format:STATICINTERSTITIAL];
}

+ (NSString*)getSdkVersion {
    return SDK_VERSION;
}

+ (NSDictionary*)getInAppVersion {
    return [ConsoliAdIOSPlugin getInAppVersion];
}

@end
