// =============================================================================
// CORPS SUSPENDU — SynthDef: \fallingDrone
// ACT II: La Chute (The Fall)
//
// A continuous drone that descends in pitch over a long duration.
// The exponential descent (XLine) makes gravity audible — the sound of
// something very large and heavy descending inexorably.
//
// Parameters:
//   out        — audio output bus
//   rev        — reverb send bus
//   startFreq  — initial frequency (Hz), e.g. 220
//   endFreq    — final frequency (Hz), e.g. 28 (a deep rumble)
//   dur        — total duration of the pitch fall (seconds)
//   amp        — amplitude (0.0–1.0)
//   gate       — 1 = sustain, 0 = release envelope
// =============================================================================

s.waitForBoot({

    SynthDef(\fallingDrone, {
        |out=0, rev=0, startFreq=220, endFreq=28, dur=120, amp=0.35, gate=1|
        var sig, env, pitchEnv;

        // Exponential descent — sounds more natural than linear for pitch
        pitchEnv = XLine.kr(startFreq, endFreq, dur);

        // Layered waveforms: saw adds body, sines add warmth and harmonics
        sig  = Saw.ar(pitchEnv, 0.4)
             + SinOsc.ar(pitchEnv,        0, 0.6)
             + SinOsc.ar(pitchEnv * 2.01, 0, 0.2);

        // Filter tracks the pitch — opens up as pitch falls, closes at low end
        sig  = LPF.ar(sig, pitchEnv * 4 + 80);
        sig  = HPF.ar(sig, 20);   // remove infrasonic rumble

        // ASR envelope allows smooth gating
        env  = EnvGen.kr(Env.asr(4, 1, 6), gate, doneAction: 2);

        sig  = Pan2.ar(sig * env * amp, LFNoise2.kr(0.05).range(-0.2, 0.2));

        Out.ar(out, sig);
        Out.ar(rev, sig * 0.3);
    }).add;

    "\\fallingDrone loaded".postln;
});
