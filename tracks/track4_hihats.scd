// ============================================================
//  tracks/track4_hihats.scd — 🎩 HI-HATS
//  Output: bus 3 (Track 4)
//
//  SynthDefs available (from synthdefs/hihat_defs.scd):
//    \hihat_closed — short, tight closed hi-hat
//    \hihat_open   — longer, open hi-hat with ring
//    \hihat_pedal  — foot hi-hat (chick), very short
//
//  WORKFLOW:
//    1. Run boot.scd first
//    2. Choose a hi-hat pattern block and evaluate it
//    3. Mix closed + open hats using multiple Pdefs
//    4. Use STOP section at the bottom to silence this track
// ============================================================

// ============================================================
//  QUICK START — eighth-note closed hats
// ============================================================
(
Pdef(\hats, Pbind(
    \instrument, \hihat_closed,
    \out,  3,
    \dur,  0.5,         // eighth notes
    \amp,  Pseq([0.6, 0.4, 0.55, 0.4, 0.6, 0.4, 0.55, 0.4], inf),
    \decay, 0.04
)).play;
)

// ============================================================
//  CLOSED HI-HAT PATTERNS
// ============================================================

// -- Straight 8ths with velocity variation ----------------------
(
Pdef(\hats_closed, Pbind(
    \instrument, \hihat_closed,
    \out,   3,
    \dur,   0.5,
    \amp,   Prand([0.5, 0.4, 0.6, 0.45, 0.55], inf),
    \decay, 0.04,
    \tone,  8000
)).play;
)

// -- 16th note pattern with rests (trap style) ------------------
(
Pdef(\hats_closed, Pbind(
    \instrument, \hihat_closed,
    \out,   3,
    \dur,   0.25,
    \amp,   Pseq([0.6, 0.4, 0.5, 0.35,
                  0.55, \rest, 0.45, 0.4,
                  0.6, 0.4, 0.5, \rest,
                  0.55, 0.4, 0.45, 0.5], inf),
    \decay, Prand([0.03, 0.04, 0.05], inf)
)).play;
)

// -- Shuffled / swung 8ths --------------------------------------
(
Pdef(\hats_closed, Pbind(
    \instrument, \hihat_closed,
    \out,   3,
    \dur,   Pseq([Pn(Pseq([0.333, 0.167]), 4)], inf),  // swung feel
    \amp,   Pseq([0.6, 0.4], inf),
    \decay, 0.035
)).play;
)

// ============================================================
//  OPEN HI-HAT PATTERNS
// ============================================================

// -- Open hat on the "and" of beat 2 and 4 ----------------------
(
Pdef(\hats_open, Pbind(
    \instrument, \hihat_open,
    \out,   3,
    \dur,   Pseq([\rest, 0.5, 0.5, \rest, 0.5, 0.5], inf),
    \amp,   Pseq([0.5, 0.45], inf),
    \decay, 0.25,
    \gate,  1
)).play;
)

// -- Open hat as accent on beat 4 --------------------------------
(
Pdef(\hats_open, Pbind(
    \instrument, \hihat_open,
    \out,   3,
    \dur,   Pseq([\rest, \rest, \rest, 1], inf),
    \amp,   0.55,
    \decay, 0.4
)).play;
)

// ============================================================
//  PEDAL HI-HAT
// ============================================================

// -- Pedal on beat 2.5 (offbeat chick) ---------------------------
(
Pdef(\hats_pedal, Pbind(
    \instrument, \hihat_pedal,
    \out,   3,
    \dur,   Pseq([\rest, 0.5, 0.5, \rest, 0.5, 0.5], inf),
    \amp,   0.4
)).play;
)

// ============================================================
//  COMBINED HAT PATTERN (closed + open layers)
// ============================================================
(
// Closed hats — running 8ths
Pdef(\hats_closed, Pbind(
    \instrument, \hihat_closed,
    \out,  3, \dur, 0.5,
    \amp,  Pseq([0.6, 0.35, 0.55, 0.35, 0.6, 0.35, 0.55, 0.35], inf),
    \decay, 0.04
)).play;

// Open hat on the "and" of beat 4
Pdef(\hats_open, Pbind(
    \instrument, \hihat_open,
    \out,  3,
    \dur,  Pseq([\rest, \rest, \rest, \rest, \rest, \rest, \rest, 1], inf),
    \amp,  0.5, \decay, 0.3
)).play;
)

// ============================================================
//  STOP
// ============================================================

// Stop individual patterns:
// Pdef(\hats_closed).stop;
// Pdef(\hats_open).stop;
// Pdef(\hats_pedal).stop;

// Stop all hats:
// [\hats, \hats_closed, \hats_open, \hats_pedal].do { |n| Pdef(n).stop };
