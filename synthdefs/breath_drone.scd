// =============================================================================
// CORPS SUSPENDU — SynthDef: \breathDrone
// ACT I: Le Souffle (The Breath)
//
// Filtered pink noise + multi-partial sine wave drone.
// The LFO-modulated low-pass filter gives a slow, organic breathing quality.
// Pair with \grainBreath for a full breath texture.
//
// Parameters:
//   out       — audio output bus
//   rev       — reverb send bus
//   freq      — fundamental frequency (Hz), try 55, 82.5, 110
//   amp       — amplitude (0.0–1.0)
//   gate      — 1 = sustain, 0 = release
//   filtFreq  — centre frequency for the LPF modulation (Hz)
//   lfoRate   — speed of the LFO sweeping the filter (Hz), 0.1–0.3 recommended
// =============================================================================

s.waitForBoot({

    SynthDef(\breathDrone, {
        |out=0, rev=0, freq=60, amp=0.3, gate=1, filtFreq=400, lfoRate=0.15|
        var sig, env, noise, lfoFilter;

        // Pink noise adds an airy, breath-like quality
        noise      = PinkNoise.ar(0.06);

        // LFO sweeps the filter cutoff slowly — the sound "inhales and exhales"
        lfoFilter  = LFNoise2.kr(lfoRate).range(filtFreq * 0.5, filtFreq * 2.5);

        // Layered partials: fundamental + 2nd + 3rd harmonic (slightly detuned)
        sig = SinOsc.ar(freq,        0, 0.6)
            + SinOsc.ar(freq * 2.003, 0, 0.2)
            + SinOsc.ar(freq * 3.01,  0, 0.08)
            + noise;

        sig = LPF.ar(sig, lfoFilter);
        sig = HPF.ar(sig, 30);  // remove DC / sub rumble

        // ASR envelope — long attack and release for smooth fades
        env = EnvGen.kr(Env.asr(6, 1, 8), gate, doneAction: 2);

        // Gentle stereo wander
        sig = Pan2.ar(sig * env * amp, LFNoise2.kr(0.08).range(-0.3, 0.3));

        Out.ar(out, sig);
        Out.ar(rev, sig * 0.4);  // send to reverb bus
    }).add;

    "\\breathDrone loaded".postln;
});
