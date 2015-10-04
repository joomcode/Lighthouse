//
//  PXNodeHierarchy.m
//  RouterDemo
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

- (id<RTRNode>)rootNode {
    if (!_rootNode) {
        RTRNodeTree *mainTree = [[RTRNodeTree alloc] init];
        [mainTree addItem:self.mainStackNode afterItemOrNil:nil];
        [mainTree addBranch:@[ self.modalStackNode, self.deepModalStackNode ] afterItemOrNil:self.mainStackNode];
        [mainTree addItem:self.anotherModalStackNode afterItemOrNil:self.mainStackNode];
        
        RTRNodeTree *alertTree = [[RTRNodeTree alloc] init];
        [alertTree addItem:self.alertNode afterItemOrNil:nil];
        
        _rootNode = [[RTRFreeStackNode alloc] initWithTrees:@[ mainTree, alertTree ]];
    }
    return _rootNode;
}

- (id<RTRNode>)mainStackNode {
    if (!_mainStackNode) {
        _mainStackNode = [[RTRStackNode alloc] initWithSingleBranch:@[ self.redNode, self.greenNode, self.blueNode ]];
    }
    return _mainStackNode;
}

- (id<RTRNode>)redNode {
    if (!_redNode) {
        _redNode = [[RTRLeafNode alloc] init];
    }
    return _redNode;
}

- (id<RTRNode>)greenNode {
    if (!_greenNode) {
        _greenNode = [[RTRLeafNode alloc] init];
    }
    return _greenNode;
}

- (id<RTRNode>)blueNode {
    if (!_blueNode) {
        _blueNode = [[RTRLeafNode alloc] init];
    }
    return _blueNode;
}

- (id<RTRNode>)modalStackNode {
    if (!_modalStackNode) {
        _modalStackNode = [[RTRStackNode alloc] initWithSingleBranch:@[ self.modalNode ]];
    }
    return _modalStackNode;
}

- (id<RTRNode>)modalNode {
    if (!_modalNode) {
        _modalNode = [[RTRLeafNode alloc] init];
    }
    return _modalNode;
}

- (id<RTRNode>)deepModalStackNode {
    if (!_deepModalStackNode) {
        _deepModalStackNode = [[RTRStackNode alloc] initWithSingleBranch:@[ self.deepModalNode ]];
    }
    return _deepModalStackNode;
}

- (id<RTRNode>)deepModalNode {
    if (!_deepModalNode) {
        _deepModalNode = [[RTRLeafNode alloc] init];
    }
    return _deepModalNode;
}

- (id<RTRNode>)anotherModalStackNode {
    if (!_anotherModalStackNode) {
        _anotherModalStackNode = [[RTRStackNode alloc] initWithSingleBranch:@[ self.anotherTabNode ]];
    }
    return _anotherModalStackNode;
}

- (id<RTRNode>)anotherTabNode {
    if (!_anotherTabNode) {
        NSArray *children = @[ self.anotherRedNode, self.anotherGreenNode, self.anotherBlueNode ];
        
        _anotherTabNode = [[RTRTabNode alloc] initWithChildren:[NSOrderedSet orderedSetWithArray:children]];
    }
    return _anotherTabNode;
}

- (id<RTRNode>)anotherRedNode {
    if (!_anotherRedNode) {
        _anotherRedNode = [[RTRLeafNode alloc] init];
    }
    return _anotherRedNode;
}

- (id<RTRNode>)anotherGreenNode {
    if (!_anotherGreenNode) {
        _anotherGreenNode = [[RTRLeafNode alloc] init];
    }
    return _anotherGreenNode;
}

- (id<RTRNode>)anotherBlueNode {
    if (!_anotherBlueNode) {
        _anotherBlueNode = [[RTRLeafNode alloc] init];
    }
    return _anotherBlueNode;
}

- (id<RTRNode>)alertNode {
    if (!_alertNode) {
        _alertNode = [[RTRLeafNode alloc] init];
    }
    return _alertNode;
}

@end
