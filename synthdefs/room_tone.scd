// =============================================================================
// CORPS SUSPENDU — SynthDef: \roomTone
// TRANSITIONS / PRE-SHOW
//
// Very quiet filtered noise representing the acoustic life of the room itself.
// Two BPF layers (one in the 200–900 Hz range, one in the 80–300 Hz range)
// with slowly wandering centre frequencies — the room "breathes."
// Use during pre-show, transitions, or underneath silence to prevent
// the audience perceiving total silence as a technical fault.
//
// Parameters:
//   out  — audio output bus
//   rev  — reverb send bus
//   amp  — amplitude (0.0–1.0), keep very quiet (0.02–0.06)
//   gate — 1 = sustain, 0 = release
// =============================================================================

s.waitForBoot({

    SynthDef(\roomTone, {
        |out=0, rev=0, amp=0.04, gate=1|
        var sig, env;

        // Upper layer: mid-range room resonances
        sig = BPF.ar(WhiteNoise.ar(1.0), LFNoise2.kr(0.05).range(200, 900), 0.3);

        // Lower layer: low-frequency room modes
        sig = sig + BPF.ar(WhiteNoise.ar(0.5), LFNoise2.kr(0.03).range(80, 300), 0.2);

        sig = LPF.ar(sig, 1200);  // roll off the harshest highs

        // Very long ASR — room tone should be imperceptible in its transitions
        env = EnvGen.kr(Env.asr(10, 1, 15), gate, doneAction: 2);

        sig = Pan2.ar(sig * env * amp, LFNoise2.kr(0.03).range(-0.4, 0.4));

        Out.ar(out, sig);
        Out.ar(rev, sig * 0.3);
    }).add;

    "\\roomTone loaded".postln;
});
