//
//  PXNodeHierarchy.h
//  RouterDemo
//
//  Created by Nick Tymchenko on 04/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Router.h>

@interface PXNodeHierarchy : NSObject

@property (nonatomic, readonly) id<RTRNode> rootNode;

@property (nonatomic, readonly) id<RTRNode> mainStackNode;
@property (nonatomic, readonly)     id<RTRNode> redNode;
@property (nonatomic, readonly)     id<RTRNode> greenNode;
@property (nonatomic, readonly)     id<RTRNode> blueNode;

@property (nonatomic, readonly) id<RTRNode> modalStackNode;
@property (nonatomic, readonly)     id<RTRNode> modalNode;

@property (nonatomic, readonly) id<RTRNode> deepModalStackNode;
@property (nonatomic, readonly)     id<RTRNode> deepModalNode;

@property (nonatomic, readonly) id<RTRNode> anotherModalStackNode;
@property (nonatomic, readonly)     id<RTRNode> anotherTabNode;
@property (nonatomic, readonly)         id<RTRNode> anotherRedNode;
@property (nonatomic, readonly)         id<RTRNode> anotherGreenNode;
@property (nonatomic, readonly)         id<RTRNode> anotherBlueNode;

@property (nonatomic, readonly) id<RTRNode> alertNode;

@end
