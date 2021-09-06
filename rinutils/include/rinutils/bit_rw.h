// SPDX-License-Identifier: MIT
// This file is part of Black Hole Solitaire Solver. It is subject to the
// license terms in the LICENSE file found in the top-level directory of this
// distribution and at
// https://www.shlomifish.org/open-source/projects/black-hole-solitaire-solver/
// . No part of Black Hole Solitaire Solver, including this file, may be
// copied, modified, propagated, or distributed except according to the terms
// contained in the LICENSE file.
//
// Copyright (c) 2010 Shlomi Fish

// rinutils/bit_rw.h - bit readers and writers.
// Note that it is not included in rinutils.h.
#pragma once
#include <stdint.h>
#include <stddef.h>

#define NUM_BITS_IN_BYTES 8

typedef uint_fast32_t rin_bit_data;
typedef uint8_t rin_uchar;

typedef struct
{
    rin_uchar *current;
    uint_fast32_t bit_in_char_idx;
    rin_uchar *start;
} rin_bit_writer;

static inline void rin_bit_writer_init(
    rin_bit_writer *const writer, rin_uchar *const start)
{
    writer->start = writer->current = start;
    writer->bit_in_char_idx = 0;
}

static inline void rin_bit_writer_init_and_clear(
    rin_bit_writer *const writer, rin_uchar *const start)
{
    *(writer->start = writer->current = start) = 0;
    writer->bit_in_char_idx = 0;
}

static inline void rin_bit_writer_write(
    rin_bit_writer *const writer, uint_fast32_t len, rin_bit_data data)
{
    for (; len; --len, (data >>= 1))
    {
        *(writer->current) |= ((data & 0x1) << (writer->bit_in_char_idx++));
        if (writer->bit_in_char_idx == NUM_BITS_IN_BYTES)
        {
            *(++writer->current) = 0;
            writer->bit_in_char_idx = 0;
        }
    }
}

static inline void rin_bit_writer_overwrite(
    rin_bit_writer *const writer, uint_fast32_t len, rin_bit_data data)
{
    rin_uchar *current = writer->current;
    rin_uchar c = *(current);
    uint_fast32_t bit_in_char_idx = writer->bit_in_char_idx;
    for (; len; --len, (data >>= 1))
    {
        c &= (~(1 << (bit_in_char_idx)));
        c |= ((data & 0x1) << (bit_in_char_idx));
        if (++bit_in_char_idx == NUM_BITS_IN_BYTES)
        {
            *(current) = c;
            c = *(++current);
            bit_in_char_idx = 0;
        }
    }
    *(writer->current = current) = c;
    writer->bit_in_char_idx = bit_in_char_idx;
}

typedef struct
{
    const rin_uchar *current;
    uint_fast32_t bit_in_char_idx;
    const rin_uchar *start;
} rin_bit_reader;

static inline void rin_bit_reader_init(
    rin_bit_reader *const reader, const rin_uchar *const start)
{
    reader->start = reader->current = start;
    reader->bit_in_char_idx = 0;
}

static inline void rin_bit_reader_skip(
    rin_bit_reader *const reader, uint_fast32_t len)
{
    if (len <= 7 - reader->bit_in_char_idx)
    {
        reader->bit_in_char_idx += len;
        return;
    }
    len -= 8 - reader->bit_in_char_idx;
    reader->bit_in_char_idx = 0;
    ++reader->current;
    reader->current += (len >> 3);
    reader->bit_in_char_idx += (len & 7);
}

static inline rin_bit_data rin_bit_reader_read(
    rin_bit_reader *const reader, const uint_fast32_t len)
{
    rin_bit_data ret = 0;

    rin_uchar c = *(reader->current);
    uint_fast32_t bit_in_char_idx = reader->bit_in_char_idx;
    for (uint_fast32_t idx = 0; idx < len; ++idx)
    {
        ret |= ((rin_bit_data)((c >> (bit_in_char_idx)) & 0x1) << idx);

        if (++bit_in_char_idx == NUM_BITS_IN_BYTES)
        {
            c = *(++reader->current);
            bit_in_char_idx = 0;
        }
    }
    reader->bit_in_char_idx = bit_in_char_idx;

    return ret;
}
static inline void rin_bit_writer_skip(
    rin_bit_writer *const writer, uint_fast32_t len)
{
    if (len <= 7 - writer->bit_in_char_idx)
    {
        writer->bit_in_char_idx += len;
        return;
    }
    len -= 8 - writer->bit_in_char_idx;
    writer->bit_in_char_idx = 0;
    ++writer->current;
    writer->current += (len >> 3);
    writer->bit_in_char_idx += (len & 7);
}
