<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xpath-default-namespace="http://www.whitmanarchive.org/namespace">
  
  <xsl:template name="key">
    <div class="v_page_key">
      <div class="v_page_key_inner">
        <xsl:choose>
          <xsl:when test="/TEI/@xml:id='ppp.01879'">
            <div class="v_printed_text_key">
              <h2>About the Reviews</h2>
              <p>After the 1855 edition of <em>Leaves of Grass</em> was published and the first several copies were circulating, Whitman collected reviews and extracts of responses to the volume as they were published in periodicals. He arranged for these to be reprinted along with other articles and extracts about poetry and poets more generally. He then arranged for the eight-page printed insertion to be bound into several of the remaining copies of <em>Leaves of Grass</em>.</p>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <div class="v_printed_text_key">
              <h2>Printed Copy Variations</h2>
              <span class="inline_tei_rdg_display">Textual and Graphical Variants</span><br/>
              <span class="inline_tei_rdg_binding_display">Bindings and Insertions</span><br/>
              <span class="inline_tei_rdg_drift_display">Spatial Variants (Drifts)</span>
              <p>The printed copy variations indicated with highlighted text and a dotted underline include stop-press changes, missing characters, binding states, inserted materials, and selected spatial and typographical differences caused by the printing process. Clicking on these variations produces a list of associated copies and images.</p>
            </div>
          </xsl:otherwise>
        </xsl:choose>
        <div class="v_related_text_key">
          <h2>Related Manuscript Text</h2>
          <div class="key_related_example">
            <span class="relation_link" data-target="line_pr28"> Relations </span>
            <div class="relation_bg_key">
              <div class="relation_num" style="width:36%"/>
            <div class="relation_num_docs" style="width:24%"/>
            </div>
          </div>
          <p>Clicking on "relations" displays related text from Whitman's early manuscripts and notebooks, links to transcriptions, and certainty about the relation. The red and green lines offer a visualization of the number of related manuscripts and notebooks. The red line corresponds to the number of related manuscript and notebook segments. The green line corresponds to the number of related manuscripts or notebooks.</p>
        </div>
        <xsl:choose>
          <xsl:when test="/TEI/@xml:id='ppp.01879'">
            <div class="v_related_works_key">
              <h2>Links to Periodical Versions</h2>
              <div class="tei_lg_poem_key tei_lg_poem_odd">
                <div class="mss_links_key">
                  <ul class="mss_links_list">
                    <li class="underline">View Periodical Version</li>
                    <li class="underline">Compare to Periodical Version</li>
                  </ul>
                </div> <p>The reviews and extracts Whitman included in this printed insertion were first published in nineteenth-century periodicals. Although they were published anonymously, Whitman himself wrote three of the reviews. In these cases, a box to the right side of the review provides a link to a transcription of the periodical version on the <em>Walt Whitman Archive</em>, as well as a link to a comparison view of the texts in Juxta.</p>
              </div>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <div class="v_related_works_key">
              <h2>List of Related Manuscripts</h2>
              <div class="tei_lg_poem_key tei_lg_poem_odd">
                <div class="mss_links_key">
                  <strong>Related Manuscripts "Leaves of Grass" [3] ("To Think of Time")</strong>
                  <ul class="mss_links_list">
                    <li>
                      <span class="fakelink">duk.00023</span> (low) </li>
                  </ul>
                </div> <p>The printed poems and the preface are each marked with a line on the right-hand side. A box next to the line gives printed or supplied 1855 titles. Repeated titles and untitled poems have been assigned a number in brackets. The poems also include their eventual (1891) titles in parentheses. Early manuscripts and notebooks that relate to some part of the preface or poem, or to the work as a whole, are linked in the box, along with a certainty (low or high) indicating how sure we are about the relation.</p>
              </div>
            </div>
          </xsl:otherwise>
        </xsl:choose>
        
        <!-- / v_related_works_key -->
        <xsl:choose>
          <xsl:when test="/TEI/@xml:id='ppp.01879'">
            <div class="v_instructions_key">
              <h2>A Note on the Text</h2>
              <p>The images provided as thumbnails before each page correspond to the insertion in a copy in the Clifton Waller Barrett Library of American Literature, Albert H. Small Special Collections Library, University of Virginia. For a complete list of copies that include the reviews insertion, see "<a target="_blank" href="https://whitman-dev.unl.edu/published/LG/1855/variorum.html#pt_0020a">Reviews and extracts</a>" in the main text or visit the <a target="_blank" href="https://whitman-dev.unl.edu/published/LG/1855/bibliography/index.html">bibliography of copies</a>.</p>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <div class="v_instructions_key">
              <h2>A Note on the Text</h2>
              <p>The images provided as thumbnails before each page correspond to a copy at the University of Iowa Special Collections and University Archives. This copy also forms the anchor for the transcription and the printed copy variations. Images from other copies, side-by-side views, and explanatory notes are available in the printed copy variations. For more information about our editorial rationale, see our <a href="https://whitman-dev.unl.edu/about/editorial.html#variorum">editorial policy statement</a> and the <a href="https://whitman-dev.unl.edu/published/LG/1855/variorum/intro.html">introduction to the variorum</a>.</p>
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </div><!-- / v_page_key_inner -->  
    </div><!-- / v_page_key -->
  </xsl:template>
  
</xsl:stylesheet>
