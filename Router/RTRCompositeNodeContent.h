//
//  RTRCompositeNodeContent.h
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContent.h"

@interface RTRCompositeNodeContent : NSObject <RTRNodeContent>

- (instancetype)initWithContentById:(NSDictionary *)contentById;

@end
