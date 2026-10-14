# README.md

My personal website. Built with Jekyll and hosted on GitHub Pages. Downloads are generated with pandoc from the output of the Jekyll build.

## Getting Started

### Install

The following command will install the necessary dependencies.

```bash
bash install.sh
```

### Build

The following command will build the website and generate the downloads.

```bash
bash build.sh
```

### Test

The following command will serve the website locally.

```bash
bash test.sh
```

Note: The downloads are only generated when the website is built. See the [downloads](#downloads) section for more information.

## Downloads

`build.sh` builds the resume pages with Jekyll into a private temporary directory outside `docs/` and passes those HTML pages to `build_downloads.sh`, which uses pandoc to convert them to the download formats. When every format succeeds, `build_downloads.sh` copies the downloads into `assets/downloads` and regenerates `_data/downloads.yml`, which lists the download paths the site references. If any format fails, it leaves both untouched. The downloads are reproducible: the same resume gives the same bytes, and git shows a download as changed only when its content changed.

The `assets/downloads` directory is stored in git. So the site can be hosted on GitHub Pages and the downloads can be served from the same repository without trying to manage the `pandoc` dependencies on the GitHub Pages server.
