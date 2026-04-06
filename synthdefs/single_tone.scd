// =============================================================================
// CORPS SUSPENDU — SynthDef: \singleTone
// TRANSITIONS
//
// A pure sine tone with subtle beating (two slightly detuned sines) for
// the liminal spaces between acts. Very quiet, very still.
// The gentle beating (0.0007 ratio ≈ ~0.15 Hz at 220 Hz) creates a barely
// perceptible pulse — the audience feels it more than hears it.
//
// Parameters:
//   out      — audio output bus
//   rev      — reverb send bus
//   freq     — frequency of the tone (Hz), try notes from the harmonic series
//   amp      — amplitude (0.0–1.0), keep very quiet (0.08–0.18)
//   gate     — 1 = sustain, 0 = release
//   fadeIn   — attack time in seconds
//   fadeOut  — release time in seconds
// =============================================================================

s.waitForBoot({

    SynthDef(\singleTone, {
        |out=0, rev=0, freq=220, amp=0.15, gate=1, fadeIn=6, fadeOut=10|
        var sig, env;

        // Two sines very slightly detuned — creates a slow beating phenomenon
        sig = SinOsc.ar(freq,           0, amp)
            + SinOsc.ar(freq * 1.0007, 0, amp * 0.3);

        // Long, gentle ASR envelope controlled by gate parameter
        env = EnvGen.kr(Env.asr(fadeIn, 1, fadeOut), gate, doneAction: 2);

        sig = Pan2.ar(sig * env, 0);  // centred in stereo field

        Out.ar(out, sig);
        Out.ar(rev, sig * 0.2);  // minimal reverb — keep it intimate
    }).add;

    "\\singleTone loaded".postln;
});
