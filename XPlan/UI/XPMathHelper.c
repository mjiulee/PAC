//
//  XPMathHelper.c
//  XPlan
//
//  Created by mjlee on 14-3-18.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#include <stdio.h>
#include "XPMathHelper.h"

CGRect CGRectZoom(CGRect rect, CGFloat dx, CGFloat dy)
{
    rect.origin.x    += dx/2;
    rect.origin.y    += dy/2;
    rect.size.width  -= dx;
    rect.size.height -= dy;
    return rect;
}