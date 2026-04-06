// =============================================================================
// CORPS SUSPENDU — SynthDef: \fmBell
// ACT III: L'Envol (The Flight)
//
// FM synthesis bell tones using a simple carrier/modulator architecture.
// The modulation index decreases over time (via its own envelope) for a
// natural bell-like spectral evolution: bright attack, warm decay.
// Uses non-integer modulation ratios for inharmonic, sacred bell quality.
//
// Parameters:
//   out       — audio output bus
//   rev       — reverb send bus
//   freq      — carrier (fundamental) frequency (Hz)
//   amp       — peak amplitude
//   modRatio  — modulator frequency / carrier frequency ratio
//               Try: 1.414, 2.0, 2.787, 3.0, 3.5 for different timbres
//   modIdx    — modulation index (depth of FM) — higher = brighter attack
//   decay     — decay time in seconds (3–8 recommended for sparse Act III use)
// =============================================================================

s.waitForBoot({

    SynthDef(\fmBell, {
        |out=0, rev=0, freq=440, amp=0.3, modRatio=2.787, modIdx=4, decay=4|
        var sig, env, car, mod, modFreq;

        modFreq = freq * modRatio;

        // Modulator has its own amplitude envelope — modulation fades over time
        mod = SinOsc.ar(
            modFreq, 0,
            freq * modIdx * EnvGen.kr(Env.perc(0.001, decay * 1.2))
        );

        // Carrier is frequency-modulated by mod
        car = SinOsc.ar(freq + mod, 0, amp);

        // Percussive amplitude envelope with exponential decay
        env = EnvGen.kr(Env.perc(0.001, decay, curve: -5), doneAction: 2);

        sig = car * env;
        sig = Pan2.ar(sig, Rand(-0.7, 0.7));  // random stereo position

        Out.ar(out, sig);
        Out.ar(rev, sig * 0.8);  // bells benefit from heavy reverb
    }).add;

    "\\fmBell loaded".postln;
});
