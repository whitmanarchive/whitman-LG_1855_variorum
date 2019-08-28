# Variorum Generation

This repository must be located relative to the cocoon site in order to run correctly:

```
same_dir/cocoon/whitmanarchive
same_dir/data/collections/whitman-variorum
```

Run `bundle exec post -x html` to generate a list of works and files which reference them, manifests for Leaves of Grass and snippets for comparison, as well as the variorum HTML itself.

## Works

To update those files which are being searched for works, please edit `source/authority/files_with_works.txt`, then re-run the post script. Results will be output to `source/authority/work_list_generated.xml`.

## Manifests

To update the snippets, download the snippets spreadsheet as a CSV and stick it in the data repo at `source/authority/snippets.csv`. Then run:

```
bundle exec post -x iiif
```

Two types of manifests will be created:

- a single manifest for the Leaves of Grass edition, with table of contents
- multiple manifests, one for each snippet, which may include more than one image (clip + original page)

The snippets process also creates a JS file, `output/[environment]/manifests/snippets/index.js` which contains information about how to relate all of the manifests.

If you are pulling the data repository changes to the server that the pages which use the manifests are calling, you should see the changes upon refreshing.
