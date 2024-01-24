// Variorum JS file, used only on variorum pages

// Function to replicate the old jquery toggle behaviour
$.fn.clicktoggle = function (a, b) {
  return this.each(function () {
    var clicked = false;
    $(this).bind("click", function () {
      if (clicked) {
        clicked = false;
        return b.apply(this, arguments);
      } else {
        clicked = true;
        return a.apply(this, arguments);
      }
    });
  });
};

$(function () {
  // Remove nojs classes
  $(".nojs").removeClass("nojs");
  
  // -----------------
  // Printed Copy Variations
  // Show/Hide
  // -----------------

  $(".variant_text_click").click(function() {
    if (!$(this).hasClass( "text_highlight" )) {
      $(this).addClass('text_highlight');
      $(this).parents(".v_container").addClass("text_highlight");
      $(this).parent('.variorum_content').append($(this).next('.tei_app'));
      var target = $(this).attr('data-target');
      var targetclass = "." + target;
      $(targetclass).attr("aria-hidden", "false");
      $(targetclass).removeClass('hide');
      
    } else {
      $(this).removeClass('text_highlight');
      $(this).parents(".v_container").removeClass("text_highlight");
      var target = $(this).attr('data-target');
      var targetclass = "." + target;
      $(targetclass).attr("aria-hidden", "true");
      $(targetclass).addClass('hide');
    }
    return false;
  });

  // Close button

  $(".v_close_tei_app button").click(function() {
    $(this).parents(".tei_app").addClass("hide");
    $(this).parents(".tei_app").attr("aria-hidden", "true");
    $(this).parents(".tei_app").siblings( ".variant_text_click" ).removeClass( "text_highlight" );
    $(this).parents(".v_container").removeClass("text_highlight");
  });
  
  // Show/Hide list of copies

  $(".open_all_rdg").clicktoggle(
  function () {
    // get the element's parent's previous sibling and hide
    $(this).parent()
          .siblings(".tei_rdg_wit")
          .removeClass("hide");
    $(this).children("span").text("Hide");
    $(this).removeClass("open_all_closed");
    return false;
  },
  function () {
    // get the element's parent's previous sibling and show
    $(this).parent()
          .siblings(".tei_rdg_wit")
          .addClass("hide");
    $(this).children("span").text("Show");
    $(this).addClass("open_all_closed");
    return false;
  });
  
  // -----------------
  // Related Manuscript Text
  // -----------------

  // TODO since we are no longer using this, perhaps remove when done
  // open all relations in new tabs 
  // (may require allowing popups)

  // $(".open_tabs").click(function() {
  //   // get the associated table for the element that was clicked
  //   var $table = $(this).parent().siblings("table");
  //   // get all the links from the location portion of the table
  //   var $anchors = $table.find(".relation_location > a");
  //   $anchors.each(function() {
  //     var href = $(this).attr("href");
  //     console.log("opening in new context: "+href);
  //     window.open(href, "_blank", "noreferrer");
  //   });
  // });

  // -----------------
  // Manipulate Manuscript supralinear overstrike within overstrike
  // -----------------

  $(".relation_data .overstrike > .noline > .supralinear").each(function(index) {

      // get the text before a noline
      // get the noline
      // get the text after a noline
      // put everything back together with closing spans and remove the noline stuff

      $container = $(this).parent(".noline").parent(".overstrike");
      // make a new placeholder for elements to be added to
      var $replacement = $("<span></span>");
      // get the containing node's overstricken children, because these will be
      // replaced with multiple elements
      $container.each(function() {
      $noline = $(this).children(".noline")
      // parse through the components of $(this)
      $(this).contents().each(function() {
        // if this is not the noline class, go ahead and stick it back on like normal
        if ($(this).hasClass("noline")) {
          // we no longer need the noline class since this is no longer
          // in an overstrike containing span, so just grab the overstrike children
          $replacement.append($(this).children(".overstrike"));
        } else {
          // if this is text, then it needs to be added inside an overstrike, otherwise
          // add things back in
          if ($(this).prop("nodeName") == "SUB") {
            $replacement.append($(this));
          } else if ($(this).prop("nodeName")) {
            $node = $(this);
            $node.addClass("overstrike");
            $replacement.append($node);
          } else {
            $replacement.append('<span class="overstrike">'+$(this).text()+'</span>')
          }
        }
      });
    });
    $container.replaceWith($replacement);
  });

  // -----------------
  // show/hide relations
  // -----------------

  $(".relation_link").click(function() {
    if ($(this).parents(".v_container").next(".relation_data").hasClass( "hide" )) {
      $(this).addClass("text_highlight");
      $(this).parents(".v_container").addClass("text_highlight");
      var target = $(this).attr('data-target');
      var targetclass = "." + target;
      $(targetclass).removeClass('hide');
      $(targetclass).attr("aria-hidden", "false");
    } else {
      $(this).removeClass("text_highlight");
      $(this).parents(".v_container").removeClass("text_highlight");
      var target = $(this).attr('data-target');
      var targetclass = "." + target;
      $(targetclass).addClass('hide');
      $(targetclass).attr("aria-hidden", "true");
    }
    return false;
  });

  // Close button

  $(".relation_data .v_close_tei_app button").click(function() {
    $(this).parents(".relation_data").addClass("hide");
    $(this).parents(".relation_data").attr("aria-hidden", "true");
    $(this).parents(".relation_data").prev().removeClass("text_highlight");
  });

  // -----------------
  // variant text
  // -----------------
  
  // provides previous and next links to jump the viewer between
  // the variant text examples

  $('.variant_text_next').click(function(e) {
    scrollVariant($(this), 1);
  });

  $('.variant_text_prev').click(function(e) {
    scrollVariant($(this), -1);
  });

  // scroll to the previous or next text variant
  // depending on the inline span that controls the current
  // text variant open / close functionality
  scrollVariant = function(item, incrementor) {
    // figure out which data-target we are looking for
    id = item.attr("class").split("variant_id_").pop();
    // find the data-target that matches the id
    $target = $('*[data-target="var_'+id+'"]').first();

    // get a list of all possible variants and determine
    // which one is currently being called, then either
    // add or subtract from that index to get the requested element
    $all_variants = $(".variant_text_expand");
    // remove the blink class from all of them in case that was previously set
    $all_variants.removeClass("blink");

    this_index = $all_variants.index($target);
    console.log("current variant: " + this_index);
    if (this_index != -1) {
      if (this_index + incrementor == $all_variants.length) {
        // if requesting beyond the last variant, go back to the beginning
        requested_index = 0;
      } else {
        requested_index = this_index + incrementor;
      }
      $requested = $all_variants.eq(requested_index);
      // scroll to the requested variant
      $requested.get(0).scrollIntoView({ behavior: "smooth", block: "center" });
      // add a class that will blink
      $requested.addClass("blink");
    }
  };

  // -----------------
  // Key/Legend
  // -----------------

  // Hide page key by default
  // $( ".v_page_key" ).addClass('hide'); // This will show by default

  // Show/hide page key
  $(".v_show_key").click(function() {
    if ($(".v_page_key").hasClass("hide")) {
      $(".v_page_key").removeClass("hide");
      $(this).text("hide key");
      
    } else {
      $(".v_page_key").addClass("hide");
      $(this).text("show key");
      $(".mss_links").css({"top": "0"});
    };
    return false;
  });

  // ----------------
  // Line Link
  // ----------------

  // When clicking a line link, copy the URL for that line to clipboard
  // Then when creating the page, add a class to highlight the line with that id

  // create background input, fill it with requested text, and copy to clipboard
  // then delete background input field
  // https://stackoverflow.com/a/30905277/4154134
  function copyToClipboard(text) {
    var $temp = $("<input>");
    $("body").append($temp);
    $temp.val(text).select();
    document.execCommand("copy");
    $temp.remove();
  }

  $(".v_line_link").on("click", function() {
    var id = $(this).parent("div.v_container").attr("id");
    var url = window.location.origin + window.location.pathname + "#" + id;
    console.log("copying " + url + " to clipboard");
    var id = $(this).parent("div.v_container").attr("id");
    copyToClipboard(url);
  })

  // on load, check for a hash
  if (window.location.hash) {
    console.log("jumping to requested line: " + window.location.hash);
    $lines = $(window.location.hash);
    if ($lines) {
      $lines.addClass("v_container_selected");
      $lines[0].scrollIntoView();
    }
  } 

});
