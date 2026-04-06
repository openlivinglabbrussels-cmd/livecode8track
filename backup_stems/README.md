# backup_stems/

This directory is for **pre-rendered audio stems** of each act in "Corps Suspendu."  
Render and store these before the performance as a safety net in case of technical failure.

---

## Why render stems?

Live SuperCollider performance carries technical risk:  
laptop crash, audio driver failure, accidental Cmd+Q, cosmic rays.  
A set of pre-rendered 24-bit stereo stems means you can switch to a  
DAW or Ableton Set in under 30 seconds and complete the performance.

---

## How to render stems using SuperCollider's non-real-time (NRT) mode

SuperCollider can render audio offline using `Score` objects.  
Below is a template for each act. Adjust durations and parameters to match  
what you're actually doing in the live performance.

### Prerequisites

```supercollider
// Set your output path (macOS example — adjust for your OS)
~stemPath = "~/Desktop/corps_suspendu_stems/";
File.mkdir(~stemPath);
```

### Render Act I — Le Souffle (~10 minutes)

```supercollider
(
var score, dur = 600; // 600 seconds = 10 minutes

score = Score([
    // t=0: add the reverb bus synth
    [0.0, [\s_new, \reverbBus, 1000, 0, 0,
           \in, 2, \out, 0, \mix, 0.55, \room, 0.88, \damp, 0.35]],

    // t=0: breath drone
    [0.0, [\s_new, \breathDrone, 1001, 0, 0,
           \out, 0, \rev, 2, \freq, 55, \amp, 0.28,
           \filtFreq, 400, \lfoRate, 0.15, \gate, 1]],

    // t=2: second breath drone layer
    [2.0, [\s_new, \breathDrone, 1002, 0, 0,
           \out, 0, \rev, 2, \freq, 110, \amp, 0.22,
           \filtFreq, 600, \lfoRate, 0.12, \gate, 1]],

    // t=120: grain breath texture enters
    [120.0, [\s_new, \grainBreath, 1003, 0, 0,
             \out, 0, \rev, 2, \freq, 220, \amp, 0.16,
             \density, 8, \grainDur, 0.12, \gate, 1]],

    // t=540: begin fading (gate=0 triggers ASR release)
    [540.0, [\n_set, 1001, \gate, 0]],
    [545.0, [\n_set, 1002, \gate, 0]],
    [550.0, [\n_set, 1003, \gate, 0]],

    // t=600: end
    [dur, [\c_set, 0, 0]]
]);

score.recordNRT(
    outputFilePath: ~stemPath ++ "act1_le_souffle.aiff",
    headerFormat:  "AIFF",
    sampleFormat:  "int24",
    sampleRate:    44100,
    duration:      dur,
    action:        { "Act I rendered.".postln }
);
)
```

### Render Act II — La Chute (~12 minutes)

```supercollider
(
var score, dur = 720;

score = Score([
    [0.0, [\s_new, \reverbBus, 1000, 0, 0,
           \in, 2, \out, 0, \mix, 0.5, \room, 0.85, \damp, 0.4]],

    // Falling drone
    [0.0, [\s_new, \fallingDrone, 1001, 0, 0,
           \out, 0, \rev, 2, \startFreq, 220, \endFreq, 28,
           \dur, 120, \amp, 0.3, \gate, 1]],

    // Second falling drone (overlapping, different start pitch)
    [60.0, [\s_new, \fallingDrone, 1002, 0, 0,
            \out, 0, \rev, 2, \startFreq, 165, \endFreq, 35,
            \dur, 120, \amp, 0.25, \gate, 1]],

    // Glitch layer enters at 5 min
    [300.0, [\s_new, \glitchPerc, 1003, 0, 0,
             \out, 0, \rev, 2, \density, 6, \minFreq, 200,
             \maxFreq, 4000, \amp, 0.35]],

    // Fade drones at 11 min
    [660.0, [\n_set, 1001, \gate, 0]],
    [660.0, [\n_set, 1002, \gate, 0]],

    [dur, [\c_set, 0, 0]]
]);

score.recordNRT(
    outputFilePath: ~stemPath ++ "act2_la_chute.aiff",
    headerFormat:  "AIFF",
    sampleFormat:  "int24",
    sampleRate:    44100,
    duration:      dur,
    action:        { "Act II rendered.".postln }
);
)
```

### Render Act III — L'Envol (~12 minutes)

```supercollider
(
var score, dur = 720;

score = Score([
    [0.0, [\s_new, \reverbBus, 1000, 0, 0,
           \in, 2, \out, 0, \mix, 0.6, \room, 0.92, \damp, 0.3]],

    // Shimmer pad
    [0.0, [\s_new, \shimmerPad, 1001, 0, 0,
           \out, 0, \rev, 2, \freq, 110, \amp, 0.16,
           \numHarm, 8, \detune, 0.007, \gate, 1]],

    // Spectral freeze enters at 6 min
    [360.0, [\s_new, \spectralFreeze, 1002, 0, 0,
             \out, 0, \rev, 2, \freq, 220, \amp, 0.14, \gate, 1]],

    // Fade at 11 min
    [660.0, [\n_set, 1001, \gate, 0]],
    [665.0, [\n_set, 1002, \gate, 0]],

    [dur, [\c_set, 0, 0]]
]);

score.recordNRT(
    outputFilePath: ~stemPath ++ "act3_lenvol.aiff",
    headerFormat:  "AIFF",
    sampleFormat:  "int24",
    sampleRate:    44100,
    duration:      dur,
    action:        { "Act III rendered.".postln }
);
)
```

### Render Act IV — Le Rire Sacré (~10 minutes)

```supercollider
(
var score, dur = 600;

score = Score([
    [0.0, [\s_new, \reverbBus, 1000, 0, 0,
           \in, 2, \out, 0, \mix, 0.5, \room, 0.85, \damp, 0.4]],

    // Sacred laugh
    [0.0, [\s_new, \sacredLaugh, 1001, 0, 0,
           \out, 0, \rev, 2, \amp, 0.22, \bwScale, 1.0, \gate, 1]],

    // Feedback enters at 3 min
    [180.0, [\s_new, \feedbackLoop, 1002, 0, 0,
             \out, 0, \rev, 2, \amp, 0.18, \delTime, 0.23,
             \feedback, 0.65, \gate, 1]],

    // Fade at 9:30
    [570.0, [\n_set, 1001, \gate, 0]],
    [570.0, [\n_set, 1002, \gate, 0]],

    [dur, [\c_set, 0, 0]]
]);

score.recordNRT(
    outputFilePath: ~stemPath ++ "act4_le_rire_sacre.aiff",
    headerFormat:  "AIFF",
    sampleFormat:  "int24",
    sampleRate:    44100,
    duration:      dur,
    action:        { "Act IV rendered.".postln }
);
)
```

---

## Using stems in an emergency

If SuperCollider crashes mid-performance:

1. **Don't panic** — the audience doesn't know your plan
2. Open your DAW (Ableton, Reaper, Logic, etc.)
3. Load the pre-rendered AIFF files into tracks
4. Set each track's start time so they can be triggered individually
5. Fade in from wherever you are in the performance arc

### Recommended stem format

| File | Duration | Format |
|------|----------|--------|
| `act1_le_souffle.aiff` | 10:00 | 24-bit / 44.1 kHz stereo |
| `act2_la_chute.aiff` | 12:00 | 24-bit / 44.1 kHz stereo |
| `act3_lenvol.aiff` | 12:00 | 24-bit / 44.1 kHz stereo |
| `act4_le_rire_sacre.aiff` | 10:00 | 24-bit / 44.1 kHz stereo |
| `transition_tone.aiff` | 1:00 | 24-bit / 44.1 kHz stereo |

---

## Rendering tip: use Recorder for live capture

If you want to capture your live rehearsal performance as stems:

```supercollider
// Start recording EVERYTHING that comes out of the server
s.record(~stemPath ++ "rehearsal_full.aiff");

// ... perform ...

s.stopRecording;
```

Then split the recording by act in your DAW.  
This is the fastest way to get realistic stems that match your actual live sound.

---

*Place your rendered .aiff files in this directory and keep it backed up in two locations.*
