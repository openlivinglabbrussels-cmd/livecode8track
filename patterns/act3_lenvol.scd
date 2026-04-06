// =============================================================================
// CORPS SUSPENDU — Patterns: Act III — L'Envol (The Flight)
// Duration: ~12 minutes
//
// Mood: Weightlessness, wonder, transcendence, the sacred.
// Techniques: Additive shimmer pads drifting through the harmonic/overtone
//             series, sparse FM bells, spectral freeze textures.
//
// Harmonic language: all frequencies drawn from the natural overtone series
//   on D (36.7 Hz): 36.7, 73.4, 110.1, 146.8, 183.5, 220.2, 256.9, 293.6,
//   330.3, 367.0, 403.7, 440.4...
//   This creates pure resonance rather than equal temperament intervals.
//
// Arc: One shimmer pad enters quietly → bells arrive like distant thoughts →
//      spectral freeze layer thickens the air → radiant climax → very slow
//      fade as the body descends back toward earth
// =============================================================================

// ─── SETUP (evaluate once after corps_suspendu.scd is loaded) ─────────────────

(
// Shimmer pad: additive harmonics drifting on the overtone series of D
// Very long notes — each pitch is a full sustained harmonic event
Pdef(\act3_shimmer,
    Pbind(
        \instrument, \shimmerPad,
        \out,        0,
        \rev,        ~reverbBus,
        // Overtone series on low D (fundamental ~36.7 Hz)
        \freq,       Prand([36.7, 73.4, 110.1, 146.8, 183.5, 220.2, 293.6, 367.0], inf),
        \numHarm,    Prand([6, 7, 8, 9, 10], inf),
        \detune,     Prand([0.004, 0.007, 0.011, 0.016], inf),
        \amp,        Pgauss(0.16, 0.03, inf),
        \dur,        Prand([25, 30, 40, 50, 60], inf),
        \legato,     1.0
    )
);

// FM bells: sparse, inharmonic, arriving like single thoughts
// Non-integer modulator ratios give each bell a unique timbre
Pdef(\act3_bells,
    Pbind(
        \instrument, \fmBell,
        \out,        0,
        \rev,        ~reverbBus,
        \freq,       Prand([
            110.1, 146.8, 183.5, 220.2, 256.9, 293.6,
            330.3, 367.0, 440.4, 550.5, 660.6, 734.0
        ], inf),
        \amp,        Pgauss(0.3, 0.06, inf),
        \modRatio,   Prand([1.414, 2.0, 2.787, 3.0, 3.5, 4.0], inf),
        \modIdx,     Pgauss(3.5, 1.2, inf).clip(0.5, 8),
        \decay,      Prand([3, 4, 5, 6, 8, 10], inf),
        \dur,        Pwhite(4.0, 18.0, inf),  // very sparse — each bell is an event
        \legato,     0.9
    )
);

// Spectral freeze: sustained harmonic clouds, smeared and slowly moving
// Arrives midway to deepen and thicken the texture
Pdef(\act3_spectral,
    Pbind(
        \instrument, \spectralFreeze,
        \out,        0,
        \rev,        ~reverbBus,
        \freq,       Prand([110.1, 146.8, 183.5, 220.2, 293.6, 367.0], inf),
        \amp,        Pgauss(0.14, 0.03, inf),
        \dur,        Prand([30, 40, 50, 60], inf),
        \legato,     1.0
    )
);
"Act III patterns defined.".postln;
)


// ─── CUE 1: The first shimmer pad enters — almost imperceptible (~0:00) ────────
(
Pdef(\act3_shimmer).play;
"[ACT III] Shimmer pad entered — let it breathe for 3 minutes".postln;
)

// ─── CUE 2: First bell arrives (~3:00) ────────────────────────────────────────
(
Pdef(\act3_bells).play;
"[ACT III] Bells added — sparse, listen for the silence between them".postln;
)

// ─── CUE 3: Spectral freeze deepens (~6:00) ───────────────────────────────────
(
Pdef(\act3_spectral).play;
"[ACT III] Spectral freeze layer added — the air thickens with harmonics".postln;
)

// ─── CUE 4: Climax (~9:00–10:00) ─────────────────────────────────────────────
// The three layers are all running and self-evolving.
// No action needed — the stochastic patterns find their own peak.
// Watch the performers and let the density breathe.

// ─── CUE 5: Begin fade out (~11:00, approaching transition) ──────────────────
// Stop patterns one by one — the long release envelopes do the work:
(
Pdef(\act3_spectral).stop;
"[ACT III] Spectral freeze fading...".postln;
)

(
Pdef(\act3_bells).stop;
"[ACT III] Bells fading...".postln;
)

(
Pdef(\act3_shimmer).stop;
"[ACT III] Shimmer pad fading... the body returns to earth".postln;
)
