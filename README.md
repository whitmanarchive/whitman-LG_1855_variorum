# 1855 Leaves of Grass Variorum

This repo shares its Ruby gem dependencies with all other Whitman data
repos via the
[Gemfile](https://github.com/whitmanarchive/whitman-scripts/blob/main/Gemfile)
in the [whitman-scripts
repo](https://github.com/whitmanarchive/whitman-scripts)

## Overview

This data repository houses the XSLT and Ruby scripts used to create all the components of the 1855 Leaves of Grass variorum. It also has several XML files which are integral to the variorum, but the bulk of the TEI which it relies on can be found in the Whitman Archive's Cocoon site (manuscripts, marginalia, marginalia annotations, notebooks).

Some of the outputs of scripts available in this repository are the actual HTML of the variorum, a list of works, and IIIF manifests.

*Currently, the Whitman development server is calling the XSLT scripts from Cocoon!*  This means that changes you make to code on the server should show up right away, but it also means that you are pulling variables from `config.xsl` rather than `public.yml`, so be aware of that discrepancy! Regardless of whether this code is on the dev or production server, the variorum is being generated via the XSLT in the `scripts` directory.

## Setup

For information about how to set up this repository and its scripts, please visit [datura](https://github.com/CDRH/datura).  You will need Ruby, Datura, Saxon-HE, and gems required by the Datura software to run these scripts.

Due to these scripts needing access to TEI-XML located in the Whitman Archive's cocoon site, this repository must be located relative to the cocoon site as follows:

```
same_dir/cocoon/whitmanarchive
same_dir/data/collections/whitman-variorum
```

You will also need to allow your web server to serve files in the `output` directory, since that is where all of the IIIF manifests and HTML are placed after generation.

### Configuration

There are several configurable pieces in this repository.

- config/public.yml
- config/config.xsl
- source/authority/files_with_works.txt
- source/authority/lg_viewer_table_of_contents.yml

*config/public.yml*

This file contains the paths for the IIIF manifests regardless of environment.  It also has variables for the XSLT when using pregenerated HTML for the variorum (for example, on production).

*config/config.xsl*

This file contains only XSLT variables for on-the-fly generation (for example, development).

*source/authority/files_with_works.txt*

Update this file if you want to check more files for associated works.

*source/authority/lg_viewer_table_of_contents.yml*

This has a lengthy name so that hopefully it doesn't need much explaining!  Update this file if you would like more pages to be highlighting in the Leaves of Grass viewer along the left-hand side.

## Variorum Generation and Updates

Please refer to the below sections for more information about scripts and behavior. For those who just can't wait, you can run the following to regenerate everything possible:

```
# for production add flag -e production
bundle exec post -x html,iiif
```

This will generate a list of works and files which reference them, manifests for the 1855 Leaves of Grass and snippets for comparison, as well as the variorum HTML itself.

When you are done, commit your changes with git:

```
# view changes
git status

# add files
git add output/[environment]

git commit -m "[message]"
git push origin [branchname]
```

## Statics Assets

A number of pages which need to be generated statically are in the source/assets folder, including main.html, reviews.html, and comparison_viewer.html and other html files. There are folders for css, js, the iiif manifest, (static) images, juxta files (for the comparison viewer), Mirador and other vendor. Files need to be in the proper place in the file hierarchy so that they can be loaded by the static html pages. If pages need to be regenerated from the xml (with `post -x html`), please note that the corresponding html files must be moved out of output/[environment]/html into source/assets and renamed accordingly. main.html is generated as ppp.01879 and reviews.html is generated as ppp.01880.

### Development vs Production

You may regenerate the development and production environments from either server, but be aware that because the TEI files for related works may differ on each server, it is recommended that you regenerate IIIF / HTML on the respective servers per environment.

Regardless of the server, the process will be:

1. Log in to server and navigate to whitman-LG_1855_variorum directory
2. `git status` to check for any local changes and verify your branch
3. `git pull origin [branchname]`
4. Make your changes to the scripts or source files
5. `bundle exec post -x html,iiif -e [environment]`
6. Check that things are working on the website
7. If you changed scripts or TEI, `git add [files]`. Always `git add output/[environment]` to track your updates to generated files
8. `git commit -m "[message"]
9. `git push origin [branchname]`

It is recommended that you make your changes on the development server, test it out, then push those changes.  Pull to the production server and regenerate the IIIF then HTML.  Commit and push the resulting changes to the HTML and you're done!

### Works

To update those TEI files (in cocoon) which are being searched for works, please edit `source/authority/files_with_works.txt`, then re-run the HTML post script. Results will be output to `source/authority/work_list_generated.xml` and the variorum will be updated.

`bundle exec post -x html`

The following are required for this script to execute correctly:

- manuscripts/marginalia/tei/*
- manuscripts/marginalia/tei-annotations/*
- manuscripts/tei/*
- manuscripts/notebooks/tei/*

### IIIF Manifests

There are multiple IIIF manifests generated by scripts in this repo.

- a single manifest for the 1855 Leaves of Grass edition, with table of contents
- multiple manifests, one for each snippet, which may include more than one image (clip + original page)

To update the snippets, download the snippets spreadsheet as a CSV and stick it in the data repo at `source/authority/snippets.csv`.

```
bundle exec post -x iiif
```

The snippets process also creates a JS file, `output/[environment]/manifests/snippets/index.js` which contains information about how to relate all of the manifests.

If you are pulling the data repository changes to the server that the pages which use the manifests are calling, you should see the changes upon hard refreshing.

### HTML

The variorum is currently set up to run in two ways:  either on-the-fly in cocoon using XSL variables OR as pregenerated HTML using variables from `config/public.yml`.
