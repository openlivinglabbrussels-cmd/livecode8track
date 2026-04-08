// ============================================================
//  synthdefs/bass_defs.scd — Bass / Synth SynthDefs
//  Track 6 → output bus 5
//
//  SynthDefs:
//    \bass_sub   — deep sub bass (sine, near-pure fundamental)
//    \bass_acid  — 303-style acid bassline (sawtooth + resonant filter)
//    \bass_fm    — FM bass with rich harmonics
// ============================================================

// ------------------------------------------------------------
//  \bass_sub — Deep sub bass
//    Pure sine with slight harmonic — modern sub / kick bass
// ------------------------------------------------------------
SynthDef(\bass_sub, { |out = 5, amp = 0.8, pan = 0,
                       freq = 55, gate = 1,
                       attack = 0.01, decay = 0.1, sustain = 0.7, release = 0.2|

    var env  = EnvGen.kr(
        Env.adsr(attack, decay, sustain, release),
        gate,
        doneAction: 2
    );

    // sub: mostly fundamental, tiny second harmonic for clarity on small speakers
    var sig  = SinOsc.ar(freq) + (SinOsc.ar(freq * 2) * 0.08);
    sig = sig * env * amp;

    Out.ar(out, Pan2.ar(sig, pan));
}).add;

// ------------------------------------------------------------
//  \bass_acid — 303-style acid bassline
//    Sawtooth oscillator through resonant lowpass filter
//    Cutoff and resonance can be modulated for acid sweeps
// ------------------------------------------------------------
SynthDef(\bass_acid, { |out = 5, amp = 0.7, pan = 0,
                        freq = 110, cutoff = 800, res = 0.6,
                        envAmount = 0.6, gate = 1,
                        attack = 0.001, decay = 0.2, sustain = 0.4, release = 0.1|

    var ampEnv = EnvGen.kr(
        Env.adsr(attack, decay, sustain, release),
        gate,
        doneAction: 2
    );
    var filtEnv = EnvGen.kr(Env.adsr(attack, decay, sustain * 0.5, release), gate);

    var osc  = Saw.ar(freq);
    // filter cutoff modulated by envelope
    var filt = MoogFF.ar(osc, (cutoff * (1 + (filtEnv * envAmount * 4))).clip(20, 20000), res * 4);
    var sig  = filt * ampEnv * amp;

    Out.ar(out, Pan2.ar(sig, pan));
}).add;

// ------------------------------------------------------------
//  \bass_fm — FM bass
//    Rich harmonic texture via FM — from mellow to punchy/gritty
// ------------------------------------------------------------
SynthDef(\bass_fm, { |out = 5, amp = 0.75, pan = 0,
                      freq = 80, ratio = 1.5, index = 3,
                      gate = 1,
                      attack = 0.005, decay = 0.15, sustain = 0.5, release = 0.2|

    var env    = EnvGen.kr(
        Env.adsr(attack, decay, sustain, release),
        gate,
        doneAction: 2
    );
    var ienv   = EnvGen.kr(Env.adsr(attack, decay, sustain * 0.3, release), gate);

    var mod    = SinOsc.ar(freq * ratio) * index * freq * ienv;
    var sig    = SinOsc.ar(freq + mod) * env * amp;

    Out.ar(out, Pan2.ar(sig, pan));
}).add;
