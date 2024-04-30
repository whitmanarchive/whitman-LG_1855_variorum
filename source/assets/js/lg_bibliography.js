$(document).ready(function() {

  // create filterable / sortable table
  var table = $('.table-sortable').DataTable({
   "autoWidth": false,
   "dom": "flirptip",
   "lengthMenu": [[25,50,-1], [25, 50,"All"]],
   "order": [[ 1, "asc" ]],
   "search": { "regex": true, "smart": false }
  });

  // automatically filters table to one entry if linking here from
  // the variorum to specific records, checks that record abbreviations
  // match the expected format
  if (window.location.hash) {
    var hash = window.location.hash.substring(1);

    // split by | and check each abbreviation, filter out non matches
    // and put back together for the query
    unsanitized = hash.split(",");
    sanitized = unsanitized.filter(function(abbrev) {
      // console.log("abbrev: " + abbrev);
      return /^[A-Za-z]{2,6}_\d{2}$/.test(abbrev);
    });

    // show a console error if something was scrubbed along the way
    if (unsanitized.length !== sanitized.length) {
      console.log("some parameters were removed as invalid, please check the abbreviation ID");
    }

    // if there's at least one parameter left, search the table to display
    if (sanitized.length > 0) {
      // surround the ids in parentheses since this is a regex query
      // also start each id with a space, because it's not at the beginning
      // of a line to use ^ character, but no space will be too greedy with ids
      var abbrevs = "( " + sanitized.join("| ") + ")";
      table.search(abbrevs).draw();

      // at this point, we also need to add a link for the user to clear the search
      allResultsLength = table.data().length;
      linkText = "View all "+allResultsLength+" entries (remove filter)";
      $("<a class='dataTables_info' href='.'>"+linkText+"</a>").insertAfter($("#DataTables_Table_0_info"))
    }
  }

  // toggle the "more info" section below some of the descriptions
  // note: aria-expanded is an attribute which indicates to screenreaders
  // that content is currently expanded or hidden
  $(".bib_more_info_open").on("click", function() {
    $(this).next().show();
    $(this).attr("aria-expanded", true);
  });
  $(".bib_more_info_close").on("click", function() {
    $(this).parent().hide();
    $(this).parent().prev().attr("aria-expanded", false);
  });
});
