//
//  LHNodeModelState.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHNodeState.h"


typedef NS_ENUM(NSInteger, LHNodeModelState) {
    LHNodeModelStateNotInitialized = LHNodeStateNotInitialized,
    LHNodeModelStateInactive = LHNodeStateInactive,
    LHNodeModelStateActive = LHNodeStateActive
};


typedef NS_OPTIONS(NSInteger, LHNodeModelStateMask) {
    LHNodeModelStateMaskNotInitialized = (1 << LHNodeModelStateNotInitialized),
    LHNodeModelStateMaskInactive = (1 << LHNodeModelStateInactive),
    LHNodeModelStateMaskActive = (1 << LHNodeModelStateActive),
    
    LHNodeModelStateMaskAll = (LHNodeModelStateMaskNotInitialized | LHNodeModelStateMaskInactive | LHNodeModelStateMaskActive),
    LHNodeModelStateMaskInitialized = (LHNodeModelStateMaskInactive | LHNodeModelStateMaskActive)
};


static inline LHNodeModelStateMask LHNodeModelStateMaskWithState(LHNodeModelState state) {
    return 1 << state;
}


static inline LHNodeState LHNodeStateWithModelState(LHNodeModelState state) {
    return (LHNodeState)state;
}


static inline LHNodeState LHNodeStateForTransition(LHNodeState previousState, LHNodeModelState currentModelState) {
    switch (currentModelState) {
        case LHNodeModelStateNotInitialized:
            switch (previousState) {
                case LHNodeStateNotInitialized:
                case LHNodeStateInactive:
                    return previousState;
                    
                default:
                    return LHNodeStateDeactivating;
            }
            
        case LHNodeModelStateInactive:
            switch (previousState) {
                case LHNodeStateNotInitialized:
                case LHNodeStateInactive:
                    return LHNodeStateInactive;
                    
                default:
                    return LHNodeStateDeactivating;
            }
            
        case LHNodeModelStateActive:
            switch (previousState) {
                case LHNodeStateActive:
                    return previousState;
                    
                default:
                    return LHNodeStateActivating;
            }
    }
}
