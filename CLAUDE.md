# web

Richard Adleta's public personal site, live at [www.richardadleta.com](https://www.richardadleta.com/). Built with Jekyll + the Minimal Mistakes theme and published via GitHub Actions to GitHub Pages. The repo is public (`git@github.com:radleta/web.git`, branch `main`). Pushing `main` triggers a workflow that rebuilds and redeploys the live site within minutes.

## Repo Layout

```
web/
├── .github/workflows/jekyll-gh-pages.yml  # CI/CD — builds + deploys on push to main
├── docs/                                  # Jekyll source root (the entire site lives here)
│   ├── _config.yml                        # Site config: theme, plugins, collections, baseurl
│   ├── Gemfile                            # Deps: github-pages gem (~232), minimal-mistakes-jekyll
│   ├── _data/
│   │   ├── resume.json                    # JSON Resume source of truth
│   │   ├── downloads.yml                  # Generated: maps resume variants to download formats
│   │   ├── navigation.yml                 # Nav menus
│   │   └── vite_manifest_vite-react-test.json  # Generated: Vite asset manifest
│   ├── _resume/                           # Resume Jekyll collection
│   │   └── _source/                       # Markdown partials (full.md, condensed.md, etc.)
│   ├── _pages/                            # Static pages (about, resume, posts, vite-react-test)
│   ├── _posts/                            # Blog posts
│   ├── assets/
│   │   ├── downloads/                     # Generated & committed: resume in md/pdf/docx/odt/epub/json
│   │   └── vite-react-test/               # Built & committed: Vite dist output
│   ├── build.sh                           # Full local build (Vite → Jekyll → downloads → Jekyll again)
│   ├── build_downloads.sh                 # Pandoc-based converter: HTML → md/pdf/docx/odt/epub + json copy
│   ├── build_vite.sh                      # Copies ../projects/vite-react-test/dist → assets/
│   ├── install.sh                         # One-time toolchain setup (rbenv, Ruby 3.3.5, Pandoc, LaTeX)
│   ├── test.sh                            # Serves locally (bundle exec jekyll serve --host 0.0.0.0 --port 4000)
│   └── proxy.sh                           # CORS proxy via lcp (optional)
└── projects/
    └── vite-react-test/                   # React+Vite micro-app (source); dist must be built and committed
```

## Build & Deploy

### How GitHub Pages publishes this site

Deployment is **Action-based, not native GitHub Pages**. The workflow at `.github/workflows/jekyll-gh-pages.yml` triggers on every push to `main`:

1. Checks out the repo.
2. Sets up Ruby 3.1 with `ruby/setup-ruby@v1` and runs `bundle install` inside `docs/`.
3. Runs `bundle exec jekyll build` (source: `docs/`, output: `docs/_site/`).
4. Uploads `docs/_site/` as a Pages artifact.
5. Deploys via `actions/deploy-pages@v4`.

The custom domain `www.richardadleta.com` is controlled by `docs/CNAME` (committed to the repo).

### What "additional work before push" means

The GH Actions workflow only runs `bundle exec jekyll build` — it does **not** run `build_downloads.sh` or `build_vite.sh`. All generated artifacts must be **built locally and committed** before pushing:

| Artifact | Generator | Must commit? |
|----------|-----------|-------------|
| `docs/assets/downloads/*.{md,pdf,docx,odt,epub,json}` | `build_downloads.sh` (Pandoc + LaTeX/Eisvogel) | Yes |
| `docs/_data/downloads.yml` | `build_downloads.sh` | Yes |
| `docs/assets/vite-react-test/` | `build_vite.sh` (copies from `projects/vite-react-test/dist`) | Yes |
| `docs/_data/vite_manifest_vite-react-test.json` | `build_vite.sh` | Yes |

The canonical full local build is:

```bash
cd docs
bash build.sh
# build.sh sequence:
#   1. build_vite.sh  — copies Vite dist from ../projects/vite-react-test/dist
#   2. bundle exec jekyll build  — first pass
#   3. build_downloads.sh  — Pandoc converts _site/resume/*.html → assets/downloads/*; writes _data/downloads.yml
#   4. bundle exec jekyll build  — second pass so downloads.yml is baked in
```

After `build.sh` succeeds, stage and commit the generated files alongside any source changes before pushing.

### Pre-push checklist

- [ ] Resume content changed? Update `docs/_data/resume.json` **and** run `bash build.sh` to regenerate downloads.
- [ ] `build.sh` completed without errors.
- [ ] Generated files in `docs/assets/downloads/`, `docs/_data/downloads.yml`, and Vite assets staged and committed.
- [ ] `CNAME` file (`docs/CNAME`) is still present — never delete it; GitHub Pages needs it to maintain the custom domain.
- [ ] `baseurl` in `docs/_config.yml` is `""` — do not change it; the custom domain requires an empty baseurl.

## Local Preview

**Toolchain required (Ruby 3.3.5 + Bundler + Jekyll + Pandoc + LaTeX/Eisvogel):**

```bash
# One-time setup (installs rbenv, Ruby 3.3.5, Bundler, Jekyll, Pandoc, Eisvogel):
cd docs
bash install.sh

# Install gem dependencies:
bundle install

# Serve with live reload:
bash test.sh
# → http://localhost:4000
```

`test.sh` runs `bundle exec jekyll serve --host 0.0.0.0 --port 4000`. Hot reload works for Markdown and Liquid changes; restart required for `_config.yml` changes.

**Toolchain availability note:** Ruby, Bundler, and Jekyll are **not** installed in this WSL environment as of 2026-06. Run `bash install.sh` from `docs/` before attempting any build or serve command. The build has not been verified by execution in this environment — all build descriptions are inferred from scripts.

## Resume Data Flow

The resume has two distinct consumers that must stay in sync:

| File | Role | Updated by |
|------|------|------------|
| `docs/_data/resume.json` | Live site source — Liquid templates read this at build time | Edit manually |
| `docs/_resume/_source/full.md` + `condensed.md` | Markdown partials rendered into HTML resume pages | Edit manually |
| `docs/assets/downloads/*` | Static download files (md, pdf, docx, odt, epub, json) | `build_downloads.sh` — run `bash build.sh` |

When resume content changes: edit `resume.json` and the `_source/` partials, then run `bash build.sh` to regenerate the downloads. Commit everything together. The `.json` download files in `assets/downloads/` are just copies of `_data/resume.json` (see `build_downloads.sh` line: `cp "_data/resume.json" "$output_file"`).

## Gotchas

| Risk | What breaks | Rule |
|------|-------------|------|
| Deleting `docs/CNAME` | GitHub Pages drops the custom domain; site reverts to `radleta.github.io/web` | Never delete or gitignore `CNAME` |
| Changing `baseurl` from `""` | All asset paths and internal links break on the live site | Leave `baseurl: ""` alone |
| Pushing without running `build.sh` | Downloads page shows stale or missing files; Vite micro-app is stale | Always run `build.sh` and commit artifacts before push |
| Vite project not built | `build_vite.sh` fails with "Vite directory does not exist" if `projects/vite-react-test/dist` is absent | Build Vite first: `cd projects/vite-react-test && npm install && npm run build` |
| Pandoc or LaTeX missing | `build_downloads.sh` exits non-zero; PDF generation fails | Run `bash install.sh` first |
| GH Actions workflow uses Ruby 3.1 | The workflow pins Ruby 3.1 (not 3.3.5 like local). `github-pages` gem (~232) manages its own compatible Jekyll version — do not pin `gem "jekyll"` directly in Gemfile | Gemfile already uses `gem "github-pages"` pattern correctly; don't change the gem strategy |
| `_config.yml` plugin list | Plugins `jekyll-feed`, `jekyll-seo-tag`, `jekyll-sitemap` are all supported by the `github-pages` gem — safe to use | Only add plugins supported by the `github-pages` gem or the workflow will fail |
