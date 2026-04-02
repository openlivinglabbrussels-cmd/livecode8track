// ============================================================
//  synthdefs/loop_defs.scd — Looper / Granular SynthDefs
//  Track 2 → output bus 1
//
//  SynthDefs:
//    \loop_buf      — simple buffer playback looper
//    \loop_granular — granular buffer stretching/texturizing
//    \loop_oneshot  — one-shot sample player (no looping)
//
//  USAGE NOTE:
//    Allocate a buffer before using these SynthDefs:
//      ~buf = Buffer.read(s, "/path/to/sample.wav");
//    Then pass the buffer number as the \buf argument.
// ============================================================

// ------------------------------------------------------------
//  \loop_buf — Simple buffer playback looper
//    Plays a buffer in a loop with speed and start-point control
// ------------------------------------------------------------
SynthDef(\loop_buf, { |out = 1, amp = 0.8, pan = 0,
                       buf = 0, rate = 1.0, startPos = 0.0,
                       loop = 1, gate = 1|

    var numFrames = BufFrames.kr(buf);
    var startFrame = startPos * numFrames;
    var env  = EnvGen.kr(Env.asr(0.01, 1, 0.1), gate, doneAction: 2);
    var sig  = BufRd.ar(
        1,
        buf,
        Phasor.ar(
            0,
            BufRateScale.kr(buf) * rate,
            startFrame,
            numFrames,
            startFrame
        ),
        loop
    );
    sig = sig * env * amp;
    Out.ar(out, Pan2.ar(sig, pan));
}).add;

// ------------------------------------------------------------
//  \loop_granular — Granular stretching/texturizing
//    Time-stretches or pitch-shifts a buffer using granular synthesis
//    Excellent for ambient textures and stretched loops
// ------------------------------------------------------------
SynthDef(\loop_granular, { |out = 1, amp = 0.6, pan = 0,
                             buf = 0, rate = 1.0, pos = 0.0,
                             posSpeed = 0.5, grainSize = 0.12,
                             scatter = 0.02, gate = 1|

    var env  = EnvGen.kr(Env.asr(0.05, 1, 0.3), gate, doneAction: 2);
    var pos2 = pos + (LFNoise1.kr(0.3) * scatter);
    var sig  = GrainBuf.ar(
        1,               // numChannels
        Impulse.ar(1 / grainSize), // trigger
        grainSize,       // grain duration
        buf,
        rate,
        pos2.clip(0, 1), // position in buffer (0-1)
        2                // window type (2 = Hann)
    );
    sig = sig * env * amp;
    Out.ar(out, Pan2.ar(sig, pan));
}).add;

// ------------------------------------------------------------
//  \loop_oneshot — One-shot sample player
//    Plays a sample once from start to end, then frees itself
// ------------------------------------------------------------
SynthDef(\loop_oneshot, { |out = 1, amp = 0.8, pan = 0,
                            buf = 0, rate = 1.0, gate = 1|

    var env = EnvGen.kr(Env.asr(0.001, 1, 0.05), gate, doneAction: 2);
    var sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate, doneAction: 2);
    sig = sig * env * amp;
    Out.ar(out, Pan2.ar(sig, pan));
}).add;
