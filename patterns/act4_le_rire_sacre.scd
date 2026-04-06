// =============================================================================
// CORPS SUSPENDU — Patterns: Act IV — Le Rire Sacré (The Sacred Laugh)
// Duration: ~10 minutes
//
// Mood: Absurdity, joy, release, the chaos that is also holy.
// Techniques: Formant-based voice-laughter textures, controlled feedback
//             swells, stochastic polyrhythmic percussion.
//
// Arc: After Act III's silence, laughter erupts — alien, uncanny, yet joyful.
//      Feedback swells arrive like waves of hilarity. Rhythmic chaos builds.
//      The whole thing collapses into one last moment of clarity, then silence.
//
// NOTES:
//   - The formant laugh texture is self-modulating — don't over-control it.
//   - Feedback amplitude should stay ≤ 0.25. If it gets too loud: ~panic.value
//   - The polyrhythm pattern uses layered duration sequences — truly poly.
// =============================================================================

// ─── SETUP (evaluate once after corps_suspendu.scd is loaded) ─────────────────

(
// Sacred laugh: chaotic formant voice — sounds like laughing, crying, speaking
Pdef(\act4_laugh,
    Pbind(
        \instrument, \sacredLaugh,
        \out,        0,
        \rev,        ~reverbBus,
        \amp,        Pgauss(0.22, 0.05, inf),
        \bwScale,    Prand([0.5, 0.75, 1.0, 1.5, 2.0], inf),
        \dur,        Prand([4, 5, 6, 8, 10], inf),
        \legato,     1.0
    )
);

// Feedback swells: controlled chaos that grows and recedes
Pdef(\act4_feedback,
    Pbind(
        \instrument, \feedbackLoop,
        \out,        0,
        \rev,        ~reverbBus,
        \amp,        Pgauss(0.16, 0.04, inf),
        \delTime,    Prand([0.17, 0.23, 0.31, 0.41, 0.53], inf),
        \feedback,   Prand([0.55, 0.62, 0.68, 0.74, 0.78], inf),
        \dur,        Prand([8, 10, 12, 15], inf),
        \legato,     1.0
    )
);

// Stochastic polyrhythm: three simultaneous duration sequences creating
// layers that phase in and out of alignment — joyful, restless, alive
Pdef(\act4_rhythm,
    Pbind(
        \instrument, \glitchPerc,
        \out,        0,
        \rev,        ~reverbBus,
        \density,    Prand([8, 12, 16, 20], inf),
        \minFreq,    200,
        \maxFreq,    5500,
        \amp,        Pgauss(0.32, 0.08, inf),
        // Three-layer poly duration sequence (prime lengths → phasing)
        \dur,        Pseq([
            Prand([0.25, 0.5],         4),   // layer A: quarters
            Prand([0.125, 0.25, 0.5],  3),   // layer B: triplet feel
            Prand([0.375, 0.75],       5)    // layer C: dotted
        ], inf),
        \legato,     0.12
    )
);
"Act IV patterns defined.".postln;
)


// ─── CUE 1: Laughter erupts — this should feel sudden (~0:00) ─────────────────
(
Pdef(\act4_laugh).play;
"[ACT IV] Le Rire Sacré — the sacred laugh begins".postln;
)

// ─── CUE 2: Feedback swells emerge (~2:30–3:00) ───────────────────────────────
(
Pdef(\act4_feedback).play;
"[ACT IV] Feedback swells added — waves of hilarity".postln;
)

// ─── CUE 3: Polyrhythmic chaos begins (~5:00) ─────────────────────────────────
(
Pdef(\act4_rhythm).play;
"[ACT IV] Polyrhythm erupts — the joy is structural now".postln;
)

// ─── CUE 4: CLIMAX (~8:00) — all three layers at maximum density ──────────────
// The stochastic patterns escalate naturally. You can also re-push the laugh:
(
Pdef(\act4_laugh,
    Pbind(
        \instrument, \sacredLaugh,
        \out,        0,
        \rev,        ~reverbBus,
        \amp,        Pgauss(0.3, 0.06, inf),      // louder
        \bwScale,    Prand([1.5, 2.0, 2.5], inf), // wider bandwidth = rawer
        \dur,        Prand([2, 3, 4, 5], inf),     // faster cycling
        \legato,     1.0
    )
).play;
"[ACT IV] CLIMAX — laugh texture intensified".postln;
)

// ─── CUE 5: Sudden collapse (~9:30–10:00) ─────────────────────────────────────
// Everything stops — the silence after the laugh is the punchline.
(
Pdef(\act4_laugh).stop;
Pdef(\act4_feedback).stop;
Pdef(\act4_rhythm).stop;
"[ACT IV] Silence — the laugh has ended. The body rests.".postln;
)
