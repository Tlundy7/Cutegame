#!/usr/bin/env bash
set -e
OUT_DIR="clicking-computer-prototype"
ZIP_NAME="${OUT_DIR}.zip"

echo "Creating project folder: ${OUT_DIR}"
rm -rf "$OUT_DIR" "$ZIP_NAME"
mkdir -p "$OUT_DIR"/{src,tools,assets/backgrounds,assets/characters,assets/voices,public}

cat > "$OUT_DIR/README.md" <<'EOF'
# Prototype: The Case of the Clicking Computer

Contents:
- story.ink          : Ink script for Scenes 1–6
- panel-mapping.json : mapping from panels to character sprites and voice keys
- assets/            : backgrounds, characters, and placeholder voices (placeholder audio generated)
- public/            : compiled story.json (put here after compiling with inklecate)
- src/               : React + inkjs app skeleton
- tools/generate_tts.py : simple TTS generator (gTTS) to create placeholder MP3s

Quick local run (recommended)
1) Install prerequisites:
   - Node.js 14+ and npm
   - (Optional) Python 3 for generate_tts.py
   - (Optional) inklecate (to compile story.ink -> story.json). Or use the online Ink compiler.

2) Install JS deps:
   npm install

3) Generate placeholder audio (optional but recommended for testing):
   - pip install gTTS
   - python3 tools/generate_tts.py

4) Compile Ink to JSON:
   - If you have inklecate:
     inklecate -o public/story.json story.ink
   - OR use an online Ink compiler and save the produced story.json to public/story.json

5) Dev:
   npm run start
   Open the dev server (webpack dev server will open the app).

6) Build for production (used by Vercel):
   npm run build
   The build output will be in /dist (vercel.json is configured to use dist).

Deploy to Vercel
- Connect your GitHub repo to Vercel
- Build Command: npm run build
- Output Directory: dist
EOF

cat > "$OUT_DIR/.gitignore" <<'EOF'
node_modules
dist
public/story.json
assets/voices/*.mp3
.DS_Store
EOF

cat > "$OUT_DIR/package.json" <<'EOF'
{
  "name": "clicking-computer-prototype",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "start": "webpack serve --mode development --open",
    "build": "webpack --mode production",
    "generate:tts": "python3 tools/generate_tts.py"
  },
  "dependencies": {
    "howler": "^2.2.3",
    "inkjs": "^1.11.1",
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "webpack": "^5.88.2",
    "webpack-cli": "^5.1.4",
    "webpack-dev-server": "^4.15.1",
    "html-webpack-plugin": "^5.5.3",
    "copy-webpack-plugin": "^11.0.0",
    "babel-loader": "^9.1.3",
    "@babel/core": "^7.25.0",
    "@babel/preset-react": "^7.22.5",
    "css-loader": "^6.8.1",
    "style-loader": "^3.3.3"
  }
}
EOF

cat > "$OUT_DIR/.babelrc" <<'EOF'
{
  "presets": ["@babel/preset-react"]
}
EOF

cat > "$OUT_DIR/index.html" <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>The Case of the Clicking Computer</title>
</head>
<body>
  <div id="root"></div>
  <script src="/bundle.js"></script>
</body>
</html>
EOF

cat > "$OUT_DIR/vercel.json" <<'EOF'
{
  "builds": [
    { "src": "package.json", "use": "@vercel/static-build", "config": { "distDir": "dist" } }
  ],
  "routes": [
    { "src": "/(.*)", "dest": "/index.html" }
  ]
}
EOF

cat > "$OUT_DIR/story.ink" <<'EOF'
// The Case of the Clicking Computer — Full Episode (Scenes 1–6)
// Comedy‑Horror tone (light, spooky cues)
// Stats
VAR Teamwork = 0
VAR Safety = 0
VAR Evidence = 0
VAR Suspicion = 0

=== scene1_click_of_doom ===
#panel_1
Ivy: (scribbling) "Okay, team—step one! Identify the problem. The computer's clicking louder than the cafeteria clock."
~ {meta: {panel: 1, voice: "ivy_01", bg: "lab_bg_day.png", pose: {"Ivy": "ivy_neutral.png"}}}

Theo: "Easy! It's haunted. Classic IT ghost problem."
~ {meta: {panel: 2, voice: "theo_01", pose: {"Theo": "theo_smug.png"}}}

Ivy: "...or maybe something more technical, Theo."
~ {meta: {panel: 3, voice: "ivy_02", pose: {"Ivy": "ivy_skeptical.png","Theo":"theo_smug.png"}}}

+ [Follow Ivy's checklist and inspect methodically.]
    ~ Teamwork = Teamwork + 1
    ~ Safety = Safety + 1
    ~ Suspicion = Suspicion - 1
    -> ivy_path

+ [Agree with Theo and go with the "haunted" guess.]
    ~ Suspicion = Suspicion + 2
    ~ Teamwork = Teamwork - 1
    -> theo_path

=== ivy_path ===
Ivy: "Alright. Let's keep it calm and test systematically — listen, look, and document."
~ {meta:{panel:4,voice:"ivy_03",pose:{"Ivy":"ivy_determined.png"}}}
-> scene2_theory_chaos

=== theo_path ===
Theo: "No time — we gotta poke it. Ghosts hate screwdrivers."
~ {meta:{panel:4b,voice:"theo_02",pose:{"Theo":"theo_confident.png"}}}
-> scene2_theory_chaos

=== scene2_theory_chaos ===
Tessa: (leaning in) "If it's clicking like popcorn it's probably the hard drive, right?"
~ {meta:{panel:5,voice:"tessa_01",pose:{"Tessa":"tessa_speaking.png"}}}

Theo: "Hard drive, fan, haunted lunchbox — my money's on the hard drive."
~ {meta:{panel:6,voice:"theo_03",pose:{"Theo":"theo_smug.png"}}}
~ Evidence = Evidence + 1

+ [Run a quiet listening test (careful diagnostics).]
    ~ Evidence = Evidence + 2
    ~ Safety = Safety + 1
    -> scene3_testing_mayhem_safe

+ [Tessa unplugs drives & powers on to test quickly (impulsive).]
    ~ Suspicion = Suspicion + 1
    ~ Teamwork = Teamwork - 1
    -> scene3_testing_mayhem_risky

=== scene3_testing_mayhem_safe ===
Tessa: "I'll grab my stethoscope — aka listen closely with the case off, power off first."
~ {meta:{panel:7,voice:"tessa_02",pose:{"Tessa":"tessa_neutral.png"}}}
~ // careful checks: no loud click
Ivy: "Good. Documented. We heard X near the drive bay."
~ {meta:{panel:8,voice:"ivy_04",pose:{"Ivy":"ivy_determined.png"}}}
-> scene4_the_plan

=== scene3_testing_mayhem_risky ===
Tessa: "I'll unplug the drives and power it up!"
~ {meta:{panel:9,voice:"tessa_03",pose:{"Tessa":"tessa_speaking.png"}}}
~ // The PC powers on; single small click then silence
Tessa: "See? The noise is gone!"
~ {meta:{panel:10,voice:"tessa_04",pose:{"Tessa":"tessa_surprised.png"}}}
~ Evidence = Evidence + 1
-> scene4_the_plan

=== scene4_the_plan ===
Plan: (pulls out sticky notes) "Step four: Plan of action — backup data, replace the drive if needed, and clean that fan."
~ {meta:{panel:11,voice:"plan_01",pose:{"Plan":"plan_speaking.png"}}}

Ivy: "Let's do it step-by-step and stay safe."
~ {meta:{panel:12,voice:"ivy_05",pose:{"Ivy":"ivy_neutral.png"}}}

+ [Follow Plan's step-by-step plan]
    ~ Teamwork = Teamwork + 2
    ~ Safety = Safety + 2
    -> scene5_implementation_plan

+ [Let Imp do a fast swap (Impulsive DIY)]
    ~ Teamwork = Teamwork - 1
    ~ Safety = Safety - 2
    -> scene5_implementation_imp

=== scene5_implementation_plan ===
Imp: "I'm ready to help but I'll follow the checklist."
~ {meta:{panel:13,voice:"imp_01",pose:{"Imp":"imp_neutral.png"}}}
~ // safe implementation: backup, remove drive with ESD strap, install replacement
Vera: "I'll run verification and tests after."
~ {meta:{panel:14,voice:"vera_01",pose:{"Vera":"vera_speaking.png"}}}
~ Evidence = Evidence + 2
-> scene6_verify_victory

=== scene5_implementation_imp ===
Imp: "Hard drive out, new one in! Watch this!"
~ {meta:{panel:15,voice:"imp_02",pose:{"Imp":"imp_speaking.png"}}}
~ // mishap: small screw dropped, extra time required
Vera: "We need to pause and find that screw."
~ {meta:{panel:16,voice:"vera_02",pose:{"Vera":"vera_concerned.png"}}}
~ Safety = Safety - 1
~ Teamwork = Teamwork - 1

+ [Search for the screw and continue (teamwork salvage).]
    ~ Teamwork = Teamwork + 1
    ~ Safety = Safety + 1
    -> scene6_verify_victory

+ [Call admin / give up and escalate (bad ending path).]
    -> bad_ending_admin_takes_over

=== scene6_verify_victory ===
Vera: "Running system tests... bootlog looks good, no clicking."
~ {meta:{panel:17,voice:"vera_03",pose:{"Vera":"vera_speaking.png"}}}

Ivy: "Document everything. Case closed, team."
~ {meta:{panel:18,voice:"ivy_06",pose:{"Ivy":"ivy_determined.png"}}}
~ Teamwork = Teamwork + 1

-> evaluate_endings

=== bad_ending_admin_takes_over ===
// A curt admin team takes the PC and the students learn about escalation.
Narration: "Admin confiscates the hardware. Learning: sometimes escalation is the right call."
~ {meta:{panel:19,voice:"narrator_01",bg:"lab_bg_day.png"}}
-> END

=== evaluate_endings ===
~ // Evaluate stats to determine ending
{ Teamwork >= 3:
    -> good_ending
- else:
    { Safety >= 2:
        -> neutral_ending
    - else:
        -> bad_ending
    }
}

=== good_ending ===
Narration: "Good ending — Teamwork + Safety led to a smooth fix and cheers all around."
~ {meta:{panel:20,voice:"narrator_02",bg:"lab_bg_day.png"}}
-> END

=== neutral_ending ===
Narration: "Neutral ending — The PC is back online but there were bumps and a missing screw slow down the team."
~ {meta:{panel:21,voice:"narrator_03",bg:"lab_bg_day.png"}}
-> END

=== bad_ending ===
Narration: "Bad ending — Too many risky choices led to escalation and lessons learned."
~ {meta:{panel:22,voice:"narrator_04",bg:"lab_bg_day.png"}}
-> END
EOF

cat > "$OUT_DIR/panel-mapping.json" <<'EOF'
{
  "scene1_click_of_doom": {
    "panels": [
      {"id":1,"bg":"lab_bg_day.png","characters":[{"name":"Ivy","image":"ivy_neutral.png","position":"left"}],"text":"Ivy: Okay, team—step one! Identify the problem.","voice":"ivy_01"},
      {"id":2,"bg":"lab_bg_day.png","characters":[{"name":"Theo","image":"theo_smug.png","position":"right"}],"text":"Theo: Easy! It's haunted.","voice":"theo_01"},
      {"id":3,"bg":"lab_bg_day.png","characters":[{"name":"Ivy","image":"ivy_skeptical.png","position":"left"},{"name":"Theo","image":"theo_smug.png","position":"right"}],"text":"Ivy: ...or maybe something more technical.","voice":"ivy_02"}
    ]
  },
  "scene2_theory_chaos": {
    "panels": [
      {"id":5,"bg":"lab_bg_day.png","characters":[{"name":"Tessa","image":"tessa_speaking.png","position":"right"}],"text":"Tessa: If it's clicking like popcorn it's probably the hard drive.","voice":"tessa_01"},
      {"id":6,"bg":"lab_bg_day.png","characters":[{"name":"Theo","image":"theo_smug.png","position":"right"}],"text":"Theo: My money's on the hard drive.","voice":"theo_03"}
    ]
  },
  "scene3_testing_mayhem_safe": {
    "panels":[
      {"id":7,"bg":"lab_bg_day.png","characters":[{"name":"Tessa","image":"tessa_neutral.png","position":"center"}],"text":"Tessa: I'll listen carefully with power off.","voice":"tessa_02"},
      {"id":8,"bg":"lab_bg_day.png","characters":[{"name":"Ivy","image":"ivy_determined.png","position":"left"}],"text":"Ivy: Documented — we heard X near the drive bay.","voice":"ivy_04"}
    ]
  },
  "scene3_testing_mayhem_risky": {
    "panels":[
      {"id":9,"bg":"lab_bg_day.png","characters":[{"name":"Tessa","image":"tessa_speaking.png","position":"center"}],"text":"Tessa: I'll unplug the drives and power it up!","voice":"tessa_03"},
      {"id":10,"bg":"lab_bg_day.png","characters":[{"name":"Tessa","image":"tessa_surprised.png","position":"center"}],"text":"Tessa: See? The noise is gone!","voice":"tessa_04"}
    ]
  },
  "scene4_the_plan": {
    "panels":[
      {"id":11,"bg":"lab_bg_day.png","characters":[{"name":"Plan","image":"plan_speaking.png","position":"center"}],"text":"Plan: Backup data, replace drive, clean fan.","voice":"plan_01"},
      {"id":12,"bg":"lab_bg_day.png","characters":[{"name":"Ivy","image":"ivy_neutral.png","position":"left"}],"text":"Ivy: Let's be safe.","voice":"ivy_05"}
    ]
  },
  "scene5_implementation_plan": {
    "panels":[
      {"id":13,"bg":"lab_bg_day.png","characters":[{"name":"Imp","image":"imp_neutral.png","position":"right"},{"name":"Vera","image":"vera_speaking.png","position":"left"}],"text":"Team implements safely.","voice":"imp_01"}
    ]
  },
  "scene5_implementation_imp": {
    "panels":[
      {"id":15,"bg":"lab_bg_day.png","characters":[{"name":"Imp","image":"imp_speaking.png","position":"right"}],"text":"Imp: Hard drive out, new one in!","voice":"imp_02"},
      {"id":16,"bg":"lab_bg_day.png","characters":[{"name":"Vera","image":"vera_concerned.png","position":"left"}],"text":"Vera: We need to pause and find that screw.","voice":"vera_02"}
    ]
  },
  "scene6_verify_victory": {
    "panels":[
      {"id":17,"bg":"lab_bg_day.png","characters":[{"name":"Vera","image":"vera_speaking.png","position":"right"}],"text":"Vera: Running system tests...","voice":"vera_03"},
      {"id":18,"bg":"lab_bg_day.png","characters":[{"name":"Ivy","image":"ivy_determined.png","position":"left"}],"text":"Ivy: Document everything. Case closed.","voice":"ivy_06"}
    ]
  },
  "endings": {
    "good": {"id":20,"bg":"lab_bg_day.png","text":"Good ending — smooth fix, cheers." ,"voice":"narrator_02"},
    "neutral": {"id":21,"bg":"lab_bg_day.png","text":"Neutral ending — PC back online with bumps.","voice":"narrator_03"},
    "bad": {"id":22,"bg":"lab_bg_day.png","text":"Bad ending — escalation and lessons.","voice":"narrator_04"}
  }
}
EOF

cat > "$OUT_DIR/tools/generate_tts.py" <<'EOF'
#!/usr/bin/env python3
"""
Generate simple placeholder TTS MP3s for the prototype using gTTS.
Creates files in ./assets/voices/ named like ivy_01.mp3, theo_01.mp3, etc.
Install: pip install gTTS
Note: pydub/ffmpeg not required for simple MP3 writes from gTTS.
"""
import os
from gtts import gTTS

lines = {
    "ivy_01": "Okay team, step one. Identify the problem.",
    "ivy_02": "Maybe something more technical, Theo.",
    "ivy_03": "Let's keep it calm and test systematically.",
    "ivy_04": "Documented. We heard X near the drive bay.",
    "ivy_05": "Let's be safe and do it step by step.",
    "ivy_06": "Document everything. Case closed, team.",
    "theo_01": "Easy! It's haunted.",
    "theo_02": "No time — we gotta poke it!",
    "theo_03": "My money's on the hard drive.",
    "tessa_01": "If it's clicking like popcorn it's probably the hard drive.",
    "tessa_02": "I'll listen carefully with the power off.",
    "tessa_03": "I'll unplug the drives and power it up!",
    "tessa_04": "See? The noise is gone!",
    "plan_01": "Backup data, replace the drive, and clean the fan.",
    "imp_01": "I'm ready to help and follow the checklist.",
    "imp_02": "Hard drive out, new one in!",
    "vera_01": "I'll run verification and tests after.",
    "vera_02": "We need to pause and find that screw.",
    "vera_03": "Running system tests... bootlog looks good, no clicking.",
    "narrator_01": "Admin takes the hardware; lesson learned.",
    "narrator_02": "Good ending — smooth fix, cheers.",
    "narrator_03": "Neutral ending — PC back online with bumps.",
    "narrator_04": "Bad ending — escalation and lessons."
}

out_dir = os.path.join("assets", "voices")
os.makedirs(out_dir, exist_ok=True)

for key, text in lines.items():
    out_path = os.path.join(out_dir, f"{key}.mp3")
    if os.path.exists(out_path):
        print(f"Skipping existing {out_path}")
        continue
    try:
        tts = gTTS(text=text, lang="en")
        tts.save(out_path)
        print(f"Wrote {out_path}")
    except Exception as e:
        print(f"Failed to create {out_path}: {e}")
EOF

cat > "$OUT_DIR/prototype.css" <<'EOF'
/* Minimal manga-panel prototype CSS (use in React app) */
html,body,#root { height:100%; margin:0; font-family: "Segoe UI", Arial, sans-serif; background:#111; color:#fff; }
.scene-canvas { position:relative; height:70vh; overflow:hidden; background:#000; }
.scene-canvas img.bg { position:absolute; inset:0; width:100%; height:100%; object-fit:cover; }
.character-img { position:absolute; bottom:0; height:85%; transition:transform .45s ease, opacity .3s ease; }
.character-left{ left:4%; } .character-center{ left:35%; } .character-right{ left:66%; }
.textbox { margin:12px auto; max-width:900px; background:rgba(0,0,0,0.6); padding:12px 16px; border-radius:10px; }
.choice-row{ display:flex; gap:8px; justify-content:center; margin-top:8px; }
.stats { position:absolute; right:14px; top:14px; background:rgba(255,255,255,0.06); padding:8px 10px; border-radius:8px; font-size:.9rem; color:#ddd; }
EOF

cat > "$OUT_DIR/src/index.jsx" <<'EOF'
import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';
import '../prototype.css';

const root = createRoot(document.getElementById('root'));
root.render(<App />);
EOF

cat > "$OUT_DIR/src/App.jsx" <<'EOF'
import React, { useEffect, useState } from 'react';
import { Howl } from 'howler';

export default function App() {
  const [text, setText] = useState("Loading story...");
  const [voice, setVoice] = useState(null);

  useEffect(() => {
    fetch('/public/story.json')
      .then(r => {
        if (!r.ok) throw new Error('story.json not found');
        return r.json();
      })
      .then(j => {
        setText("Story loaded. Click Start.");
      })
      .catch(err => {
        console.warn(err);
        setText("No compiled story.json found. Please compile story.ink to public/story.json.");
      });
  }, []);

  function playVoice(key) {
    const url = `/assets/voices/${key}.mp3`;
    const s = new Howl({ src: [url] });
    s.play();
    setVoice(key);
  }

  return (
    <div style={{padding:20}}>
      <h2>The Case of the Clicking Computer — Prototype</h2>
      <div className="scene-canvas" style={{background:'#222',height:360,marginBottom:12}}>
        <div style={{padding:20,color:'#ddd'}}>{text}</div>
      </div>

      <div className="textbox">
        <div style={{display:'flex',gap:8,alignItems:'center'}}>
          <button onClick={() => setText("Prototype: use compiled story.json and assets/voices/*.mp3 to test audio playback.")}>Start (demo)</button>
          <button onClick={() => playVoice('ivy_01')}>Play ivy_01</button>
          <button onClick={() => playVoice('tessa_01')}>Play tessa_01</button>
          <div style={{marginLeft:'auto',color:'#bbb'}}>Current voice: {voice||'none'}</div>
        </div>
      </div>
    </div>
  );
}
EOF

cat > "$OUT_DIR/webpack.config.js" <<'EOF'
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
  entry: './src/index.jsx',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'bundle.js',
    publicPath: '/'
  },
  resolve: {
    extensions: ['.js', '.jsx']
  },
  module: {
    rules: [
      { test: /\.jsx?$/, use: 'babel-loader', exclude: /node_modules/ },
      { test: /\.css$/, use: ['style-loader','css-loader'] },
      { test: /\.(png|jpg|gif|mp3)$/, type: 'asset/resource' }
    ]
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: './index.html'
    }),
    new CopyWebpackPlugin({
      patterns: [
        { from: 'assets', to: 'assets' },
        { from: 'public', to: 'public' }
      ]
    })
  ],
  devServer: {
    static: {
      directory: path.join(__dirname, '/'),
    },
    port: 8080,
    historyApiFallback: true,
    open: true,
  },
  mode: 'development'
};
EOF

cat > "$OUT_DIR/assets/README.md" <<'EOF'
Assets README — how to replace placeholders with your real VA and sprites

Folders (project root)
- assets/backgrounds/
  - lab_bg_day.png (default background)
- assets/characters/
  - ivy_neutral.png, ivy_speaking.png, ivy_surprised.png
  - theo_neutral.png, theo_speaking.png, theo_surprised.png
  - tessa_neutral.png, tessa_speaking.png, tessa_surprised.png
  - plan_neutral.png, plan_speaking.png, plan_surprised.png
  - imp_neutral.png, imp_speaking.png, imp_surprised.png
  - vera_neutral.png, vera_speaking.png, vera_surprised.png
- assets/voices/
  - Placeholder TTS files are named to match voice keys used in story.ink:
    ivy_01.mp3, ivy_02.mp3, ..., theo_01.mp3, tessa_01.mp3, plan_01.mp3, imp_01.mp3, vera_01.mp3
  - Narration keys: narrator_01.mp3, narrator_02.mp3, etc.

Replacing placeholders with final VA
1) Name your final VA files exactly to match keys in panel-mapping.json / story.ink (e.g., ivy_01.mp3).
2) Put the files into assets/voices/.
3) Restart the dev server (or rebuild) — the app will use the new files automatically.

Audio guidance
- Format: MP3 or OGG (mp3 widely supported)
- Sample rate: 44.1 kHz
- Bitrate: 128–192 kbps
- Mono is fine for dialogue
- Trim leading/trailing silence and normalize peaks around -3 dBFS

Image guidance
- Export character crops as PNG (transparent background preferred) at up to 2048 px on the long edge.
- If you want more expressions, add files following the same pattern (e.g., ivy_angry.png).

TTS placeholder generation
- If you want placeholder MP3s created automatically, run the included script:
  python3 tools/generate_tts.py
- Filenames will match the voice keys referenced in story.ink/panel-mapping.json
EOF

# create a minimal public/story.json placeholder so the demo shows something immediately
cat > "$OUT_DIR/public/story.json" <<'EOF'
{
  "root": {
    "content": [
      {
        "text": "Demo placeholder — compile story.ink with inklecate for full content."
      }
    ]
  }
}
EOF

# create minimal placeholder images (tiny transparent PNG) to avoid missing-asset errors
# using base64 1x1 transparent PNG
TRANSPARENT_PNG="iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII="
for f in lab_bg_day.png ivy_neutral.png ivy_skeptical.png ivy_determined.png theo_smug.png tessa_speaking.png tessa_neutral.png tessa_surprised.png plan_speaking.png imp_neutral.png imp_speaking.png vera_speaking.png vera_concerned.png; do
  echo "$TRANSPARENT_PNG" | base64 --decode > "$OUT_DIR/assets/characters/$f"
done
# copy one as background instead
cp "$OUT_DIR/assets/characters/lab_bg_day.png" "$OUT_DIR/assets/backgrounds/lab_bg_day.png"

# create a small README for usage
echo "Created project skeleton in $OUT_DIR"

# optional: create placeholder mp3 files by creating tiny silent mp3s if ffmpeg available,
# otherwise leave assets/voices empty and user can run tools/generate_tts.py
if command -v ffmpeg >/dev/null 2>&1; then
  echo "Creating tiny silent placeholder MP3s (requires ffmpeg)"
  for key in ivy_01 ivy_02 ivy_03 ivy_04 ivy_05 ivy_06 theo_01 theo_02 theo_03 tessa_01 tessa_02 tessa_03 tessa_04 plan_01 imp_01 imp_02 vera_01 vera_02 vera_03 narrator_01 narrator_02 narrator_03 narrator_04; do
    ffmpeg -loglevel error -f lavfi -i anullsrc=channel_layout=mono:sample_rate=22050 -t 0.5 -q:a 9 "$OUT_DIR/assets/voices/${key}.mp3" || true
  done
  echo "Placeholder MP3s created."
else
  echo "ffmpeg not found — placeholder MP3s not auto-generated. To create TTS files, run:"
  echo "  pip install gTTS"
  echo "  python3 tools/generate_tts.py"
fi

echo "Zipping ${OUT_DIR} -> ${ZIP_NAME}"
zip -r "$ZIP_NAME" "$OUT_DIR" >/dev/null

echo "Done. Created ${ZIP_NAME} in the current directory."
echo ""
echo "Next steps:"
echo " 1) Unzip and inspect the files."
echo " 2) (Optional) Run 'npm install' inside ${OUT_DIR} then 'npm run start' to test locally."
echo " 3) To deploy on Vercel: push the folder to a GitHub repo and connect it in Vercel (Build: npm run build, Output dir: dist)."
