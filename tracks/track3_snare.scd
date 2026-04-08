// ============================================================
//  tracks/track3_snare.scd — 🪘 SNARE 1 & 2
//  Output: bus 2 (Track 3)
//
//  SynthDefs available (from synthdefs/snare_defs.scd):
//    \snare1     — classic noise + tone snare (full, snappy)
//    \snare2     — tight rimshot-style snare (dry, cracky)
//    \snare_fat  — wide roomy snare (low-end, wide)
//
//  WORKFLOW:
//    1. Run boot.scd first
//    2. Choose a snare pattern block and evaluate it
//    3. Mix snare1 + snare2 using two Pdefs simultaneously
//    4. Use STOP section at the bottom to silence this track
// ============================================================

// ============================================================
//  QUICK START — basic snare on beats 2 and 4
// ============================================================
(
Pdef(\snare, Pbind(
    \instrument, \snare1,
    \out,  2,
    \dur,  Pseq([\rest, 1, \rest, 1], inf),  // beats 2 and 4
    \amp,  0.75,
    \freq, 200,
    \decay, 0.15
)).play;
)

// ============================================================
//  SNARE 1 PATTERNS
// ============================================================

// -- Classic 2/4 snare ------------------------------------------
(
Pdef(\snare1, Pbind(
    \instrument, \snare1,
    \out,  2,
    \dur,  Pseq([\rest, 1, \rest, 1], inf),
    \amp,  Pseq([0.8, 0.8], inf),
    \freq, 200,
    \decay, 0.15,
    \toneAmp,  0.5,
    \noiseAmp, 0.6
)).play;
)

// -- Snare with ghost notes (quiet 16th hits) --------------------
(
Pdef(\snare1, Pbind(
    \instrument, \snare1,
    \out,  2,
    \dur,  Pseq([0.25], inf),
    \amp,  Pseq([
        \rest, \rest, \rest, \rest,  // beat 1
        0.75, \rest, 0.25, \rest,   // beat 2 (main + ghost)
        \rest, \rest, 0.2, \rest,   // beat 3 (ghost)
        0.8, \rest, 0.3, \rest      // beat 4 (main + ghost)
    ], inf),
    \freq, 200,
    \decay, Prand([0.15, 0.08], inf)
)).play;
)

// ============================================================
//  SNARE 2 PATTERNS (layer with snare1 for texture)
// ============================================================

// -- Tight rimshot on offbeats -----------------------------------
(
Pdef(\snare2, Pbind(
    \instrument, \snare2,
    \out,   2,
    \dur,   Pseq([\rest, 0.5, 0.5, \rest, 0.5, 0.5], inf),
    \amp,   Pseq([0.5, 0.4, 0.6, 0.5], inf),
    \freq,  350,
    \decay, 0.06
)).play;
)

// -- Snare2 as fill ----------------------------------------------
(
Pdef(\snare2fill, Pbind(
    \instrument, \snare2,
    \out,  2,
    \dur,  Pseq([0.125], inf),
    \amp,  Pseq([
        \rest, \rest, \rest, \rest, \rest, \rest, \rest, \rest,  // bars 1-2
        \rest, \rest, \rest, \rest, \rest, \rest, \rest, \rest,
        \rest, \rest, \rest, \rest, \rest, \rest, \rest, \rest,  // bars 3
        0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85             // fill in bar 4
    ], inf),
    \freq, 380
)).play;
)

// ============================================================
//  FAT SNARE PATTERNS
// ============================================================

// -- Fat snare on beats 2 and 4 (roomy) -------------------------
(
Pdef(\snare, Pbind(
    \instrument, \snare_fat,
    \out,  2,
    \dur,  Pseq([\rest, 1, \rest, 1], inf),
    \amp,  0.7,
    \freq, 160,
    \decay, 0.3
)).play;
)

// ============================================================
//  DUAL-LAYER SNARE (snare1 + snare2 together)
// ============================================================
(
// Snare 1: main hits
Pdef(\snare1, Pbind(
    \instrument, \snare1,
    \out,  2, \dur, Pseq([\rest, 1, \rest, 1], inf),
    \amp, 0.8, \freq, 200, \decay, 0.15
)).play;

// Snare 2: rimshot layers for extra crack
Pdef(\snare2, Pbind(
    \instrument, \snare2,
    \out,  2, \dur, Pseq([\rest, 1, \rest, 1], inf),
    \amp, 0.5, \freq, 320, \decay, 0.07
)).play;
)

// ============================================================
//  STOP
// ============================================================

// Stop individual layers:
// Pdef(\snare1).stop;
// Pdef(\snare2).stop;
// Pdef(\snare2fill).stop;

// Stop all snare patterns:
// Pdef(\snare).stop;
// [\snare, \snare1, \snare2, \snare2fill].do { |n| Pdef(n).stop };
