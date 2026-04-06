// =============================================================================
// CORPS SUSPENDU — Patterns: Transitions
//
// The liminal spaces between acts. These are often more powerful than the
// acts themselves — the audience is suspended, uncertain, listening.
//
// Three transition types are available:
//   1. \transition_tone  — a single held sine with gentle beating
//   2. \roomTone         — near-silence, just the room's acoustic life
//   3. Absolute silence  — no pattern, no sound (evaluate the stop block)
//
// TIMING GUIDE:
//   Pre-show          → room tone / transition tone (very quiet)
//   Act I → Act II    → ~45–60 sec tone, then silence, then Act II drone
//   Act II → Act III  → ~30–45 sec pure silence (most dramatic)
//   Act III → Act IV  → ~20–30 sec tone or silence, then sudden laugh
//   Post-show         → one last tone fading to nothing
// =============================================================================

// ─── SETUP (evaluate once after corps_suspendu.scd is loaded) ─────────────────

(
// Single tone: a pure sine with subtle beating — the sound of a held breath
// Choose freq from the harmonic series for continuity with surrounding acts
Pdef(\transition_tone,
    Pbind(
        \instrument, \singleTone,
        \out,        0,
        \rev,        ~reverbBus,
        \freq,       Prand([55, 73.4, 110, 146.8, 165, 220], 1),  // one note
        \amp,        0.11,
        \fadeIn,     8,
        \fadeOut,    12,
        \dur,        50,    // ~50 seconds total event
        \legato,     1.0
    )
);

// Room tone: almost nothing — just the air
Pdef(\transition_roomtone,
    Pbind(
        \instrument, \roomTone,
        \out,        0,
        \rev,        ~reverbBus,
        \amp,        0.035,
        \dur,        Prand([40, 50, 60], inf),
        \legato,     1.0
    )
);
"Transition patterns defined.".postln;
)


// ─── PRE-SHOW: house lights going down ────────────────────────────────────────
(
Pdef(\transition_roomtone).play;
"[PRE-SHOW] Room tone playing — audience settling".postln;
)

// ─── TRANSITION I → II ────────────────────────────────────────────────────────
// After Act I fades, hold a tone. Then cut to silence. Then Act II drone enters.
(
Pdef(\transition_tone).play;
"[TRANS I→II] Transition tone — ~45 seconds, then stop and enter Act II".postln;
)

(
Pdef(\transition_tone).stop;
"[TRANS I→II] Silence — evaluate Act II cues now".postln;
)

// ─── TRANSITION II → III ──────────────────────────────────────────────────────
// After the chaos of Act II, let absolute silence reign.
// This is the most powerful transition — trust it.
(
// No pattern. Just silence.
// Wait 30–45 seconds before starting Act III.
"[TRANS II→III] Pure silence — do not rush into Act III".postln;
)

// Optional: if silence feels too long, add a very quiet tone:
// Pdef(\transition_tone).play;

// ─── TRANSITION III → IV ──────────────────────────────────────────────────────
// Act III ends in luminosity. Let it fade completely, then sudden laughter.
(
Pdef(\transition_tone).stop;
// After shimmer fully dies (10+ seconds), evaluate Act IV's first cue
"[TRANS III→IV] Shimmer fading — when it is gone, the laughter begins".postln;
)

// ─── POST-SHOW: final note and silence ────────────────────────────────────────
(
Pdef(\transition_tone).play;
"[POST-SHOW] Final tone — let it fade completely before leaving the stage".postln;
)

(
Pdef(\transition_tone).stop;
Pdef(\transition_roomtone).stop;
s.freeAll;
~reverb = Synth(\reverbBus, [\in, ~reverbBus, \out, 0, \mix, 0.55, \room, 0.88, \damp, 0.35]);
"Corps Suspendu — fin. Merci.".postln;
)
