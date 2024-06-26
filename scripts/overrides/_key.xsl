<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0">
  
  <xsl:template name="key">
    <div class="v_page_key">
      <div class="v_page_key_inner">
        <xsl:choose>
          <xsl:when test="/TEI/@xml:id='ppp.01879'">
            <div class="v_printed_text_key">
              <h2>About the Reviews</h2>
              <p>After the 1855 edition of <em>Leaves of Grass</em> was published and the first several copies were circulating, Whitman collected reviews and extracts of responses to the volume as they were published in periodicals. Although they were published anonymously, Whitman himself wrote three of the reviews. He arranged for these to be reprinted along with other articles and extracts about poetry and poets more generally. He then arranged for the eight-page printed insertion to be bound into several of the remaining copies of <em>Leaves of Grass</em>.</p>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <div class="v_printed_text_key">
              <h2>Printed Copy Variations</h2>
              <span class="inline_tei_rdg_display inline_tei_rdg_key">Textual and Graphical Variants</span><br/>
              <span class="inline_tei_rdg_binding_display inline_tei_rdg_key">Bindings and Insertions</span><br/>
              <span class="inline_tei_rdg_drift_display inline_tei_rdg_key">Spatial Variants (Selected)</span>
              <p>The printed copy variations indicated with highlighted text and a dotted underline include stop-press changes, missing characters, bindings, inserted materials, and selected spatial and typographical differences caused by the printing process. Clicking on these variations produces a list of associated copies and images. Copy identifiers link to a bibliography with more information about individual copies.</p>
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
          <p>Clicking on "relations" displays related text from Whitman's early manuscripts and notebooks, along with links to transcriptions. The red and blue lines offer a visualization of the relations. The blue line corresponds to the number of related manuscripts or notebooks. The red line corresponds to the total number of related text segments from those manuscripts and notebooks. For more about how we have determined relations, see our
            <a target="_blank">
              <xsl:attribute name="href">
                <xsl:value-of select="$siteroot"/>
                <xsl:text>about/editorial.html#variorum</xsl:text>
              </xsl:attribute>
              <xsl:text>editorial policy statement</xsl:text>
            </a>.
          </p>
        </div>
        <xsl:choose>
          <xsl:when test="/TEI/@xml:id='ppp.01879'">
            <div class="v_related_works_key">
              <h2>Links to Periodical Versions</h2>
              <div class="tei_lg_poem_key tei_reviews">
                <div class="mss_links_key">
                  <ul class="mss_links_list">
                    <li class="fakelink_rev">View Periodical Version</li><br/>
                    <li class="fakelink_rev">Compare to Periodical Version (in Juxta)</li>
                  </ul>
                </div> <p>The reviews and extracts Whitman included in this printed insertion were first published in nineteenth-century periodicals. A green line to the right marks the beginning and end of each review or section. For each of the three reviews authored by Whitman, a box to the right side of the review provides a link to a transcription of the periodical version on the <em>Walt Whitman Archive</em>, as well as a link to a comparison view of the periodical version to the 1855 insertion version in Juxta.</p>
              </div>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <div class="v_related_works_key">
              <h2>List of Related Manuscripts</h2>
              <div class="tei_lg_poem_key tei_lg_poem_odd">
                <div class="mss_links_key">
                  <span class="mss_links_title"><strong>"Leaves of Grass" [3] ("To Think of Time")</strong></span>
                  <ul class="mss_links_list">
                    <strong>Related Manuscripts</strong>
                    <li>
                      <span class="fakelink">duk.00023</span> (low) </li>
                  </ul>
                </div> <p>The printed poems and the preface are each marked with a line on the right-hand side. A box next to the line gives printed or supplied 1855 titles. Repeated titles and untitled poems have been assigned a number in brackets. The poems also include their eventual (1881) titles in parentheses. Early manuscripts and notebooks that relate to some part of the preface or poem, or to the work as a whole, are linked in the box, along with a certainty (low or high) indicating how sure we are about the relation.</p>
              </div>
            </div>
          </xsl:otherwise>
        </xsl:choose>
        
        <!-- / v_related_works_key -->
        <xsl:choose>
          <xsl:when test="/TEI/@xml:id='ppp.01879'">
            <div class="v_instructions_key">
              <h2>A Note on the Text</h2>
              <p>The images provided as thumbnails before each page correspond to the insertion in a copy in the Clifton Waller Barrett Library of American Literature, Albert H. Small Special Collections Library, University of Virginia. For a complete list of copies that include the reviews insertion, see "<a target="_blank">
                  <xsl:attribute name="href">
                    <xsl:value-of select="$siteroot"/>
                    <xsl:text>published/LG/1855/variorum/main.html#pt_0020a</xsl:text>
                  </xsl:attribute>
                  <xsl:text>Reviews and extracts</xsl:text></a>" in the main text or visit the
                <a target="_blank">
                  <xsl:attribute name="href">
                    <xsl:value-of select="$siteroot"/>
                    <xsl:text>published/LG/1855/bibliography/index.html</xsl:text>
                  </xsl:attribute>
                  <xsl:text>bibliography of copies</xsl:text>
                </a>.
                For more information about our editorial rationale, see our
                <a target="_blank">
                  <xsl:attribute name="href">
                    <xsl:value-of select="$siteroot"/>
                    <xsl:text>about/editorial.html#variorum</xsl:text>
                  </xsl:attribute>
                  <xsl:text>editorial policy statement</xsl:text>
                </a> and the
                <a target="_blank">
                  <xsl:attribute name="href">
                    <xsl:value-of select="$siteroot"/>
                    <xsl:text>published/LG/1855/variorum/intro.html</xsl:text>
                  </xsl:attribute>
                  <xsl:text>introduction to the variorum</xsl:text>
                </a>.
              </p>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <div class="v_instructions_key">
              <h2>A Note on the Text</h2>
              <p>The images provided as thumbnails before each page correspond to a copy at the University of Iowa Special Collections and University Archives. This copy also forms the anchor for the transcription and the printed copy variations. Images from other copies, side-by-side views, and explanatory notes are available in the printed copy variations. For more information about our editorial rationale, see our
              <a target="_blank">
                <xsl:attribute name="href">
                  <xsl:value-of select="$siteroot"/>
                  <xsl:text>about/editorial.html#variorum</xsl:text>
                </xsl:attribute>
                <xsl:text>editorial policy statement</xsl:text>
              </a>
              and the
              <a target="_blank">
                <xsl:attribute name="href">
                  <xsl:value-of select="$siteroot"/>
                  <xsl:text>published/LG/1855/variorum/intro.html</xsl:text>
                </xsl:attribute>
                <xsl:text>introduction to the variorum</xsl:text>
              </a>.
              </p>
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </div><!-- / v_page_key_inner -->  
    </div><!-- / v_page_key -->
  </xsl:template>
  
</xsl:stylesheet>
