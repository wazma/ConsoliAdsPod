//
//  CAInterstitialImage.m
//  ObjectiveC-AdNetworks
//
//

#import "CAStaticInterstitial.h"
#import "ConsoliAdIOSPlugin.h"
#import "CAManager.h"
#import "AdNetwork.h"
#import "NSObject+ClassName.h"
#import "CALogManager.h"
#import "ConsoliAds.h"
#import "CAConstants.h"

@interface CAStaticInterstitial() <CAAdNetworkInitializeListener> {
    BOOL isRequestPending;
    PlaceholderName placeholderName;
}

@end

@implementation CAStaticInterstitial

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
    return [[ConsoliAdIOSPlugin sharedPlugIn] isStaticInterstitialAvailable:scene];
}

- (void)requestAdWithPlaceHolderName:(PlaceholderName)placeholder {
    
    if(!_isInitialized) {
        [[ConsoliAds sharedInstance] onAdLoadFailed:CONSOLIADSSTATICINTERSTITIAL format:STATICINTERSTITIAL];
        return;
    }
    else if (![[CAManager sharedManager] isInitialized]) {
        placeholderName = placeholder;
        isRequestPending = YES;
        return;
    }

    [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:@"ConsoliAds Static Interstitial request has Called"];

    [[ConsoliAds sharedInstance] saveAdNetworkRequest:self];

    
    if ([self isAdAvailableWithPlaceHolderName:placeholder]) {
        [[ConsoliAds sharedInstance] onAdLoadSuccess:CONSOLIADSSTATICINTERSTITIAL format:STATICINTERSTITIAL];
    }
    else {
        [[ConsoliAds sharedInstance] onAdLoadFailed:CONSOLIADSSTATICINTERSTITIAL format:STATICINTERSTITIAL];
    }
}

- (BOOL)showAdWithViewController:(UIViewController*)viewController {
    [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:@"ConsoliAds showAd has called"];
    
    NSString* scene = [NSString stringWithFormat:@"%lu", (unsigned long)self.shownForPlaceholder];
    return [[ConsoliAdIOSPlugin sharedPlugIn] showStaticInterstitial:scene withRootViewController:viewController];
}

#pragma mark CAAdNetworkInitializeListener

- (void)onAdNetworkInitialized:(BOOL)status {
    if (isRequestPending) {
        isRequestPending = NO;
        if (status) {
            [self requestAdWithPlaceHolderName:placeholderName];
        }
        else {
            [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:[NSString stringWithFormat:@"Ad load failed: %ld",(long)CONSOLIADSSTATICINTERSTITIAL]];
            self.isAdLoaded = Failed;
            [[ConsoliAds sharedInstance] onAdLoadFailed:CONSOLIADSSTATICINTERSTITIAL format:STATICINTERSTITIAL];
        }
    }
}

@end
