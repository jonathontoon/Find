//
// Created by Alex Manarpies on 09/01/15.
// www.aceontech.com
//
//
// Copyright (c) 2015 Alex Manarpies
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
* Akin to CGRectIntegral, CGPointIntegral aligns a CGPoint to the screen's pixel boundaries by rounding its values appropriately.
* This avoids the blurry anti-aliasing seen when drawing fractional coordinates (e.g. 20.224). Depending on the screen's
* scale (retina), the following rounding rules are applied:
*
*   - Scale 1 (non-retina): round to pure integral values, e.g. 44
*   - Scale 2 (retina): round to half integrals (if necessary), e.g. 44.5
*   - Scale 3 (retina plus): round to thirds (if necessary), e.g. 44.66
*/
extern CGPoint CGPointIntegral(CGPoint point);

extern CGPoint CGPointIntegralWithScale(CGPoint point, CGFloat scale);