// ============================================================
//  patterns/live_session.scd — Full 8-Track Live Session Example
//
//  A complete example live session combining all 8 tracks.
//  Demonstrates a structured arrangement with intro, build,
//  drop, breakdown, and outro.
//
//  REQUIRES: boot.scd to have been evaluated first.
//
//  HOW TO USE:
//    - Evaluate sections one at a time during performance
//    - Or select all and run for a fully automated demo
//    - Sections are separated by bar markers for easy navigation
// ============================================================

// ============================================================
//  SECTION 0 — SETUP (run first, one time)
// ============================================================
(
// Set tempo to 128 BPM (house/techno range)
TempoClock.default.tempo = 128/60;

// Set up FX buses for reverb and delay
~reverbBus = Bus.audio(s, 1);
~delayBus  = Bus.audio(s, 1);
s.sync;

~reverbSynth = Synth(\fx_reverb,
    [\in, ~reverbBus, \out, 7, \mix, 0.4, \room, 0.7, \damp, 0.5, \amp, 0.65],
    s, \addToTail
);
~delaySynth  = Synth(\fx_delay,
    [\in, ~delayBus, \out, 7, \delTime, 0.234375, \feedback, 0.4, \mix, 0.3, \amp, 0.55],
    s, \addToTail
);

"Session setup complete. BPM: 128".postln;
)

// ============================================================
//  SECTION 1 — INTRO (bars 1–8)
//  Kick only — establish the groove
// ============================================================
(
// Track 1: Kick enters
Pdef(\kick, Pbind(
    \instrument, \kick_808,
    \out,  0,
    \dur,  1,          // quarter notes = 4/4 at 128 BPM
    \amp,  0.9,
    \freq, 60,
    \sweep, 200, \sweepTime, 0.07,
    \decay, 0.5
)).play;
)

// ============================================================
//  SECTION 2 — BUILD (bars 9–16)
//  Add hi-hats and bass
// ============================================================
(
// Track 4: Closed hi-hats enter
Pdef(\hats_closed, Pbind(
    \instrument, \hihat_closed,
    \out,   3,
    \dur,   0.5,
    \amp,   Pseq([0.6, 0.3, 0.5, 0.3, 0.6, 0.3, 0.5, 0.3], inf),
    \decay, 0.04
)).play;

// Track 6: Sub bass enters
Pdef(\bass, Pbind(
    \instrument, \bass_sub,
    \out,      5,
    \midinote, Pseq([36, \rest, 36, \rest, 36, \rest, 38, \rest], inf),
    \dur,      0.5,
    \amp,      0.85,
    \attack,   0.008,
    \release,  0.12
)).play;
)

// ============================================================
//  SECTION 3 — DROP (bars 17–32)
//  Full groove: kick + snare + hats + bass + percussion
// ============================================================
(
// Track 1: Kick pattern stays
Pdef(\kick, Pbind(
    \instrument, \kick_808,
    \out,  0,
    \dur,  Pseq([1, 0.5, 0.5, 1, 1], inf),
    \amp,  Pseq([0.9, 0.7, 0.65, 0.85, 0.9], inf),
    \freq, 60, \decay, 0.5
)).play;

// Track 3: Snare on 2 and 4
Pdef(\snare1, Pbind(
    \instrument, \snare1,
    \out,  2,
    \dur,  Pseq([\rest, 1, \rest, 1], inf),
    \amp,  0.78, \freq, 200, \decay, 0.15
)).play;

// Track 4: Full hat pattern (closed + open)
Pdef(\hats_closed, Pbind(
    \instrument, \hihat_closed,
    \out,   3,
    \dur,   0.5,
    \amp,   Pseq([0.6, 0.3, 0.55, 0.3, 0.6, 0.3, 0.55, 0.3], inf),
    \decay, 0.04
)).play;

Pdef(\hats_open, Pbind(
    \instrument, \hihat_open,
    \out,   3,
    \dur,   Pseq([\rest, \rest, \rest, \rest, \rest, \rest, \rest, 1], inf),
    \amp,   0.5, \decay, 0.3
)).play;

// Track 5: Clap + shaker
Pdef(\clap, Pbind(
    \instrument, \clap,
    \out,  4,
    \dur,  Pseq([\rest, 1, \rest, 1], inf),
    \amp,  0.7, \decay, 0.18
)).play;

Pdef(\shaker, Pbind(
    \instrument, \shaker,
    \out,  4, \dur, 0.5,
    \amp,  Prand([0.25, 0.3, 0.27, 0.22], inf)
)).play;

// Track 6: Acid bass enters
Pdef(\bass, Pbind(
    \instrument, \bass_acid,
    \out,  5,
    \midinote, Pseq([36, 36, 43, 36, 39, \rest, 41, 43], inf),
    \dur,  0.25, \amp, 0.75,
    \cutoff, Prand([400, 600, 1000, 1800], inf),
    \res,  0.65, \envAmount, 0.7
)).play;
)

// ============================================================
//  SECTION 4 — LAYER IN LEAD (bars 33–48)
// ============================================================
(
// Track 7: Supersaw lead enters
Pdef(\lead, Pbind(
    \instrument, \lead_saw,
    \out,      6,
    \midinote, Prand([60, 63, 65, 67, 70, 72], inf),
    \dur,      Prand([0.25, 0.5, 0.375, 0.125], inf),
    \amp,      Pexprand(0.3, 0.5, inf),
    \detune,   0.22,
    \cutoff,   Prand([2000, 3000, 4000], inf),
    \res,      0.25,
    \attack,   0.01,
    \release,  0.18
)).play;
)

// ============================================================
//  SECTION 5 — BREAKDOWN (bars 49–56)
//  Strip back to pad + kick only
// ============================================================
(
// Stop drums and bass
[\snare1, \hats_closed, \hats_open, \clap, \shaker, \bass, \lead].do { |n|
    Pdef(n).stop;
};

// Track 7: Soft pad takes over
Pdef(\pad, Pbind(
    \instrument, \pad_soft,
    \out,      6,
    \midinote, Pseq([[48, 52, 55, 60], [46, 50, 53, 58],
                     [43, 47, 50, 55], [41, 45, 48, 53]], inf),
    \dur,  4, \amp, 0.38, \attack, 1.5, \release, 2.5, \gate, 1
)).play;

// Track 7: Add texture layer
Pdef(\texture, Pbind(
    \instrument, \texture_grain,
    \out,  6, \dur, Inf,
    \freq, Prand([800, 1200, 1600, 2000], inf),
    \lfoRate, 0.4, \depth, 0.5,
    \amp, 0.2, \attack, 1.0, \release, 2.0, \gate, 1
)).play;
)

// ============================================================
//  SECTION 6 — REBUILD (bars 57–64)
//  Gradually bring drums back
// ============================================================
(
// Kick and snare return
Pdef(\kick, Pbind(
    \instrument, \kick_808,
    \out,  0, \dur, 1, \amp, 0.9, \freq, 60, \decay, 0.5
)).play;

Pdef(\snare1, Pbind(
    \instrument, \snare1,
    \out,  2, \dur, Pseq([\rest, 1, \rest, 1], inf), \amp, 0.78
)).play;
)

(
// Full drop returns
Pdef(\hats_closed, Pbind(
    \instrument, \hihat_closed,
    \out,   3, \dur, 0.5,
    \amp,   Pseq([0.6, 0.3, 0.55, 0.3, 0.6, 0.3, 0.55, 0.3], inf)
)).play;

Pdef(\bass, Pbind(
    \instrument, \bass_fm,
    \out,  5,
    \midinote, Pseq([36, \rest, 38, 36, \rest, 43, 41, \rest], inf),
    \dur,  Pseq([0.5, 0.25, 0.25, 0.5, 0.25, 0.25, 0.5, 0.5], inf),
    \amp,  0.8, \ratio, 1.5, \index, Pseq([3, 4, 5, 4], inf)
)).play;

// Keep pad but stop texture
Pdef(\texture).stop;
)

// ============================================================
//  SECTION 7 — OUTRO (bars 65–72)
//  Gradually remove elements
// ============================================================
(
// Remove lead and extra percussion
[\lead, \clap, \shaker].do { |n| Pdef(n).stop };
)

(
// Strip to kick + pad
[\snare1, \hats_closed, \hats_open, \bass].do { |n| Pdef(n).stop };
)

(
// Final fadeout — stop everything
[\kick, \pad, \texture].do { |n| Pdef(n).stop };
~reverbSynth.free;
~delaySynth.free;
"Session ended.".postln;
)

// ============================================================
//  EMERGENCY STOP — stops everything immediately
// ============================================================
// CmdPeriod.run;
