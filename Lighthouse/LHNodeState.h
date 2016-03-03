//
//  LHNodeState.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 21/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, LHNodeState) {
    LHNodeStateNotInitialized,
    LHNodeStateInactive,
    LHNodeStateDeactivating,
    LHNodeStateActivating,
    LHNodeStateActive
};


typedef NS_OPTIONS(NSInteger, LHNodeStateMask) {
    LHNodeStateMaskNotInitialized = (1 << LHNodeStateNotInitialized),
    LHNodeStateMaskInactive = (1 << LHNodeStateInactive),
    LHNodeStateMaskDeactivating = (1 << LHNodeStateDeactivating),
    LHNodeStateMaskActivating = (1 << LHNodeStateActivating),
    LHNodeStateMaskActive = (1 << LHNodeStateActive),
    
    LHNodeStateMaskAll = (LHNodeStateMaskNotInitialized | LHNodeStateMaskInactive | LHNodeStateMaskDeactivating | LHNodeStateMaskActivating | LHNodeStateMaskActive),
    LHNodeStateMaskInitialized = (LHNodeStateMaskInactive | LHNodeStateMaskDeactivating | LHNodeStateMaskActivating | LHNodeStateMaskActive),
    LHNodeStateMaskTransitioning = (LHNodeStateMaskDeactivating | LHNodeStateMaskActivating),
    LHNodeStateMaskNotTransitioning = (LHNodeStateMaskNotInitialized | LHNodeStateMaskInactive | LHNodeStateMaskActive)
};


static inline LHNodeStateMask LHNodeStateMaskWithState(LHNodeState state) {
    return 1 << state;
}
