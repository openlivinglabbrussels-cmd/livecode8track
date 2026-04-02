// ============================================================
//  tracks/track1_kick.scd — 🥁 KICK DRUM
//  Output: bus 0 (Track 1)
//
//  SynthDefs available (from synthdefs/kick_defs.scd):
//    \kick_808   — classic sine sweep (deep, boomy)
//    \kick_noise — transient + filtered noise body
//    \kick_fm    — FM synthesis kick (punchy, metallic)
//
//  WORKFLOW:
//    1. Run boot.scd first
//    2. Select a pattern block below and evaluate it
//    3. Modify parameters live — changes take effect immediately
//    4. Use the STOP section at the bottom to silence this track
// ============================================================

// ============================================================
//  QUICK START — evaluate this block to get a basic kick going
// ============================================================
(
Pdef(\kick, Pbind(
    \instrument, \kick_808,
    \out,        0,
    \dur,        0.5,       // 0.5 = eighth notes at 120 BPM
    \amp,        0.85,
    \freq,       60,
    \sweep,      180,
    \sweepTime,  0.07,
    \decay,      0.5
)).play;
)

// ============================================================
//  PATTERNS — uncomment and modify these live
// ============================================================

// -- Four-on-the-floor -------------------------------------------
(
Pdef(\kick, Pbind(
    \instrument, \kick_808,
    \out,  0,
    \dur,  1,              // quarter notes
    \amp,  0.9,
    \freq, 60,
    \decay, 0.5
)).play;
)

// -- Syncopated kick pattern -------------------------------------
(
Pdef(\kick, Pbind(
    \instrument, \kick_808,
    \out,  0,
    \dur,  Pseq([1, 0.5, 0.5, 1, 1], inf),
    \amp,  Pseq([0.9, 0.7, 0.6, 0.85, 0.9], inf),
    \freq, 60,
    \decay, Pseq([0.5, 0.3, 0.3, 0.5, 0.5], inf)
)).play;
)

// -- Noise kick (harder, industrial) ----------------------------
(
Pdef(\kick, Pbind(
    \instrument, \kick_noise,
    \out,  0,
    \dur,  Pseq([1, 1, 0.5, 0.5], inf),
    \amp,  Pseq([0.8, 0.6, 0.5, 0.7], inf),
    \freq, 80,
    \res,  0.3,
    \decay, 0.3
)).play;
)

// -- FM kick (metallic punch) ------------------------------------
(
Pdef(\kick, Pbind(
    \instrument, \kick_fm,
    \out,   0,
    \dur,   Pseq([1, 0.75, 0.25, 1], inf),
    \amp,   0.85,
    \freq,  50,
    \ratio, 2.5,
    \index, 4,
    \decay, 0.4
)).play;
)

// -- Kick with velocity accents ----------------------------------
(
Pdef(\kick, Pbind(
    \instrument, \kick_808,
    \out,  0,
    \dur,  Pseq([1, 1, 0.5, 0.5], inf),
    \amp,  Pseq([0.95, 0.55, 0.65, 0.75], inf),  // velocity accents
    \freq, Pseq([55, 60, 58, 60], inf),            // slight pitch variation
    \decay, Pseq([0.55, 0.35, 0.3, 0.4], inf)
)).play;
)

// -- Trap-style kick (16th grid) ---------------------------------
(
Pdef(\kick, Pbind(
    \instrument, \kick_808,
    \out,  0,
    \dur,  Pseq([0.25], inf),
    \amp,  Pseq([0.9, \rest, \rest, \rest,   // beat 1
                 \rest, \rest, \rest, \rest,  // beat 2 (rest)
                 0.85, \rest, \rest, \rest,   // beat 3
                 \rest, \rest, 0.7, \rest],   // beat 4 (with late hit)
               inf),
    \freq, 55,
    \decay, 0.6
)).play;
)

// ============================================================
//  LIVE TWEAKING — modify individual parameters in real time
// ============================================================

// Change decay on the fly:
// Pdef(\kick).set(\decay, 0.8);

// Change tempo (affects all tracks):
// TempoClock.default.tempo = 130/60;

// ============================================================
//  STOP
// ============================================================

// Stop only this track:
// Pdef(\kick).stop;

// Fade out (stop after current cycle):
// Pdef(\kick).stop;

// Free the Pdef completely:
// Pdef(\kick).clear;
