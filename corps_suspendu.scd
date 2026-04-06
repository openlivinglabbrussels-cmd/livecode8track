// =============================================================================
// CORPS SUSPENDU
// A SuperCollider Live Performance for "Où est la sainte dramaturgie?"
// Compagnie Sens du Sommeil — Cirque-Théâtre
//
// Duration: 40 minutes to 1 hour
// Structure: 4 Acts + Transitions
//
// HOW TO USE:
//   1. Boot the server: s.boot
//   2. Evaluate the SETUP block (all SynthDefs + buses)
//   3. Use the PERFORMANCE CONTROL section at the bottom to cue each act
//   4. Use ~panic anytime to kill everything
// =============================================================================

s.waitForBoot({

// =============================================================================
// GLOBAL BUSES & SETUP
// =============================================================================

~reverbBus = Bus.audio(s, 2);  // stereo reverb send bus
~masterAmp = 1.0;              // master amplitude (adjust live)

// =============================================================================
// GLOBAL REVERB — always running, receives sends from synths
// =============================================================================

SynthDef(\reverbBus, {
    |in, out=0, mix=0.5, room=0.85, damp=0.4, amp=1.0|
    var sig;
    sig = In.ar(in, 2);
    sig = FreeVerb2.ar(sig[0], sig[1], mix: mix, room: room, damp: damp);
    Out.ar(out, sig * amp);
}).add;

// =============================================================================
// SYNTHDEFS — ACT I: LE SOUFFLE (The Breath)
// =============================================================================

// Filtered pink noise + sine with LFO-modulated filter cutoff
// This is the foundational breath drone — a warm, slowly evolving texture
SynthDef(\breathDrone, {
    |out=0, rev=0, freq=60, amp=0.3, gate=1, filtFreq=400, lfoRate=0.15|
    var sig, env, noise, lfoFilter;
    noise   = PinkNoise.ar(0.06);
    lfoFilter = LFNoise2.kr(lfoRate).range(filtFreq * 0.5, filtFreq * 2.5);
    sig     = SinOsc.ar(freq, 0, 0.6)
            + SinOsc.ar(freq * 2.003, 0, 0.2)
            + SinOsc.ar(freq * 3.01,  0, 0.08)
            + noise;
    sig     = LPF.ar(sig, lfoFilter);
    sig     = HPF.ar(sig, 30);
    env     = EnvGen.kr(Env.asr(6, 1, 8), gate, doneAction: 2);
    sig     = Pan2.ar(sig * env * amp, LFNoise2.kr(0.08).range(-0.3, 0.3));
    Out.ar(out, sig);
    Out.ar(rev, sig * 0.4);
}).add;

// Granular synthesis — dust-triggered sinusoidal grains suggesting breath texture
SynthDef(\grainBreath, {
    |out=0, rev=0, freq=220, amp=0.18, gate=1, density=8, grainDur=0.12|
    var sig, env, trig;
    trig = Dust.kr(density);
    sig  = GrainSin.ar(
        numChannels: 2,
        trigger:     trig,
        dur:         grainDur + LFNoise2.kr(0.5).range(-0.04, 0.04),
        freq:        freq * LFNoise2.kr(0.3).range(0.97, 1.03),
        pan:         LFNoise2.kr(1).range(-0.6, 0.6),
        envbufnum:   -1
    );
    env = EnvGen.kr(Env.asr(5, 1, 7), gate, doneAction: 2);
    sig = sig * env * amp;
    Out.ar(out, sig);
    Out.ar(rev, sig * 0.6);
}).add;

// =============================================================================
// SYNTHDEFS — ACT II: LA CHUTE (The Fall)
// =============================================================================

// Ringz-based percussive hit with pitch dropping via XLine — the feeling of falling
SynthDef(\fallingHit, {
    |out=0, rev=0, freq=900, amp=0.5, decay=0.3, dropRatio=0.05|
    var sig, env, pitchEnv;
    pitchEnv = XLine.kr(freq, freq * dropRatio, 2.5);
    sig  = Ringz.ar(Impulse.ar(0) + Dust.ar(0.5), pitchEnv, decay);
    env  = EnvGen.kr(Env.perc(0.002, 2.5), doneAction: 2);
    sig  = Pan2.ar(sig * env * amp, Rand(-0.9, 0.9));
    Out.ar(out, sig);
    Out.ar(rev, sig * 0.35);
}).add;

// A drone that slowly falls in pitch — gravity made audible
SynthDef(\fallingDrone, {
    |out=0, rev=0, startFreq=220, endFreq=28, dur=120, amp=0.35, gate=1|
    var sig, env, pitchEnv;
    pitchEnv = XLine.kr(startFreq, endFreq, dur);
    sig  = Saw.ar(pitchEnv, 0.4)
         + SinOsc.ar(pitchEnv, 0, 0.6)
         + SinOsc.ar(pitchEnv * 2.01, 0, 0.2);
    sig  = LPF.ar(sig, pitchEnv * 4 + 80);
    sig  = HPF.ar(sig, 20);
    env  = EnvGen.kr(Env.asr(4, 1, 6), gate, doneAction: 2);
    sig  = Pan2.ar(sig * env * amp, LFNoise2.kr(0.05).range(-0.2, 0.2));
    Out.ar(out, sig);
    Out.ar(rev, sig * 0.3);
}).add;

// Stochastic percussive glitches — Dust triggers resonant filters for a body-shock texture
SynthDef(\glitchPerc, {
    |out=0, rev=0, amp=0.4, density=3, minFreq=200, maxFreq=4000|
    var sig, env, trig, freq;
    trig = Dust.ar(density);
    freq = TRand.kr(minFreq, maxFreq, trig);
    sig  = Ringz.ar(trig, freq, 0.05 + LFNoise0.kr(5).range(0.01, 0.15), 0.5);
    sig  = sig + Ringz.ar(trig, freq * 1.618, 0.04, 0.3);
    sig  = HPF.ar(sig, 60);
    sig  = Limiter.ar(sig, 0.9);
    sig  = Pan2.ar(sig * amp, LFNoise0.kr(density * 0.5).range(-1.0, 1.0));
    Out.ar(out, sig);
    Out.ar(rev, sig * 0.25);
}).add;

// =============================================================================
// SYNTHDEFS — ACT III: L'ENVOL (The Flight)
// =============================================================================

// Additive synthesis with detuned harmonics — the shimmer of weightlessness
SynthDef(\shimmerPad, {
    |out=0, rev=0, freq=220, amp=0.18, gate=1, numHarm=8, detune=0.008|
    var sig, env, partials;
    partials = Mix.fill(numHarm, { |i|
        var harmFreq = freq * (i + 1) * (1 + (LFNoise2.kr(0.05 + (i * 0.01)).range(detune.neg, detune)));
        SinOsc.ar(harmFreq, 0, (1 / (i + 1).sqrt) * 0.2)
    });
    sig  = partials;
    sig  = sig + (sig * LFNoise2.kr(0.3).range(0.0, 0.15));
    env  = EnvGen.kr(Env.asr(8, 1, 10), gate, doneAction: 2);
    sig  = sig * env * amp;
    sig  = [sig, sig * LFNoise2.kr(0.07).range(0.85, 1.0)];  // slight stereo divergence
    Out.ar(out, sig);
    Out.ar(rev, sig * 0.7);
}).add;

// FM synthesis bell tones — sparse, ethereal, sacred
SynthDef(\fmBell, {
    |out=0, rev=0, freq=440, amp=0.3, modRatio=2.787, modIdx=4, decay=4|
    var sig, env, car, mod, modFreq;
    modFreq = freq * modRatio;
    mod     = SinOsc.ar(modFreq, 0, freq * modIdx * EnvGen.kr(Env.perc(0.001, decay * 1.2)));
    car     = SinOsc.ar(freq + mod, 0, amp);
    env     = EnvGen.kr(Env.perc(0.001, decay, curve: -5), doneAction: 2);
    sig     = car * env;
    sig     = Pan2.ar(sig, Rand(-0.7, 0.7));
    Out.ar(out, sig);
    Out.ar(rev, sig * 0.8);
}).add;

// Spectral freeze-like texture: long overlapping delays + smeared input
// (Simulates PV_MagFreeze behaviour using delays + pitch shift)
SynthDef(\spectralFreeze, {
    |out=0, rev=0, freq=330, amp=0.15, gate=1, rate=0.5|
    var sig, env, layers;
    layers = Mix.fill(6, { |i|
        var baseFreq = freq * (i + 1) * LFNoise2.kr(0.02 + (i * 0.005)).range(0.995, 1.005);
        var delTime  = (i * 0.13) + LFNoise2.kr(0.03).range(0.0, 0.04);
        DelayC.ar(
            SinOsc.ar(baseFreq, 0, (1 / (i + 1).sqrt) * 0.18),
            0.8, delTime
        )
    });
    sig  = layers;
    sig  = LPF.ar(sig, 8000);
    env  = EnvGen.kr(Env.asr(10, 1, 12), gate, doneAction: 2);
    sig  = sig * env * amp;
    sig  = Pan2.ar(sig, LFNoise2.kr(0.05).range(-0.5, 0.5));
    Out.ar(out, sig);
    Out.ar(rev, sig * 0.85);
}).add;

// =============================================================================
// SYNTHDEFS — ACT IV: LE RIRE SACRÉ (The Sacred Laugh)
// =============================================================================

// Formant-based chaotic voice-like textures — human laughter made alien
SynthDef(\sacredLaugh, {
    |out=0, rev=0, amp=0.25, gate=1, bwScale=1.0|
    var sig, trig, env, laughRate;
    laughRate = LFNoise0.kr(0.4).range(4, 18);
    trig  = Dust.kr(laughRate);
    sig   = Formant.ar(
        fundfreq: LFNoise0.kr(trig).range(80, 500),
        formfreq: LFNoise0.kr(trig * 0.5).range(200, 3000),
        bwfreq:   LFNoise2.kr(0.3).range(40, 600) * bwScale
    );
    sig   = CombL.ar(sig, 0.3, LFNoise2.kr(0.2).range(0.015, 0.25), 1.5);
    sig   = HPF.ar(sig, 80);
    sig   = Limiter.ar(sig, 0.85);
    env   = EnvGen.kr(Env.asr(3, 1, 5), gate, doneAction: 2);
    sig   = Pan2.ar(sig * env * amp, LFNoise2.kr(0.5).range(-0.8, 0.8));
    Out.ar(out, sig);
    Out.ar(rev, sig * 0.5);
}).add;

// Controlled feedback with delay lines — chaos with intention
SynthDef(\feedbackLoop, {
    |out=0, rev=0, amp=0.2, gate=1, delTime=0.23, feedback=0.65|
    var sig, env, fb;
    fb   = LocalIn.ar(1);
    sig  = SinOsc.ar(
        LFNoise2.kr(0.3).range(80, 400) + (fb * 120),
        0, 0.3
    );
    sig  = sig + (fb * feedback);
    sig  = Limiter.ar(sig, 0.9);
    sig  = LPF.ar(sig, 4000);
    LocalOut.ar(DelayC.ar(sig, 0.5, delTime + LFNoise2.kr(0.1).range(-0.02, 0.02)));
    env  = EnvGen.kr(Env.asr(4, 1, 6), gate, doneAction: 2);
    sig  = Pan2.ar(sig * env * amp, LFNoise2.kr(0.4).range(-0.7, 0.7));
    Out.ar(out, sig);
    Out.ar(rev, sig * 0.4);
}).add;

// =============================================================================
// SYNTHDEFS — TRANSITIONS
// =============================================================================

// A pure sine tone for liminal moments between acts
SynthDef(\singleTone, {
    |out=0, rev=0, freq=220, amp=0.15, gate=1, fadeIn=6, fadeOut=10|
    var sig, env;
    sig = SinOsc.ar(freq, 0, amp)
        + SinOsc.ar(freq * 1.0007, 0, amp * 0.3);  // subtle beating
    env = EnvGen.kr(Env.asr(fadeIn, 1, fadeOut), gate, doneAction: 2);
    sig = Pan2.ar(sig * env, 0);
    Out.ar(out, sig);
    Out.ar(rev, sig * 0.2);
}).add;

// Very quiet filtered noise — the room itself breathing
SynthDef(\roomTone, {
    |out=0, rev=0, amp=0.04, gate=1|
    var sig, env;
    sig = BPF.ar(WhiteNoise.ar(1.0), LFNoise2.kr(0.05).range(200, 900), 0.3);
    sig = sig + BPF.ar(WhiteNoise.ar(0.5), LFNoise2.kr(0.03).range(80, 300), 0.2);
    sig = LPF.ar(sig, 1200);
    env = EnvGen.kr(Env.asr(10, 1, 15), gate, doneAction: 2);
    sig = Pan2.ar(sig * env * amp, LFNoise2.kr(0.03).range(-0.4, 0.4));
    Out.ar(out, sig);
    Out.ar(rev, sig * 0.3);
}).add;

// Allow SynthDefs to propagate to the server before continuing
s.sync;

// =============================================================================
// START THE GLOBAL REVERB
// =============================================================================

~reverb = Synth(\reverbBus, [\in, ~reverbBus, \out, 0, \mix, 0.55, \room, 0.88, \damp, 0.35]);

// =============================================================================
// PDEFS — ACT I: LE SOUFFLE (~10 min)
// Layered breath drone + grain textures, slowly evolving
// =============================================================================

Pdef(\act1_breath,
    Pbind(
        \instrument, \breathDrone,
        \out,        0,
        \rev,        ~reverbBus,
        \freq,       Prand([55, 82.5, 110, 73.4], inf),  // overtone series on low A
        \amp,        Pgauss(0.28, 0.04, inf),
        \filtFreq,   Prand([300, 450, 600, 800], inf),
        \lfoRate,    Pgauss(0.15, 0.03, inf),
        \dur,        Prand([30, 40, 50, 60], inf),       // long overlapping notes
        \legato,     1.0,
        \gate,       1
    )
);

Pdef(\act1_texture,
    Pbind(
        \instrument, Pwrand([\grainBreath, \roomTone], [0.75, 0.25], inf),
        \out,        0,
        \rev,        ~reverbBus,
        \freq,       Prand([110, 165, 220, 293, 330], inf),
        \amp,        Pgauss(0.16, 0.03, inf),
        \density,    Prand([5, 8, 12, 6], inf),
        \grainDur,   Prand([0.08, 0.12, 0.18, 0.25], inf),
        \dur,        Prand([20, 25, 30, 35], inf),
        \legato,     1.0
    )
);

// =============================================================================
// PDEFS — ACT II: LA CHUTE (~12 min)
// Percussive hits, pitch-dropping drone, glitchy rhythms
// =============================================================================

// Stochastic falling hits — density increases as act progresses
Pdef(\act2_hits,
    Pbind(
        \instrument, \fallingHit,
        \out,        0,
        \rev,        ~reverbBus,
        \freq,       Prand([1200, 800, 550, 330, 180], inf),
        \amp,        Pgauss(0.42, 0.08, inf),
        \decay,      Prand([0.2, 0.35, 0.5, 0.8], inf),
        \dropRatio,  Prand([0.03, 0.05, 0.08, 0.12], inf),
        \dur,        Pwhite(0.5, 6.0, inf),   // random spacing — stochastic
        \legato,     0.5
    )
);

// The drone that falls in pitch across the whole act
Pdef(\act2_drone,
    Pbind(
        \instrument, \fallingDrone,
        \out,        0,
        \rev,        ~reverbBus,
        \startFreq,  Prand([220, 180, 165], inf),
        \endFreq,    Prand([28, 35, 22], inf),
        \dur,        120,                       // one note = 2 minutes of falling
        \legato,     1.0,
        \amp,        0.3
    )
);

// Glitchy rhythmic patterns — fragmented, staccato, mechanical
Pdef(\act2_glitch,
    Pbind(
        \instrument, \glitchPerc,
        \out,        0,
        \rev,        ~reverbBus,
        \density,    Prand([2, 4, 6, 8, 12], inf),
        \minFreq,    Prand([100, 200, 400], inf),
        \maxFreq,    Prand([2000, 3500, 6000], inf),
        \amp,        Pgauss(0.35, 0.07, inf),
        \dur,        Prand([0.25, 0.5, 1.0, 2.0, 0.125], inf),
        \legato,     0.2
    )
);

// =============================================================================
// PDEFS — ACT III: L'ENVOL (~12 min)
// Shimmer pads, FM bells, spectral textures
// =============================================================================

// Shimmer pads drifting through the harmonic/overtone series
Pdef(\act3_shimmer,
    Pbind(
        \instrument, \shimmerPad,
        \out,        0,
        \rev,        ~reverbBus,
        // Harmonic series on low D: 36.7, 73.4, 110, 146.8, 183.5, 220 ...
        \freq,       Prand([36.7, 73.4, 110, 146.8, 183.5, 220, 293.3, 366.6], inf),
        \numHarm,    Prand([6, 7, 8, 9], inf),
        \detune,     Prand([0.004, 0.007, 0.012, 0.018], inf),
        \amp,        Pgauss(0.16, 0.03, inf),
        \dur,        Prand([25, 35, 45, 55], inf),
        \legato,     1.0
    )
);

// Sparse FM bells — each one arrives like a thought
Pdef(\act3_bells,
    Pbind(
        \instrument, \fmBell,
        \out,        0,
        \rev,        ~reverbBus,
        // Modal, microtonal frequencies — partial series, not equal temperament
        \freq,       Prand([
            110, 138.6, 165, 183.5, 220, 247.5, 275,
            330, 366.6, 440, 495, 550, 660
        ], inf),
        \amp,        Pgauss(0.28, 0.06, inf),
        \modRatio,   Prand([1.414, 2.0, 2.787, 3.0, 3.5], inf),
        \modIdx,     Pgauss(3.5, 1.2, inf).clip(0.5, 8),
        \decay,      Prand([3, 4, 5, 6, 8], inf),
        \dur,        Pwhite(3.0, 14.0, inf),   // very sparse
        \legato,     0.8
    )
);

// Spectral freeze textures — sustained, shimmering harmonics
Pdef(\act3_spectral,
    Pbind(
        \instrument, \spectralFreeze,
        \out,        0,
        \rev,        ~reverbBus,
        \freq,       Prand([110, 165, 220, 293.3, 330, 440], inf),
        \amp,        Pgauss(0.14, 0.03, inf),
        \dur,        Prand([30, 40, 50], inf),
        \legato,     1.0
    )
);

// =============================================================================
// PDEFS — ACT IV: LE RIRE SACRÉ (~10 min)
// Chaotic formant laughter, feedback swells, polyrhythm
// =============================================================================

// Chaotic formant voice textures
Pdef(\act4_laugh,
    Pbind(
        \instrument, \sacredLaugh,
        \out,        0,
        \rev,        ~reverbBus,
        \amp,        Pgauss(0.22, 0.05, inf),
        \bwScale,    Prand([0.5, 1.0, 1.5, 2.0], inf),
        \dur,        Prand([4, 6, 8, 10], inf),
        \legato,     1.0
    )
);

// Feedback swells — growing then receding waves of controlled chaos
Pdef(\act4_feedback,
    Pbind(
        \instrument, \feedbackLoop,
        \out,        0,
        \rev,        ~reverbBus,
        \amp,        Pgauss(0.18, 0.04, inf),
        \delTime,    Prand([0.17, 0.23, 0.31, 0.41], inf),
        \feedback,   Prand([0.55, 0.65, 0.72, 0.78], inf),
        \dur,        Prand([8, 10, 12, 15], inf),
        \legato,     1.0
    )
);

// Stochastic polyrhythmic patterns — joyful chaos
Pdef(\act4_rhythm,
    Pbind(
        \instrument, \glitchPerc,
        \out,        0,
        \rev,        ~reverbBus,
        \density,    Prand([6, 10, 14, 20], inf),
        \minFreq,    200,
        \maxFreq,    5000,
        \amp,        Pgauss(0.32, 0.08, inf),
        \dur,        Pseq([
            Prand([0.25, 0.5], 4),
            Prand([0.125, 0.25, 0.5], 3),
            Prand([0.375, 0.75], 5)
        ], inf),
        \legato,     0.15
    )
);

// =============================================================================
// PDEFS — TRANSITIONS
// =============================================================================

// Single held sine tone — the sound of a held breath between acts
Pdef(\transition_tone,
    Pbind(
        \instrument, \singleTone,
        \out,        0,
        \rev,        ~reverbBus,
        \freq,       Prand([110, 146.8, 165, 220, 73.4], 1),  // one note per transition
        \amp,        0.12,
        \fadeIn,     8,
        \fadeOut,    12,
        \dur,        45,          // ~45 seconds held
        \legato,     1.0
    )
);

// =============================================================================
// PANIC FUNCTION — evaluate this line at any time to kill everything
// =============================================================================

~panic = {
    Pdef.all.do(_.stop);
    s.freeAll;
    ~reverb = Synth(\reverbBus, [\in, ~reverbBus, \out, 0, \mix, 0.55, \room, 0.88, \damp, 0.35]);
    "⚠️  PANIC — all patterns stopped, server freed, reverb restarted".postln;
};

// =============================================================================
// MIDI CONTROLLER MAPPING (optional — uncomment to activate)
// Tested with nanoKONTROL2 but adaptable to any CC controller
// =============================================================================

/*
MIDIClient.init;
MIDIIn.connectAll;

// CC 1  → Master amplitude
MIDIdef.cc(\masterAmpCC, { |val|
    ~masterAmp = val.linlin(0, 127, 0.0, 1.2);
    "masterAmp: %".format(~masterAmp).postln;
}, ccNum: 1);

// CC 2  → Reverb mix
MIDIdef.cc(\reverbMixCC, { |val|
    var mix = val.linlin(0, 127, 0.0, 1.0);
    ~reverb.set(\mix, mix);
    "reverbMix: %".format(mix).postln;
}, ccNum: 2);

// CC 3  → Grain density (for act1_texture)
MIDIdef.cc(\grainDensityCC, { |val|
    var density = val.linlin(0, 127, 1.0, 25.0);
    // Pdef patterns re-read variables on each event — store as a global:
    ~grainDensity = density;
    "grainDensity: %".format(density).postln;
}, ccNum: 3);

// CC 4  → Filter cutoff broadcast
MIDIdef.cc(\filterCutoffCC, { |val|
    var cutoff = val.linexp(0, 127, 80.0, 8000.0);
    ~filterCutoff = cutoff;
    "filterCutoff: %".format(cutoff).postln;
}, ccNum: 4);

// CC 5  → Tempo / pattern density multiplier
MIDIdef.cc(\tempoDensityCC, { |val|
    var mult = val.linlin(0, 127, 0.4, 2.5);
    TempoClock.default.tempo = 1.0 * mult;
    "tempo mult: %".format(mult).postln;
}, ccNum: 5);
*/

"Corps Suspendu — SynthDefs loaded. Ready for performance.".postln;
"Evaluate the PERFORMANCE CONTROL section below to begin.".postln;

}); // end s.waitForBoot


// =============================================================================
//
//   ██████╗ ███████╗██████╗ ███████╗ ██████╗ ██████╗ ███╗   ███╗ █████╗ ███╗   ██╗ ██████╗███████╗
//   ██╔══██╗██╔════╝██╔══██╗██╔════╝██╔═══██╗██╔══██╗████╗ ████║██╔══██╗████╗  ██║██╔════╝██╔════╝
//   ██████╔╝█████╗  ██████╔╝█████╗  ██║   ██║██████╔╝██╔████╔██║███████║██╔██╗ ██║██║     █████╗
//   ██╔═══╝ ██╔══╝  ██╔══██╗██╔══╝  ██║   ██║██╔══██╗██║╚██╔╝██║██╔══██║██║╚██╗██║██║     ██╔══╝
//   ██║     ███████╗██║  ██║██║     ╚██████╔╝██║  ██║██║ ╚═╝ ██║██║  ██║██║ ╚████║╚██████╗███████╗
//   ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝
//
//   CONTROL SECTION — evaluate individual blocks during performance
//   TIP: Use Cmd+Return (macOS) or Ctrl+Return (Win/Linux) to evaluate a block
//
// =============================================================================


// ─────────────────────────────────────────────────────────────────────────────
// BEFORE THE SHOW — boot and load (evaluate once, before performers enter)
// ─────────────────────────────────────────────────────────────────────────────
// s.boot;   // ← uncomment only if server not already running


// ─────────────────────────────────────────────────────────────────────────────
// ===== PRE-SHOW: Silence / Room Tone =====
// Let room tone play very quietly as audience enters
// ─────────────────────────────────────────────────────────────────────────────
(
Pdef(\transition_tone).play;
)

// ─────────────────────────────────────────────────────────────────────────────
// ===== ACT I: LE SOUFFLE (The Breath) — ~10 minutes =====
// Start with breath drone. Fade in grain textures after ~2 min.
// Dynamics: begin very quiet, swell slowly to mezzo-forte
// ─────────────────────────────────────────────────────────────────────────────
(
Pdef(\transition_tone).stop;
Pdef(\act1_breath).play;
)

// After ~2 minutes, add grain texture layer:
(
Pdef(\act1_texture).play;
)

// To fade out Act I (before transition), stop patterns:
// Pdef(\act1_breath).stop;
// Pdef(\act1_texture).stop;


// ─────────────────────────────────────────────────────────────────────────────
// ===== TRANSITION I → II =====
// One sine tone held for ~45 seconds. Absolute stillness.
// ─────────────────────────────────────────────────────────────────────────────
(
Pdef(\act1_breath).stop;
Pdef(\act1_texture).stop;
Pdef(\transition_tone).play;
)


// ─────────────────────────────────────────────────────────────────────────────
// ===== ACT II: LA CHUTE (The Fall) — ~12 minutes =====
// Start with the falling drone. Add hits gradually. Glitches arrive last.
// Dynamics: tension builds — forte by 8 min, then sudden silence before trans
// ─────────────────────────────────────────────────────────────────────────────
(
Pdef(\transition_tone).stop;
Pdef(\act2_drone).play;
)

// After ~2 min, introduce hits:
(
Pdef(\act2_hits).play;
)

// After ~5 min, add glitch layer:
(
Pdef(\act2_glitch).play;
)

// Fade out Act II:
// Pdef(\act2_hits).stop;
// Pdef(\act2_glitch).stop;
// Pdef(\act2_drone).stop;


// ─────────────────────────────────────────────────────────────────────────────
// ===== TRANSITION II → III =====
// Silence, or a very quiet single tone. Let the air clear.
// ─────────────────────────────────────────────────────────────────────────────
(
Pdef(\act2_drone).stop;
Pdef(\act2_hits).stop;
Pdef(\act2_glitch).stop;
Pdef(\transition_tone).play;
)


// ─────────────────────────────────────────────────────────────────────────────
// ===== ACT III: L'ENVOL (The Flight) — ~12 minutes =====
// Begin with shimmer pad. Bells arrive sparsely after ~3 min.
// Spectral freeze layer adds depth from ~6 min onward.
// Dynamics: grows from piano to a radiant, luminous forte
// ─────────────────────────────────────────────────────────────────────────────
(
Pdef(\transition_tone).stop;
Pdef(\act3_shimmer).play;
)

// After ~3 min, add bells:
(
Pdef(\act3_bells).play;
)

// After ~6 min, add spectral layer:
(
Pdef(\act3_spectral).play;
)

// Fade out Act III:
// Pdef(\act3_shimmer).stop;
// Pdef(\act3_bells).stop;
// Pdef(\act3_spectral).stop;


// ─────────────────────────────────────────────────────────────────────────────
// ===== TRANSITION III → IV =====
// Hold the shimmer a little longer, then cut to silence, then laughter erupts
// ─────────────────────────────────────────────────────────────────────────────
(
Pdef(\act3_shimmer).stop;
Pdef(\act3_bells).stop;
Pdef(\act3_spectral).stop;
// Brief silence — no tone. Let the performers fill the space.
)


// ─────────────────────────────────────────────────────────────────────────────
// ===== ACT IV: LE RIRE SACRÉ (The Sacred Laugh) — ~10 minutes =====
// Start with formant laughter. Feedback swells emerge after ~3 min.
// Rhythm builds from ~5 min to a chaotic, joyful climax.
// Dynamics: start mezzo, build to a wild forte, then sudden release
// ─────────────────────────────────────────────────────────────────────────────
(
Pdef(\act4_laugh).play;
)

// After ~3 min, add feedback:
(
Pdef(\act4_feedback).play;
)

// After ~5 min, rhythm erupts:
(
Pdef(\act4_rhythm).play;
)

// ─────────────────────────────────────────────────────────────────────────────
// ===== ENDING — Le Silence Final =====
// Stop everything abruptly, or fade out one by one.
// End with transition_tone very quietly, then let it die.
// ─────────────────────────────────────────────────────────────────────────────
(
Pdef(\act4_laugh).stop;
Pdef(\act4_feedback).stop;
Pdef(\act4_rhythm).stop;
Pdef(\transition_tone).play;   // one last breath
)

// Final silence — evaluate to end all sound:
(
Pdef(\transition_tone).stop;
s.freeAll;
~reverb = Synth(\reverbBus, [\in, ~reverbBus, \out, 0, \mix, 0.55, \room, 0.88, \damp, 0.35]);
"Corps Suspendu — fin.".postln;
)


// ─────────────────────────────────────────────────────────────────────────────
// ===== PANIC — evaluate THIS at any time if anything goes wrong =====
// ─────────────────────────────────────────────────────────────────────────────
~panic.value;
