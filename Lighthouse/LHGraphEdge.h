//
//  LHGraphEdge.h
//  Lighthouse
//
//  Created by Makarov Yury on 03/11/2016.
//  Copyright © 2016 Joom. All rights reserved.
//

#import "LHDebugPrintable.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LHGraphNode;


@interface LHGraphEdge<__covariant NodeType> : NSObject <LHDebugPrintable>

@property (nonatomic, strong, readonly) NodeType fromNode;
@property (nonatomic, strong, readonly) NodeType toNode;
@property (nonatomic, copy, readonly, nullable) NSString *label;

- (instancetype)initWithFromNode:(NodeType)fromNode toNode:(NodeType)toNode label:(nullable NSString *)label NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFromNode:(NodeType)fromNode toNode:(NodeType)toNode;

- (instancetype)init NS_UNAVAILABLE;

- (BOOL)isEqualToEdge:(LHGraphEdge<NodeType> *)other;

@end

NS_ASSUME_NONNULL_END
