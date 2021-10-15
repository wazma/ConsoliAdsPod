//
//  ConsoliSDKAdsDelegate.h
//  ConsoliAds
//
//  Created by FazalElahi on 09/02/2017.
//  Copyright © 2017 FazalElahi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConsoliSDKAdsDelegate <NSObject>

- (void)sdkDidInitialized:(BOOL)status;

- (void)didCloseInterstitial:(NSString*) sceneId;
- (void)didClickInterstitial:(NSString*) sceneId;
- (void)didDisplayInterstitial:(NSString*) sceneId;
- (void)didFailedToLoadInterstitialAd:(NSString*)scene error:(NSString *)error;


- (void)didDisplayNative:(NSString*)sceneId;
- (void)didClickNative:(NSString*)sceneId;
- (void)didCloseNative:(NSString*)sceneId;
- (void)didFailedToLoadNativeAd:(NSString*)scene error:(NSString *)error;

- (void)onAdError:(NSString*)error;

- (void)rewardedVideoAdLoaded:(NSString*)sceneId;
//- (void)rewardedVideoAdFailed:(NSString*)sceneId;
- (void)rewardedVideoAdCompleted:(NSString*)sceneId withReward:(int)reward;
- (void)rewardedVideoAdClosed:(NSString*)sceneId;
- (void)rewardedVideoAdClicked:(NSString*)sceneId;
- (void)rewardedVideoAdDidDisplay:(NSString*)sceneId;
- (void)didFailToLoadRewardedVideo:(NSString*)sceneID error:(NSString *)error;
- (void)didFailToShowRewardedVideo:(NSString*)sceneID error:(NSString *)error;



//- (void)didCloseIcon:(NSString*) scene;
//- (void)didClickIcon:(NSString*) scene;
//- (void)didDisplayIcon:(NSString*) scene;

//- (void)didDisplayBannerAd:(NSString *)scene;
//- (void)didClickBannerAd:(NSString *)scene;

@optional

- (void)didSucceedToLoadRewardedVideo:(NSString*)sceneID;

@end
