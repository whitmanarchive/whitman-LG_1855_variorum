// this file is separate from the manuscript_comparison_viewer.js file
// because that file has not previously been exposed to jquery
// while this file requires it
// the snippetInfo variable is set in the manuscript_comparison_viewer file

// IE 9+ compatible query-string retrieval
// https://stackoverflow.com/a/7732379
function qs(key) {
  // escape RegEx meta chars
  key = key.replace(/[*+?^$.\[\]{}()|\\\/]/g, "\\$&");

  var match = location.search.match(new RegExp("[?&]"+key+"=([^&]+)(&|$)"));
  return match && decodeURIComponent(match[1].replace(/\+/g, " "));
}

// draw the mirador viewer
$(function() {
  var hostname = window.location.hostname;
  // changed link to relative
  var dataPath = "iiif/"


  idList = qs("ids");
  var ids = idList.split(",");

  var data = [];
  var windowObjects = [];
  var num = ids.length;
  for (var i = 0; i < num; i++) {
    var id = ids[i];
    data.push({
      manifestUri: dataPath+"snippets/"+id+".json",
      location: "Leaves of Grass 1855"
    });
    windowObjects.push({
      loadedManifest: dataPath+"snippets/"+id+".json",
      // canvasID: dataPath+"snippets/"+id,
      // slotAddress: "row1.column1",
      viewType: "ImageView",
      displayLayout: false,
      bottomPanel : false,
      annotationLayer: false,
      sidePanel: false
    });
  }

  myMiradorInstance = Mirador({
    id: "viewer",
    mainMenuSettings: { show: true },
    layout: "1x"+num,
    buildPath: "mirador/",
    data: data,
    windowObjects: windowObjects
  });
});
