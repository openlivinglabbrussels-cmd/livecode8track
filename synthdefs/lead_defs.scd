// ============================================================
//  synthdefs/lead_defs.scd — Lead / Pad / FX SynthDefs
//  Track 7 → output bus 6
//
//  SynthDefs:
//    \lead_saw   — detuned supersaw lead
//    \lead_square — hollow square wave lead with filter
//    \pad_soft   — soft ambient pad (slow attack, long release)
//    \texture_grain — granular-style texture (LFO modulated noise)
// ============================================================

// ------------------------------------------------------------
//  \lead_saw — Detuned supersaw lead
//    Multiple detuned saws — classic trance/electro lead
// ------------------------------------------------------------
SynthDef(\lead_saw, { |out = 6, amp = 0.5, pan = 0,
                       freq = 440, detune = 0.2, cutoff = 3000, res = 0.3,
                       gate = 1,
                       attack = 0.01, decay = 0.1, sustain = 0.8, release = 0.3|

    var env  = EnvGen.kr(
        Env.adsr(attack, decay, sustain, release),
        gate,
        doneAction: 2
    );

    // 5 detuned sawtooth oscillators
    var saws = Mix([-2, -1, 0, 1, 2].collect { |i|
        Saw.ar(freq * (1 + (i * detune * 0.01)))
    }) / 5;

    var sig  = RLPF.ar(saws, cutoff, res) * env * amp;
    Out.ar(out, Pan2.ar(sig, pan));
}).add;

// ------------------------------------------------------------
//  \lead_square — Square wave lead with filter sweep
//    Hollow square timbre — great for arpeggios and melodies
// ------------------------------------------------------------
SynthDef(\lead_square, { |out = 6, amp = 0.5, pan = 0,
                           freq = 440, width = 0.5, cutoff = 2000, res = 0.5,
                           gate = 1,
                           attack = 0.005, decay = 0.1, sustain = 0.7, release = 0.2|

    var env    = EnvGen.kr(
        Env.adsr(attack, decay, sustain, release),
        gate,
        doneAction: 2
    );
    var filtEnv = EnvGen.kr(Env.adsr(attack, decay * 0.5, sustain * 0.5, release), gate);

    var osc    = Pulse.ar(freq, width);
    var filt   = RLPF.ar(osc, (cutoff * (1 + filtEnv)).clip(20, 20000), res);
    var sig    = filt * env * amp;

    Out.ar(out, Pan2.ar(sig, pan));
}).add;

// ------------------------------------------------------------
//  \pad_soft — Soft ambient pad
//    Slow attack, lush modulated sound — atmospheric textures
// ------------------------------------------------------------
SynthDef(\pad_soft, { |out = 6, amp = 0.4, pan = 0,
                       freq = 220, detune = 0.3, gate = 1,
                       attack = 1.5, decay = 0.5, sustain = 0.7, release = 2.0|

    var env  = EnvGen.kr(
        Env.adsr(attack, decay, sustain, release),
        gate,
        doneAction: 2
    );

    // warm pad: sine + slightly detuned saws + slow LFO modulation
    var lfo  = SinOsc.kr(0.3) * 0.005;
    var saws = Mix([-1, 0, 1].collect { |i|
        Saw.ar(freq * (1 + (i * detune * 0.01) + lfo))
    }) / 3;
    var sig  = LPF.ar(saws, 2000) * env * amp;

    Out.ar(out, Pan2.ar(sig, pan));
}).add;

// ------------------------------------------------------------
//  \texture_grain — Granular-style texture / noise synth
//    LFO-modulated bandpass noise — dreamy texture layers
// ------------------------------------------------------------
SynthDef(\texture_grain, { |out = 6, amp = 0.3, pan = 0,
                             freq = 1000, lfoRate = 0.5, depth = 0.5,
                             gate = 1,
                             attack = 0.5, release = 1.0|

    var env   = EnvGen.kr(
        Env.asr(attack, 1, release),
        gate,
        doneAction: 2
    );
    var lfo   = SinOsc.kr(lfoRate) * depth + (1 - depth);
    var noise = BPF.ar(GrayNoise.ar, freq * lfo, 0.3);
    var sig   = noise * env * amp;

    Out.ar(out, Pan2.ar(sig, pan));
}).add;
