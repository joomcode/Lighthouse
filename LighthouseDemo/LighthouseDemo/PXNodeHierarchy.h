//
//  PXNodeHierarchy.h
//  LighthouseDemo
//
//  Created by Nick Tymchenko on 04/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Lighthouse.h>

@interface PXNodeHierarchy : NSObject

@property (nonatomic, strong, readonly) id<LHNode> rootNode;

@property (nonatomic, strong, readonly) id<LHNode> mainStackNode;
@property (nonatomic, strong, readonly)     id<LHNode> redNode;
@property (nonatomic, strong, readonly)     id<LHNode> greenNode;
@property (nonatomic, strong, readonly)     id<LHNode> blueNode;

@property (nonatomic, strong, readonly) id<LHNode> modalStackNode;
@property (nonatomic, strong, readonly)     id<LHNode> modalNode;

@property (nonatomic, strong, readonly) id<LHNode> deepModalStackNode;
@property (nonatomic, strong, readonly)     id<LHNode> deepModalNode;

@property (nonatomic, strong, readonly) id<LHNode> anotherModalStackNode;
@property (nonatomic, strong, readonly)     id<LHNode> anotherTabNode;
@property (nonatomic, strong, readonly)         id<LHNode> anotherRedNode;
@property (nonatomic, strong, readonly)         id<LHNode> anotherGreenNode;
@property (nonatomic, strong, readonly)         id<LHNode> anotherBlueNode;

@property (nonatomic, strong, readonly) id<LHNode> alertNode;

@end
