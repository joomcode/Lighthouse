//
//  RTRCompositeNodeContentProvider.h
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContentProvider.h"

@interface RTRCompositeNodeContentProvider : NSObject <RTRNodeContentProvider>

- (instancetype)initWithContentProviders:(NSArray *)contentProviders;

@end
