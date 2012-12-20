//
//  SFTools.m
//  SegmentFault
//
//  Created by jiajun on 12/6/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFTools.h"

@implementation SFTools

+ (UIImage *)convertViewToImage:(UIView *)aView {
    UIGraphicsBeginImageContext(aView.bounds.size);
    [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
