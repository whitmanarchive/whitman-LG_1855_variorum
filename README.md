# Variorum Generation

This repository must be located relative to the cocoon site in order to run correctly:

```
same_dir/cocoon/whitmanarchive
same_dir/data/collections/whitman-variorum
```

Run `bundle exec post -x html` to generate a list of works and files which reference them and the variorum HTML itself.

To update those files which are being searched for works, please edit `source/authority/files_with_works.txt`.

