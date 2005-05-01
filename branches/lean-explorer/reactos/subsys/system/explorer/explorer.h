/*
 * Copyright 2003, 2004 Martin Fuchs
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */


 //
 // Explorer clone, lean version
 //
 // explorer.h
 //
 // Martin Fuchs, 23.07.2003
 //


#include "utility/shellclasses.h"

#include "shell/entries.h"

#include "shell/winfs.h"
#include "shell/shellfs.h"

#include "utility/window.h"


#define	IDW_STATUSBAR			0x100
#define	IDW_TOOLBAR				0x101
#define	IDW_FIRST_CHILD			0xC000	/*0x200*/


#define	PM_GET_CONTROLWINDOW	(WM_APP+0x16)

#define	PM_RESIZE_CHILDREN		(WM_APP+0x17)
#define	PM_GET_WIDTH			(WM_APP+0x18)


#define	CLASSNAME_FRAME 		TEXT("CabinetWClass")	// same class name for frame window as in MS Explorer

#define	CLASSNAME_CHILDWND		TEXT("WFS_Child")
#define	CLASSNAME_WINEFILETREE	TEXT("WFS_Tree")


#include "shell/shellbrowser.h"

#ifndef ROSSHELL
#include "shell/mainframe.h"
#endif
