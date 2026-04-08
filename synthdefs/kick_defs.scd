// ============================================================
//  synthdefs/kick_defs.scd — Kick Drum SynthDefs
//  Track 1 → output bus 0
//
//  SynthDefs:
//    \kick_808   — classic 808-style sine pitch sweep
//    \kick_noise — transient + filtered noise body
//    \kick_fm    — FM synthesis kick with punch
// ============================================================

// ------------------------------------------------------------
//  \kick_808 — Classic 808-style kick
//    Sine oscillator with exponential frequency sweep
//    Creates the deep boomy bass-drum thud
// ------------------------------------------------------------
SynthDef(\kick_808, { |out = 0, amp = 0.9, pan = 0,
                       freq = 60, sweep = 200, sweepTime = 0.08,
                       decay = 0.5, gate = 1|

    var env    = EnvGen.kr(Env.perc(0.001, decay), gate, doneAction: 2);
    var fenv   = EnvGen.kr(Env.perc(0.001, sweepTime), gate);
    var pitch  = freq + (fenv * sweep);  // frequency sweeps down from (freq+sweep) to freq
    var sig    = SinOsc.ar(pitch) * env;
    var click  = HPF.ar(WhiteNoise.ar, 2000) * EnvGen.kr(Env.perc(0.0001, 0.005), gate) * 0.3;
    sig = (sig + click) * amp;
    Out.ar(out, Pan2.ar(sig, pan));
}).add;

// ------------------------------------------------------------
//  \kick_noise — Transient + noise body kick
//    Punchy click transient layered with filtered noise decay
//    Great for harder, more industrial kick sounds
// ------------------------------------------------------------
SynthDef(\kick_noise, { |out = 0, amp = 0.8, pan = 0,
                         freq = 80, res = 0.3, decay = 0.35,
                         clickAmp = 0.5, gate = 1|

    var clickEnv = EnvGen.kr(Env.perc(0.0001, 0.015), gate);
    var bodyEnv  = EnvGen.kr(Env.perc(0.001, decay), gate, doneAction: 2);
    var fenv     = EnvGen.kr(Env.perc(0.001, 0.06), gate);

    // punchy click transient
    var click  = SinOsc.ar(freq * 8) * clickEnv * clickAmp;

    // filtered noise body
    var noise  = BPF.ar(WhiteNoise.ar, freq + (fenv * freq * 3), res) * bodyEnv;

    var sig    = (click + noise) * amp;
    Out.ar(out, Pan2.ar(sig, pan));
}).add;

// ------------------------------------------------------------
//  \kick_fm — FM synthesis kick
//    Carrier + modulator FM pair with pitch envelope
//    Creates metallic, punchy, or soft kick textures
// ------------------------------------------------------------
SynthDef(\kick_fm, { |out = 0, amp = 0.85, pan = 0,
                      freq = 55, ratio = 2.5, index = 4,
                      decay = 0.4, sweepTime = 0.1, gate = 1|

    var env      = EnvGen.kr(Env.perc(0.001, decay), gate, doneAction: 2);
    var fenv     = EnvGen.kr(Env.perc(0.001, sweepTime), gate);
    var pitchEnv = freq + (fenv * freq * 3);

    // FM: carrier modulated by modulator
    var mod  = SinOsc.ar(pitchEnv * ratio) * index * pitchEnv;
    var sig  = SinOsc.ar(pitchEnv + mod) * env * amp;

    Out.ar(out, Pan2.ar(sig, pan));
}).add;
