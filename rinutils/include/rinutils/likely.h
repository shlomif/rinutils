// This file is part of Freecell Solver. It is subject to the license terms in
// the COPYING.txt file found in the top-level directory of this distribution
// and at http://fc-solve.shlomifish.org/docs/distro/COPYING.html . No part of
// Freecell Solver, including this file, may be copied, modified, propagated,
// or distributed except according to the terms contained in the COPYING file.
//
// Copyright (c) 2010 Shlomi Fish
// likely.h - the purpose of this file is to define the likely
// and unlikely macros. See: https://lwn.net/Articles/255364/ .
#pragma once

#if !defined(likely)
// compilers known to support it: gnu gcc, intel icc, clang, IBM C, Cray C
#if defined(__GNUC__) || defined(__INTEL_COMPILER) || defined(__clang__) ||    \
    (defined(__IBMC__) || defined(__IBMCPP__)) || defined(_CRAYC)
#if defined(__cplusplus)
// https://stackoverflow.com/a/43870188/1067003
#define likely(x) __builtin_expect(static_cast<bool>((x)), 1)
#define unlikely(x) __builtin_expect(static_cast<bool>((x)), 0)
#else
#define likely(x) __builtin_expect(!!(x), 1)
#define unlikely(x) __builtin_expect(!!(x), 0)
#endif
#else
// compilers known to _not_ support it: tcc (TinyC), msvc, Digital Mars
#if defined(__TINYC__) || defined(_MSC_VER) || defined(__DMC__)
#define likely(x) (x)
#define unlikely(x) (x)
#else
// unknown compiler
#warning support for __builtin_expect() is unknown on this compiler. please submit a bugreport.
#define likely(x) (x)
#define unlikely(x) (x)
#endif
#endif
#endif
