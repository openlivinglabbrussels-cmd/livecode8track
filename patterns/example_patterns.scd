// ============================================================
//  patterns/example_patterns.scd — Example Patterns per Track
//  Reference sheet for Pdef/Pbind examples across all 8 tracks
//
//  This file shows example patterns for each track.
//  Copy these into the matching track file and modify live.
//
//  REQUIRES: boot.scd to have been evaluated first.
// ============================================================

// ============================================================
//  TRACK 1 — 🥁 KICK (out 0)
// ============================================================

// Basic 4/4 kick
(
Pdef(\kick, Pbind(
    \instrument, \kick_808,
    \out,  0, \dur, 1, \amp, 0.9, \freq, 60, \decay, 0.5
)).play;
)

// Syncopated kick
(
Pdef(\kick, Pbind(
    \instrument, \kick_808,
    \out,  0,
    \dur,  Pseq([1, 0.5, 0.5, 1, 1], inf),
    \amp,  Pseq([0.9, 0.7, 0.6, 0.85, 0.9], inf)
)).play;
)

// ============================================================
//  TRACK 2 — 🔁 LOOP (out 1)
// ============================================================

// Buffer loop (set ~loopBuf first)
// ~loopBuf = Buffer.read(s, "/path/to/loop.wav");
(
Pdef(\loop, Pbind(
    \instrument, \loop_buf,
    \out,  1, \buf, ~loopBuf, \dur, Inf, \rate, 1.0, \amp, 0.75, \gate, 1
)).play;
)

// Granular texture
(
Pdef(\loop, Pbind(
    \instrument, \loop_granular,
    \out,  1, \buf, ~loopBuf, \dur, Inf,
    \rate, 0.5, \pos, 0.0, \grainSize, 0.15, \amp, 0.6, \gate, 1
)).play;
)

// ============================================================
//  TRACK 3 — 🪘 SNARE (out 2)
// ============================================================

// Snare on 2 and 4
(
Pdef(\snare1, Pbind(
    \instrument, \snare1,
    \out,  2, \dur, Pseq([\rest, 1, \rest, 1], inf), \amp, 0.75
)).play;
)

// Snare with ghost notes
(
Pdef(\snare1, Pbind(
    \instrument, \snare1,
    \out,  2,
    \dur,  0.25,
    \amp,  Pseq([\rest, \rest, \rest, \rest, 0.75, \rest, 0.25, \rest,
                 \rest, \rest, 0.2, \rest, 0.8, \rest, 0.3, \rest], inf)
)).play;
)

// ============================================================
//  TRACK 4 — 🎩 HI-HATS (out 3)
// ============================================================

// Straight 8ths closed hat
(
Pdef(\hats_closed, Pbind(
    \instrument, \hihat_closed,
    \out,  3, \dur, 0.5,
    \amp,  Pseq([0.6, 0.35, 0.55, 0.35], inf), \decay, 0.04
)).play;
)

// Open hat accent
(
Pdef(\hats_open, Pbind(
    \instrument, \hihat_open,
    \out,  3, \dur, Pseq([\rest, \rest, \rest, 1], inf),
    \amp,  0.55, \decay, 0.35
)).play;
)

// ============================================================
//  TRACK 5 — 🔔 PERCUSSION (out 4)
// ============================================================

// Clap on 2 and 4
(
Pdef(\clap, Pbind(
    \instrument, \clap,
    \out,  4, \dur, Pseq([\rest, 1, \rest, 1], inf), \amp, 0.7, \decay, 0.18
)).play;
)

// Shaker running
(
Pdef(\shaker, Pbind(
    \instrument, \shaker,
    \out,  4, \dur, 0.5, \amp, Prand([0.25, 0.3, 0.28], inf)
)).play;
)

// ============================================================
//  TRACK 6 — 🎹 BASS (out 5)
// ============================================================

// Sub bass groove
(
Pdef(\bass, Pbind(
    \instrument, \bass_sub,
    \out,  5,
    \midinote, Pseq([36, \rest, 36, \rest, 39, \rest, 41, \rest], inf),
    \dur,  0.5, \amp, 0.85, \attack, 0.008, \release, 0.1
)).play;
)

// Acid bassline
(
Pdef(\bass, Pbind(
    \instrument, \bass_acid,
    \out,  5,
    \midinote, Pseq([36, 36, 43, 36, 39, \rest, 41, 43], inf),
    \dur,  0.25, \amp, 0.75,
    \cutoff, Prand([400, 800, 1600, 2500], inf),
    \res,  0.7, \envAmount, 0.8
)).play;
)

// ============================================================
//  TRACK 7 — 🎸 LEAD / FX (out 6)
// ============================================================

// Supersaw lead melody
(
Pdef(\lead, Pbind(
    \instrument, \lead_saw,
    \out,  6,
    \midinote, Prand([60, 63, 65, 67, 70, 72], inf),
    \dur,  Prand([0.25, 0.5, 0.375], inf),
    \amp,  0.45, \detune, 0.25, \cutoff, 3000
)).play;
)

// Ambient pad
(
Pdef(\pad, Pbind(
    \instrument, \pad_soft,
    \out,  6,
    \midinote, Pseq([[48, 52, 55, 60], [46, 50, 53, 58]], inf),
    \dur,  4, \amp, 0.35, \attack, 1.5, \release, 2.0, \gate, 1
)).play;
)

// ============================================================
//  TRACK 8 — 🎚️ MASTER / AUX (out 7)
// ============================================================

// Start reverb send:
// ~reverbBus = Bus.audio(s, 1);
// ~reverbSynth = Synth(\fx_reverb, [\in, ~reverbBus, \out, 7, \mix, 0.4], s, \addToTail);

// Start delay send:
// ~delayBus = Bus.audio(s, 1);
// ~delaySynth = Synth(\fx_delay, [\in, ~delayBus, \out, 7, \delTime, 0.25], s, \addToTail);

// ============================================================
//  STOP ALL PATTERNS
// ============================================================

// (
// [\kick, \loop, \snare, \snare1, \snare2,
//  \hats, \hats_closed, \hats_open, \hats_pedal,
//  \clap, \rim, \shaker, \cowbell,
//  \bass, \lead, \pad, \texture].do { |n| Pdef(n).stop };
// )
