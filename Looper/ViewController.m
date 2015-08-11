//
//  ViewController.m
//  Looper
//
//  Created by James on 2/18/15.
//  Copyright (c) 2015 James. All rights reserved.
//

/** 图片数量 */
#define JJImageCount 15

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 0.一些固定的尺寸参数
    CGFloat imageW = self.scrollView.frame.size.width;
    CGFloat imageH = self.scrollView.frame.size.height;
    CGFloat imageY = 0;
    
    // 1.添加5张图片到scrollView中
    for (NSInteger index = 0; index < JJImageCount; index++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        // 设置frame
        CGFloat imageX = index * imageW + imageW;
        imageView.frame = CGRectMake(imageX , imageY, imageW, imageH);
        // 设置图片
        NSString *name = [NSString stringWithFormat:@"%ld.jpg", index + 1];
        imageView.image = [UIImage imageNamed:name];
        
        [self.scrollView addSubview:imageView];
    }
    
    // 1.1 将最后一张图片放在第0个位置
    UIImageView *lastImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"15.jpg"]];
    lastImage.frame = CGRectMake(0, 0, imageW, imageH);
    [self.scrollView addSubview:lastImage];
    
    // 1.2 将第一张图片放在最后1页
    UIImageView *firstImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.jpg"]];
    firstImage.frame = CGRectMake((JJImageCount + 1) * imageW, 0, imageW, imageH);
    [self.scrollView addSubview:firstImage];
    
    
    // 2.设置内容尺寸
    CGFloat contentW = (JJImageCount + 2) * imageW;
    self.scrollView.contentSize = CGSizeMake(contentW, 0);
    
    // 3.隐藏水平滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    // 4.分页
    self.scrollView.pagingEnabled = YES;
    
    // 5.设置pageControl的总页数
    self.pageControl.numberOfPages = JJImageCount;
    
    [self.scrollView setContentOffset:CGPointMake(imageW, 0)];
    
    self.pageControl.currentPage = 0;
    
    // 6.添加定时器(每隔2秒调用一次self 的nextImage方法)
    [self addTimer];
}

/****************	私有方法   ****************/
/**
 *  添加定时器
 */
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *  移除定时器
 */
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

/**
 *  下一张图片
 */
- (void)nextImage{
    // 1.增加pageControl的页码
    NSInteger page = 0;
    if (self.pageControl.currentPage == JJImageCount) {
        page = 0;
    } else {
        page = self.pageControl.currentPage + 1; // 1
    }
    // 2.计算scrollView滚动的位置
    CGFloat offsetX = (page + 1) * self.scrollView.frame.size.width; // 600
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.scrollView setContentOffset:offset animated:YES];
}

/**
 *  当停止滚动的时候调用
 */
-(void)scrollViewDidStop:(UIScrollView *)scrollView{
    CGFloat scrollW = scrollView.frame.size.width;
    int page = (self.scrollView.contentOffset.x + 0.5 * scrollW) / scrollW;
    if (page == 0){
        [self.scrollView setContentOffset:CGPointMake(scrollW * JJImageCount, 0)];
    } else if (page == (JJImageCount + 1)) {
        [self.scrollView setContentOffset:CGPointMake(scrollW , 0)];
    }
}

/****************	代理方法   ****************/
/**
 *  当scrollView正在滚动就会调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 根据scrollView的滚动位置决定pageControl显示第几页
    CGFloat scrollW = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + scrollW * 0.5) / scrollW;
    self.pageControl.currentPage = --page;
}

/**
 *  开始拖拽的时候调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 停止定时器(一旦定时器停止了,就不能再使用)
    [self removeTimer];
}

/**
 *  停止拖拽的时候调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 开启定时器
    [self addTimer];
}

/** 结束滚动动画 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidStop:scrollView];
}

/** 减缓滚动 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidStop:scrollView];
}

@end
