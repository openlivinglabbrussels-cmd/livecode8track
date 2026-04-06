// =============================================================================
// CORPS SUSPENDU — SynthDef: \sacredLaugh
// ACT IV: Le Rire Sacré (The Sacred Laugh)
//
// Formant-based voice-like synthesis with randomised fundamental and formant
// frequencies, giving an uncanny, laughing quality. CombL delay adds an
// echoic, multiplied dimension. The result is human-like but alien.
//
// The laugh rate itself is modulated by LFNoise0 — it stutters, accelerates,
// pauses, erupts — unpredictable, alive.
//
// Parameters:
//   out      — audio output bus
//   rev      — reverb send bus
//   amp      — amplitude (0.0–1.0)
//   gate     — 1 = sustain, 0 = release
//   bwScale  — scales the Formant bandwidth — higher = smoother, buzzier
// =============================================================================

s.waitForBoot({

    SynthDef(\sacredLaugh, {
        |out=0, rev=0, amp=0.25, gate=1, bwScale=1.0|
        var sig, trig, env, laughRate;

        // The laugh rate itself wanders chaotically
        laughRate = LFNoise0.kr(0.4).range(4, 18);
        trig  = Dust.kr(laughRate);

        // Formant synthesis: pitch (fundfreq), resonance peak (formfreq), bandwidth (bwfreq)
        // All three are independently randomised, producing uncanny variety
        sig = Formant.ar(
            fundfreq: LFNoise0.kr(trig).range(80, 500),
            formfreq: LFNoise0.kr(trig * 0.5).range(200, 3000),
            bwfreq:   LFNoise2.kr(0.3).range(40, 600) * bwScale
        );

        // CombL adds a repeating echo with wandering delay time — laugh multiplies
        sig = CombL.ar(sig, 0.3, LFNoise2.kr(0.2).range(0.015, 0.25), 1.5);

        sig = HPF.ar(sig, 80);
        sig = Limiter.ar(sig, 0.85);  // prevent formant spikes

        env = EnvGen.kr(Env.asr(3, 1, 5), gate, doneAction: 2);

        // Wide random stereo panning — the laugh comes from everywhere
        sig = Pan2.ar(sig * env * amp, LFNoise2.kr(0.5).range(-0.8, 0.8));

        Out.ar(out, sig);
        Out.ar(rev, sig * 0.5);
    }).add;

    "\\sacredLaugh loaded".postln;
});
