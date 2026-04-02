// ============================================================
//  tracks/track5_perc.scd — 🔔 PERCUSSION
//  Output: bus 4 (Track 5)
//
//  SynthDefs available (from synthdefs/perc_defs.scd):
//    \clap       — electronic clap (layered noise bursts)
//    \rimshot    — rimshot / sidestick
//    \shaker     — shaker / maraca texture
//    \cowbell    — 808-style cowbell
//
//  WORKFLOW:
//    1. Run boot.scd first
//    2. Choose a percussion pattern block and evaluate it
//    3. Layer multiple percussion Pdefs together
//    4. Use STOP section at the bottom to silence this track
// ============================================================

// ============================================================
//  QUICK START — clap on beats 2 and 4
// ============================================================
(
Pdef(\perc, Pbind(
    \instrument, \clap,
    \out,  4,
    \dur,  Pseq([\rest, 1, \rest, 1], inf),
    \amp,  0.7,
    \decay, 0.18
)).play;
)

// ============================================================
//  CLAP PATTERNS
// ============================================================

// -- Classic clap on 2 and 4 ------------------------------------
(
Pdef(\clap, Pbind(
    \instrument, \clap,
    \out,   4,
    \dur,   Pseq([\rest, 1, \rest, 1], inf),
    \amp,   0.75,
    \decay, 0.2
)).play;
)

// -- Clap roll / flam effect ------------------------------------
(
Pdef(\clap, Pbind(
    \instrument, \clap,
    \out,   4,
    \dur,   Pseq([\rest, \rest, \rest, 0.75, 0.083, 0.083, 0.083], inf),
    \amp,   Pseq([0.3, 0.4, 0.5, 0.7, 0.75, 0.8, 0.85], inf),
    \decay, 0.15
)).play;
)

// ============================================================
//  RIMSHOT PATTERNS
// ============================================================

// -- Rimshot on offbeats ----------------------------------------
(
Pdef(\rim, Pbind(
    \instrument, \rimshot,
    \out,   4,
    \dur,   Pseq([0.5, \rest, 0.5, \rest], inf),
    \amp,   Pseq([0.6, 0.5], inf),
    \freq,  800,
    \decay, 0.06
)).play;
)

// -- Tight rimshot fills ----------------------------------------
(
Pdef(\rim, Pbind(
    \instrument, \rimshot,
    \out,   4,
    \dur,   Pseq([0.25], inf),
    \amp,   Prand([\rest, 0.3, 0.4, 0.5, 0.35], inf),
    \freq,  Prand([700, 800, 900, 600], inf)
)).play;
)

// ============================================================
//  SHAKER PATTERNS
// ============================================================

// -- Shaker running 8ths ----------------------------------------
(
Pdef(\shaker, Pbind(
    \instrument, \shaker,
    \out,  4,
    \dur,  0.5,
    \amp,  Prand([0.3, 0.25, 0.35, 0.28], inf),
    \freq, Prand([5500, 6000, 6500, 7000], inf),
    \decay, 0.05
)).play;
)

// -- Shaker on 16ths with accents --------------------------------
(
Pdef(\shaker, Pbind(
    \instrument, \shaker,
    \out,  4,
    \dur,  0.25,
    \amp,  Pseq([0.4, 0.2, 0.3, 0.2], inf),
    \freq, 6000
)).play;
)

// ============================================================
//  COWBELL PATTERNS
// ============================================================

// -- Cowbell accent on beat 1 -----------------------------------
(
Pdef(\cowbell, Pbind(
    \instrument, \cowbell,
    \out,   4,
    \dur,   Pseq([1, \rest, \rest, \rest], inf),
    \amp,   0.55,
    \freq,  562,
    \decay, 0.4
)).play;
)

// -- Cowbell groove (the more cowbell pattern) -------------------
(
Pdef(\cowbell, Pbind(
    \instrument, \cowbell,
    \out,   4,
    \dur,   Pseq([0.5, 0.5, 0.25, 0.75, 0.5, 0.5, 0.25, 0.75], inf),
    \amp,   Pseq([0.6, 0.4, 0.35, 0.5, 0.55, 0.4, 0.35, 0.5], inf),
    \freq,  562,
    \decay, Pseq([0.4, 0.2, 0.15, 0.3], inf)
)).play;
)

// ============================================================
//  FULL PERCUSSION GROOVE (all layers)
// ============================================================
(
// Clap on 2 and 4
Pdef(\clap, Pbind(
    \instrument, \clap,
    \out,  4, \dur, Pseq([\rest, 1, \rest, 1], inf),
    \amp,  0.7, \decay, 0.18
)).play;

// Shaker running
Pdef(\shaker, Pbind(
    \instrument, \shaker,
    \out,  4, \dur, 0.5,
    \amp,  Prand([0.25, 0.3, 0.28, 0.22], inf)
)).play;

// Rim on offbeats
Pdef(\rim, Pbind(
    \instrument, \rimshot,
    \out,  4, \dur, Pseq([\rest, 0.5, 0.5, \rest], inf),
    \amp,  0.45, \freq, 780
)).play;
)

// ============================================================
//  STOP
// ============================================================

// Stop individual percussion layers:
// Pdef(\clap).stop;
// Pdef(\rim).stop;
// Pdef(\shaker).stop;
// Pdef(\cowbell).stop;

// Stop everything on this track:
// [\perc, \clap, \rim, \shaker, \cowbell].do { |n| Pdef(n).stop };
