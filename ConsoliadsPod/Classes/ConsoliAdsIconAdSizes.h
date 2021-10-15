//
//  ConsoliAdsIconAdSizes.h
//  ConsoliAd
//
//  Created by rehmanaslam on 16/01/2019.
//  Copyright © 2019 FazalElahi. All rights reserved.
//

#ifndef ConsoliAdsIconAdSizes_h
#define ConsoliAdsIconAdSizes_h


typedef NS_ENUM(NSUInteger , CAIconAdSize){
  
    KCAAdSizeSmallIcon = 0,    /// Small Icon size  Typically 60x60.
    KCAAdSizeMediumIcon = 1,   /// MediumIcon size  Typically 75x75.
    KCAAdSizeLargeIcon = 2,    /// LargeIcon size  Typically 100x100.
   
};

typedef NS_ENUM(NSUInteger , CAIconAnimationTypes){

    KCAAdNoIconAnimation = 0,    ///  No Icon Animation
    KCAAdRotationIconAnimation = 1,   /// Rotation Animation
    KCAAdScaleIconAnimation = 2,    /// Scale ANimation
};


#endif /* ConsoliAdsIconAdSizes_h */
