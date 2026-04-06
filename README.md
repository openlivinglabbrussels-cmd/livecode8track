# Corps Suspendu
### A SuperCollider Live Performance for *Où est la sainte dramaturgie?*
**Compagnie Sens du Sommeil — Cirque-Théâtre**

---

## Overview

**Corps Suspendu** (*Suspended Body*) is a complete, ready-to-perform SuperCollider score for a 40–60 minute live performance. It is designed as a sonic companion to a circus-theatre spectacle: a sound world of breath, gravity, flight, and sacred laughter.

The performance is structured in **4 acts + transitions**, following the arc of a body suspended in space — from stillness to release.

| Act | Title | Duration | Mood |
|-----|-------|----------|------|
| I | **Le Souffle** (The Breath) | ~10 min | Stillness, anticipation, air |
| — | *Transition I→II* | ~1–2 min | Silence, single tone |
| II | **La Chute** (The Fall) | ~12 min | Gravity, weight, tension |
| — | *Transition II→III* | ~1–2 min | Pure silence |
| III | **L'Envol** (The Flight) | ~12 min | Weightlessness, wonder, the sacred |
| — | *Transition III→IV* | ~30 sec | Silence or held tone |
| IV | **Le Rire Sacré** (The Sacred Laugh) | ~10 min | Absurdity, joy, release |
| — | *Ending* | ~2 min | Final tone, then silence |

---

## Technical Requirements

### Essential
- **SuperCollider 3.12+** (download: [supercollider.github.io](https://supercollider.github.io))
- **Audio interface** with at least 2 outputs (stereo)
- **Laptop** (macOS, Windows, or Linux)

### Recommended
- **MIDI controller** — nanoKONTROL2 or similar (for live filter/reverb control)
- **Headphones** for monitoring (in-ear or closed-back)
- **IEM or PA** for the venue — the low-frequency content needs a subwoofer

### Optional
- **Contact microphone** on circus apparatus (rope, trapeze, floor) for live input
- **Backup**: pre-rendered audio stems (see `backup_stems/README.md`)

---

## Repository Structure

```
corps_suspendu.scd          ← MAIN FILE — load this to perform
synthdefs/                  ← Individual SynthDef files (practice/development)
│   breath_drone.scd
│   grain_breath.scd
│   falling_hit.scd
│   falling_drone.scd
│   glitch_perc.scd
│   shimmer_pad.scd
│   fm_bell.scd
│   spectral_freeze.scd
│   sacred_laugh.scd
│   feedback_loop.scd
│   single_tone.scd
│   room_tone.scd
│   reverb_bus.scd
patterns/                   ← Per-act pattern files with detailed cue notes
│   act1_le_souffle.scd
│   act2_la_chute.scd
│   act3_lenvol.scd
│   act4_le_rire_sacre.scd
│   transitions.scd
backup_stems/               ← Instructions for rendering safety stems
    README.md
```

---

## How to Load and Run the Performance

### Step 1 — Open the main file

Open `corps_suspendu.scd` in SuperCollider IDE.

### Step 2 — Boot and load

Select the entire file (Cmd+A / Ctrl+A) and evaluate it (Cmd+Return / Ctrl+Return).  
This will:
- Wait for the server to boot
- Define all SynthDefs and send them to the server
- Define all Pdef patterns
- Start the global reverb bus
- Print "Corps Suspendu — SynthDefs loaded. Ready for performance."

### Step 3 — Use the Performance Control section

Scroll to the bottom of the file. You will find clearly labelled blocks:

```supercollider
// ===== ACT I: LE SOUFFLE =====
Pdef(\act1_breath).play;
```

**Evaluate each block individually** using Cmd+Return when standing on the line or  
selecting the block and evaluating. Each block is self-contained.

### Step 4 — During the performance

- Watch the performers — let their physicality guide your dynamics
- The MIDI controller mapping (if enabled) gives you real-time control over:
  - CC 1: Master amplitude
  - CC 2: Reverb mix
  - CC 3: Grain density
  - CC 4: Filter cutoff
  - CC 5: Tempo/density multiplier

---

## Act-by-Act Performance Guide

### Pre-Show (before performers enter)
```supercollider
Pdef(\transition_tone).play;
```
Very quiet. Let the audience settle. Room tone / single tone at low amplitude.

---

### ACT I — Le Souffle (~10 min)

**Concept**: A body before it moves. Breath before sound.  
**Timing guide**:
- `0:00` — Start breath drone (`Pdef(\act1_breath).play`)
- `2:00` — Add grain texture (`Pdef(\act1_texture).play`)
- `8:00` — Begin fade (stop patterns; long release envelopes handle the rest)
- `9:30` — Transition tone

**Watch for**: The first moment a performer inhales visibly on stage. Match it.

---

### TRANSITION I → II

Single held sine tone, ~45 seconds. Then silence.  
The silence before Act II is the setup for the fall.

---

### ACT II — La Chute (~12 min)

**Concept**: Gravity. Inevitability. The weight of everything.  
**Timing guide**:
- `0:00` — Falling drone enters
- `2:00` — First percussive hits arrive (sparse)
- `5:00` — Glitch layer erupts
- `9:00` — Maximum density (re-evaluate with higher density parameters)
- `11:30` — Cut or fade

**Watch for**: Any moment of physical impact or fall on stage. Trigger a `\fallingHit`  
directly: `Synth(\fallingHit, [\freq, 800, \amp, 0.6, \rev, ~reverbBus])`

---

### TRANSITION II → III

**Pure silence.** Minimum 30 seconds.  
This is the most powerful transition. Do not fill it.

---

### ACT III — L'Envol (~12 min)

**Concept**: The body in flight. Weightlessness. The sacred geometry of the air.  
**Harmonic language**: All frequencies drawn from the natural overtone series on D.  
**Timing guide**:
- `0:00` — First shimmer pad (barely audible, piano)
- `3:00` — Bells arrive — sparse, inharmonic, sacred
- `6:00` — Spectral freeze layer thickens
- `9:00` — Luminous peak (all three layers in full bloom)
- `11:00` — Slow fade, layer by layer

**Watch for**: Moments of sustained aerial pose. Hold a shimmer chord longer.

---

### TRANSITION III → IV

After the shimmer fully fades — silence or one last bell.  
Then: the laugh erupts. No warning.

---

### ACT IV — Le Rire Sacré (~10 min)

**Concept**: The absurdity of the sacred. The holiness of chaos.  
**Timing guide**:
- `0:00` — Formant laugh erupts
- `3:00` — Feedback swells emerge
- `5:00` — Polyrhythm begins
- `8:00` — Maximum chaos
- `9:30` — Sudden cut to silence

**Watch for**: Moments of comedic timing on stage. The rhythm is stochastic —  
it finds its own punchlines.

---

### Ending

```supercollider
Pdef(\transition_tone).play;  // one last breath
// wait for it to fully fade (60+ seconds)
s.freeAll;
```

---

## MIDI Controller Mapping

Uncomment the MIDI section in `corps_suspendu.scd` to enable:

| CC | Parameter | Range |
|----|-----------|-------|
| 1  | Master amplitude | 0.0 – 1.2 |
| 2  | Reverb mix | 0.0 – 1.0 |
| 3  | Grain density | 1 – 25 grains/sec |
| 4  | Filter cutoff | 80 – 8000 Hz |
| 5  | Tempo/density multiplier | 0.4× – 2.5× |

---

## Panic Function

If anything goes wrong, evaluate this **immediately**:

```supercollider
~panic.value;
```

This stops all patterns, frees all synths, and restarts the reverb bus.  
After panic, you can restart any act from its first cue.

---

## Tips for Performing with Circus Artists

1. **Watch, don't listen to yourself** — the performance is what's on stage.
2. **Leave more silence than you think you need.** Circus bodies are loud.
3. **Sync with breath, not beat.** Watch for inhales, exhales, and held breath.
4. **Physical impacts are musical events.** Have a `\fallingHit` ready to trigger.
5. **The stochastic patterns will surprise you.** That's the point. Trust them.
6. **If something sounds wrong, stop it and move on.** The audience won't know.
7. **Position your screen so you can see the stage** without turning your head.

---

## Gear Checklist

### Day-of
- [ ] Laptop (fully charged + power adapter)
- [ ] Audio interface (tested, drivers installed)
- [ ] Stereo cable to PA/mixer
- [ ] MIDI controller + USB cable (optional)
- [ ] In-ear monitors or closed headphones
- [ ] SuperCollider open and `corps_suspendu.scd` loaded
- [ ] Backup stems rendered and on desktop (see `backup_stems/README.md`)
- [ ] Backup: DAW open with stems loaded and ready

### Sound check
- [ ] Verify stereo output routing
- [ ] Set conservative master volume — start quiet
- [ ] Test `Pdef(\transition_tone).play` — confirm sound reaches PA
- [ ] Test `~panic.value` — confirm kill function works
- [ ] Test reverb wet/dry balance

### Post-show
- [ ] Evaluate final silence block (`s.freeAll`)
- [ ] Save any live-coded variations you liked
- [ ] Back up the `.scd` file

---

## Harmonic Language Reference

The performance uses **spectral/modal harmony** rather than equal temperament:

**Overtone series on D (36.7 Hz)**:
```
Harmonic  1: 36.7 Hz  (D1)
Harmonic  2: 73.4 Hz  (D2)
Harmonic  3: 110.1 Hz (A2)
Harmonic  4: 146.8 Hz (D3)
Harmonic  5: 183.5 Hz (F#3 + 14¢)
Harmonic  6: 220.2 Hz (A3)
Harmonic  7: 256.9 Hz (C4 - 31¢)
Harmonic  8: 293.6 Hz (D4)
Harmonic  9: 330.3 Hz (E4)
Harmonic 10: 367.0 Hz (F#4 + 14¢)
Harmonic 12: 440.4 Hz (A4)
```

All melodic and harmonic material is drawn from these relationships.  
The result is pure resonance — chords that feel physical, not harmonic.

---

*"La dramaturgie, c'est le souffle."*
