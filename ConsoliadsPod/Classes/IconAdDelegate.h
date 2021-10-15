//
//  IconAdDelegate.h
//  ConsoliAd
//
//  Created by saira on 17/12/2019.
//  Copyright © 2019 FazalElahi. All rights reserved.
//

#ifndef IconAdDelegate_h
#define IconAdDelegate_h

#import <UIKit/UIKit.h>

#endif /* IconAdDelegate_h */
@protocol IconAdDelegate <NSObject>

-(void)didCloseIconAd:(NSString*)scene;
-(void)didClickIconAd:(NSString*)scene;
-(void)didRefreshIconAd:(NSString*)scene;
-(void)didDisplayIconAd:(NSString*)scene;
-(void)didFailedToDisplayIconAd:(NSString*)scene error:(NSString *)error;

@end
