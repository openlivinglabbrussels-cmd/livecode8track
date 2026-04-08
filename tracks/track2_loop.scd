// ============================================================
//  tracks/track2_loop.scd — 🔁 LOOP / SAMPLER
//  Output: bus 1 (Track 2)
//
//  SynthDefs available (from synthdefs/loop_defs.scd):
//    \loop_buf      — buffer looper (set rate, startPos)
//    \loop_granular — granular stretching / texturizing
//    \loop_oneshot  — one-shot sample trigger
//
//  WORKFLOW:
//    1. Load a sample into a buffer (see SETUP section)
//    2. Choose a loop pattern and evaluate it
//    3. Modify parameters live
//    4. Use the STOP section at the bottom to silence this track
// ============================================================

// ============================================================
//  SETUP — load your sample(s) into buffers
//  Edit the paths to point to your sample files
// ============================================================
(
// Load a sample — put your WAV/AIFF files in the samples/ folder
// ~loopBuf = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "../samples/myloop.wav");
// ~loopBuf = Buffer.read(s, "/path/to/your/loop.wav");

// For testing with a synthetic buffer (sine tone, 2 seconds):
~loopBuf = Buffer.alloc(s, s.sampleRate * 2, 1, { |b|
    b.sine1Msg([1, 0.5, 0.25, 0.125], true, true, true);
});

s.sync;
("Loop buffer loaded: " ++ ~loopBuf.numFrames ++ " frames").postln;
)

// ============================================================
//  BASIC LOOP PLAYBACK
// ============================================================
(
Pdef(\loop, Pbind(
    \instrument, \loop_buf,
    \out,      1,
    \buf,      ~loopBuf,
    \dur,      Inf,       // play for a very long time (gated loop)
    \rate,     1.0,       // playback rate (1.0 = original pitch)
    \startPos, 0.0,       // start position (0.0–1.0)
    \loop,     1,         // 1 = loop, 0 = one-shot
    \amp,      0.75,
    \gate,     1
)).play;
)

// -- Pitched loop variants (rate changes pitch and speed) --------
(
Pdef(\loop, Pbind(
    \instrument, \loop_buf,
    \out,  1,
    \buf,  ~loopBuf,
    \dur,  Inf,
    \rate, Prand([1.0, 0.75, 1.5, 0.5], inf),  // random pitch each cycle
    \amp,  0.7,
    \gate, 1
)).play;
)

// -- One-shot trigger pattern (rhythmic sample triggers) ---------
(
Pdef(\loop, Pbind(
    \instrument, \loop_oneshot,
    \out,  1,
    \buf,  ~loopBuf,
    \dur,  Pseq([1, 0.5, 0.5, 1, 1], inf),
    \rate, Prand([1.0, 0.5, 2.0, 0.75, 1.25], inf),
    \amp,  Pseq([0.8, 0.5, 0.6, 0.75, 0.7], inf)
)).play;
)

// -- Granular stretch (time-stretch and texturize) ----------------
(
Pdef(\loop, Pbind(
    \instrument,  \loop_granular,
    \out,         1,
    \buf,         ~loopBuf,
    \dur,         Inf,
    \rate,        0.5,        // 0.5 = half-speed (pitch down one octave)
    \pos,         0.0,        // playhead position (0.0–1.0)
    \posSpeed,    0.3,        // how fast the playhead moves
    \grainSize,   0.15,       // grain duration in seconds
    \scatter,     0.05,       // position randomisation
    \amp,         0.6,
    \gate,        1
)).play;
)

// -- Granular texture (very slow, ambient wash) -------------------
(
Pdef(\loop, Pbind(
    \instrument, \loop_granular,
    \out,        1,
    \buf,        ~loopBuf,
    \dur,        Inf,
    \rate,       0.1,
    \pos,        LFNoise1.kr(0.05).range(0.0, 1.0),
    \grainSize,  0.3,
    \scatter,    0.1,
    \amp,        0.5,
    \gate,       1
)).play;
)

// ============================================================
//  LIVE TWEAKING
// ============================================================

// Change playback rate on the fly:
// ~loopSynth.set(\rate, 0.5);

// Load a different buffer:
// ~loopBuf2 = Buffer.read(s, "/path/to/other.wav");

// ============================================================
//  STOP
// ============================================================

// Stop the loop:
// Pdef(\loop).stop;

// Free the buffer when done:
// ~loopBuf.free;
