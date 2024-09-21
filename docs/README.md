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
bash serve.sh
```

Note: The downloads are only generated when the website is built. See the [downloads](#downloads) section for more information.

## Downloads

The downloads are defined in the `build_downloads.sh` script. The script uses pandoc to convert output in the `_site` directory to the desired formats. The output of which is placed back in the `assets/downloads` directory. It will also regenerate the `_data/downloads.yml` file with the new download paths which are referenced in the website.

The `assets/downloads` directory is stored in git. So the site can be hosted on GitHub Pages and the downloads can be served from the same repository without trying to manage the `pandoc` dependencies on the GitHub Pages server.
