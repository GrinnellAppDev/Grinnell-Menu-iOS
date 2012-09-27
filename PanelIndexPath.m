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

#import "PanelIndexPath.h"


@implementation PanelIndexPath

- (id)initWithRow:(int)row section:(int)section page:(int)page
{
	if (self = [super init])
	{
		_row = row;
		_section = section;
		_page = page;
	}
	return self;
}

+ (id)panelIndexPathForRow:(int)row section:(int)section page:(int)page
{
	return [[self alloc] initWithRow:row section:section page:page];
}

+ (id)panelIndexPathForPage:(int)page indexPath:(NSIndexPath*)indexPath
{
	return [[self alloc] initWithRow:indexPath.row section:indexPath.section page:page];
}

-(NSString *)description {
    return [NSString stringWithFormat:@"Page: %d, Section: %d, Row: %d", self.page, self.section, self.row];
}

@end
