/*
 * This file is part of Freecell Solver. It is subject to the license terms in
 * the COPYING.txt file found in the top-level directory of this distribution
 * and at http://fc-solve.shlomifish.org/docs/distro/COPYING.html . No part of
 * Freecell Solver, including this file, may be copied, modified, propagated,
 * or distributed except according to the terms contained in the COPYING file.
 *
 * Copyright (c) 2010 Shlomi Fish
 */
// likely.h - the purpose of this file is to define the likely
// and unlikely macros. See: https://lwn.net/Articles/255364/ .
#pragma once

#if !defined(likely)
#if defined(__cplusplus)
// https://stackoverflow.com/a/43870188/1067003
#define likely(x) __builtin_expect(static_cast<bool>((x)), 1)
#define unlikely(x) __builtin_expect(static_cast<bool>((x)), 0)
#else
#define likely(x) __builtin_expect(!!(x), 1)
#define unlikely(x) __builtin_expect(!!(x), 0)
#endif
#endif
