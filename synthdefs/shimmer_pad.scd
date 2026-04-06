// =============================================================================
// CORPS SUSPENDU — SynthDef: \shimmerPad
// ACT III: L'Envol (The Flight)
//
// Additive synthesis with detuned harmonics over the natural overtone series.
// Each partial is independently detuned by a slow LFNoise2, creating a
// shimmering, beating quality — the acoustic sensation of weightlessness.
//
// Parameters:
//   out      — audio output bus
//   rev      — reverb send bus
//   freq     — fundamental frequency (Hz) — use overtone series values
//   amp      — amplitude (0.0–1.0)
//   gate     — 1 = sustain, 0 = release
//   numHarm  — number of harmonics to synthesise (4–12 recommended)
//   detune   — max detuning fraction per partial (0.004–0.02 recommended)
// =============================================================================

s.waitForBoot({

    SynthDef(\shimmerPad, {
        |out=0, rev=0, freq=220, amp=0.18, gate=1, numHarm=8, detune=0.008|
        var sig, env, partials;

        // Build additive synthesis from harmonic partials
        // Each partial has an independent slow LFO detune for shimmer
        partials = Mix.fill(numHarm, { |i|
            var harmFreq = freq * (i + 1)
                         * (1 + LFNoise2.kr(0.05 + (i * 0.01)).range(detune.neg, detune));
            // Amplitude decreases with harmonic number (1/sqrt(n))
            SinOsc.ar(harmFreq, 0, (1 / (i + 1).sqrt) * 0.2)
        });

        sig = partials;

        // Slight random amplitude tremolo adds organic life
        sig = sig + (sig * LFNoise2.kr(0.3).range(0.0, 0.15));

        // ASR envelope — very long attack and release for Act III
        env = EnvGen.kr(Env.asr(8, 1, 10), gate, doneAction: 2);
        sig = sig * env * amp;

        // Subtle stereo divergence by LFO-modulating one channel's level
        sig = [sig, sig * LFNoise2.kr(0.07).range(0.85, 1.0)];

        Out.ar(out, sig);
        Out.ar(rev, sig * 0.7);  // heavy reverb send for maximum space
    }).add;

    "\\shimmerPad loaded".postln;
});
