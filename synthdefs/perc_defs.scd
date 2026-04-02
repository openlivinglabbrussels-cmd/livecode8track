// ============================================================
//  synthdefs/perc_defs.scd — Percussion SynthDefs
//  Track 5 → output bus 4
//
//  SynthDefs:
//    \clap       — electronic clap (layered noise bursts)
//    \rimshot    — rimshot / sidestick
//    \shaker     — shaker / maraca texture
//    \cowbell    — classic electronic cowbell
// ============================================================

// ------------------------------------------------------------
//  \clap — Electronic clap
//    Multiple short noise bursts with slight timing offset
// ------------------------------------------------------------
SynthDef(\clap, { |out = 4, amp = 0.75, pan = 0,
                   decay = 0.2, gate = 1|

    var env1 = EnvGen.kr(Env.perc(0.001, 0.01));
    var env2 = EnvGen.kr(Env.perc(0.012, 0.008));
    var env3 = EnvGen.kr(Env.perc(0.024, decay), doneAction: 2);

    var noise1 = BPF.ar(WhiteNoise.ar, 1200, 0.7) * env1;
    var noise2 = BPF.ar(WhiteNoise.ar, 1500, 0.6) * env2;
    var noise3 = BPF.ar(WhiteNoise.ar, 1000, 0.8) * env3;

    var sig = (noise1 + noise2 + noise3) / 3 * amp;
    Out.ar(out, Pan2.ar(sig, pan));
}).add;

// ------------------------------------------------------------
//  \rimshot — Rimshot / sidestick
//    Short, sharp pitched click — rim hit or wood block
// ------------------------------------------------------------
SynthDef(\rimshot, { |out = 4, amp = 0.7, pan = 0,
                      freq = 800, decay = 0.06, gate = 1|

    var env  = EnvGen.kr(Env.perc(0.0005, decay), gate, doneAction: 2);
    var fenv = EnvGen.kr(Env.perc(0.0005, 0.005), gate);

    var tone  = SinOsc.ar(freq + (fenv * freq)) * 0.6;
    var noise = BPF.ar(WhiteNoise.ar, freq * 1.5, 0.5) * 0.4;
    var sig   = (tone + noise) * env * amp;

    Out.ar(out, Pan2.ar(sig, pan));
}).add;

// ------------------------------------------------------------
//  \shaker — Shaker / maraca
//    Filtered noise with fast envelope — shake or maraca sound
// ------------------------------------------------------------
SynthDef(\shaker, { |out = 4, amp = 0.5, pan = 0,
                     freq = 6000, decay = 0.05, gate = 1|

    var env  = EnvGen.kr(Env.perc(0.002, decay), gate, doneAction: 2);
    var sig  = BPF.ar(WhiteNoise.ar, freq, 0.4) * env * amp;

    Out.ar(out, Pan2.ar(sig, pan));
}).add;

// ------------------------------------------------------------
//  \cowbell — Classic electronic cowbell
//    Two square waves with short decay — 808-style cowbell
// ------------------------------------------------------------
SynthDef(\cowbell, { |out = 4, amp = 0.6, pan = 0,
                      freq = 562, decay = 0.5, gate = 1|

    var env  = EnvGen.kr(Env.perc(0.001, decay), gate, doneAction: 2);

    // classic cowbell uses two slightly detuned square waves
    var sig  = (SquareWave.ar(freq) + SquareWave.ar(freq * 1.502)) * 0.5;
    sig = BPF.ar(sig, freq * 2, 0.8) * env * amp;

    Out.ar(out, Pan2.ar(sig, pan));
}).add;
