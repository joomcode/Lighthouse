//
//  LHNodeState.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, LHNodeState) {
    LHNodeStateNotInitialized = 0,
    LHNodeStateInactive = 1,
    LHNodeStateActive = 4
};


static inline BOOL LHNodeStateIsInitialized(LHNodeState state) {
    return state != LHNodeStateNotInitialized;
}
