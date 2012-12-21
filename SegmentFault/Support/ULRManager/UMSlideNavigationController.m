//
//  UMSlideNavigationController.m
//  SegmentFault
//
//  Created by jiajun on 11/26/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "UMSlideNavigationController.h"
#import "UMViewController.h"

#define SLIDE_VIEW_WIDTH                260.0f
#define ANIMATION_DURATION              0.3f
#define SILENT_DISTANCE                 30.0f


@interface UMSlideNavigationController ()

// 可以滑动的View
@property (strong, nonatomic) UIView            *contentView;

// 标记ContentView的静止状态left
@property (assign, nonatomic) CGFloat           left;

- (void)moveContentViewTo:(CGPoint)toPoint WithPath:(UIBezierPath *)path inDuration:(CGFloat)duration;
- (void)slideButtonClicked;

- (void)addPanRecognizer;
- (void)slidePanAction:(UIPanGestureRecognizer *)recognizer;

- (void)addShadowToContentView;

@end

@implementation UMSlideNavigationController

@synthesize items           = _items;
@synthesize slideView       = _slideView;
@synthesize contentView     = _contentView;
@synthesize navItem         = _navItem;
@synthesize left            = _left;
@synthesize currentIndex    = _currentIndex;

- (id)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        self.items = items;
        return self;
    }
    return nil;
}

- (void)addShadowToContentView
{
    
}

- (void)addPanRecognizer
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanAction:)];
    [self.contentView addGestureRecognizer:panRecognizer];
    self.left = self.contentView.left;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navItem = [[UINavigationItem alloc] initWithTitle:@""];
    self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slide_navigator_shadow.png"]];
    shadow.height = self.contentView.height;
    shadow.right = self.contentView.left;
    [self.contentView addSubview:shadow];

    self.slideView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, self.view.height)
                                                  style:UITableViewStylePlain];

    if (0 < self.items.count) {
        [self.contentView addSubview:[(UIViewController *)self.items[0][0] view]];
        [(UIViewController *)self.items[0][0] view].top = -20.0f;
    }

    [self.view addSubview:self.slideView];
    [self.view addSubview:self.contentView];

    [self addPanRecognizer];
}

#pragma mark - Actions

- (void)showItemAtIndex:(NSIndexPath *)index
{
    if (index.section < [self.items count] && index.row < [self.items[index.section] count]) {
        self.currentIndex = index;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(self.contentView.left, 0.0f)];
        [path addLineToPoint:CGPointMake(self.contentView.width, 0.0f)];
        [self moveContentViewTo:CGPointMake(self.contentView.width, 0.0f) WithPath:path inDuration:0.2f];
        [self performSelector:@selector(switchCurrentView) withObject:nil afterDelay:0.2f];
    }
}

- (void)switchCurrentView
{
    [self.contentView removeAllSubviews];
    self.slideView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, self.view.height)
                                                  style:UITableViewStylePlain];
    UIViewController *currentVC = (UIViewController *)self.items[self.currentIndex.section][self.currentIndex.row];
    [self.contentView addSubview:currentVC.view];
    currentVC.view.top = -20.0f;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.contentView.left, 0.0f)];
    [path addLineToPoint:CGPointMake(0.0f, 0.0f)];
    [self moveContentViewTo:CGPointMake(0.0f, 0.0f) WithPath:path inDuration:ANIMATION_DURATION];
    
    // 每次切换会清空contentView，这里重新贴阴影
    UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slide_navigator_shadow.png"]];
    shadow.height = self.contentView.height;
    shadow.right = self.contentView.left;
    [self.contentView addSubview:shadow];
}

- (void)slidePanAction:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.contentView];
    CGPoint velocity = [recognizer velocityInView:self.contentView];
    CGFloat newLeft = self.left;
    if(recognizer.state == UIGestureRecognizerStateChanged && 2 <= ABS(self.left - ABS(translation.x))) { // sliding.
        newLeft = self.left + translation.x;
        if (0 > newLeft) {
            newLeft = 0;
        }
        else if (SLIDE_VIEW_WIDTH < newLeft){
            newLeft = SLIDE_VIEW_WIDTH;
        }
        if (SILENT_DISTANCE < abs(translation.x)) { // more than SILENT, move
            self.contentView.left = newLeft;
        }
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded) { // end slide.
        CGFloat animationDuration = 0.0f;
        CGFloat v = SLIDE_VIEW_WIDTH / ANIMATION_DURATION;
        if (0 < velocity.x) { // left to right
            if (500.0f < velocity.x || SLIDE_VIEW_WIDTH / 2 < self.left + translation.x) { // fast or more than half
                animationDuration = (SLIDE_VIEW_WIDTH - translation.x) / v;
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(self.contentView.left, 0.0f)];
                [path addLineToPoint:CGPointMake(SLIDE_VIEW_WIDTH, 0.0f)];
                [self moveContentViewTo:CGPointMake(SLIDE_VIEW_WIDTH, 0.0f)
                               WithPath:path
                             inDuration:animationDuration];
            }
            else if (SLIDE_VIEW_WIDTH / 2 >= self.left + translation.x) {
                animationDuration = translation.x / v;
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(self.contentView.left, 0.0f)];
                [path addLineToPoint:CGPointMake(0.0f, 0.0f)];
                [self moveContentViewTo:CGPointMake(0.0f, 0.0f)
                               WithPath:path
                             inDuration:animationDuration];
            }
        }
        else { // right to left
            if (-500.0f > velocity.x || SLIDE_VIEW_WIDTH / 2 > self.left + translation.x) { // fast or more than half
                animationDuration = (SLIDE_VIEW_WIDTH + translation.x) / v;
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(self.contentView.left, 0.0f)];
                [path addLineToPoint:CGPointMake(0.0f, 0.0f)];
                [self moveContentViewTo:CGPointMake(0.0f, 0.0f)
                               WithPath:path
                             inDuration:animationDuration];
            }
            else if (SLIDE_VIEW_WIDTH / 2 <= self.left + translation.x) {
                animationDuration = - translation.x / v;
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(self.contentView.left, 0.0f)];
                [path addLineToPoint:CGPointMake(SLIDE_VIEW_WIDTH, 0.0f)];
                [self moveContentViewTo:CGPointMake(SLIDE_VIEW_WIDTH, 0.0f)
                               WithPath:path
                             inDuration:animationDuration];

            }
        }
    }
}

- (void)slideButtonClicked
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.contentView.left, 0.0f)];

    if (0.0f < self.contentView.left) {
        [path addLineToPoint:CGPointMake(self.contentView.width, 0.0f)];
        [path addLineToPoint:CGPointMake(0.0f, 0.0f)];
        [self moveContentViewTo:CGPointMake(0.0f, 0.0f)
                       WithPath:path
                     inDuration:ANIMATION_DURATION + 0.2];
    }
    else {
        [path addLineToPoint:CGPointMake(SLIDE_VIEW_WIDTH, 0.0f)];
        [self moveContentViewTo:CGPointMake(SLIDE_VIEW_WIDTH, 0.0f)
                       WithPath:path
                     inDuration:ANIMATION_DURATION];
    }
}

- (void)moveContentViewTo:(CGPoint)toPoint WithPath:(UIBezierPath *)path inDuration:(CGFloat)duration
{
    self.contentView.layer.anchorPoint = CGPointZero;
    self.contentView.layer.frame = CGRectMake(toPoint.x, toPoint.y, self.contentView.width, self.contentView.height);
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.duration = duration;
    pathAnimation.path = path.CGPath;
    pathAnimation.calculationMode = kCAAnimationLinear;
    [self.contentView.layer addAnimation:pathAnimation forKey:[NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]]];
    self.left = toPoint.x;
    
    if (0 < toPoint.x) {
        UIControl *backToNormal = [[UIControl alloc] initWithFrame:self.contentView.bounds];
        backToNormal.backgroundColor = [UIColor clearColor];
        backToNormal.tag = 1000002;
        [backToNormal addTarget:self action:@selector(slideButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:backToNormal];
    }
    else {
        __weak UIControl *backToNormal = (UIControl *)[self.contentView viewWithTag:1000002];
        [backToNormal removeFromSuperview];
    }
}

@end
