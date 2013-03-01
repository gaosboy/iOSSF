//
//  SFLabel.m
//  SegmentFault
//
//  Created by jiajun on 3/1/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import "SFLabel.h"

@implementation SFLabel

@synthesize insets = _insets;

-(id) initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self){
        self.insets = insets;
    }
    return self;
}

-(id) initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self){
        self.insets = insets;
    }
    return self;
}

- (void)sizeToFit {
    [super sizeToFit];
    self.width = self.width + self.insets.right + self.insets.left;
    self.height = self.height + self.insets.top + self.insets.bottom;
}

@end
