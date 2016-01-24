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
@synthesize alertNode = _alertNode;

- (id<LHNode>)rootNode {
    if (!_rootNode) {
        LHNodeTree *mainTree = [[LHNodeTree alloc] init];
        [mainTree addItem:self.mainStackNode afterItemOrNil:nil];
        [mainTree addBranch:@[ self.modalStackNode, self.deepModalStackNode ] afterItemOrNil:self.mainStackNode];
        [mainTree addItem:self.anotherModalStackNode afterItemOrNil:self.mainStackNode];
        
        LHNodeTree *alertTree = [[LHNodeTree alloc] init];
        [alertTree addItem:self.alertNode afterItemOrNil:nil];
        
        _rootNode = [[LHStackNode alloc] initWithTrees:@[ mainTree, alertTree ]];
    }
    return _rootNode;
}

- (id<LHNode>)mainStackNode {
    if (!_mainStackNode) {
        _mainStackNode = [[LHStackNode alloc] initWithSingleBranch:@[ self.redNode, self.greenNode, self.blueNode ]];
    }
    return _mainStackNode;
}

- (id<LHNode>)redNode {
    if (!_redNode) {
        _redNode = [[LHLeafNode alloc] init];
    }
    return _redNode;
}

- (id<LHNode>)greenNode {
    if (!_greenNode) {
        _greenNode = [[LHLeafNode alloc] init];
    }
    return _greenNode;
}

- (id<LHNode>)blueNode {
    if (!_blueNode) {
        _blueNode = [[LHLeafNode alloc] init];
    }
    return _blueNode;
}

- (id<LHNode>)modalStackNode {
    if (!_modalStackNode) {
        _modalStackNode = [[LHStackNode alloc] initWithSingleBranch:@[ self.modalNode ]];
    }
    return _modalStackNode;
}

- (id<LHNode>)modalNode {
    if (!_modalNode) {
        _modalNode = [[LHLeafNode alloc] init];
    }
    return _modalNode;
}

- (id<LHNode>)deepModalStackNode {
    if (!_deepModalStackNode) {
        _deepModalStackNode = [[LHStackNode alloc] initWithSingleBranch:@[ self.deepModalNode ]];
    }
    return _deepModalStackNode;
}

- (id<LHNode>)deepModalNode {
    if (!_deepModalNode) {
        _deepModalNode = [[LHLeafNode alloc] init];
    }
    return _deepModalNode;
}

- (id<LHNode>)anotherModalStackNode {
    if (!_anotherModalStackNode) {
        _anotherModalStackNode = [[LHStackNode alloc] initWithSingleBranch:@[ self.anotherTabNode ]];
    }
    return _anotherModalStackNode;
}

- (id<LHNode>)anotherTabNode {
    if (!_anotherTabNode) {
        NSArray *children = @[ self.anotherRedNode, self.anotherGreenNode, self.anotherBlueNode ];
        
        _anotherTabNode = [[LHTabNode alloc] initWithChildren:[NSOrderedSet orderedSetWithArray:children]];
    }
    return _anotherTabNode;
}

- (id<LHNode>)anotherRedNode {
    if (!_anotherRedNode) {
        _anotherRedNode = [[LHLeafNode alloc] init];
    }
    return _anotherRedNode;
}

- (id<LHNode>)anotherGreenNode {
    if (!_anotherGreenNode) {
        _anotherGreenNode = [[LHLeafNode alloc] init];
    }
    return _anotherGreenNode;
}

- (id<LHNode>)anotherBlueNode {
    if (!_anotherBlueNode) {
        _anotherBlueNode = [[LHLeafNode alloc] init];
    }
    return _anotherBlueNode;
}

- (id<LHNode>)alertNode {
    if (!_alertNode) {
        _alertNode = [[LHLeafNode alloc] init];
    }
    return _alertNode;
}

@end
