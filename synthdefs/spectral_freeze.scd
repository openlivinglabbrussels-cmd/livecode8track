// =============================================================================
// CORPS SUSPENDU — SynthDef: \spectralFreeze
// ACT III: L'Envol (The Flight)
//
// Simulates a spectral freeze / smear texture using overlapping delay taps
// and additive sinusoidal layers. Each partial is delayed by a different
// amount with slow independent LFO detuning, creating a smeared, sustained
// harmonic cloud — similar in effect to PV_MagFreeze or PV_MagSmear.
//
// This approach avoids FFT buffer complexity while giving a comparable sonic
// result: a texture that feels "frozen in time" yet gently moving.
//
// Parameters:
//   out   — audio output bus
//   rev   — reverb send bus
//   freq  — base frequency of the harmonic stack (Hz)
//   amp   — amplitude (0.0–1.0)
//   gate  — 1 = sustain, 0 = release
//   rate  — currently unused placeholder for future modulation rate param
// =============================================================================

s.waitForBoot({

    SynthDef(\spectralFreeze, {
        |out=0, rev=0, freq=330, amp=0.15, gate=1, rate=0.5|
        var sig, env, layers;

        // Six delayed harmonic partials — each with independent detune + delay offset
        layers = Mix.fill(6, { |i|
            var baseFreq = freq * (i + 1)
                         * LFNoise2.kr(0.02 + (i * 0.005)).range(0.995, 1.005);
            var delTime  = (i * 0.13) + LFNoise2.kr(0.03).range(0.0, 0.04);

            // Delay each partial by a different amount — creates "smear" effect
            DelayC.ar(
                SinOsc.ar(baseFreq, 0, (1 / (i + 1).sqrt) * 0.18),
                0.8,
                delTime
            )
        });

        sig  = layers;
        sig  = LPF.ar(sig, 8000);

        // Very long ASR envelope — this texture should emerge and dissolve slowly
        env  = EnvGen.kr(Env.asr(10, 1, 12), gate, doneAction: 2);

        sig  = sig * env * amp;
        sig  = Pan2.ar(sig, LFNoise2.kr(0.05).range(-0.5, 0.5));

        Out.ar(out, sig);
        Out.ar(rev, sig * 0.85);  // maximum reverb for a truly spatial texture
    }).add;

    "\\spectralFreeze loaded".postln;
});
