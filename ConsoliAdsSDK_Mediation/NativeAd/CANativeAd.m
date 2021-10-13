//
//  CANativeAd.m
//  ConsoliAdsMediation
//
//  Created by rehmanaslam on 13/12/2018.
//  Copyright © 2018 ConsoliAds. All rights reserved.
//

#import "NSObject+ClassName.h"
#import "CAManager.h"
#import "CANativeAd.h"
#import "CAAdChoicesView.h"
#import "CANativeAdMediaView.h"
#import "ConsoliAdIOSPlugin.h"
#import "NativeAdBase.h"
#import "ConsoliAdsNativeAdAdapter.h"
#import "ConsoliSDKAdsDelegate.h"

@interface ConsoliAdsNativeAd : NSObject

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) id<CANativeAdRequestDelegate> delegate;
@property (nonatomic, weak) CANativeAd* adNetwork;
@property (nonatomic, copy) NSString *sceneIndex;
@property (nonatomic, strong) NativeAdBase *nativeAd;
@property (nonatomic, strong) ConsoliAdsNativeAdAdapter *nativeAdAdapter;

@end

@implementation ConsoliAdsNativeAd

- (instancetype)initNativeAd:(UIViewController *_Nonnull)viewController sceneIndex:(NSString*)sceneIndex delegate:(id<CANativeAdRequestDelegate>_Nonnull)delegate {
    
    if(self = [super init]) {
        _viewController = viewController;
        _delegate = delegate;
        _sceneIndex = sceneIndex;
    }
    return self;
}

- (void)loadNativeAd {
    
    NativeAdBase *caNatveAd = [[ConsoliAdIOSPlugin sharedPlugIn] showNative:self.sceneIndex];
    
    if (caNatveAd != nil) {
        [self onAdLoaded:caNatveAd];
    }
    else {
        [self onAdLoadedFailed];
    }
}

- (CAMediatedNativeAd*)createMediatedNativeInternalAd {
    
    return [[CAMediatedInternalNativeAd alloc] initWithAdNetwork:self.adNetwork nativeAd:self bodyText:self.nativeAd.nativeAdTitle advertiser:@"" socialContext:self.nativeAd.nativeAdDescription sponsoredText:self.nativeAd.nativeAdSubtitle callToAction:self.nativeAd.callToActionButtonTitle];
}

- (void)registerViewForInteractionWithNativeAdView:(UIView <CANativeAdRenderingDelegate>*)nativeAdView {
    
    _nativeAdAdapter.nativeAdView = nativeAdView;
    [_nativeAdAdapter renderUnifiedAdViewWithAdapter];
    [_nativeAdAdapter registerViewsForInteractionWithController:_viewController];
}

- (void)onAdLoadedFailed {
    
    [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:@"NativeAd load failed: %@"];
    [[ConsoliAds sharedInstance] onNativeLoadFailed:CONSOLIADSNATIVE viewController:_viewController delegate:_delegate];
}

- (void)onAdLoaded:(NativeAdBase*)nativeAd {
    
    self.nativeAd = nativeAd;

    _nativeAdAdapter = [[ConsoliAdsNativeAdAdapter alloc] initWithConsoliAdsNativeAd:self.nativeAd];
    _nativeAdAdapter.delegate = _delegate;
    [[ConsoliAds sharedInstance] onAdLoadSuccess:CONSOLIADSNATIVE format:NATIVE];
    
    if ([_delegate respondsToSelector:@selector(onNativeAdLoaded:)]) {
        [_delegate onNativeAdLoaded:[self createMediatedNativeInternalAd]];
    }
}

- (void)resetNativeAdView {
    [_nativeAdAdapter resetView];
}

@end

@interface CANativeAd () <CAAdNetworkInitializeListener> {
    BOOL isRequestPending;
}

@property (nonatomic) PlaceholderName placeholderName;
@property (nonatomic , weak) id<CANativeAdRequestDelegate> delegate;
@property (nonatomic , weak) UIViewController * viewController;

@end

@implementation CANativeAd

- (BOOL)initializeWith:(BOOL)userConsent {
    
    if (![self isValidAdID:[self.adIDs objectForKey:K_ADAPP_KEY]]) {
        NSString *errorMessage = [NSString stringWithFormat:@"Failed to call initialize, %@", [self.adIDs objectForKey:K_ADAPP_ID]];
        [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:errorMessage];
        self.isInitialized = NO;
    }
    else {
        [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:@"Initialize Called"];
        
        if (![[CAManager sharedManager] isInitialized]) {
            [[CAManager sharedManager] initializeWithAppKey:[self.adIDs objectForKey:K_ADAPP_KEY] consent:userConsent delegate:self];
        }
        self.isInitialized = YES;
        self.nativeAdsArray = [NSMutableArray new];
    }

    return _isInitialized;
}

- (BOOL)isInitialized {
    return _isInitialized && [[CAManager sharedManager] isInitialized];
}

- (void)loadNativeAdInViewController:(UIViewController *_Nonnull)viewController
                         placeHolder:(PlaceholderName)placeHolder
                            delegate:(id<CANativeAdRequestDelegate>_Nonnull)delegate {
    
    if(!_isInitialized) {
        [[ConsoliAds sharedInstance] onNativeLoadFailed:CONSOLIADSNATIVE viewController:viewController delegate:delegate];
        return;
    }
    else if (![[CAManager sharedManager] isInitialized]) {
        isRequestPending = YES;
        _placeholderName = placeHolder;
        _delegate = delegate;
        _viewController = viewController;
        return;
    }
        
    NSString* scene = [NSString stringWithFormat:@"%lu", (unsigned long)placeHolder];
    ConsoliAdsNativeAd *caNativeAd = [[ConsoliAdsNativeAd alloc] initNativeAd:viewController sceneIndex:scene delegate:delegate];
    caNativeAd.adNetwork = self;

    [[ConsoliAds sharedInstance] saveAdNetworkRequest:self];

    [caNativeAd loadNativeAd];
    [self.nativeAdsArray addObject:caNativeAd];
}

- (void)registerViewForInteraction:(id)nativeAd nativeAdView:(UIView <CANativeAdRenderingDelegate>*)nativeAdView {
    
    ConsoliAdsNativeAd *consoliAdsNativeAd = (ConsoliAdsNativeAd*)nativeAd;
    
    if (consoliAdsNativeAd != nil && [consoliAdsNativeAd isKindOfClass:[ConsoliAdsNativeAd class]]) {
        [consoliAdsNativeAd registerViewForInteractionWithNativeAdView:nativeAdView];
    }
    else {
        [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:@"add object not found"];
    }
}

- (void)resetNativeAdView:(UIView <CANativeAdRenderingDelegate>*)nativeAdView {
    
    for (UIView *subView in nativeAdView.subviews) {
        for (UIView *nestedView in subView.subviews) {
            if ([nestedView isKindOfClass:[CAAdChoicesView class]] ||
                [nestedView isKindOfClass:[CANativeAdMediaView class]]) {
                    [nestedView removeFromSuperview];
            }
            if ([nestedView isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel*)nestedView;
                if (label != nil) {
                    label.text = @"";
                }
            }
        }
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel*)subView;
            if (label != nil) {
                label.text = @"";
            }
        }
        if ([subView isKindOfClass:[CAAdChoicesView class]] ||
            [subView isKindOfClass:[CANativeAdMediaView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    ConsoliAdsNativeAd *consoliAdsNativeAd = [self.nativeAdsArray firstObject];
    
    if (consoliAdsNativeAd != nil && [consoliAdsNativeAd isKindOfClass:[ConsoliAdsNativeAd class]]) {
        [consoliAdsNativeAd resetNativeAdView];
    }
}

- (void)destroyNativeAd:(id)nativeAd {
    
}

#pragma mark CAAdNetworkInitializeListener

- (void)onAdNetworkInitialized:(BOOL)status {
    if (isRequestPending) {
        isRequestPending = NO;
        if (status) {
            [self loadNativeAdInViewController:_viewController placeHolder:_placeholderName delegate:_delegate];
        }
        else {
            [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:[NSString stringWithFormat:@"Ad load failed: %ld",(long)CONSOLIADSNATIVE]];
            self.isAdLoaded = Failed;
            [[ConsoliAds sharedInstance] onNativeLoadFailed:CONSOLIADSNATIVE viewController:_viewController delegate:_delegate];
        }
    }
}

@end
