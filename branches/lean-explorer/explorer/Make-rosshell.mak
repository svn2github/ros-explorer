#
#  ReactOS lean shell
#
#  Makefile
#

# Windows is default host environment
ifeq ($(HOST),)
HOST = mingw32-windows
endif

ifeq ($(HOST),mingw32-linux)
CC = mingw32-gcc
CXX = mingw32-g++
LINK = mingw32-g++
RC = mingw32-windres
CD_PREFIX := ./
PREFIX = mingw32-
EXE_POSTFIX :=
EXE_PREFIX := ./
endif

ifeq ($(HOST),mingw32-windows)
CC = gcc
CXX = g++
LINK = g++
RC = windres
CD_PREFIX := 
PREFIX =
EXE_PREFIX :=
EXE_POSTFIX := .exe
endif

PATH_TO_TOP = ../../..
TOOLS_PATH = $(PATH_TO_TOP)/tools

ifndef UNICODE
UNICODE = 1
endif

CFLAGS	= -I./ -DWIN32 -D_ROS_ -D_WIN32_IE=0x0501 -D_WIN32_WINNT=0x0501 -fexceptions -Wall
RCFLAGS	= -DWIN32 -D_ROS_ -D__WINDRES__
LFLAGS	= -Wl,--subsystem,windows

ifdef DEBUG
CFLAGS	+= -D_DEBUG -g
RCFLAGS	+= -D_DEBUG
LFLAGS	+= -g
else
CFLAGS	+= -DNDEBUG -Os -D_NO_CONTEXT
RCFLAGS	+= -DNDEBUG
LFLAGS	+= -s
endif

ifeq ($(UNICODE),1)
CFLAGS	+= -DUNICODE
# LFLAGS+= -Wl,--entry,_wWinMain@16
RCFLAGS += -DUNICODE
endif

CXXFLAGS = $(CFLAGS)

EXEC_SUFFIX = .exe
RES_SUFFIX = .coff

VPATH = shell utility taskbar desktop dialogs

PROGRAM = rosshell

TARGET = $(PROGRAM)$(EXEC_SUFFIX)

OBJECTS = \
	startup.o \
	shellclasses.o \
	utility.o \
	window.o \
	dragdropimpl.o \
	shellbrowserimpl.o \
	explorer.o \
	entries.o \
	shellfs.o \
	desktop.o \
	desktopbar.o \
	taskbar.o \
	startmenu.o \
	traynotify.o \
	quicklaunch.o \
	settings.o

LIBS = gdi32 comctl32 ole32 uuid

.PHONY: all depends implib clean install dist bootcd depends

all: $(TARGET)

ever:

$(TARGET): $(OBJECTS) $(PROGRAM)$(RES_SUFFIX)
	$(LINK) $(LFLAGS) -o $@ $^ $(addprefix -l,$(LIBS))

$(PROGRAM)$(RES_SUFFIX): explorer_intres.rc res/*.bmp res/*.ico
	$(RC) $(RCFLAGS) -o $@ explorer_intres.rc

clean:
	$(TOOLS_PATH)/rdel $(TARGET) $(OBJECTS) $(PROGRAM)$(RES_SUFFIX) \
	desktop/*.o dialogs/*.o shell/*.o taskbar/*.o utility/*.o

# Use environment var ROS_INSTALL to override default install dir
ifneq ($(ROS_INSTALL),)
INSTALL_DIR = $(ROS_INSTALL)
else
ifeq ($(HOST),mingw32-windows)
INSTALL_DIR = C:/reactos
else
INSTALL_DIR = $(PATH_TO_TOP)/reactos
endif
endif

implib:

install:
	-$(TOOLS_PATH)/rcopy $(TARGET) $(INSTALL_DIR)/$(TARGET)

bootcd:


# dependency scanning

DEP_FILTERED := $(filter-out $(DEP_EXCLUDE_FILTER), $(OBJECTS:.o=.d))
DEP_FILES := $(join $(dir $(DEP_FILTERED)), $(addprefix ., $(notdir $(DEP_FILTERED))))

ifneq ($(MAKECMDGOALS),clean)
-include $(DEP_FILES)
endif

ifeq ($(HOST),mingw32-windows)
DEPENDS_EXE := ..\..\..\tools\depends
else
DEPENDS_EXE := $(TOOLS_PATH)/depends
endif

.%.d: %.c $(PATH_TO_TOP)/tools/depends$(EXE_POSTFIX)
	$(CC) $(CFLAGS) -M $< | $(DEPENDS_EXE) $(@D) $@

.%.d: %.cpp $(PATH_TO_TOP)/tools/depends$(EXE_POSTFIX)
	$(CC) $(CFLAGS) -M $< | $(DEPENDS_EXE) $(@D) $@

