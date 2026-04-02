// ============================================================
//  synthdefs/hihat_defs.scd — Hi-Hat SynthDefs
//  Track 4 → output bus 3
//
//  SynthDefs:
//    \hihat_closed — short, tight closed hi-hat
//    \hihat_open   — longer, open hi-hat with natural decay
//    \hihat_pedal  — foot hi-hat (chick) — very short and muffled
// ============================================================

// ------------------------------------------------------------
//  \hihat_closed — Closed hi-hat
//    Short burst of metallic noise, very tight decay
// ------------------------------------------------------------
SynthDef(\hihat_closed, { |out = 3, amp = 0.6, pan = 0,
                            decay = 0.04, tone = 8000, gate = 1|

    var env  = EnvGen.kr(Env.perc(0.0005, decay), gate, doneAction: 2);

    // metallic character: mix of square/pulse oscillators like real hi-hat
    var freqs = [tone, tone * 1.414, tone * 1.732, tone * 2.0, tone * 2.4, tone * 2.76];
    var metal = Mix(freqs.collect { |f| SquareWave.ar(f) }) / freqs.size;
    var sig   = HPF.ar(metal, 6000) * env * amp;

    Out.ar(out, Pan2.ar(sig, pan));
}).add;

// ------------------------------------------------------------
//  \hihat_open — Open hi-hat
//    Longer decay with natural ring — gate it short for effect
// ------------------------------------------------------------
SynthDef(\hihat_open, { |out = 3, amp = 0.55, pan = 0,
                          decay = 0.35, tone = 7500, gate = 1|

    var env  = EnvGen.kr(
        Env.asr(0.001, 1, decay),
        gate,
        doneAction: 2
    );

    var freqs = [tone, tone * 1.414, tone * 1.732, tone * 2.0, tone * 2.4, tone * 2.76];
    var metal = Mix(freqs.collect { |f| SquareWave.ar(f) }) / freqs.size;
    var sig   = HPF.ar(metal, 5500) * env * amp;

    Out.ar(out, Pan2.ar(sig, pan));
}).add;

// ------------------------------------------------------------
//  \hihat_pedal — Pedal/foot hi-hat (chick sound)
//    Very short and muffled — the "chick" of a closed pedal
// ------------------------------------------------------------
SynthDef(\hihat_pedal, { |out = 3, amp = 0.45, pan = 0,
                           decay = 0.015, gate = 1|

    var env  = EnvGen.kr(Env.perc(0.001, decay), gate, doneAction: 2);
    var noise = BPF.ar(WhiteNoise.ar, 5000, 0.5) * env * amp;

    Out.ar(out, Pan2.ar(noise, pan));
}).add;
