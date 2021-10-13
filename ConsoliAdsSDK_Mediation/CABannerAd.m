//
//  CABannerAd.m
//  ConsoliAdsMediation
//
//  Created by rehmanaslam on 26/11/2018.
//  Copyright © 2018 ConsoliAds. All rights reserved.
//

#import "NSObject+ClassName.h"
#import "CALogManager.h"
#import "ConsoliAds.h"
#import "CABannerAd.h"
#import "CAConstants.h"
#import "NSObject+ClassName.h"
#import "AdNetwork.h"
#import "CAManager.h"
#import "ConsoliAdIOSPlugin.h"
#import "BannerAdDelegate.h"

@interface CABannerAd () <BannerAdDelegate , CAAdNetworkInitializeListener> {
    BOOL isRequestPending;
}

@property (nonatomic , weak) UIViewController *viewController;
@property (nonatomic , weak) CAMediatedBannerView *mediatedBannerView;
@property (nonatomic , strong) UIView *customBannerView;
@property (nonatomic) BOOL isBannerRefresh;

@end

@implementation CABannerAd

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
    }
    return _isInitialized;
}

- (BOOL)isInitialized {
    return _isInitialized && [[CAManager sharedManager] isInitialized];
}

- (BOOL)loadBannerWithViewController:(UIViewController*)viewController {
    
    if (![self isBannerAdSizeSupported:self.bannerSize]) {
        [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:[NSString stringWithFormat:@"%@: adsize is not supported",[self formatBannerSizeToString:self.bannerSize]]];
        return NO;
    }
    
    if(!_isInitialized) {
        return NO;
    }

    [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:@""];
    
    return YES;
}

- (BOOL)showBannerWithAdView:(CAMediatedBannerView*)mediatedBanner viewController:(UIViewController*)viewController {
    
    self.viewController = viewController;
    self.mediatedBannerView = mediatedBanner;
    
    if(![[CAManager sharedManager] isInitialized]) {
        isRequestPending = YES;
        return YES;
    }

    CGRect bannerFrame = [self getBannerFrameWithSize:self.bannerSize position:Center viewSize:viewController.view.bounds.size];
    
    self.customBannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bannerFrame.size.width, bannerFrame.size.height)];
    self.customBannerView.backgroundColor = UIColor.clearColor;

    NSString* scene = [NSString stringWithFormat:@"%lu", (unsigned long)self.shownForPlaceholder];
    self.isAdLoaded = Completed;

    [[ConsoliAds sharedInstance] saveAdNetworkRequest:self];
    
    switch (self.bannerSize) {
            
        case Banner:
           return [[ConsoliAdIOSPlugin sharedPlugIn] showBanner:scene withUIView:self.customBannerView withAdSize:KCAAdSizeBanner withAdPosition:KCAAdPositionCustom andDelegate:self];
            break;
        case LargeBanner:
            return [[ConsoliAdIOSPlugin sharedPlugIn] showBanner:scene withUIView:self.customBannerView withAdSize:KCAAdSizeLargeBanner withAdPosition:KCAAdPositionCustom andDelegate:self];
            break;
        case IABBanner:
            return [[ConsoliAdIOSPlugin sharedPlugIn] showBanner:scene withUIView:self.customBannerView withAdSize:KCAAdSizeFullBanner withAdPosition:KCAAdPositionCustom andDelegate:self];
            break;
        case Leaderboard:
            return [[ConsoliAdIOSPlugin sharedPlugIn] showBanner:scene withUIView:self.customBannerView withAdSize:KCAAdSizeLeaderboardBanner withAdPosition:KCAAdPositionCustom andDelegate:self];
            break;
        case SmartBanner:
            [self updateSmartBannerFrame];
            return [[ConsoliAdIOSPlugin sharedPlugIn] showBanner:scene withUIView:self.customBannerView withAdSize:KCAAdSizeSmartBanner withAdPosition:KCAAdPositionCustom andDelegate:self];
            break;
        default:
            return [[ConsoliAdIOSPlugin sharedPlugIn] showBanner:scene withUIView:self.customBannerView withAdSize:KCAAdSizeBanner withAdPosition:KCAAdPositionCustom andDelegate:self];
            break;
    }
    
    return true;
}

-(void)updateSmartBannerFrame {
    if (@available(iOS 11.0, *)) {
        CGRect safeAreaFrame = self.viewController.view.safeAreaLayoutGuide.layoutFrame;
        CGRect frame = self.customBannerView.frame;
        frame.size.width = safeAreaFrame.size.width - safeAreaFrame.origin.x;
        frame.size.height = 50;
        self.customBannerView.frame = frame;
    }
}

- (void)destroyBannerView:(CAMediatedBannerView*_Nonnull)bannerView {
    [[ConsoliAdIOSPlugin sharedPlugIn] hideBannerFromView:self.customBannerView];
    [self.customBannerView removeFromSuperview];
    self.customBannerView = nil;
}

-(BOOL)isAdSizeSupported:(BannerSize)bannerSize mediatedAd:(CAMediatedBannerView*)mediatedBannerView {
    
    if (!CGSizeEqualToSize(mediatedBannerView.customSize,CGSizeZero)) { //custome size
        return false;
    }
    else {
        return [self isBannerAdSizeSupported:bannerSize];
    }
}

#pragma mark
#pragma mark BannerAdDelegate

- (void)bannerAdShown:(NSString *)scene {

    self.isAdLoaded = Completed;
    [[ConsoliAds sharedInstance] onAdLoadSuccess:CONSOLIADSBANNER format:BANNER];
    [self showBannerView:self.customBannerView mbView:self.mediatedBannerView vc:self.viewController];
    [[self mediatedBannerView] setBannerState:SHOWN];
}

- (void)bannerAdClicked:(NSString *)scene {
    [[ConsoliAds sharedInstance] onBannerAdClick:CONSOLIADSBANNER mediatedAd:self.mediatedBannerView];
}

- (void)bannerAdClosed:(NSString *)scene {
}

- (void)bannerAdRefreshed:(NSString *)scene {

    self.isAdLoaded = Completed;
    [[ConsoliAds sharedInstance] onAdLoadSuccess:CONSOLIADSBANNER format:BANNER];
    [[ConsoliAds sharedInstance] onBannerAdLoadSuccess:CONSOLIADSBANNER mediatedAd:self.mediatedBannerView refreshed:_isBannerRefresh];
    _isBannerRefresh = YES;
}

- (void)bannerAdShownFailed:(NSString *)scene error:(NSString *)error {
    self.isAdLoaded = Failed;
  
    [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:error];
    [[ConsoliAds sharedInstance] onBannerAdLoadFailed:CONSOLIADSBANNER mediatedAd:self.mediatedBannerView viewController:self.viewController];
}

- (BOOL)isBannerAdSizeSupported:(BannerSize)adSize {
    
    switch (adSize) {
        case Banner:
            return YES;
        case Leaderboard:
            return YES;
        case IABBanner:
            return YES;
        case LargeBanner:
            return YES;
        case SmartBanner:
            return YES;
        default:
            return NO;
    }
}

#pragma mark
#pragma mark UtilityMethod -ShowBanner-

- (void)showBannerView:(UIView*)bannerView mbView:(CAMediatedBannerView*)mediatedBannerView vc:(UIViewController*)viewController {

    if (bannerView != nil && viewController != nil && mediatedBannerView != nil && !self.isBannerRefresh) {
        
        [self runOnUIThread:^{
            [self.mediatedBannerView destroyBanner];
            [self updateHastable:self.mediatedBannerView];
            [self addBannerView:bannerView];
            [[ConsoliAds sharedInstance] onBannerAdLoadSuccess:CONSOLIADSBANNER mediatedAd:self.mediatedBannerView refreshed:self.isBannerRefresh];
            self.isBannerRefresh = YES;
        }];
    }
    else {
        [[ConsoliAds sharedInstance] onBannerAdLoadSuccess:CONSOLIADSBANNER mediatedAd:self.mediatedBannerView refreshed:_isBannerRefresh];
    }
}

#pragma mark
#pragma mark PositionBannerView

- (void)addBannerView:(UIView*)view {
    
    [self.mediatedBannerView addSubview:view];
    [self.mediatedBannerView bringSubviewToFront:view];

    if (self.mediatedBannerView.shouldResizeSelf) {
        
        if (CGSizeEqualToSize(self.mediatedBannerView.customSize,CGSizeZero)) {
            
            CGRect frame = self.mediatedBannerView.frame;
            
            if (CGSizeEqualToSize(view.frame.size,CGSizeZero)) {
                CGSize size = [self.mediatedBannerView getBannerRectSize];
                frame.size = size;
            }
            else {
                frame.size.width = view.bounds.size.width;
                frame.size.height = view.bounds.size.height;
            }
            self.mediatedBannerView.frame = frame;
        }
        else {
            CGRect frame = self.mediatedBannerView.frame;
            frame.size.width = self.mediatedBannerView.customSize.width;
            frame.size.height = self.mediatedBannerView.customSize.height;
            self.mediatedBannerView.frame = frame;
        }
    }
    else {
        [self setBannerViewPosition:view];
    }
}

- (void)setBannerViewPosition:(UIView*)view {
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    if (@available(ios 11.0, *)) {
        [self setWidthHeight:view];
        [self positionBannerViewToSafeArea:view];
    }
    else {
        [self setWidthHeight:view];
        [self positionBannerView:view];
    }
}

- (void)positionBannerViewToSafeArea:(UIView*)view NS_AVAILABLE_IOS(11.0) {
    
    UILayoutGuide *guide = self.mediatedBannerView.safeAreaLayoutGuide;
    
    [NSLayoutConstraint activateConstraints:@[
        [view.centerXAnchor constraintEqualToAnchor:guide.centerXAnchor],
        [view.centerYAnchor constraintEqualToAnchor:guide.centerYAnchor]
    ]];
}

- (void)positionBannerView:(UIView *)view {
    
    [self.mediatedBannerView addConstraints:@[
        [NSLayoutConstraint constraintWithItem:view
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.mediatedBannerView
                                     attribute:NSLayoutAttributeCenterX
                                    multiplier:1
                                      constant:0],
        [NSLayoutConstraint constraintWithItem:view
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.mediatedBannerView
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1
                                      constant:0]
    ]];
    
}

- (void)setWidthHeight:(UIView*)view {
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute: NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:view.frame.size.width]];
    
    // Height constraint
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute: NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:view.frame.size.height]];
}

- (void)dealloc {
    [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message: @"Deallocated"];
}

#pragma mark CAAdNetworkInitializeListener

- (void)onAdNetworkInitialized:(BOOL)status {
    if (isRequestPending) {
        isRequestPending = NO;
        if (status) {
            if (![self showBannerWithAdView:self.mediatedBannerView viewController:self.viewController]) {
                [[ConsoliAds sharedInstance] onBannerAdLoadFailed:CONSOLIADSBANNER mediatedAd:self.mediatedBannerView viewController:self.viewController];
            }
        }
        else {
            [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:[NSString stringWithFormat:@"Ad load failed: %ld",(long)CONSOLIADSBANNER]];
            self.isAdLoaded = Failed;
            [[ConsoliAds sharedInstance] onBannerAdLoadFailed:CONSOLIADSBANNER mediatedAd:self.mediatedBannerView viewController:self.viewController];
        }
    }
}

@end
