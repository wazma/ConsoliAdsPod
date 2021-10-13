//
//  CANativeAd.h
//  ConsoliAdsMediation
//
//  Created by rehmanaslam on 13/12/2018.
//  Copyright © 2018 ConsoliAds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdNetwork.h"
#import "CAConstants.h"
#import "CALogManager.h"
#import "ConsoliAds.h"
#import "CANativeAdRequestDelegate.h"
#import "CAMediatedNativeAd.h"
#import "CAMediatedInternalNativeAd.h"

NS_ASSUME_NONNULL_BEGIN

@interface CANativeAd : AdNetwork

@property (nonatomic, strong) NSMutableArray *nativeAdsArray;

@end

NS_ASSUME_NONNULL_END
