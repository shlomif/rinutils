// SPDX-License-Identifier: MIT
// This file is part of rinutils. It is subject to the license terms in
// the LICENSE file found in the top-level directory of this distribution
// and at https://github.com/shlomif/rinutils/ . No part of
// rinutils, including this file, may be copied, modified, propagated,
// or distributed except according to the terms contained in the LICENSE file.
//
// Copyright (c) 2010 Shlomi Fish

// longlong.h - mostly portable long long handling routines. Works on Win32 and
// UNIX-like systems.
#pragma once
#ifdef __cplusplus
extern "C" {
#endif

#ifndef WIN32
#define RIN_LL_FMT "%lld"
#define RIN_ULL_FMT "%llu"
#define RIN_LL6_FMT "%.6lld"
#define RIN_LL9_FMT "%09lld"
#else
#define RIN_LL_FMT "%I64d"
#define RIN_ULL_FMT "%I64u"
#define RIN_LL6_FMT "%.6I64d"
#define RIN_LL9_FMT "%09I64d"
#endif

#ifdef __cplusplus
};
#endif
