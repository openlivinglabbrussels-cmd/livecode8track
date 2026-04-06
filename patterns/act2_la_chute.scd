// =============================================================================
// CORPS SUSPENDU — Patterns: Act II — La Chute (The Fall)
// Duration: ~12 minutes
//
// Mood: Gravity, weight, tension, mechanical failure, body in descent.
// Techniques: Pitch-dropping drone (entire act), percussive hits (sparse→dense),
//             glitchy stochastic rhythms.
//
// Arc: Transition silence → the drone begins falling → isolated hits arrive →
//      glitches multiply and fragment → a climactic wall of noise →
//      sudden silence or cut to transition
//
// IMPORTANT: The \fallingDrone is designed to last 2 minutes per instance.
//            Queue multiple overlapping drones for longer coverage.
//            Each has its own XLine pitch fall — the polyphony is intentional.
// =============================================================================

// ─── SETUP (evaluate once after corps_suspendu.scd is loaded) ─────────────────

(
// Falling drone: pitch descends exponentially over ~2 minutes per note
// Multiple overlapping instances accumulate into a thick gravitational mass
Pdef(\act2_drone,
    Pbind(
        \instrument, \fallingDrone,
        \out,        0,
        \rev,        ~reverbBus,
        \startFreq,  Prand([220, 180, 165, 247], inf),
        \endFreq,    Prand([28, 35, 22, 40], inf),
        \dur,        120,       // 2-minute events — re-triggers create layers
        \legato,     1.0,
        \amp,        Pgauss(0.28, 0.04, inf)
    )
);

// Falling percussive hits: isolated impacts, randomised pitch and timing
// Start sparse — one every several seconds — let density increase naturally
Pdef(\act2_hits,
    Pbind(
        \instrument, \fallingHit,
        \out,        0,
        \rev,        ~reverbBus,
        \freq,       Prand([1200, 800, 550, 330, 180, 90], inf),
        \amp,        Pgauss(0.42, 0.08, inf),
        \decay,      Prand([0.2, 0.35, 0.5, 0.8, 1.2], inf),
        \dropRatio,  Prand([0.03, 0.05, 0.08, 0.12], inf),
        \dur,        Pwhite(0.5, 8.0, inf),  // random spacing: calm yet inevitable
        \legato,     0.5
    )
);

// Glitch layer: stochastic mechanical fragmentation
// Arrives around 5 minutes in — the falls are becoming chaotic
Pdef(\act2_glitch,
    Pbind(
        \instrument, \glitchPerc,
        \out,        0,
        \rev,        ~reverbBus,
        \density,    Prand([2, 4, 6, 8, 12, 16], inf),
        \minFreq,    Prand([100, 200, 400, 600], inf),
        \maxFreq,    Prand([2000, 3500, 5000, 7000], inf),
        \amp,        Pgauss(0.35, 0.07, inf),
        \dur,        Prand([0.125, 0.25, 0.5, 1.0, 2.0], inf),
        \legato,     0.2
    )
);
"Act II patterns defined.".postln;
)


// ─── CUE 1: The drone begins — the first thing heard is gravity (~0:00) ────────
(
Pdef(\act2_drone).play;
"[ACT II] Falling drone started — the descent begins".postln;
)

// ─── CUE 2: Isolated hits arrive (~2:00) ──────────────────────────────────────
(
Pdef(\act2_hits).play;
"[ACT II] Percussive hits added — sparse, irregular, heavy".postln;
)

// ─── CUE 3: Glitch layer erupts (~5:00) ───────────────────────────────────────
(
Pdef(\act2_glitch).play;
"[ACT II] Glitch layer added — mechanical fragmentation".postln;
)

// ─── CUE 4: Peak chaos (~9:00) ────────────────────────────────────────────────
// The glitch density is already stochastic — it will self-escalate.
// Optionally re-evaluate this block to retrigger with higher density:
(
Pdef(\act2_glitch,
    Pbind(
        \instrument, \glitchPerc,
        \out,        0,
        \rev,        ~reverbBus,
        \density,    Prand([12, 16, 20, 24], inf),  // much denser
        \minFreq,    100,
        \maxFreq,    8000,
        \amp,        Pgauss(0.45, 0.08, inf),
        \dur,        Prand([0.0625, 0.125, 0.25], inf),
        \legato,     0.1
    )
).play;
"[ACT II] PEAK — glitch density maximised".postln;
)

// ─── CUE 5: Fade out Act II (~11:30, approaching transition) ─────────────────
(
Pdef(\act2_hits).stop;
Pdef(\act2_glitch).stop;
Pdef(\act2_drone).stop;
"[ACT II] Fading out — the fall is over".postln;
)
