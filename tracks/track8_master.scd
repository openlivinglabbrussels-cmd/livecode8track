// ============================================================
//  tracks/track8_master.scd — 🎚️ MASTER / AUX
//  Output: bus 7 (Track 8)
//
//  SynthDefs available (from synthdefs/fx_defs.scd):
//    \fx_reverb     — plate reverb (FreeVerb)
//    \fx_delay      — ping-pong delay
//    \fx_compressor — soft-knee compressor
//    \fx_master     — master bus EQ + limiter + saturation
//
//  WORKFLOW:
//    1. Run boot.scd first — all FX buses are created here
//    2. Set up send buses and start FX synths below
//    3. Route signals into FX buses from track files
//    4. This track also outputs its own audio to bus 7
//    5. Use STOP section at the bottom to stop all FX
// ============================================================

// ============================================================
//  SETUP — create send buses and start FX synths
//  Run this once after boot.scd
// ============================================================
(
// Create private audio buses for each FX send
~reverbBus = Bus.audio(s, 1);
~delayBus  = Bus.audio(s, 1);

s.sync;

// Start FX synths — add them AFTER all other synths (\addToTail)
~reverbSynth = Synth.new(\fx_reverb,
    [\in, ~reverbBus, \out, 7, \mix, 0.45, \room, 0.75, \damp, 0.5, \amp, 0.7],
    s, \addToTail
);
~delaySynth = Synth.new(\fx_delay,
    [\in, ~delayBus, \out, 7, \delTime, 0.25, \feedback, 0.45, \mix, 0.35, \amp, 0.6],
    s, \addToTail
);

"FX synths started:".postln;
("  Reverb bus: " ++ ~reverbBus).postln;
("  Delay  bus: " ++ ~delayBus).postln;
)

// ============================================================
//  MASTER BUS PROCESSING
//  Apply compression and gentle limiting on output bus 7
// ============================================================
(
~masterSynth = Synth.new(\fx_master,
    [\in, 7, \out, 7, \amp, 0.9, \driveAmt, 0.15],
    s, \addToTail
);
"Master bus processing active.".postln;
)

// ============================================================
//  SEND ROUTING — in your track files, send signal to FX buses
//  Examples of how to route from other tracks:
// ============================================================

// From any track file, you can write to the FX buses:
//   Out.ar(~reverbBus, signal * sendLevel);
//   Out.ar(~delayBus,  signal * sendLevel);

// Example: play a synth and send 30% to reverb
// (
// {
//     var sig = SinOsc.ar(440) * 0.3 *
//               EnvGen.kr(Env.perc(0.01, 1), doneAction: 2);
//     Out.ar(6, sig);                        // dry to bus 6 (Track 7 output)
//     Out.ar(~reverbBus, sig * 0.3);         // wet send to reverb
// }.play;
// )

// ============================================================
//  LIVE TWEAKING — adjust FX parameters
// ============================================================

// Reverb: increase room size for a bigger space
// ~reverbSynth.set(\room, 0.9, \mix, 0.6);

// Reverb: pull back to a tight plate
// ~reverbSynth.set(\room, 0.3, \mix, 0.25);

// Delay: sync to tempo (0.5 = 8th note delay at 120 BPM)
// ~delaySynth.set(\delTime, 0.5, \feedback, 0.5);

// Delay: subtle slapback
// ~delaySynth.set(\delTime, 0.1, \feedback, 0.2, \mix, 0.2);

// Master drive — more saturation
// ~masterSynth.set(\driveAmt, 0.4);

// Master amp — overall level
// ~masterSynth.set(\amp, 0.8);

// ============================================================
//  AUXILIARY OUTPUT — also use track 8 as a spare output
//  e.g., for a headphone cue mix or monitoring
// ============================================================

// (
// Pdef(\aux, Pbind(
//     \instrument, \lead_saw,
//     \out,      7,              // direct to output 7
//     \midinote, Pseq([60, 63, 67], inf),
//     \dur,      0.5,
//     \amp,      0.3
// )).play;
// )

// ============================================================
//  STOP
// ============================================================

// Stop FX synths:
// ~reverbSynth.free;
// ~delaySynth.free;
// ~masterSynth.free;

// Free FX buses:
// ~reverbBus.free;
// ~delayBus.free;

// Stop everything (all tracks):
// CmdPeriod.run;
