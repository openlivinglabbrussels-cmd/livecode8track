// ============================================================
//  synthdefs/snare_defs.scd — Snare Drum SynthDefs
//  Track 3 → output bus 2
//
//  SynthDefs:
//    \snare1     — classic noise + tone layered snare
//    \snare2     — tight rimshot-style snare with more crack
//    \snare_fat  — wide, roomy snare with extra low end
// ============================================================

// ------------------------------------------------------------
//  \snare1 — Classic noise + tone snare
//    Layered: pitched body tone + filtered noise for snare wire
// ------------------------------------------------------------
SynthDef(\snare1, { |out = 2, amp = 0.8, pan = 0,
                     freq = 200, toneAmp = 0.5, noiseAmp = 0.6,
                     decay = 0.15, gate = 1|

    var toneEnv  = EnvGen.kr(Env.perc(0.001, decay * 0.8), gate);
    var noiseEnv = EnvGen.kr(Env.perc(0.001, decay), gate, doneAction: 2);

    // pitched body: two sine tones for the drum head resonance
    var tone     = (SinOsc.ar(freq) + SinOsc.ar(freq * 1.6)) * 0.5 * toneEnv * toneAmp;

    // noise layer: bandpass filtered for snare wire texture
    var noise    = BPF.ar(WhiteNoise.ar, 3000, 0.8) * noiseEnv * noiseAmp;

    var sig      = (tone + noise) * amp;
    Out.ar(out, Pan2.ar(sig, pan));
}).add;

// ------------------------------------------------------------
//  \snare2 — Tight rimshot-style snare
//    More crack and attack, less body — punchy and dry
// ------------------------------------------------------------
SynthDef(\snare2, { |out = 2, amp = 0.8, pan = 0,
                     freq = 320, crack = 0.7, decay = 0.08,
                     gate = 1|

    var env    = EnvGen.kr(Env.perc(0.0005, decay), gate, doneAction: 2);
    var fenv   = EnvGen.kr(Env.perc(0.0005, 0.01), gate);

    // sharp transient click
    var click  = SinOsc.ar(freq + (fenv * freq * 2)) * env * crack;

    // high-passed white noise burst
    var noise  = HPF.ar(WhiteNoise.ar, 4000) * env * (1 - crack);

    var sig    = (click + noise) * amp;
    Out.ar(out, Pan2.ar(sig, pan));
}).add;

// ------------------------------------------------------------
//  \snare_fat — Wide, roomy snare
//    Extended decay, extra low-end body, wider noise band
// ------------------------------------------------------------
SynthDef(\snare_fat, { |out = 2, amp = 0.75, pan = 0,
                        freq = 160, decay = 0.3,
                        toneAmp = 0.6, noiseAmp = 0.7, gate = 1|

    var toneEnv  = EnvGen.kr(Env.perc(0.002, decay * 0.7), gate);
    var noiseEnv = EnvGen.kr(Env.perc(0.001, decay), gate, doneAction: 2);

    // fat body: three layered tones
    var tone     = Mix([
        SinOsc.ar(freq),
        SinOsc.ar(freq * 1.4) * 0.7,
        SinOsc.ar(freq * 2.1) * 0.4
    ]) * toneEnv * toneAmp / 3;

    // wide noise: two BPFs mixed
    var noise    = (
        BPF.ar(WhiteNoise.ar, 2000, 0.9) +
        BPF.ar(WhiteNoise.ar, 5000, 0.6)
    ) * 0.5 * noiseEnv * noiseAmp;

    var sig = (tone + noise) * amp;
    Out.ar(out, Pan2.ar(sig, pan));
}).add;
