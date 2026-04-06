// =============================================================================
// CORPS SUSPENDU — SynthDef: \glitchPerc
// ACT II: La Chute (The Fall) / ACT IV: Le Rire Sacré
//
// Stochastic percussive glitches using Dust triggers into resonant Ringz filters.
// Density, frequency range, and amplitude are all controllable.
// Useful in Act II for mechanical/body-shock textures, and Act IV for chaos.
//
// Parameters:
//   out       — audio output bus
//   rev       — reverb send bus
//   amp       — amplitude (0.0–1.0)
//   density   — average trigger rate (events/second)
//   minFreq   — lower bound of random resonant frequency (Hz)
//   maxFreq   — upper bound of random resonant frequency (Hz)
// =============================================================================

s.waitForBoot({

    SynthDef(\glitchPerc, {
        |out=0, rev=0, amp=0.4, density=3, minFreq=200, maxFreq=4000|
        var sig, trig, freq;

        trig = Dust.ar(density);

        // Random resonant frequency chosen at each trigger (TRand)
        freq = TRand.kr(minFreq, maxFreq, trig);

        // Two Ringz filters: fundamental + golden ratio interval above
        sig  = Ringz.ar(trig, freq,           0.05 + LFNoise0.kr(5).range(0.01, 0.15), 0.5);
        sig  = sig + Ringz.ar(trig, freq * 1.618, 0.04, 0.3);

        sig  = HPF.ar(sig, 60);
        sig  = Limiter.ar(sig, 0.9);  // protect against transient spikes

        // Random stereo position on every trigger group
        sig  = Pan2.ar(sig * amp, LFNoise0.kr(density * 0.5).range(-1.0, 1.0));

        Out.ar(out, sig);
        Out.ar(rev, sig * 0.25);
    }).add;

    "\\glitchPerc loaded".postln;
});
