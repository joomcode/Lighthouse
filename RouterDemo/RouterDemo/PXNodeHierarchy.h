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

@property (nonatomic, strong, readonly) id<RTRNode> rootNode;

@property (nonatomic, strong, readonly) id<RTRNode> mainStackNode;
@property (nonatomic, strong, readonly)     id<RTRNode> redNode;
@property (nonatomic, strong, readonly)     id<RTRNode> greenNode;
@property (nonatomic, strong, readonly)     id<RTRNode> blueNode;

@property (nonatomic, strong, readonly) id<RTRNode> modalStackNode;
@property (nonatomic, strong, readonly)     id<RTRNode> modalNode;

@property (nonatomic, strong, readonly) id<RTRNode> deepModalStackNode;
@property (nonatomic, strong, readonly)     id<RTRNode> deepModalNode;

@property (nonatomic, strong, readonly) id<RTRNode> anotherModalStackNode;
@property (nonatomic, strong, readonly)     id<RTRNode> anotherTabNode;
@property (nonatomic, strong, readonly)         id<RTRNode> anotherRedNode;
@property (nonatomic, strong, readonly)         id<RTRNode> anotherGreenNode;
@property (nonatomic, strong, readonly)         id<RTRNode> anotherBlueNode;

@property (nonatomic, strong, readonly) id<RTRNode> alertNode;

@end
