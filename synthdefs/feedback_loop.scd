// =============================================================================
// CORPS SUSPENDU — SynthDef: \feedbackLoop
// ACT IV: Le Rire Sacré (The Sacred Laugh)
//
// Controlled feedback using LocalIn/LocalOut with a delay line.
// The feedback path processes the signal through a sine oscillator whose
// frequency is influenced by the feedback signal itself — a chaotic system
// that sounds alive and unpredictable, yet stays bounded via Limiter.
//
// CAUTION: Keep amp low (0.1–0.25) and feedback < 0.85 to avoid runaway.
// The ~panic function will kill it immediately if needed.
//
// Parameters:
//   out       — audio output bus
//   rev       — reverb send bus
//   amp       — amplitude (0.0–1.0), keep low
//   gate      — 1 = sustain, 0 = release
//   delTime   — feedback delay time (seconds), try 0.17–0.41
//   feedback  — feedback coefficient (0.0–0.8 recommended)
// =============================================================================

s.waitForBoot({

    SynthDef(\feedbackLoop, {
        |out=0, rev=0, amp=0.2, gate=1, delTime=0.23, feedback=0.65|
        var sig, env, fb;

        // Read the delayed feedback signal
        fb  = LocalIn.ar(1);

        // Sine oscillator whose frequency is nudged by the feedback value
        sig = SinOsc.ar(
            LFNoise2.kr(0.3).range(80, 400) + (fb * 120),
            0, 0.3
        );

        // Mix in the scaled feedback
        sig = sig + (fb * feedback);
        sig = Limiter.ar(sig, 0.9);   // hard limiter — safety net
        sig = LPF.ar(sig, 4000);      // tame harsh high frequencies

        // Write back into the delay — this creates the feedback loop
        LocalOut.ar(
            DelayC.ar(sig, 0.5, delTime + LFNoise2.kr(0.1).range(-0.02, 0.02))
        );

        env = EnvGen.kr(Env.asr(4, 1, 6), gate, doneAction: 2);

        sig = Pan2.ar(sig * env * amp, LFNoise2.kr(0.4).range(-0.7, 0.7));

        Out.ar(out, sig);
        Out.ar(rev, sig * 0.4);
    }).add;

    "\\feedbackLoop loaded".postln;
});
