// =============================================================================
// CORPS SUSPENDU — Patterns: Act I — Le Souffle (The Breath)
// Duration: ~10 minutes
//
// Mood: Stillness, anticipation, air. Very quiet opening.
// Techniques: Granular breath clouds, filtered drone, room tone underneath.
//
// Arc: Silence → barely audible room tone → breath drone swells in →
//      grain clouds arrive → a single swell to mezzo-forte → fade to transition
//
// HOW TO USE:
//   1. Load corps_suspendu.scd first (boots server, defines SynthDefs)
//   2. Evaluate the setup block below to define the patterns
//   3. Use the cue blocks to trigger each layer at the right moment
// =============================================================================

// ─── SETUP (evaluate once after corps_suspendu.scd is loaded) ─────────────────

(
// Breath drone: low, warm, slowly evolving
// Uses overtone series on low A (55 Hz): 55, 82.5 (3rd partial), 110 (2nd), 73.4 (5th)
Pdef(\act1_breath,
    Pbind(
        \instrument, \breathDrone,
        \out,        0,
        \rev,        ~reverbBus,
        \freq,       Prand([55, 82.5, 110, 73.4], inf),
        \amp,        Pgauss(0.28, 0.04, inf),
        \filtFreq,   Prand([300, 450, 600, 800], inf),
        \lfoRate,    Pgauss(0.15, 0.03, inf),
        \dur,        Prand([30, 40, 50, 60], inf),  // very long notes, overlapping
        \legato,     1.0
    )
);

// Grain texture: sparse grain clouds around the harmonic series
// Arrives after ~2 min to add airiness
Pdef(\act1_texture,
    Pbind(
        \instrument, Pwrand([\grainBreath, \roomTone], [0.75, 0.25], inf),
        \out,        0,
        \rev,        ~reverbBus,
        \freq,       Prand([110, 165, 220, 293, 330], inf),
        \amp,        Pgauss(0.15, 0.03, inf),
        \density,    Prand([5, 8, 12, 6], inf),
        \grainDur,   Prand([0.08, 0.12, 0.18, 0.25], inf),
        \dur,        Prand([20, 25, 30, 35], inf),
        \legato,     1.0
    )
);
"Act I patterns defined.".postln;
)


// ─── CUE 1: Opening room tone (pre-show / house lights going down) ─────────────
(
Pdef(\transition_tone).play;
"[ACT I] Room tone / transition tone — house lights going down".postln;
)

// ─── CUE 2: First breath drone enters (~0:00 of Act I) ────────────────────────
(
Pdef(\transition_tone).stop;
Pdef(\act1_breath).play;
"[ACT I] Breath drone started — let it swell for 2+ minutes before adding grains".postln;
)

// ─── CUE 3: Grain clouds arrive (~2:00 into Act I) ───────────────────────────
(
Pdef(\act1_texture).play;
"[ACT I] Grain texture layer added".postln;
)

// ─── CUE 4: Fade out Act I (at ~9:00, before the transition) ─────────────────
// The synths have long release envelopes — stopping patterns fades them naturally
(
Pdef(\act1_breath).stop;
Pdef(\act1_texture).stop;
"[ACT I] Fading out — wait ~10 seconds for natural release, then cue transition".postln;
)
