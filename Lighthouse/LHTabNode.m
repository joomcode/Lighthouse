//
//  LHTabNode.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHTabNode.h"
#import "LHTarget.h"
#import "LHDebugDescription.h"

@interface LHTabNode ()

@property (nonatomic, strong) LHTabNodeChildrenState *childrenState;

@end


@implementation LHTabNode

@synthesize label = _label;

#pragma mark - Init

- (instancetype)initWithChildren:(NSOrderedSet<id<LHNode>> *)children label:(NSString *)label {
    NSParameterAssert(children.count > 0);
    
    self = [super init];
    if (!self) return nil;
    
    _label = label;
    _orderedChildren = [children copy];
    
    [self resetChildrenState];
    
    return self;
}

#pragma mark - LHNode

@synthesize childrenState = _childrenState;

- (NSSet<id<LHNode>> *)allChildren {
    return self.orderedChildren.set;
}

- (void)resetChildrenState {
    self.childrenState = [[LHTabNodeChildrenState alloc] initWithParent:self activeChildIndex:0];
}

- (LHNodeUpdateResult)updateChildrenState:(LHTarget *)target {
    if (target.activeNodes.count > 1) {
        return LHNodeUpdateResultInvalid;
    }
    
    if (target.activeNodes.count == 1) {
        NSInteger childIndex = [self.orderedChildren indexOfObject:target.activeNodes.anyObject];
        if (childIndex == NSNotFound) {
            return LHNodeUpdateResultInvalid;
        }
        
        self.childrenState = [[LHTabNodeChildrenState alloc] initWithParent:self activeChildIndex:childIndex];
    }
    
    if ([target.inactiveNodes containsObject:self.childrenState.activeChild]) {
        return LHNodeUpdateResultDeactivation;
    }
    
    return LHNodeUpdateResultNormal;
}

#pragma mark - LHDebugPrintable

- (NSString *)lh_descriptionWithIndent:(NSUInteger)indent {
    return [self lh_descriptionWithIndent:indent block:^(NSMutableString *buffer, NSString *indentString, NSUInteger indent) {
        [buffer appendFormat:@"%@label = %@\n", indentString, self.label];
        [buffer appendFormat:@"%@childrenState = %@\n", indentString, [self.childrenState lh_descriptionWithIndent:indent]];
    }];
}

- (NSString *)description {
    return [self lh_descriptionWithIndent:0];
}

@end
