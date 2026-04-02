// ============================================================
//  boot.scd — Main Boot File for livecode8track
//  SuperCollider 8-output live-coding environment
//
//  HOW TO USE:
//    1. Select All  (Cmd+A / Ctrl+A)
//    2. Evaluate    (Cmd+Enter / Ctrl+Enter)
//    3. Wait for "=== livecode8track READY ===" in the post window
//    4. Open any file in tracks/ and start live-coding!
// ============================================================

(
// ------------------------------------------------------------
// 1. SERVER OPTIONS — configure for 8 outputs
// ------------------------------------------------------------
s.options.numOutputBusChannels = 8;   // 8 dedicated output channels
s.options.numInputBusChannels  = 8;   // 8 input channels (adjust if needed)
s.options.blockSize            = 128; // smaller block = lower latency
s.options.sampleRate           = 44100;
s.options.memSize              = 65536; // 64 MB server memory (for buffers)
s.options.maxNodes             = 4096;
s.options.maxSynthDefs         = 1024;

// ------------------------------------------------------------
// AUDIO DEVICE — uncomment and edit the line for your OS
// ------------------------------------------------------------
// macOS (CoreAudio):
//   ServerOptions.devices.do { |d| d.postln };  // list devices
//   s.options.device = "Focusrite USB ASIO";    // replace with your device name

// Windows (ASIO):
//   ServerOptions.devices.do { |d| d.postln };  // list devices
//   s.options.device = "ASIO : Focusrite USB ASIO";

// Linux (JACK — start jackd first):
//   (SuperCollider connects to JACK automatically when jackd is running)

// Linux (ALSA — no JACK):
//   s.options.device = "hw:0";

// ------------------------------------------------------------
// 2. BOOT SERVER AND LOAD EVERYTHING
// ------------------------------------------------------------
s.waitForBoot({

    // --------------------------------------------------------
    // 2a. Set default BPM (120 BPM = 2.0 beats/second)
    // --------------------------------------------------------
    TempoClock.default.tempo = 120/60;

    // --------------------------------------------------------
    // 2b. Load all SynthDef files from synthdefs/ folder
    // --------------------------------------------------------
    var synthdefsPath = thisProcess.nowExecutingPath.dirname +/+ "synthdefs";
    PathName(synthdefsPath).filesDo { |file|
        if(file.extension == "scd") {
            ("Loading SynthDef: " ++ file.fileName).postln;
            file.fullPath.load;
        };
    };

    // Give the server a moment to compile SynthDefs
    s.sync;

    // --------------------------------------------------------
    // 2c. Initialize a ProxySpace (accessible as ~p globally)
    // --------------------------------------------------------
    ~p = ProxySpace.push(s);

    // --------------------------------------------------------
    // 2d. Print welcome message and routing table
    // --------------------------------------------------------
    "".postln;
    "╔══════════════════════════════════════════════════════╗".postln;
    "║          livecode8track — READY 🎛️                   ║".postln;
    "╠══════════════════════════════════════════════════════╣".postln;
    "║  Track 1  │  out 0  │  🥁  Kick                     ║".postln;
    "║  Track 2  │  out 1  │  🔁  Loop                     ║".postln;
    "║  Track 3  │  out 2  │  🪘  Snare 1 & 2              ║".postln;
    "║  Track 4  │  out 3  │  🎩  Hi-Hats                  ║".postln;
    "║  Track 5  │  out 4  │  🔔  Percussion               ║".postln;
    "║  Track 6  │  out 5  │  🎹  Bass / Synth             ║".postln;
    "║  Track 7  │  out 6  │  🎸  Lead / FX                ║".postln;
    "║  Track 8  │  out 7  │  🎚️  Master / Aux             ║".postln;
    "╠══════════════════════════════════════════════════════╣".postln;
    "║  BPM: 120  │  ProxySpace: ~p                        ║".postln;
    "║  STOP ALL: Cmd+.  (macOS)  /  Alt+.  (Win/Linux)   ║".postln;
    "╚══════════════════════════════════════════════════════╝".postln;
    "".postln;
    "Open any file in tracks/ and start live-coding!".postln;

});
)

// ============================================================
//  GLOBAL HELPERS — evaluate these individually as needed
// ============================================================

// Change BPM at any time:
// TempoClock.default.tempo = 140/60;  // 140 BPM

// Stop everything on all tracks:
// CmdPeriod.run;

// Show server status:
// s.status;

// Free all Pdefs:
// Pdef.all.do(_.stop);
