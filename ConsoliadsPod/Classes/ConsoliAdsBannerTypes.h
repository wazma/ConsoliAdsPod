//
//  ConsoliAdsBannerTypes.h
//  ConsoliAd
//
//  Created by rehmanaslam on 28/11/2018.
//  Copyright © 2018 FazalElahi. All rights reserved.
//

#ifndef ConsoliAdsBannerTypes_h
#define ConsoliAdsBannerTypes_h

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


typedef NS_ENUM(NSUInteger , CABannerAdSize){
    KCAAdSizeBanner = 0,    /// Banner size  Typically 320x50.
    KCAAdSizeLargeBanner = 1,   /// LargeBanner size  Typically 320x100.
    KCAAdSizeFullBanner = 2,    /// FullBanner size  Typically 468x60.
    KCAAdSizeLeaderboardBanner = 3, /// Leaderboard size  Typically 728x90.
    KCAAdSizeSmartBanner = 4    /// SmartBanner size  Typically 728x90.
};

typedef NS_ENUM(NSUInteger , CAAdPosition){
    KCAAdPositionTop = 0,
    KCAAdPositionBottom = 1,
    KCAAdPositionTopLeft = 2,
    KCAAdPositionTopRight = 3,
    KCAAdPositionBottomLeft = 4,
    KCAAdPositionBottomRight = 5,
    KCAAdPositionCenter = 6,
    KCAAdPositionCustom = 7

};


#endif /* ConsoliAdsBannerTypes_h */


