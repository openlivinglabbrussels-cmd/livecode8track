# livecode8track 🎛️

A complete **SuperCollider live-coding environment** designed for an **8-output soundcard**, where each output corresponds to a dedicated track that can be live-coded independently during performance.

---

## Track Routing Table

| Track | Output | File | Role | Description |
|-------|--------|------|------|-------------|
| **Track 1** | out 0 | `tracks/track1_kick.scd` | 🥁 Kick | Bass drum — live-coded kick patterns and synthesis |
| **Track 2** | out 1 | `tracks/track2_loop.scd` | 🔁 Loop | Looper — sample playback, granular, buffer-based loops |
| **Track 3** | out 2 | `tracks/track3_snare.scd` | 🪘 Snare 1 & 2 | Dual snare layering — two SynthDefs that can be mixed/switched |
| **Track 4** | out 3 | `tracks/track4_hihats.scd` | 🎩 Hi-Hats | Open and closed hi-hat patterns |
| **Track 5** | out 4 | `tracks/track5_perc.scd` | 🔔 Percussion | Claps, rimshots, shakers, cowbell, misc percussion |
| **Track 6** | out 5 | `tracks/track6_bass.scd` | 🎹 Bass/Synth | Bassline synthesis — sub bass, acid, FM bass |
| **Track 7** | out 6 | `tracks/track7_lead.scd` | 🎸 Lead / FX | Lead melodies, pads, effects, textures |
| **Track 8** | out 7 | `tracks/track8_master.scd` | 🎚️ Master / Aux | Mix bus, reverb sends, delay sends, master processing |

---

## Project Structure

```
livecode8track/
├── README.md                  # This file
├── boot.scd                   # Main boot file — configures server, loads SynthDefs, init ProxySpace
├── synthdefs/
│   ├── kick_defs.scd          # Kick drum SynthDefs (kick_808, kick_noise, kick_fm)
│   ├── loop_defs.scd          # Loop/granular/buffer SynthDefs
│   ├── snare_defs.scd         # Snare SynthDefs (snare1, snare2)
│   ├── hihat_defs.scd         # Hi-hat SynthDefs (hihat_closed, hihat_open)
│   ├── perc_defs.scd          # Percussion SynthDefs (clap, rim, shaker, cowbell)
│   ├── bass_defs.scd          # Bass SynthDefs (bass_sub, bass_acid, bass_fm)
│   ├── lead_defs.scd          # Lead/pad/texture SynthDefs
│   └── fx_defs.scd            # FX SynthDefs (reverb, delay, compressor, master bus)
├── tracks/
│   ├── track1_kick.scd        # Live-coding workspace — Track 1 (output 0)
│   ├── track2_loop.scd        # Live-coding workspace — Track 2 (output 1)
│   ├── track3_snare.scd       # Live-coding workspace — Track 3 (output 2)
│   ├── track4_hihats.scd      # Live-coding workspace — Track 4 (output 3)
│   ├── track5_perc.scd        # Live-coding workspace — Track 5 (output 4)
│   ├── track6_bass.scd        # Live-coding workspace — Track 6 (output 5)
│   ├── track7_lead.scd        # Live-coding workspace — Track 7 (output 6)
│   └── track8_master.scd      # Live-coding workspace — Track 8 (output 7)
├── patterns/
│   ├── example_patterns.scd   # Pdef/Pbind examples for each track
│   └── live_session.scd       # Full example live session combining all 8 tracks
└── samples/
    └── .gitkeep               # Placeholder — add your own samples here
```

---

## Requirements

- **SuperCollider** 3.12 or later ([supercollider.github.io](https://supercollider.github.io))
- An **8-output audio interface** (ASIO on Windows, CoreAudio on macOS, JACK/ALSA on Linux)
- Optional: sc3-plugins for extended UGens

---

## Soundcard Setup

### macOS (CoreAudio)

In `boot.scd`, set your device name:
```supercollider
ServerOptions.devices;               // list available devices
s.options.device = "Your Device Name";
```

### Windows (ASIO)

```supercollider
ServerOptions.devices;               // list available ASIO devices
s.options.device = "ASIO : Your ASIO Driver";
```
Make sure ASIO4ALL or your interface driver is installed.

### Linux (JACK)

Start JACK first:
```bash
jackd -d alsa -d hw:0 -r 44100 -p 512 -n 2 &
```
Then boot SuperCollider — it will connect to JACK automatically.

### Linux (ALSA, no JACK)

```supercollider
s.options.device = "hw:0";
```

---

## How to Boot

1. Open SuperCollider IDE
2. Open `boot.scd`
3. Select all (`Cmd+A` / `Ctrl+A`) and evaluate (`Cmd+Enter` / `Ctrl+Enter`)
4. Wait for the server to boot and print the welcome message
5. Open any track file in `tracks/` and start live coding!

---

## How to Live-Code Each Track

Each track file is an independent workspace. The general workflow:

```supercollider
// Define/redefine a pattern live — changes take effect immediately
Pdef(\kick, Pbind(
    \instrument, \kick_808,
    \dur, 0.5,
    \amp, 0.8,
    \out, 0
)).play;

// Modify the pattern while it's running
Pdef(\kick, Pbind(
    \instrument, \kick_808,
    \dur, Pseq([0.5, 0.5, 0.25, 0.25], inf),
    \amp, Pseq([0.9, 0.6, 0.7, 0.5], inf),
    \out, 0
));

// Stop the pattern
Pdef(\kick).stop;
```

Each track file contains ready-made examples — just uncomment and modify!

---

## Tips for Live Performance

- **Use `Pdef` for patterns** — redefine them on the fly without stopping
- **Use `Ndef` for synths** — swap synthesis algorithms without audio gaps
- **ProxySpace** (`p`) is pre-initialized in `boot.scd` — use `p[\name]` for live NodeProxy coding
- **Tempo**: Change `TempoClock.default.tempo` to adjust BPM globally (e.g., `TempoClock.default.tempo = 140/60`)
- **Panic**: `CmdPeriod` (`.` on macOS, `Alt+.` on Windows/Linux) stops everything immediately
- **Track 8** (`track8_master.scd`) handles global FX — tweak reverb/delay sends during performance

---

## Keyboard Shortcuts (SuperCollider IDE)

| Action | macOS | Windows/Linux |
|--------|-------|---------------|
| Evaluate selection/line | `Cmd+Enter` | `Ctrl+Enter` |
| Stop all sound | `Cmd+.` | `Alt+.` |
| Boot server | `Cmd+B` | `Ctrl+B` |
| Open help | `Cmd+D` | `Ctrl+D` |

---

## Links

- [SuperCollider Docs](https://doc.sccode.org)
- [SuperCollider GitHub](https://github.com/supercollider/supercollider)
- [ProxySpace Help](https://doc.sccode.org/Classes/ProxySpace.html)
- [Pdef Help](https://doc.sccode.org/Classes/Pdef.html)
- [Pattern Guide](https://doc.sccode.org/Tutorials/A-Practical-Guide/PG_01_Introduction.html)
