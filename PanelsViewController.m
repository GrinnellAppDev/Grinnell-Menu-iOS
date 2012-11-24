/**
 * Copyright (c) 2009 Muh Hon Cheng
 * Created by honcheng on 11/27/10.
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject
 * to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT
 * WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT
 * SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR
 * IN CONNECTION WITH THE SOFTWARE OR
 * THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * @author 		Muh Hon Cheng <honcheng@gmail.com>
 * @copyright	2010	Muh Hon Cheng
 * @version
 *
 */

#import "PanelsViewController.h"

@implementation UIScrollViewExt
@synthesize isEditing;
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	if (self.isEditing) return self;
	else return [super hitTest:point withEvent:event];
}
@end


@interface PanelsViewController()
- (void)tilePages;
- (void)configurePage:(PanelView*)page forIndex:(int)index;
- (BOOL)isDisplayingPageForIndex:(int)index;
- (PanelView *)panelForPage:(NSInteger)page;
@end

@implementation PanelsViewController
@synthesize currentPage, lastDisplayedPage, scrollView, recycledPages, visiblePages, isEditing;
- (void)loadView
{
	[super loadView];
	CGRect frame = [self scrollViewFrame];
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone)
        frame.size.height += 44;
	self.scrollView = [[UIScrollViewExt alloc] initWithFrame:CGRectMake(-1*GAP,0,frame.size.width+2*GAP,frame.size.height)];
	[self.scrollView setScrollsToTop:YES];
	[self.scrollView setDelegate:self];
	[self.scrollView setShowsHorizontalScrollIndicator:NO];
	[self.scrollView setPagingEnabled:YES];
	[self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    [self.view addSubview:self.scrollView];
	[self.scrollView setContentSize:CGSizeMake(([self panelViewSize].width+2*GAP)*[self numberOfPanels], self.scrollView.frame.size.height)];
    //Push the scrollview beneath the top banner so the shadow shows. Arbitrarily picked -9. The most negative value goes behind everything.
    self.scrollView.layer.zPosition = -9;
	
	recycledPages = [NSMutableSet set];
	visiblePages = [NSMutableSet set];
	
	[self tilePages];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
	PanelView *panelView = [self panelViewAtPage:self.currentPage];
	[panelView pageDidAppear];
}

- (void)viewWillAppear:(BOOL)animated
{
	PanelView *panelView = [self panelViewAtPage:self.currentPage];
	[panelView pageWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated
{
	PanelView *panelView = [self panelViewAtPage:self.currentPage];
	[panelView pageWillDisappear];
}

#pragma mark editing

- (void)shouldWiggle:(BOOL)wiggle
{
	for (int i=0; i<[self numberOfPanels]; i++)
	{
		PanelView *panelView = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+i];
		[panelView shouldWiggle:wiggle];
		
	}
}

- (void)setEditing:(BOOL)editing
{
	self.isEditing = editing;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.2];
	[self.scrollView setIsEditing:editing];
	[self shouldWiggle:editing];
	if (editing)
	{
		[self.scrollView setTransform:CGAffineTransformMakeScale(0.5, 0.5)];
		[self.scrollView setClipsToBounds:NO];
	}
	else
	{
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(onEditingAnimationStopped)];
		[self.scrollView setTransform:CGAffineTransformMakeScale(1, 1)];
		
	}
	[UIView commitAnimations];
}

- (void)onEditingAnimationStopped
{
	[self.scrollView setClipsToBounds:YES];
}

#pragma mark frame and sizes

/*
 Overwrite this to change size of scroll view.
 Default implementation fills the screen
 */
- (CGRect)scrollViewFrame
{
	return CGRectMake(0,0,[self.view bounds].size.width,[self.view bounds].size.height - 44);
}

- (CGSize)panelViewSize
{
	float width = [self scrollViewFrame].size.width;
	if ([self numberOfVisiblePanels]>1)
	{
		width = ([self scrollViewFrame].size.width-2*GAP*([self numberOfVisiblePanels]-1))/[self numberOfVisiblePanels];
	}
	
	return CGSizeMake(width,[self scrollViewFrame].size.height);
}

/*
 Overwrite this to change number of visible panel views
 */
- (int)numberOfVisiblePanels
{
	return 1;
}

#pragma mark adding and removing panels

- (void)addPage
{
	[self.scrollView setContentSize:CGSizeMake(([self panelViewSize].width+2*GAP)*[self numberOfPanels],self.scrollView.frame.size.width)];
}

- (void)removeCurrentPage
{
	if (self.currentPage==[self numberOfPanels] && self.currentPage!=0)
	{
		// this is the last page
		//numberOfPages -= 1;
		
		PanelView *panelView = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+self.currentPage];
		[panelView showPanel:NO animated:YES];
		[self removeContentOfPage:self.currentPage];
		
		[panelView performSelector:@selector(showPreviousPanel) withObject:nil afterDelay:0.4];
		[self performSelector:@selector(jumpToPreviousPage) withObject:nil afterDelay:0.6];
	}
	else if ([self numberOfPanels]==0)
	{
		PanelView *panelView = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+self.currentPage];
		[panelView showPanel:NO animated:YES];
		[self removeContentOfPage:self.currentPage];
	}
	else
	{
		PanelView *panelView = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+self.currentPage];
		[panelView showPanel:NO animated:YES];
		[self removeContentOfPage:self.currentPage];
		[self performSelector:@selector(pushNextPage) withObject:nil afterDelay:0.4];
	}
}

- (void)jumpToPreviousPage
{
	[self.scrollView setContentSize:CGSizeMake(([self panelViewSize].width+2*GAP)*[self numberOfPanels],self.scrollView.frame.size.width)];
}

- (void)pushNextPage
{
	[self.scrollView setContentSize:CGSizeMake(([self panelViewSize].width+2*GAP)*[self numberOfPanels],self.scrollView.frame.size.width)];
	
	for (int i=self.currentPage; i<[self numberOfVisiblePanels]; i++)
	{
		if (self.currentPage < [self numberOfPanels])
		{
			PanelView *panelView = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+i];
			[panelView showNextPanel];
			[panelView pageWillAppear];
            //TODO figure out whether this is working and whether there is a better place for this
            //            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            // [panelView.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
		}
		
	}
}

- (void)removeContentOfPage:(int)page
{
	
}

#pragma mark scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView_
{
	PanelView *panelView = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+self.currentPage];
	[panelView pageWillDisappear];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView_
{
	//NSLog(@"%@", scrollView_);
	[self tilePages];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_
{
	
	if (self.currentPage!=self.lastDisplayedPage)
	{
		PanelView *panelView = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+self.currentPage];
		[panelView pageDidAppear];
	}
	
	self.lastDisplayedPage = self.currentPage;
}

#pragma mark reuse table views

- (void)tilePages
{
	CGRect visibleBounds = [self.scrollView bounds];
	int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds)) * [self numberOfVisiblePanels];
	int lastNeededPageIndex = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds)) * [self numberOfVisiblePanels];
    
	firstNeededPageIndex = MAX(firstNeededPageIndex,0);
	lastNeededPageIndex = MIN(lastNeededPageIndex, [self numberOfPanels]-1) + [self numberOfVisiblePanels];
	
	if (self.isEditing) firstNeededPageIndex -= 1;
	
	if (firstNeededPageIndex<0) firstNeededPageIndex = 0;
	if (lastNeededPageIndex>=[self numberOfPanels]) lastNeededPageIndex = [self numberOfPanels]-1;
	
	self.currentPage = firstNeededPageIndex;
	
	for (PanelView *panel in self.visiblePages)
	{
		if (panel.pageNumber < firstNeededPageIndex || panel.pageNumber > lastNeededPageIndex)
		{
			[self.recycledPages addObject:panel];
			[panel removeFromSuperview];
			[panel shouldWiggle:NO];
		}
	}
	[self.visiblePages minusSet:self.recycledPages];
	
	for (int index=firstNeededPageIndex; index<=lastNeededPageIndex; index++)
	{
		if (![self isDisplayingPageForIndex:index])
		{
			PanelView *panel = [self panelForPage:index];
			int x = ([self panelViewSize].width+2*GAP)*index + GAP;
            //CHANGED HERE TO MAKE IT SIT BELOW THE TITLE BAR
			CGRect panelFrame = CGRectMake(x,47,[self panelViewSize].width,[self scrollViewFrame].size.height);
			
			[panel setFrame:panelFrame];
			[panel setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
			[panel setDelegate:self];
			[panel setTag:TAG_PAGE+index];
			[panel setPageNumber:index];
			[panel pageWillAppear];
			[self.scrollView addSubview:panel];
			[self.visiblePages addObject:panel];
			[panel shouldWiggle:self.isEditing];
		}
	}
}

- (BOOL)isDisplayingPageForIndex:(int)index
{
	for (PanelView *page in self.visiblePages)
	{
		if (page.pageNumber==index) return YES;
	}
	return NO;
}

- (void)configurePage:(PanelView*)page forIndex:(int)index
{
	int x = ([self.view bounds].size.width+2*GAP)*index + GAP;
	CGRect pageFrame = CGRectMake(x,0,[self.view bounds].size.width,[self.view bounds].size.height);
	[page setFrame:pageFrame];
	[page setPageNumber:index];
	[page pageWillAppear];
}

- (PanelView*)dequeueReusablePageWithIdentifier:(NSString*)identifier
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.identifier == %@", identifier];
	NSSet *filteredSet =[self.recycledPages filteredSetUsingPredicate:predicate];
	PanelView *page = [filteredSet anyObject];
	if (page)
	{
		//[[page retain] autorelease];
		[self.recycledPages removeObject:page];
	}
	return page;
}

#pragma mark panel views

- (PanelView *)panelViewAtPage:(NSInteger)page
{
	PanelView *panelView = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+page];
	return panelView;
}

- (PanelView *)panelForPage:(NSInteger)page
{
	static NSString *identifier = @"PanelTableView";
	PanelView *panelView = (PanelView*)[self dequeueReusablePageWithIdentifier:identifier];
	if (panelView == nil)
	{
		panelView = [[PanelView alloc] initWithIdentifier:identifier];
	}
    return panelView;
}

- (NSInteger)numberOfPanels
{
	return 0;
}

- (CGFloat)panelView:(PanelView *)panelView heightForRowAtIndexPath:(PanelIndexPath *)indexPath
{
	return 50;
}

- (UITableViewCell *)panelView:(PanelView *)panelView cellForRowAtIndexPath:(PanelIndexPath *)indexPath
{
	static NSString *identity = @"UITableViewCell";
	UITableViewCell *cell = (UITableViewCell*)[panelView.tableView dequeueReusableCellWithIdentifier:identity];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
	}
	return cell;
}

- (NSInteger)panelView:(PanelView *)panelView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section
{
	return 0;
}

- (void)panelView:(PanelView *)panelView didSelectRowAtIndexPath:(PanelIndexPath *)indexPath
{
	
}

- (NSInteger)panelView:(id)panelView numberOfSectionsInPage:(NSInteger)pageNumber
{
    //Can control the number of sections from here.
	return 1;
}

- (NSString*)panelView:(id)panelView titleForHeaderInPage:(NSInteger)pageNumber section:(NSInteger)section
{
	return [NSString stringWithFormat:@"Page %i Section %i", pageNumber, section];
}

//Our Own Custom Implementations!
- (void)panelView:(id)panelView accessoryButtonTappedForRowInPage:(NSInteger)pageNumber withIndexPath:(PanelIndexPath*)indexPath
{
    
}

- (UIView *)panelView:(id)panelView viewForHeaderInPage:(NSInteger)pageNumber section:(NSInteger)section
{
    return nil;
}

- (void)reloadData:(PanelView *)panelView{
    [panelView.tableView reloadData];
}

- (void)reloadAllTables{
    for (PanelView *p in self.visiblePages) {
        [p.tableView reloadData];
    }
}

- (PanelIndexPath *)indexForCell:(UITableViewCell *)cell{
    NSIndexPath *temp;
    PanelView *p = [self panelViewAtPage:self.currentPage];

    temp = [p.tableView indexPathForCell:cell];
        if (temp != NULL){
            PanelIndexPath *result = [[PanelIndexPath alloc] initWithRow:temp.row section:temp.section page:self.currentPage];
            return result;
        }
    return nil;
}

-(void)skipToOffset:(int)offset
{
    [self.scrollView setContentOffset:CGPointMake((self.panelViewSize.width + 2*GAP) * offset, 0)];
}

- (void)fixWeekends:(int)visible{
    [self.scrollView setContentSize:CGSizeMake(([self panelViewSize].width+2*GAP)*visible,self.scrollView.frame.size.width)];
}


@end
