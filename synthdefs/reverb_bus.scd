// =============================================================================
// CORPS SUSPENDU — SynthDef: \reverbBus (Global Effects Bus)
//
// A stereo FreeVerb2 reverb operating on a dedicated audio bus.
// All other SynthDefs send a portion of their signal to ~reverbBus,
// which this SynthDef reads and processes, outputting to the main bus.
//
// This synth must run AFTER all source synths in the node tree.
// Create it AFTER evaluating the other SynthDefs, like so:
//
//   ~reverbBus = Bus.audio(s, 2);
//   ~reverb = Synth(\reverbBus, [\in, ~reverbBus, \out, 0, ...]);
//
// Parameters:
//   in   — input audio bus index (should be ~reverbBus)
//   out  — output audio bus (usually 0 for master out)
//   mix  — dry/wet mix (0.0 = dry, 1.0 = fully wet), ~0.5 recommended
//   room — room size (0.0–1.0), 0.85+ for large, spatial sounds
//   damp — high-frequency damping (0.0–1.0), 0.3–0.5 keeps air
//   amp  — output gain (0.0–1.0)
// =============================================================================

s.waitForBoot({

    SynthDef(\reverbBus, {
        |in, out=0, mix=0.5, room=0.85, damp=0.4, amp=1.0|
        var sig;

        sig = In.ar(in, 2);
        sig = FreeVerb2.ar(sig[0], sig[1], mix: mix, room: room, damp: damp);

        Out.ar(out, sig * amp);
    }).add;

    "\\reverbBus loaded".postln;
    "Usage:  ~reverbBus = Bus.audio(s, 2);".postln;
    "        ~reverb = Synth(\\reverbBus, [\\in, ~reverbBus, \\out, 0]);".postln;
});
