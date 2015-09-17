//
//  RTRBasicNodeContentProvider.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContentProvider.h"

typedef id<RTRNodeContent> (^RTRNodeContentProvidingBlock)(id<RTRNode> node);

@interface RTRBasicNodeContentProvider : NSObject <RTRNodeContentProvider>

- (void)bindNode:(id<RTRNode>)node toBlock:(RTRNodeContentProvidingBlock)block;

- (void)bindNodes:(NSArray *)nodes toBlock:(RTRNodeContentProvidingBlock)block;

- (void)bindNodeClass:(Class)nodeClass toBlock:(RTRNodeContentProvidingBlock)block;

@end
