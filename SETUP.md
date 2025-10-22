# Setup Instructions

## 🚀 Initial Push to GitHub

The repository has been initialized and the first commit is ready. To push to GitHub:

```bash
git push -u origin master
```

**Note:** If you get an authentication error, you may need to:
1. Use a personal access token instead of password
2. Or configure SSH keys

## 📄 Enable GitHub Pages

After pushing, you **must manually enable GitHub Pages** in the repository settings:

### Step-by-Step Instructions:

1. **Go to Repository Settings**
   - Navigate to: https://github.com/BIH-CEI/MVGenomSeq-on-FHIR
   - Click on **Settings** tab

2. **Navigate to Pages Section**
   - In the left sidebar, click **Pages** (under "Code and automation")

3. **Configure Source**
   - Under "Build and deployment"
   - **Source:** Select "GitHub Actions" (NOT "Deploy from a branch")
   - This enables the custom workflow in `.github/workflows/build-ig.yml`

4. **Save and Wait**
   - GitHub will automatically trigger the workflow
   - First build takes ~5-10 minutes
   - You can watch progress in the **Actions** tab

5. **Access Your IG**
   - Once deployed, the IG will be available at:
   - **https://bih-cei.github.io/MVGenomSeq-on-FHIR/**

## 🔄 Automatic Updates

After initial setup, the IG will automatically rebuild and redeploy whenever you push to the `master` branch.

### Workflow Details:
- **Trigger:** Push to `master` branch
- **Build Steps:**
  1. Install Java 17
  2. Install Node.js 20
  3. Install SUSHI
  4. Download IG Publisher
  5. Run SUSHI (compiles FSH)
  6. Run IG Publisher (generates HTML)
  7. Deploy to GitHub Pages

### Monitor Build Status:
- Go to **Actions** tab in GitHub
- Click on latest workflow run
- Green checkmark = success ✅
- Red X = failure ❌ (check logs)

## 🏗️ Local Development

### Prerequisites
- Node.js 20+
- Java 17+
- Git

### Build Locally

1. **Install SUSHI:**
   ```bash
   npm install -g fsh-sushi
   ```

2. **Download IG Publisher** (first time only):
   ```bash
   mkdir -p input-cache
   curl -L https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar -o input-cache/publisher.jar
   ```

3. **Run Build:**
   ```bash
   # Quick build with SUSHI only
   sushi .

   # Full build with IG Publisher
   java -jar input-cache/publisher.jar -ig .

   # Or use the provided scripts
   ./_genonce.sh    # Unix/Mac
   ./_genonce.bat   # Windows
   ```

4. **View Output:**
   ```bash
   # Open in browser
   open output/index.html      # Mac
   xdg-open output/index.html  # Linux
   start output/index.html     # Windows
   ```

## 🎨 Viewing PlantUML Diagrams

The PlantUML diagrams are in `input/images/*.plantuml`

### Option 1: Let IG Publisher Handle It
The IG Publisher will automatically render PlantUML diagrams during build.

### Option 2: Render Manually
```bash
# Install PlantUML CLI
npm install -g node-plantuml

# Render all diagrams
plantuml input/images/*.plantuml

# This creates PNG files alongside the .plantuml files
```

### Option 3: Use VS Code Extension
- Install "PlantUML" extension
- Open `.plantuml` files
- Press `Alt+D` to preview

## 🐛 Troubleshooting

### Build Fails in GitHub Actions

1. **Check Java/Node versions:**
   - Workflow uses Java 17 and Node 20
   - Ensure compatibility with dependencies

2. **Check SUSHI errors:**
   - Look for FSH syntax errors in workflow logs
   - Test locally first: `sushi .`

3. **Check IG Publisher errors:**
   - Download validation report: `output/qa.html`
   - Common issues: missing dependencies, invalid profiles

### GitHub Pages Not Working

1. **Verify GitHub Pages is enabled:**
   - Settings → Pages → Source = "GitHub Actions"

2. **Check workflow status:**
   - Actions tab → Look for green checkmarks
   - If red, click to see error logs

3. **Wait for first deployment:**
   - Can take 5-10 minutes
   - Refresh the Pages URL after build completes

### Local Build Issues

1. **Java version:**
   ```bash
   java -version  # Should be 17+
   ```

2. **Node version:**
   ```bash
   node --version  # Should be 20+
   ```

3. **SUSHI installation:**
   ```bash
   sushi --version  # Should show version number
   ```

4. **Clean and rebuild:**
   ```bash
   rm -rf fsh-generated output
   sushi .
   java -jar input-cache/publisher.jar -ig .
   ```

## 📚 Content Structure

```
mvgenomseq-on-fhir/
├── .github/workflows/
│   └── build-ig.yml              # Auto-build workflow
├── input/
│   ├── pagecontent/
│   │   ├── index.md              # Landing page
│   │   ├── integration.md        # Overview
│   │   ├── integration-fhir-to-mvgenomseq.md
│   │   ├── integration-diz-repository.md
│   │   └── integration-fhir-submission.md
│   ├── images/
│   │   └── *.plantuml            # Process diagrams
│   └── fsh/
│       └── patient.fsh           # FSH profiles (add more here)
├── sushi-config.yaml             # SUSHI configuration
├── README.md                     # Project readme
└── SETUP.md                      # This file
```

## 🔧 Next Steps

1. **Push to GitHub:**
   ```bash
   git push -u origin master
   ```

2. **Enable GitHub Pages** (see instructions above)

3. **Wait for build** (~5-10 minutes)

4. **Visit your IG:**
   https://bih-cei.github.io/MVGenomSeq-on-FHIR/

5. **Start developing:**
   - Add FSH profiles in `input/fsh/`
   - Add content pages in `input/pagecontent/`
   - Update examples
   - Commit and push - automatic rebuild!

## 📖 Additional Resources

- [SUSHI Documentation](https://fshschool.org/)
- [HL7 FHIR IG Publisher](https://confluence.hl7.org/display/FHIR/IG+Publisher+Documentation)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)

## 💬 Questions?

If you encounter issues:
1. Check workflow logs in GitHub Actions tab
2. Try building locally to isolate the problem
3. Consult SUSHI/IG Publisher documentation
4. Check FHIR Zulip chat for community support
