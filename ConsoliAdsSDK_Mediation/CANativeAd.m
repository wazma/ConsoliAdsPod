//
//  CANativeAd.m
//  ConsoliAdsMediation
//
//  Created by rehmanaslam on 13/12/2018.
//  Copyright © 2018 ConsoliAds. All rights reserved.
//

#import "NSObject+ClassName.h"
#import "CALogManager.h"
#import "ConsoliAds.h"
#import "CAConstants.h"
#import "NSObject+ClassName.h"
#import "AdNetwork.h"
#import "CAManager.h"
#import "ConsoliAdIOSPlugin.h"
#import "NativeAdView.h"
#import "NativeAdBase.h"
#import "CANativeAd.h"

@interface CANativeAd()

@property (nonatomic, strong) NativeAdView *nativeAdView;
@property (nonatomic, strong) NativeAdBase *nativeAd;
@property (nonatomic) BOOL isConfiguredCalled;
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) UIView* nativeAdUserPlaceHolder;

@end

@implementation CANativeAd

- (BOOL)initializeWith:(NSString*)uniqueDeviceID userConsent:(BOOL)userConsent  {
    
    [[CALogManager sharedManager] logWithLogType:INFO className:self.className  methodName:NSStringFromSelector(_cmd) message:@"ConsoliAdsNativeAd has initialized"];
    [[CAManager sharedManager] initializeWithAppKey:[self.adIDs objectForKey:K_ADAPP_KEY]];
    self.isInitialized = YES;
    return YES;
}

- (void)configureConsoliAdsNativeAd:(NSInteger)sceneIndex nativeAdPlaceholder:(UIView *)nativeAdPlaceholder {
    self.isConfiguredCalled = YES;
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"NativeAdView" owner:nil options:nil];
    NativeAdView *adView = [nibObjects firstObject];
    self.nativeAdView = adView;
    adView.frame = nativeAdPlaceholder.bounds;
    self.nativeAdUserPlaceHolder = nativeAdPlaceholder;
}

-(BOOL)showAdWithViewController:(UIViewController*)viewController {
    
    [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:@"ConsoliAdsNativeAd show has Called"];
    NSString* scene = [NSString stringWithFormat:@"%lu", (unsigned long)self.shownForPlaceholder ];
    
    if (self.nativeAdUserPlaceHolder.hidden == YES) {
        self.nativeAdUserPlaceHolder.hidden = NO;
    }
    _viewController = viewController;
    self.nativeAd = [[ConsoliAdIOSPlugin sharedPlugIn] showNative:scene];
    if (self.nativeAd != nil) {
        self.isAdLoaded = Completed;
        [[ConsoliAds sharedInstance] onAdLoadSuccess:CONSOLIADSNATIVE format:NATIVE forIndex:(int)self.adManagerListIndex];
        if (self.isConfiguredCalled ) {
            [self.nativeAdUserPlaceHolder addSubview: self.nativeAdView];
            [self setUIElements];
        }
        return YES;
    }
    else {
        self.isAdLoaded = Failed;
        [[ConsoliAds sharedInstance] onAdLoadFailed:CONSOLIADSNATIVE format:NATIVE forIndex:(int)self.adManagerListIndex];
    }
    return NO;
}

- (BOOL)isAdAvailableWithPlaceHolderName:(PlaceholderName)placeholder {
    return self.isAdLoaded == Completed ?YES:NO;
}

- (void)setUIElements {
    
    self.nativeAdView.nativeAd = self.nativeAd;
    self.nativeAdView.nativeAdTitle.text =  self.nativeAd.nativeAdTitle;
    self.nativeAdView.nativeAdSubtitle.text =  self.nativeAd.nativeAdSubtitle;
    self.nativeAdView.nativeAdDescription.text =  self.nativeAd.nativeAdDescription;
    
    if (self.nativeAd.callToActionButtonTitle != nil) {
        [self.nativeAdView.callToAction setTitle:self.nativeAd.callToActionButtonTitle forState:UIControlStateNormal];
    }
    
}

- (void)onDestroyForNativeAd {
    
    if (self.nativeAdView != nil) {
        [self.nativeAdView removeFromSuperview];
        self.nativeAdUserPlaceHolder.hidden = YES;
        self.nativeAdView = nil;
    }
}

- (id)getNativeAdObject {
    return self.nativeAd;
}

@end
