// ============================================================
//  synthdefs/fx_defs.scd — FX / Master Bus SynthDefs
//  Track 8 → output bus 7 (master/aux)
//  Also used as send effects on internal buses
//
//  SynthDefs:
//    \fx_reverb    — plate-style reverb (FreeVerb)
//    \fx_delay     — stereo ping-pong delay
//    \fx_compressor — soft-knee compressor / limiter
//    \fx_master    — master bus: EQ + limiter + soft saturation
//
//  USAGE:
//    These FX synths read from an input bus and write to an output bus.
//    Create a private bus for each send:
//      ~reverbBus = Bus.audio(s, 1);
//    Route source signals into ~reverbBus, then run fx_reverb reading from it.
// ============================================================

// ------------------------------------------------------------
//  \fx_reverb — Plate-style reverb (FreeVerb algorithm)
// ------------------------------------------------------------
SynthDef(\fx_reverb, { |in = 0, out = 7, amp = 0.7,
                         mix = 0.4, room = 0.7, damp = 0.5|

    var sig = In.ar(in, 1);
    var wet = FreeVerb.ar(sig, mix, room, damp);
    Out.ar(out, Pan2.ar(wet * amp, 0));
}).add;

// ------------------------------------------------------------
//  \fx_delay — Stereo ping-pong delay
// ------------------------------------------------------------
SynthDef(\fx_delay, { |in = 0, out = 7, amp = 0.6,
                        delTime = 0.25, feedback = 0.45, mix = 0.35|

    var sig   = In.ar(in, 1);
    var wetL  = CombC.ar(sig, 2.0, delTime,       feedback * 6);
    var wetR  = CombC.ar(sig, 2.0, delTime * 0.75, feedback * 6);
    var wet   = [wetL, wetR] * mix;
    var dry   = [sig, sig] * (1 - mix);
    Out.ar(out, (wet + dry) * amp);
}).add;

// ------------------------------------------------------------
//  \fx_compressor — Soft-knee compressor
// ------------------------------------------------------------
SynthDef(\fx_compressor, { |in = 0, out = 7, amp = 1.0,
                             thresh = 0.5, ratio = 4, attack = 0.01, release = 0.1|

    var sig  = In.ar(in, 1);
    var comp = Compander.ar(sig, sig, thresh,
        slopeBelow: 1,
        slopeAbove: 1 / ratio,
        clampTime: attack,
        relaxTime: release
    );
    Out.ar(out, Pan2.ar(comp * amp, 0));
}).add;

// ------------------------------------------------------------
//  \fx_master — Master bus processing
//    Light EQ (shelf filters) + soft clipper + limiter
// ------------------------------------------------------------
SynthDef(\fx_master, { |in = 0, out = 7, amp = 0.9,
                         lowShelf = 1.0, highShelf = 1.0,
                         driveAmt = 0.2|

    var sig = In.ar(in, 1);

    // simple 2-band shelf EQ
    sig = BLowShelf.ar(sig, 100, 0.7, lowShelf.ampdb);
    sig = BHiShelf.ar(sig,  8000, 0.7, highShelf.ampdb);

    // soft saturation / drive
    sig = sig * (1 + driveAmt);
    sig = sig.tanh;  // soft clip

    // final limiter
    sig = Limiter.ar(sig, 0.98, 0.001);

    Out.ar(out, Pan2.ar(sig * amp, 0));
}).add;
