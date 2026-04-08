// ============================================================
//  tracks/track6_bass.scd — 🎹 BASS / SYNTH
//  Output: bus 5 (Track 6)
//
//  SynthDefs available (from synthdefs/bass_defs.scd):
//    \bass_sub   — deep sub bass (sine)
//    \bass_acid  — 303-style acid bassline (saw + resonant filter)
//    \bass_fm    — FM bass (rich harmonics)
//
//  WORKFLOW:
//    1. Run boot.scd first
//    2. Choose a bass pattern and evaluate it
//    3. Modify notes and parameters live
//    4. Use STOP section at the bottom to silence this track
// ============================================================

// ============================================================
//  NOTE REFERENCE (MIDI note numbers → frequency)
//    C2=36, D2=38, E2=40, F2=41, G2=43, A2=45, B2=47
//    C3=48, D3=50, E3=52, F3=53, G3=55, A3=57, B3=59
//    Use \midinote to set note by MIDI number (auto-converts to freq)
// ============================================================

// ============================================================
//  QUICK START — simple bass riff
// ============================================================
(
Pdef(\bass, Pbind(
    \instrument, \bass_sub,
    \out,      5,
    \midinote, Pseq([36, \rest, 36, \rest, 39, \rest, 41, \rest], inf),
    \dur,      0.5,
    \amp,      0.8,
    \gate,     1,
    \attack,   0.01,
    \release,  0.15
)).play;
)

// ============================================================
//  SUB BASS PATTERNS
// ============================================================

// -- Simple root note groove ------------------------------------
(
Pdef(\bass, Pbind(
    \instrument, \bass_sub,
    \out,      5,
    \midinote, Pseq([36, \rest, 36, \rest, 36, \rest, 38, \rest], inf),
    \dur,      0.5,
    \amp,      0.85,
    \attack,   0.008,
    \release,  0.1
)).play;
)

// -- Walking bassline -------------------------------------------
(
Pdef(\bass, Pbind(
    \instrument, \bass_sub,
    \out,      5,
    \midinote, Pseq([36, 40, 43, 48, 47, 43, 40, 38], inf),
    \dur,      Pseq([0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5], inf),
    \amp,      Pseq([0.85, 0.65, 0.7, 0.75, 0.7, 0.65, 0.6, 0.7], inf),
    \attack,   0.005,
    \release,  0.15
)).play;
)

// ============================================================
//  ACID BASS PATTERNS
// ============================================================

// -- Classic acid bassline (C minor pentatonic) -----------------
(
Pdef(\bass, Pbind(
    \instrument, \bass_acid,
    \out,      5,
    \midinote, Pseq([36, 36, 43, 36, 39, \rest, 41, 43], inf),
    \dur,      Pseq([0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25], inf),
    \amp,      Pseq([0.8, 0.5, 0.65, 0.7, 0.6, 0.3, 0.65, 0.7], inf),
    \cutoff,   Prand([400, 600, 800, 1200, 2000], inf),
    \res,      0.7,
    \envAmount, 0.8,
    \attack,   0.001,
    \decay,    0.15,
    \sustain,  0.3,
    \release,  0.05
)).play;
)

// -- Acid with filter sweep -------------------------------------
(
Pdef(\bass, Pbind(
    \instrument, \bass_acid,
    \out,      5,
    \midinote, Pseq([36, 39, 43, 46, 48, 46, 43, 39], inf),
    \dur,      0.25,
    \amp,      0.7,
    \cutoff,   Penvir((), Pseg([400, 3000, 400], [4, 4], \exp), inf),
    \res,      0.75,
    \envAmount, 0.6
)).play;
)

// ============================================================
//  FM BASS PATTERNS
// ============================================================

// -- FM bass groove --------------------------------------------
(
Pdef(\bass, Pbind(
    \instrument, \bass_fm,
    \out,      5,
    \midinote, Pseq([36, \rest, 38, 36, \rest, 43, 41, \rest], inf),
    \dur,      Pseq([0.5, 0.25, 0.25, 0.5, 0.25, 0.25, 0.5, 0.5], inf),
    \amp,      Pseq([0.8, 0, 0.65, 0.7, 0, 0.7, 0.65, 0], inf),
    \ratio,    1.5,
    \index,    Pseq([3, 5, 4, 6], inf),
    \attack,   0.005,
    \release,  0.12
)).play;
)

// ============================================================
//  LIVE TWEAKING
// ============================================================

// Transpose a running pattern by changing midinote offset:
// Pdefn(\bass).set(\midinote, 41);

// Change cutoff on acid bass live:
// Pdef(\bass).set(\cutoff, 2000);

// ============================================================
//  STOP
// ============================================================

// Stop the bass:
// Pdef(\bass).stop;

// Stop and clear:
// Pdef(\bass).clear;
