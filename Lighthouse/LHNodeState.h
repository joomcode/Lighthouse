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


typedef NS_OPTIONS(NSInteger, LHNodeStateMask) {
    LHNodeStateMaskNotInitialized = (1 << LHNodeStateNotInitialized),
    LHNodeStateMaskInactive = (1 << LHNodeStateInactive),
    LHNodeStateMaskActive = (1 << LHNodeStateActive),
    
    LHNodeStateMaskAll = (LHNodeStateMaskNotInitialized | LHNodeStateMaskInactive | LHNodeStateMaskActive),
    LHNodeStateMaskInitialized = (LHNodeStateMaskInactive | LHNodeStateMaskActive)
};


static inline LHNodeStateMask LHNodeStateMaskWithState(LHNodeState state) {
    return 1 << state;
}
