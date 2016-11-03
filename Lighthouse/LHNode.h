//
//  LHNode.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHNodeChildrenState;
@class LHTarget;

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, LHNodeUpdateResult) {
    LHNodeUpdateResultNormal = 0,
    LHNodeUpdateResultDeactivation = 1,
    LHNodeUpdateResultInvalid = 2
};


@protocol LHNode <NSObject>

@property (nonatomic, copy, readonly, nullable) NSString *label;

@property (nonatomic, strong, readonly, nullable) NSSet<id<LHNode>> *allChildren;

@property (nonatomic, strong, readonly, nullable) id<LHNodeChildrenState> childrenState;

- (void)resetChildrenState;

- (LHNodeUpdateResult)updateChildrenState:(LHTarget *)target;

@end


NS_ASSUME_NONNULL_END
