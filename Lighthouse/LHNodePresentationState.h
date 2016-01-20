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
    LHNodePresentationStateNotInitialized = 0,
    LHNodePresentationStateInactive = 1,
    LHNodePresentationStateDeactivating = 2,
    LHNodePresentationStateActivating = 3,
    LHNodePresentationStateActive = 4
};


static inline LHNodePresentationState LHNodePresentationStateWithState(LHNodeState state) {
    switch (state) {
        case LHNodeStateNotInitialized:
            return LHNodePresentationStateNotInitialized;
        case LHNodeStateInactive:
            return LHNodePresentationStateInactive;
        case LHNodeStateActive:
            return LHNodePresentationStateActive;
    }
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

static inline BOOL LHNodePresentationStateIsInitialized(LHNodePresentationState state) {
    return state != LHNodePresentationStateNotInitialized;
}

static inline BOOL LHNodePresentationStateIsTransitioning(LHNodePresentationState state) {
    return state == LHNodePresentationStateDeactivating || state == LHNodePresentationStateActivating;
}