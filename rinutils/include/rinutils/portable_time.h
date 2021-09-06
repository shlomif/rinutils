// SPDX-License-Identifier: MIT
// This file is part of rinutils. It is subject to the license terms in
// the LICENSE file found in the top-level directory of this distribution
// and at https://github.com/shlomif/rinutils/ . No part of
// rinutils, including this file, may be copied, modified, propagated,
// or distributed except according to the terms contained in the LICENSE file.
//
// Copyright (c) 2010 Shlomi Fish

// portable_time.h - mostly portable time handling routines. Works on Win32 and
// UNIX-like systems.
#pragma once
#ifdef __cplusplus
extern "C" {
#endif

#include "rinutils/longlong.h"
#include "rinutils/typeof_wrap.h"
#include <stdio.h>

#ifndef WIN32
#include <sys/time.h>

typedef struct
{
    struct timeval tv;
    struct timezone tz;
} rinutils_portable_time;

#define RIN_GET_TIME(pt) gettimeofday(&((pt).tv), &((pt).tz))
#define RIN_TIME_GET_SEC(pt) ((long long)((pt).tv.tv_sec))
#define RIN_TIME_GET_USEC(pt) ((long long)((pt).tv.tv_usec))
#else
#include <sys/types.h>
#include <sys/timeb.h>

typedef struct
{
    struct _timeb tb;
} rinutils_portable_time;

#define RIN_GET_TIME(pt) _ftime(&((pt).tb))
#define RIN_TIME_GET_SEC(pt) ((long long)((pt).tb.time))
#define RIN_TIME_GET_USEC(pt) ((long long)(((pt).tb.millitm) * 1000))
#endif

#define RIN_TIME__GET_BOTH(pt) RIN_TIME_GET_SEC(pt), RIN_TIME_GET_USEC(pt)

static inline rinutils_portable_time rinutils_get_time(void)
{
    rinutils_portable_time ret;
    RIN_GET_TIME(ret);
    return ret;
}
#define RIN_TIME_FMT RIN_LL_FMT "." RIN_LL6_FMT

#ifdef __cplusplus
};
#endif
