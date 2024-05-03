// this used to make more sense when it was embedded in the HTML but cocoon
// hates <a> tags and also greater than signs so moved HTML output scripting
// to javascript file instead

// the below writes links to different snippet groupings and creates a previous / next
// button for basic navigation

// IE 9+ compatible query-string retrieval
// https://stackoverflow.com/a/7732379
function qs(key) {
    // escape RegEx meta chars
    key = key.replace(/[*+?^$.\[\]{}()|\\\/]/g, "\\$&");

    var match = location.search.match(new RegExp("[?&]"+key+"=([^&]+)(&|$)"));
    return match && decodeURIComponent(match[1].replace(/\+/g, " "));
}

$(function () {
  var hostname = window.location.hostname;
  var viewerUrl = "comparison_viewer.html";
  var iFrameUrl = "comparison_viewer_iframe.html";

  var nav = document.getElementById("snippet_navigation");
  var iframeholder = document.getElementById("iframe_holder");
  // default to front-cover section
  var base = qs("base");

  // calculates the current index for previous / next functionality
  // IE 9+ compatible
  var currentSnippetIndex = -1;
  snippets.some(function(el, i) {
    if (el["link"] === base) {
      currentSnippetIndex = i;
      return true;
    }
  });

  var snippetInfo = null;
  if (currentSnippetIndex == -1) {
    console.log("no known snippet specified, defaulting to first snippet");
    var snippetInfo = snippets[0];
  } else {
    var snippetInfo = snippets[currentSnippetIndex];
  }

  // HTML GENERATION

  // links to each snippet group by label
  snippets.forEach(function(snippet) {
    if (snippet["link"] == base) {
      nav.innerHTML += '<a class="active" href="'+viewerUrl+'?base='+snippet["link"]+'">'+snippet["label"]+'</a>';
    } else {
      nav.innerHTML += '<a href="'+viewerUrl+'?base='+snippet["link"]+'">'+snippet["label"]+'</a>';
    }
  });

  // iframe
  var idsForIframe = snippetInfo["ids"].join(",");
  iframeholder.innerHTML += '<div class="page_content"> \
    <iframe id="mirador_viewer_window" \
      title="Inline Mirador Viewer" \
      allowfullscreen="true" \
      width="300" \
      height="200" \
      src="'+iFrameUrl+'?ids='+idsForIframe+'"> \
    </iframe> \
  </div>';
});

