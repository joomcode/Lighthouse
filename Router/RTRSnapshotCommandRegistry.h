//
//  RTRSnapshotCommandRegistry.h
//  Router
//
//  Created by Nick Tymchenko on 19/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRCommandRegistry.h"

@class RTRSnapshotCommand;

@interface RTRSnapshotCommandRegistry : NSObject <RTRCommandRegistry>

- (void)bindCommand:(id<RTRCommand>)command toNodes:(NSSet *)nodes;

@end
