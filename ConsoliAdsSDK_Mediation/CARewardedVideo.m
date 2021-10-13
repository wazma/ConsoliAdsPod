//
//  CARewardedVideo.m
//  ObjectiveC-AdNetworks
//
//  Created by rehmanaslam on 15/10/2018.
//  Copyright © 2018 rehmanaslam. All rights reserved.
//

#import "CARewardedVideo.h"
#import "ConsoliAdIOSPlugin.h"
#import "CAManager.h"
#import "ConsoliAds.h"
#import "CALogManager.h"
#import "NSObject+ClassName.h"

@interface CARewardedVideo() <CAAdNetworkInitializeListener> {
    BOOL isRequestPending;
    PlaceholderName placeholderName;
}

@end

@implementation CARewardedVideo

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

- (void)requestAdWithPlaceHolderName:(PlaceholderName)placeholder {
    
    if(!_isInitialized) {
        [[ConsoliAds sharedInstance] onAdLoadFailed:CONSOLIADSREWARDEDVIDEO format:REWARDED];
        return;
    }
    else if (![[CAManager sharedManager] isInitialized]) {
        placeholderName = placeholder;
        isRequestPending = YES;
        return;
    }
    
    [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:@"ConsoliAdsRewarded has requested"];
    
    [[ConsoliAds sharedInstance] saveAdNetworkRequest:self];

    
    if ([self isAdAvailableWithPlaceHolderName:placeholder]) {
        [[ConsoliAds sharedInstance] onAdLoadSuccess:CONSOLIADSREWARDEDVIDEO format:REWARDED];
    }
    else {
        [[ConsoliAds sharedInstance] onAdLoadFailed:CONSOLIADSREWARDEDVIDEO format:REWARDED];
    }
}

- (BOOL)isAdAvailableWithPlaceHolderName:(PlaceholderName)placeholder {
    
    NSString* scene = [NSString stringWithFormat:@"%lu", (unsigned long)placeholder];
    return [[ConsoliAdIOSPlugin sharedPlugIn] isRewardedVideoAvailable:scene];
}

- (BOOL)showAdWithViewController:(UIViewController*)viewController {
    
    [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:@"ConsoliAdsRewarded showAd has called"];
    NSString* scene = [NSString stringWithFormat:@"%lu", (unsigned long)self.shownForPlaceholder];
    return [[ConsoliAdIOSPlugin sharedPlugIn] showRewardedVideoAdForScene:scene withRootViewController: viewController];
}

#pragma mark CAAdNetworkInitializeListener

- (void)onAdNetworkInitialized:(BOOL)status {
    if (isRequestPending) {
        isRequestPending = NO;
        if (status) {
            [self requestAdWithPlaceHolderName:placeholderName];
        }
        else {
            [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:[NSString stringWithFormat:@"Ad load failed: %ld",(long)CONSOLIADSREWARDEDVIDEO]];
            self.isAdLoaded = Failed;
            [[ConsoliAds sharedInstance] onAdLoadFailed:CONSOLIADSREWARDEDVIDEO format:REWARDED];
        }
    }
}

@end
