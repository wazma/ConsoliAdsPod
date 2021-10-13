//
//  CAIconAd.m
//  ConsoliMediation
//
//  Created by saira on 18/12/2019.
//  Copyright © 2019 ConsoliAds. All rights reserved.
//

#import "CAIconAd.h"
#import "ConsoliAds.h"
#import "CALogManager.h"
#import "NSObject+ClassName.h"
#import "CAManager.h"
#import "ConsoliAdsMediationIconAdDelegate.h"
#import "ConsoliAdIOSPlugin.h"
#import "CAConstants.h"
#import "CAIconAdView.h"

@interface ConsoliAdsIconAd :NSObject<IconAdDelegate>

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) id<ConsoliAdsMediationIconAdDelegate> delegate;
@property (nonatomic) BOOL isClicked;
@property (nonatomic) NSString *shownForPlaceholder;
@property (nonatomic) NSInteger shownForSceneIndex;
@property (nonatomic) IconSize consoliAdIconSize;

@end

@implementation ConsoliAdsIconAd

-(instancetype)initIconAd:(UIViewController *_Nonnull)viewController shownForPlaceholder:(NSString*)placholder shownForSceneIndex:(NSInteger)sceneIndex delegate:(id<ConsoliAdsMediationIconAdDelegate>_Nonnull)delegate {
    
    if(self = [super init]) {
        _viewController = viewController;
        _delegate = delegate;
        _isClicked = false;
        _shownForSceneIndex = sceneIndex;
        _shownForPlaceholder = placholder;
    }
    return self;
}

-(void)loadIconAd:(IconSize)iconAdSize iconAdView:(CAIconAdView*)iconAdView {
    
    self.consoliAdIconSize = iconAdSize;
    switch (self.consoliAdIconSize) {
            
        case SmallIcon:
            [[ConsoliAdIOSPlugin sharedPlugIn] showIconAd:self.shownForPlaceholder iconAdView:iconAdView withAdSize:KCAAdSizeSmallIcon delegate:self];
            break;
        case MediumIcon:
            [[ConsoliAdIOSPlugin sharedPlugIn] showIconAd:self.shownForPlaceholder iconAdView:iconAdView withAdSize:KCAAdSizeMediumIcon delegate:self];
            break;
        case LargeIcon:
            [[ConsoliAdIOSPlugin sharedPlugIn] showIconAd:self.shownForPlaceholder iconAdView:iconAdView withAdSize:KCAAdSizeLargeIcon delegate:self];
            break;
        default:
            [[ConsoliAdIOSPlugin sharedPlugIn] showIconAd:self.shownForPlaceholder iconAdView:iconAdView withAdSize:KCAAdSizeSmallIcon delegate:self];
            break;
    }
}

#pragma mark Icon Delegates

-(void)didCloseIconAd:(NSString*)scene {
    [[ConsoliAds sharedInstance] onAdClosed:CONSOLIADSICON format:ICONAD];
    
    if ([_delegate respondsToSelector:@selector(onIconAdClosedEvent)]) {
        [_delegate onIconAdClosedEvent];
    }
}

-(void)didClickIconAd:(NSString*)scene {

    if (!self.isClicked) {
        CAIconAd *caIcon = (CAIconAd*)[[ConsoliAds sharedInstance] getFromAdnetworkList:CONSOLIADSICON];
        if (caIcon) {
            caIcon.shownForSceneIndex = _shownForSceneIndex;
            caIcon.shownForPlaceholder = (PlaceholderName)[_shownForPlaceholder intValue];
            self.isClicked = true;
        }
    }
    else {
        _shownForSceneIndex = -1;
    }
    [[ConsoliAds sharedInstance] onAdClick:CONSOLIADSICON format:ICONAD];
    if ([_delegate respondsToSelector:@selector(onIconAdClickEvent)]) {
        [_delegate onIconAdClickEvent];
    }
}

-(void)didRefreshIconAd:(NSString*)scene {
    
    if ([_delegate respondsToSelector:@selector(onIconAdRefreshEvent)]) {
        [_delegate onIconAdRefreshEvent];
    }
    CAIconAd *caIcon = (CAIconAd*)[[ConsoliAds sharedInstance] getFromAdnetworkList:CONSOLIADSICON];
    if (caIcon) {
        caIcon.shownForSceneIndex = _shownForSceneIndex;
        caIcon.shownForPlaceholder = (PlaceholderName)[_shownForPlaceholder intValue];
        self.isClicked = false;
    }
    [[ConsoliAds sharedInstance] onIconAdRefresh];
}

- (void)didFailedToLoadIconAd:(NSString *)scene error:(NSString *)error {
    
    [[ConsoliAds sharedInstance] onAdLoadFailed:CONSOLIADSICON format:ICONAD];
    
    /*-------------------------------------*/
    
    if ([_delegate respondsToSelector:@selector(onIconAdFailedToShownEvent)]) {
        [_delegate onIconAdFailedToShownEvent];
    }
}

- (void)didLoadIconAd:(NSString *)scene {
}

-(void)didDisplayIconAd:(NSString*)scene {
    
    [[ConsoliAds sharedInstance] onAdLoadSuccess:CONSOLIADSICON format:ICONAD];
    
    /*-------------------------------------*/
    
    if ([_delegate respondsToSelector:@selector(onIconAdShownEvent)]) {
        [_delegate onIconAdShownEvent];
    }
    CAIconAd *caIcon = (CAIconAd*)[[ConsoliAds sharedInstance] getFromAdnetworkList:CONSOLIADSICON];
    if (caIcon) {
        caIcon.shownForSceneIndex = _shownForSceneIndex;
        caIcon.shownForPlaceholder = (PlaceholderName)[_shownForPlaceholder intValue];
    }
    [[ConsoliAds sharedInstance] onAdShowSuccess:CONSOLIADSICON format:ICONAD];
    
}

-(void)didFailedToDisplayIconAd:(NSString*)scene error:(NSString *)error
{
    [[ConsoliAds sharedInstance] onAdLoadFailed:CONSOLIADSICON format:ICONAD];
    [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:error];
    if ([_delegate respondsToSelector:@selector(onIconAdFailedToShownEvent)]) {
        [_delegate onIconAdFailedToShownEvent];
    }
}

@end

/*----------Inner Class End------------*/

@interface CAIconAd() <CAAdNetworkInitializeListener> {
    BOOL isRequestPending;
}

@property (nonatomic , weak) UIView *iconAdView;
@property (nonatomic) IconSize adSize;
@property (nonatomic , weak) id<ConsoliAdsMediationIconAdDelegate> iconAdDelegate;

@end

@implementation CAIconAd

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
        _iconObjectArray = [NSMutableArray new];
    }
    return _isInitialized;
}

- (BOOL)isInitialized {
    return _isInitialized && [[CAManager sharedManager] isInitialized];
}

- (void)showIconAd:(IconSize)iconAdSize iconAdView:(UIView*)iconAdView delegate:(id<ConsoliAdsMediationIconAdDelegate>_Nonnull)delegate {
    
    if(!_isInitialized) {
        [[ConsoliAds sharedInstance] onAdLoadFailed:CONSOLIADSICON format:ICONAD];
        return;
    }
    else if (![[CAManager sharedManager] isInitialized]) {
        self.iconAdView = iconAdView;
        self.adSize = iconAdSize;
        self.iconAdDelegate = delegate;
        isRequestPending = YES;
        return;
    }
    
    [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:@"ConsoliAdsIcon showIconAd has called"];
    
    [[ConsoliAds sharedInstance] saveAdNetworkRequest: self];
    
    if (iconAdView == nil ) {
        [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:@"cannot show icon ad view is nil"];
        return;
    }
    
    CAIconAdView *caIconAdView = (CAIconAdView*)iconAdView;
    NSString* scene = [NSString stringWithFormat:@"%lu", (unsigned long)self.shownForPlaceholder];
    
    ConsoliAdsIconAd *iconAd = [[ConsoliAdsIconAd alloc] initIconAd:caIconAdView.rootViewController shownForPlaceholder:scene shownForSceneIndex:self.shownForSceneIndex delegate:delegate];
    
    if (self.iconObjectArray == nil) {
        self.iconObjectArray = [NSMutableArray new];
    }
    
    [self.iconObjectArray addObject:iconAd];
    [iconAd loadIconAd:iconAdSize iconAdView:caIconAdView];
}

- (void)dealloc {
    NSLog(@"%@,%@, dealloc",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}

#pragma mark CAAdNetworkInitializeListener

- (void)onAdNetworkInitialized:(BOOL)status {
    if (isRequestPending) {
        isRequestPending = NO;
        if (status) {
            [self showIconAd:self.adSize iconAdView:self.iconAdView delegate:self.iconAdDelegate];
        }
        else {
            [[CALogManager sharedManager] logWithLogType:INFO className:self.className methodName:NSStringFromSelector(_cmd) message:[NSString stringWithFormat:@"Ad load failed: %ld",(long)CONSOLIADSICON]];
            self.isAdLoaded = Failed;
            [[ConsoliAds sharedInstance] onAdLoadFailed:CONSOLIADSICON format:ICONAD];
        }
    }
}

@end
