// =============================================================================
// CORPS SUSPENDU — SynthDef: \fallingHit
// ACT II: La Chute (The Fall)
//
// Ringz-based percussive body with pitch dropping via XLine.
// Simulates the acoustic signature of a falling object: high-pitched impact
// that Doppler-shifts down as it falls away.
// Each synth instance is triggered once and frees itself (doneAction: 2).
//
// Parameters:
//   out        — audio output bus
//   rev        — reverb send bus
//   freq       — initial frequency of the ring (Hz)
//   amp        — peak amplitude
//   decay      — ring decay time (seconds)
//   dropRatio  — ratio of final to initial frequency (e.g. 0.05 = drops to 5%)
// =============================================================================

s.waitForBoot({

    SynthDef(\fallingHit, {
        |out=0, rev=0, freq=900, amp=0.5, decay=0.3, dropRatio=0.05|
        var sig, env, pitchEnv;

        // XLine gives an exponential (perceptually linear) pitch descent
        pitchEnv = XLine.kr(freq, freq * dropRatio, 2.5);

        // Ringz excited by an impulse at onset + occasional random dust triggers
        sig  = Ringz.ar(Impulse.ar(0) + Dust.ar(0.5), pitchEnv, decay);

        // Short percussive amplitude envelope
        env  = EnvGen.kr(Env.perc(0.002, 2.5), doneAction: 2);

        // Randomise stereo position for each hit
        sig  = Pan2.ar(sig * env * amp, Rand(-0.9, 0.9));

        Out.ar(out, sig);
        Out.ar(rev, sig * 0.35);
    }).add;

    "\\fallingHit loaded".postln;
});
