//
//  LHNodePresentationState.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 21/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHNodeState.h"


typedef NS_ENUM(NSInteger, LHNodePresentationState) {
    LHNodePresentationStateNotInitialized = LHNodeStateNotInitialized,
    LHNodePresentationStateInactive = LHNodeStateInactive,
    LHNodePresentationStateDeactivating = 2,
    LHNodePresentationStateActivating = 3,
    LHNodePresentationStateActive = LHNodeStateActive
};


typedef NS_OPTIONS(NSInteger, LHNodePresentationStateMask) {
    LHNodePresentationStateMaskNotInitialized = (1 << LHNodePresentationStateNotInitialized),
    LHNodePresentationStateMaskInactive = (1 << LHNodePresentationStateInactive),
    LHNodePresentationStateMaskDeactivating = (1 << LHNodePresentationStateDeactivating),
    LHNodePresentationStateMaskActivating = (1 << LHNodePresentationStateActivating),
    LHNodePresentationStateMaskActive = (1 << LHNodePresentationStateActive),
    
    LHNodePresentationStateMaskAll = (LHNodePresentationStateMaskNotInitialized | LHNodePresentationStateMaskInactive | LHNodePresentationStateMaskDeactivating | LHNodePresentationStateMaskActivating | LHNodePresentationStateMaskActive),
    LHNodePresentationStateMaskInitialized = (LHNodePresentationStateMaskInactive | LHNodePresentationStateMaskDeactivating | LHNodePresentationStateMaskActivating | LHNodePresentationStateMaskActive),
    LHNodePresentationStateMaskTransitioning = (LHNodePresentationStateMaskDeactivating | LHNodePresentationStateMaskActivating),
    LHNodePresentationStateMaskNotTransitioning = (LHNodePresentationStateMaskNotInitialized | LHNodePresentationStateMaskInactive | LHNodePresentationStateMaskActive)
};


static inline LHNodePresentationState LHNodePresentationStateWithState(LHNodeState state) {
    return (LHNodePresentationState)state;
}

static inline LHNodePresentationStateMask LHNodePresentationStateMaskWithState(LHNodePresentationState state) {
    return 1 << state;
}

static inline LHNodePresentationState LHNodePresentationStateForTransition(LHNodePresentationState oldPresentationState,
                                                                           LHNodeState newState) {
    switch (newState) {
        case LHNodeStateNotInitialized:
            switch (oldPresentationState) {
                case LHNodePresentationStateNotInitialized:
                case LHNodePresentationStateInactive:
                    return oldPresentationState;
                    
                default:
                    return LHNodePresentationStateDeactivating;
            }
            
        case LHNodeStateInactive:
            switch (oldPresentationState) {
                case LHNodePresentationStateNotInitialized:
                case LHNodePresentationStateInactive:
                    return LHNodePresentationStateInactive;
                    
                default:
                    return LHNodePresentationStateDeactivating;
            }
            
        case LHNodeStateActive:
            switch (oldPresentationState) {
                case LHNodePresentationStateActive:
                    return oldPresentationState;
                    
                default:
                    return LHNodePresentationStateActivating;
            }
    }
}
