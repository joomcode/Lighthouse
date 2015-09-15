//
//  RTRNodeContentProvider.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNode;
@protocol RTRNodeContent;

@protocol RTRNodeContentProvider <NSObject>

- (id<RTRNodeContent>)contentForNode:(id<RTRNode>)node;

@end
