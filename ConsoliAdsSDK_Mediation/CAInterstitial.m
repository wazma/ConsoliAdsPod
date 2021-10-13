//
//  CAInterstitial.m
//  ObjectiveC-AdNetworks
//
//  Created by rehmanaslam on 12/10/2018.
//  Copyright © 2018 rehmanaslam. All rights reserved.
//

#import "CAInterstitial.h"
#import "ConsoliAdIOSPlugin.h"
#import "CAManager.h"
#import "AdNetwork.h"
#import "NSObject+ClassName.h"
#import "CALogManager.h"
#import "ConsoliAds.h"
#import "CAConstants.h"

@interface CAInterstitial() <CAAdNetworkInitializeListener> {
    BOOL isRequestPending;
    PlaceholderName placeholderName;
}

@end

@implementation CAInterstitial

- (BOOL)initializeWith:(BOOL)userConsent {

    if (![self isValidAdID:[self.adIDs objectForKey:K_ADAPP_KEY]]) {
        NSString *errorMessage = [NSString stringWithFormat:@"Failed to call initialize, %@", [self.adIDs objectForKey:K_ADAPP_ID]];
        [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:errorMessage];
        self.isInitialized = NO;
    }
    else {
        [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:@"Initialize Called"];
        
        placeholderName = Default;
        if (![[CAManager sharedManager] isInitialized]) {
            [[CAManager sharedManager] initializeWithAppKey:[self.adIDs objectForKey:K_ADAPP_KEY] consent:userConsent delegate:self];
        }
        self.isInitialized = YES;
        self.isAdLoaded = Completed;
    }
    return _isInitialized;
}

- (BOOL)isInitialized {
    return _isInitialized && [[CAManager sharedManager] isInitialized];
}

- (BOOL)isAdAvailableWithPlaceHolderName:(PlaceholderName)placeholder {
    NSString* scene = [NSString stringWithFormat:@"%lu", (unsigned long)placeholder];
    return [[ConsoliAdIOSPlugin sharedPlugIn] isInterstitialLoaded:scene];
}

- (void)requestAdWithPlaceHolderName:(PlaceholderName)placeholder {
     
    if(!_isInitialized) {
        [[ConsoliAds sharedInstance] onAdLoadFailed:CONSOLIADS format:INTERSTITIAL];
        return;
    }
    else if (![[CAManager sharedManager] isInitialized]) {
        placeholderName = placeholder;
        isRequestPending = YES;
        return;
    }
    
    [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:@"ConsoliAdsInterstitial request has Called"];

    [[ConsoliAds sharedInstance] saveAdNetworkRequest:self];

    if ([self isAdAvailableWithPlaceHolderName:placeholder]) {
        [[ConsoliAds sharedInstance] onAdLoadSuccess:CONSOLIADS format:INTERSTITIAL];
    }
    else {
        [[ConsoliAds sharedInstance] onAdLoadFailed:CONSOLIADS format:INTERSTITIAL];
    }
}

- (BOOL)showAdWithViewController:(UIViewController*)viewController {
    [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:@"ConsoliAds showAd has called"];
    
    NSString* scene = [NSString stringWithFormat:@"%lu", (unsigned long)self.shownForPlaceholder];
    return [[ConsoliAdIOSPlugin sharedPlugIn] showInterstitial:scene withRootViewController:viewController];
}

- (NSString*)getSdkVersion {
    return [CAManager getSdkVersion];
}

#pragma mark CAAdNetworkInitializeListener

- (void)onAdNetworkInitialized:(BOOL)status {
    if (isRequestPending) {
        isRequestPending = NO;
        if (status) {
            [self requestAdWithPlaceHolderName:placeholderName];
        }
        else {
            [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:[NSString stringWithFormat:@"Ad load failed: %ld",(long)CONSOLIADS]];
            self.isAdLoaded = Failed;
            [[ConsoliAds sharedInstance] onAdLoadSuccess:CONSOLIADS format:INTERSTITIAL];
        }
    }
}



@end
