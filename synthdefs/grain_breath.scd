// =============================================================================
// CORPS SUSPENDU — SynthDef: \grainBreath
// ACT I: Le Souffle (The Breath)
//
// Granular synthesis using GrainSin with dust (random) triggers.
// Creates a cloud of sinusoidal grains suggesting scattered breath fragments.
// Combine with \breathDrone for the full Act I texture.
//
// Parameters:
//   out       — audio output bus
//   rev       — reverb send bus
//   freq      — centre frequency of the grains (Hz)
//   amp       — amplitude (0.0–1.0)
//   gate      — 1 = sustain, 0 = release
//   density   — average grain triggers per second (Dust rate)
//   grainDur  — average duration of each grain in seconds
// =============================================================================

s.waitForBoot({

    SynthDef(\grainBreath, {
        |out=0, rev=0, freq=220, amp=0.18, gate=1, density=8, grainDur=0.12|
        var sig, env, trig;

        // Dust gives random timing — irregular, breath-like
        trig = Dust.kr(density);

        // GrainSin: each grain is a brief windowed sine wave
        // Frequency and pan are randomly scattered around the centre
        sig = GrainSin.ar(
            numChannels: 2,
            trigger:     trig,
            dur:         grainDur + LFNoise2.kr(0.5).range(-0.04, 0.04),
            freq:        freq * LFNoise2.kr(0.3).range(0.97, 1.03),
            pan:         LFNoise2.kr(1).range(-0.6, 0.6),
            envbufnum:   -1   // use default Hann window
        );

        // ASR envelope — long fade in/out for integration with breathDrone
        env = EnvGen.kr(Env.asr(5, 1, 7), gate, doneAction: 2);

        sig = sig * env * amp;

        Out.ar(out, sig);
        Out.ar(rev, sig * 0.6);  // heavier reverb send for spatial depth
    }).add;

    "\\grainBreath loaded".postln;
});
