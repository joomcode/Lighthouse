//
//  PXNodeHierarchy.m
//  LighthouseDemo
//
//  Created by Nick Tymchenko on 04/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "PXNodeHierarchy.h"

@implementation PXNodeHierarchy

@synthesize rootNode = _rootNode;
@synthesize mainStackNode = _mainStackNode;
@synthesize redNode = _redNode;
@synthesize greenNode = _greenNode;
@synthesize blueNode = _blueNode;
@synthesize modalStackNode = _modalStackNode;
@synthesize modalNode = _modalNode;
@synthesize deepModalStackNode = _deepModalStackNode;
@synthesize deepModalNode = _deepModalNode;
@synthesize anotherModalStackNode = _anotherModalStackNode;
@synthesize anotherTabNode = _anotherTabNode;
@synthesize anotherRedNode = _anotherRedNode;
@synthesize anotherGreenNode = _anotherGreenNode;
@synthesize anotherBlueNode = _anotherBlueNode;

- (id<LHNode>)rootNode {
    if (!_rootNode) {
        _rootNode = [[LHStackNode alloc] initWithGraphBlock:^(LHMutableGraph<id<LHNode>> *graph) {
            graph.rootNode = self.mainStackNode;
            [graph addBidirectionalEdgeFromNode:self.mainStackNode toNode:self.modalStackNode];
            [graph addBidirectionalEdgeFromNode:self.modalStackNode toNode:self.deepModalStackNode];
            [graph addBidirectionalEdgeFromNode:self.mainStackNode toNode:self.anotherModalStackNode];
        } label:@"rootStack"];
    }
    return _rootNode;
}

- (id<LHNode>)mainStackNode {
    if (!_mainStackNode) {
        _mainStackNode = [[LHStackNode alloc] initWithGraphBlock:^(LHMutableGraph<id<LHNode>> *graph) {
            graph.rootNode = self.redNode;
            [graph addBidirectionalEdgeFromNode:self.redNode toNode:self.greenNode];
            [graph addBidirectionalEdgeFromNode:self.redNode toNode:self.blueNode];
            [graph addBidirectionalEdgeFromNode:self.greenNode toNode:self.blueNode];
            [graph addBidirectionalEdgeFromNode:self.greenNode toNode:self.redNode];
            [graph addBidirectionalEdgeFromNode:self.greenNode toNode:self.greenNode];
        } label:@"mainStack"];
    }
    return _mainStackNode;
}

- (id<LHNode>)redNode {
    if (!_redNode) {
        _redNode = [[LHLeafNode alloc] initWithLabel:@"Red"];
    }
    return _redNode;
}

- (id<LHNode>)greenNode {
    if (!_greenNode) {
        _greenNode = [[LHLeafNode alloc] initWithLabel:@"Green"];
    }
    return _greenNode;
}

- (id<LHNode>)blueNode {
    if (!_blueNode) {
        _blueNode = [[LHLeafNode alloc] initWithLabel:@"Blue"];
    }
    return _blueNode;
}

- (id<LHNode>)modalStackNode {
    if (!_modalStackNode) {
        _modalStackNode = [[LHStackNode alloc] initWithSingleBranch:@[ self.modalNode ] label:@"modalStack"];
    }
    return _modalStackNode;
}

- (id<LHNode>)modalNode {
    if (!_modalNode) {
        _modalNode = [[LHLeafNode alloc] initWithLabel:@"Modal"];
    }
    return _modalNode;
}

- (id<LHNode>)deepModalStackNode {
    if (!_deepModalStackNode) {
        _deepModalStackNode = [[LHStackNode alloc] initWithSingleBranch:@[ self.deepModalNode ] label:@"deepModalStack"];
    }
    return _deepModalStackNode;
}

- (id<LHNode>)deepModalNode {
    if (!_deepModalNode) {
        _deepModalNode = [[LHLeafNode alloc] initWithLabel:@"Deep Modal"];
    }
    return _deepModalNode;
}

- (id<LHNode>)anotherModalStackNode {
    if (!_anotherModalStackNode) {
        _anotherModalStackNode = [[LHStackNode alloc] initWithSingleBranch:@[ self.anotherTabNode ] label:@"anotherModalStack"];
    }
    return _anotherModalStackNode;
}

- (id<LHNode>)anotherTabNode {
    if (!_anotherTabNode) {
        NSArray *children = @[ self.anotherRedNode, self.anotherGreenNode, self.anotherBlueNode ];
        
        _anotherTabNode = [[LHTabNode alloc] initWithChildren:[NSOrderedSet orderedSetWithArray:children] label:@"anotherTab"];
    }
    return _anotherTabNode;
}

- (id<LHNode>)anotherRedNode {
    if (!_anotherRedNode) {
        _anotherRedNode = [[LHLeafNode alloc] initWithLabel:@"Another Red"];
    }
    return _anotherRedNode;
}

- (id<LHNode>)anotherGreenNode {
    if (!_anotherGreenNode) {
        _anotherGreenNode = [[LHLeafNode alloc] initWithLabel:@"Another Green"];
    }
    return _anotherGreenNode;
}

- (id<LHNode>)anotherBlueNode {
    if (!_anotherBlueNode) {
        _anotherBlueNode = [[LHLeafNode alloc] initWithLabel:@"Another Blue"];
    }
    return _anotherBlueNode;
}

@end
