//
//  CAInAppError.h
//  ConsoliAd
//
//  Created by saira on 21/12/2020.
//  Copyright © 2020 FazalElahi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAInAppDetails.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAInAppError : NSObject

@property (nonatomic) CAAdType adType;
@property(nonatomic,) NSError *error;

@end

NS_ASSUME_NONNULL_END
