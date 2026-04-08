// ============================================================
//  tracks/track7_lead.scd — 🎸 LEAD / FX
//  Output: bus 6 (Track 7)
//
//  SynthDefs available (from synthdefs/lead_defs.scd):
//    \lead_saw      — detuned supersaw lead
//    \lead_square   — hollow square wave lead
//    \pad_soft      — ambient pad (slow attack/release)
//    \texture_grain — granular-style noise texture
//
//  WORKFLOW:
//    1. Run boot.scd first
//    2. Choose a lead or pad pattern and evaluate it
//    3. Layer lead + pad for rich textures
//    4. Use STOP section at the bottom to silence this track
// ============================================================

// ============================================================
//  QUICK START — simple supersaw lead melody
// ============================================================
(
Pdef(\lead, Pbind(
    \instrument, \lead_saw,
    \out,      6,
    \midinote, Pseq([60, 63, 67, 70, 72, 70, 67, 63], inf),
    \dur,      0.5,
    \amp,      0.45,
    \detune,   0.3,
    \cutoff,   3000,
    \res,      0.25,
    \attack,   0.01,
    \release,  0.2
)).play;
)

// ============================================================
//  SUPERSAW LEAD PATTERNS
// ============================================================

// -- Arpeggiated minor chord ------------------------------------
(
Pdef(\lead, Pbind(
    \instrument, \lead_saw,
    \out,      6,
    \midinote, Pseq([60, 63, 67, 72, 67, 63], inf),
    \dur,      0.25,
    \amp,      Pseq([0.5, 0.35, 0.4, 0.45, 0.35, 0.4], inf),
    \detune,   0.25,
    \cutoff,   Pexprand(1500, 5000, inf),
    \res,      0.3,
    \attack,   0.005,
    \release,  0.15
)).play;
)

// -- Pentatonic melody (C minor pentatonic) ---------------------
(
Pdef(\lead, Pbind(
    \instrument, \lead_saw,
    \out,      6,
    \midinote, Prand([60, 63, 65, 67, 70, 72, 75], inf),
    \dur,      Prand([0.25, 0.5, 0.375, 0.125], inf),
    \amp,      Pexprand(0.3, 0.55, inf),
    \detune,   0.2,
    \cutoff,   2500,
    \res,      0.2,
    \attack,   0.01,
    \release,  0.2
)).play;
)

// ============================================================
//  SQUARE WAVE LEAD PATTERNS
// ============================================================

// -- Square lead melody -----------------------------------------
(
Pdef(\lead, Pbind(
    \instrument, \lead_square,
    \out,      6,
    \midinote, Pseq([60, 60, 63, \rest, 65, 67, \rest, 67], inf),
    \dur,      Pseq([0.25, 0.25, 0.25, 0.25, 0.5, 0.5, 0.25, 0.5], inf),
    \amp,      Pseq([0.5, 0.35, 0.45, 0, 0.5, 0.45, 0, 0.4], inf),
    \width,    0.5,
    \cutoff,   1800,
    \res,      0.4,
    \attack,   0.003,
    \release,  0.1
)).play;
)

// ============================================================
//  PAD PATTERNS
// ============================================================

// -- Soft ambient pad (long chord tones) ------------------------
(
Pdef(\pad, Pbind(
    \instrument, \pad_soft,
    \out,      6,
    \midinote, Pseq([
        [48, 52, 55, 60],  // Cm chord
        [46, 50, 53, 58],  // Bb chord
        [43, 47, 50, 55],  // G chord
        [41, 45, 48, 53]   // F chord
    ], inf),
    \dur,      4,          // hold each chord for 4 beats (1 bar in 4/4)
    \amp,      0.35,
    \detune,   0.4,
    \attack,   1.5,
    \release,  2.0,
    \gate,     1
)).play;
)

// ============================================================
//  TEXTURE / FX PATTERNS
// ============================================================

// -- Granular texture layer -------------------------------------
(
Pdef(\texture, Pbind(
    \instrument, \texture_grain,
    \out,      6,
    \dur,      Inf,
    \freq,     Prand([500, 800, 1200, 2000, 3000], inf),
    \lfoRate,  Prand([0.3, 0.5, 0.8, 1.2], inf),
    \depth,    0.6,
    \amp,      0.25,
    \attack,   0.8,
    \release,  1.5,
    \gate,     1
)).play;
)

// ============================================================
//  COMBINED LEAD + PAD LAYER
// ============================================================
(
// Atmospheric pad underneath
Pdef(\pad, Pbind(
    \instrument, \pad_soft,
    \out,  6, \midinote, Pseq([[48, 52, 55], [46, 50, 53]], inf),
    \dur,  4, \amp, 0.3, \attack, 1.5, \release, 2.0, \gate, 1
)).play;

// Lead melody on top
Pdef(\lead, Pbind(
    \instrument, \lead_saw,
    \out,  6,
    \midinote, Prand([60, 63, 65, 67, 70, 72], inf),
    \dur,  Prand([0.25, 0.5, 0.375], inf),
    \amp,  0.4, \detune, 0.2, \cutoff, 2800, \attack, 0.01, \release, 0.2
)).play;
)

// ============================================================
//  STOP
// ============================================================

// Stop individual layers:
// Pdef(\lead).stop;
// Pdef(\pad).stop;
// Pdef(\texture).stop;

// Stop all lead/pad patterns:
// [\lead, \pad, \texture].do { |n| Pdef(n).stop };
