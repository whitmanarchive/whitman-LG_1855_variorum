<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xpath-default-namespace="http://www.whitmanarchive.org/namespace">

  <xsl:template name="key">
    <div class="v_page_key">
      <div class="v_page_key_inner">
          <div class="v_printed_text_key">
            
              <h2>Printed Text (Copy) Variations</h2>
              <span class="inline_tei_rdg">Textual and Graphical Variant</span><br/>
              <span class="inline_tei_rdg_binding text_highlight_binding">Bindings and Insertions</span><br/>
              <span class="inline_tei_rdg_drift">Drifts (Spatial Variants)</span>
            
           
              <p>Variations range from spelling corrections, differences in binding and other aspect, and changes due to the printing process. </p>
            
          </div>
          <div class="v_related_text_key">
           
              <h2>Related Text from Manuscripts</h2>
              <div class="key_related_example">
              <span class="relation_link" data-target="line_pr28"> Relations </span>
              <div class="relation_num" style="width:36%"/>
              </div>
            
          
              <p>Clicking on "relations" displays related text from Whitman manuscripts. The length of the line is a visualization fo the number of relations there are, the longer the line the more variations there are. </p>
            
          </div>
          <div class="v_related_works_key">
          
              <h2>Related Works</h2>
              <div class="tei_lg_poem_key tei_lg_poem_odd">
                <div class="mss_links_key">
                    <strong>"To Think of Time" (xxx.00266) </strong>
                    <ul class="mss_links_list">
                      <li>
                        <a href="https://whitman-dev.unl.edu/manuscripts/transcriptions/duk.00023.html"
                          target="_blank" rel="noreferrer noopener">duk.00023</a> (low) </li>
                    </ul>
                </div> <p>Each poem is marked with a line on the right hand side, with a box next to it with information and links. Manuscripts that contain some part of the poem are linked in the box, along with a certainty (low or high) about how sure we are about the poem relation.</p>
              </div>
  
            
             
            
          </div><!-- / v_related_works_key -->
        <div class="v_instructions_key">
          <h2>Instructions</h2>
          <p>Proin dictum, erat vitae ultrices interdum, lectus nunc ultrices nunc, sit amet dictum urna erat id justo. Morbi hendrerit fermentum ipsum, vitae porta ipsum finibus id. Cras pretium purus lacus, vel sollicitudin leo lobortis nec. Vestibulum odio leo, venenatis at molestie non, euismod et risus.  </p>
        </div>
      </div><!-- / v_page_key_inner -->
    </div><!-- / v_page_key -->
  </xsl:template>

</xsl:stylesheet>
