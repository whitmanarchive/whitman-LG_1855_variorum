# Variorum Generation

This repository must be located relative to the cocoon site in order to run correctly:

```
same_dir/cocoon/whitmanarchive
same_dir/data/collections/whitman-variorum
```

Run `bundle exec post -x html` to generate a list of works and files which reference them and the variorum HTML itself.

To update those files which are being searched for works, please edit `source/authority/files_with_works.txt`.

## Manifests

Currently the manifests are being generated separately from the post script and are only available for the development environment. To update the Leaves of Grass manifest, run this command:

```
ruby scripts/leaves_of_grass.rb
```

The resulting file is written to `output/development/manifests/leaves_of_grass.json`. You will need to put this file on the cdrh production server to see the changes, currently.

To update the snippets, download the snippets spreadsheet as a CSV and put it at `source/authority/snippets.csv`. Then run:

```
ruby scripts/manifest_snippets.rb
```

That generates JSON files for each image, and then a JS file which describes how all the manifests should be displayed in `output/development/manifests/snippets`. These files will also need to be on the cdrh production server to see your changes in the temporary html sites on that same server.
