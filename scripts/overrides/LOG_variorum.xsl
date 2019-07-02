<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
 xpath-default-namespace="http://www.whitmanarchive.org/namespace">

 <xsl:param name="refID"/>
 <xsl:param name="path1">undefined</xsl:param>
 <!-- added link to config file -KMD -->
 <xsl:include href="../../../xslt/config.xsl"/>
 <xsl:output method="html" indent="yes" encoding="UTF-8" media-type="text/html"/>


 <!-- BEGIN: HTML OUTPUT STRUCTURE -->
 <xsl:template match="/">
  <!--<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>-->
  <html xmlns="http://www.w3.org/1999/xhtml">
   <head>

    <title>Walt Whitman Archive - Published Works - Books by Whitman - Leaves of Grass</title>

   </head>

   <body>
    <h1 class="docTitle">Published Works</h1>
    <h2 class="docTitle">Leaves of Grass</h2>
    <div class="variorum_header">
     <a href="variorum.html">Back to index page</a>
     <h1>1855 <i>Leaves of Grass</i> Variorum</h1>
    </div>

    <xsl:apply-templates select="/TEI/text/front"/>
    <xsl:apply-templates select="/TEI/text/body"/>
    <xsl:if test="/TEI/text/back">
     <xsl:apply-templates select="/TEI/text/back"/>
    </xsl:if>


    <!--Added to create display tables 8/29/18, nhg-->
    <!-- <script
              src="https://code.jquery.com/jquery-1.12.4.min.js">&#160;</script>-->
    <script>
              $(".open").on("click", function(){
              $(this).prev().children(".popup-content").addClass("active");
              });
              $(".close, .popup").on("click",function(){
              $(".popup, .popup-content").removeClass("active");
              });
             </script>
   </body>
  </html>
 </xsl:template>
 <!-- END: OUTPUT -->

 

 
<!-- ===== NAMED TEMPLATES ======= -->

 <xsl:template name="related_mss">
  <xsl:variable name="line_id" select="concat('#', @xml:id)"/>
  <xsl:variable name="uri_line_id" select="concat('ppp.00271_var.xml', $line_id)"/>
  <xsl:variable name="corresp_doc" select="document('../../../published/LG/sandbox/anc.02134.xml')"/>
  <xsl:variable name="rel_num"
   select="count($corresp_doc//link[contains(@target, concat($uri_line_id, ' '))])"/>
  <xsl:variable name="percent_num" select="round($rel_num div 14 * 100)"/>
  <!--<xsl:value-of select="$percent_num"/><br/>-->
  <div class="relation_num" style="width:{$percent_num}%"/>
 </xsl:template>

  <xsl:template name="corresp_table">
    <xsl:variable name="line_id" select="concat('#', @xml:id)"/>
    <xsl:variable name="uri_line_id" select="concat('ppp.00271_var.xml', $line_id)"/>
    <xsl:variable name="line" select="."/>
    <xsl:variable name="corresp_doc" select="document('../../../published/LG/sandbox/anc.02134.xml')"/>
    <xsl:if test="$corresp_doc//link[contains(@target, concat($uri_line_id, ' '))]">
      <span class="popup-overlay">
        <span class="popup-content">
          <span class="close">x</span>
          <table>
            <tr>
              <th scope="col">
                <strong>document</strong>
              </th>
              <th scope="col">
                <strong>text</strong>
              </th>
            </tr>
            <xsl:for-each select="$corresp_doc//link">
              <xsl:if test="contains(@target, concat($uri_line_id, ' '))">
                <xsl:variable name="fileID" select="ancestor::linkGrp/@corresp"/>
                <xsl:variable name="fileIDhtml" select="concat(substring-before($fileID, '.xml'), '.html')"/>
                <xsl:variable name="msID" select="substring-after(substring-after(@target, '#'), '#')"/>
                <xsl:variable name="nbPath" select="concat('../../../manuscripts/notebooks/tei/', $fileID)"/>
                <xsl:variable name="nbFile" select="document($nbPath)"/>
                <xsl:variable name="msPath" select="concat('../../../manuscripts/tei/', $fileID)"/>
                <xsl:variable name="msFile" select="document($msPath)"/>
                <!--TEMPORARY LOCATION-->
                <xsl:variable name="otherPath" select="concat('../../../published/LG/sandbox/',$fileID)"/>
                <xsl:variable name="otherFile" select="document($otherPath)"/>
                <!--/TEMPORARY LOCATION-->
                <xsl:variable name="cert" select="@cert"/>
                <tr>
                  <xsl:if test="$cert='low'"><xsl:attribute name="style">background-color: #e6e6e6</xsl:attribute></xsl:if>
                  <td>
                    <a target="_blank">
                      <xsl:choose>
                        <xsl:when test="doc-available(concat('../../../manuscripts/notebooks/tei/', $fileID))">
                          <xsl:attribute name="href"
                            select="concat('../../../manuscripts/notebooks/transcriptions_var/', $fileIDhtml, '#', $msID)"
                          />
                        </xsl:when>
                        <!--TEMPORARY LOCATION-->
                        <xsl:when test="doc-available(concat('../../../published/LG/sandbox/',$fileID))">
                          <xsl:attribute name="href" select="concat('../../../published/LG/1855/related/',$fileIDhtml,'#',$msID)"/>
                        </xsl:when>
                        <!--/TEMPORARY LOCATION-->
                        <xsl:otherwise>
                          <xsl:attribute name="href"
                            select="concat('../../../manuscripts/transcriptions_var/', $fileIDhtml, '#', $msID)"/>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:value-of select="substring-before($fileID, '.xml')"/>
                    </a>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="doc-available($nbPath)">
                        <xsl:apply-templates mode="mss" select="$nbFile//*[@xml:id = $msID]"/>
                      </xsl:when>
                      <!--TEMPORARY LOCATION-->
                      <xsl:when test="doc-available($otherPath)">
                        <xsl:apply-templates mode="mss" select="$otherFile//*[@xml:id=$msID]"/>
                      </xsl:when>
                      <!--/TEMPORARY LOCATION-->
                      <xsl:otherwise>
                        <xsl:apply-templates mode="mss" select="$msFile//*[@xml:id = $msID]"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
              </xsl:if>
            </xsl:for-each>
            <tr>
              <td><!--ppp.00271--><i>Leaves of Grass</i> (1855)</td>
              <td>
                <xsl:apply-templates mode="mss" select="$line"/>
              </td>
            </tr>
          </table>
          <span class="open_all"><a target="_blank" href="https://www.whitmanarchive.org">Open all in tabs</a></span>
        </span>
      </span>
      <span class="open popup_click">Relations</span>
    </xsl:if>
  </xsl:template>
 
<!-- ===== MATCH TEMPLATES ======= -->
  
  <!--BEGIN: PREFACE-->
  <xsl:template match="//div1[@type = 'preface']">
    <div class="tei_div_preface">
      <!-- A very sketched in idea of how this might work -kmd -->
      <div class="mss_links">
        <strong class="mss_link"><a href="https://whitman-dev.unl.edu/grant_search/search?f%5B%5D=subcategory%7Ctranscriptions&amp;f%5B%5D=date.year%7C1845" target="_blank">MSS</a></strong><br/>
        <strong class="mss_show">Show</strong><br/>
        <div class="mss_links_hide"><br/>"Preface"<br/><br/>wwa.00001 <br/>wwa.00002 <br/>wwa.00003 <br/>wwa.00004 <br/>wwa.00005 <br/>wwa.00006 <br/>wwa.00007 <br/>wwa.00008 <br/>wwa.00009 <br/>wwa.00010 <br/>wwa.00011 <br/>wwa.00012 <br/>wwa.00013 <br/>wwa.00014 <br/>wwa.00015 <br/>wwa.00016</div></div>
      <xsl:choose>
        <xsl:when test="@rend = 'italic'">
          <div class="italic">
            <em>
              <xsl:apply-templates/>
            </em>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div>
            <xsl:apply-templates/>
          </div>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="following-sibling::lg[@type = 'poem']">
        <br/>
      </xsl:if>
    </div>
  </xsl:template>
  
  <!-- BEGIN: POETRY -->
  <xsl:template match="//lg[@type = 'poem']">
    <xsl:if test="not(ancestor::div1[@type='review'])"><div>
      <xsl:attribute name="class">
        <xsl:text>tei_lg_poem </xsl:text>
        <xsl:variable name="num_pos">
          <xsl:number/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$num_pos mod 2 = 0">
            <xsl:text>tei_lg_poem_even</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>tei_lg_poem_odd</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:variable name="work_id" select="descendant::relations/work/@ref"/>
      <xsl:variable name="poem_name">
        <xsl:choose>
          <xsl:when test="$work_id='xxx.00048'">"Song of Myself"</xsl:when>
          <xsl:when test="$work_id='xxx.00119'">"A Song for Occupations"</xsl:when>
          <xsl:when test="$work_id='xxx.00266'">"To Think of Time"</xsl:when>
          <xsl:when test="$work_id='xxx.00264'">"The Sleepers"</xsl:when>
          <xsl:when test="$work_id='xxx.00052'">"I Sing the Body Electric"</xsl:when>
          <xsl:when test="$work_id='xxx.00271'">"Faces"</xsl:when>
          <xsl:when test="$work_id='xxx.00113'">"Song of the Answerer"</xsl:when>
          <xsl:when test="$work_id='xxx.00144'">"Europe, the 72d and 73d Years of These States"</xsl:when>
          <xsl:when test="$work_id='xxx.00143'">"A Boston Ballad"</xsl:when>
          <xsl:when test="$work_id='xxx.00226'">"There Was a Child Went Forth"</xsl:when>
          <xsl:when test="$work_id='xxx.00250'">"Who Learns My Lesson Complete"</xsl:when>
          <xsl:when test="$work_id='xxx.00430'">"Great are the Myths"</xsl:when>
        </xsl:choose>
      </xsl:variable>
      <!-- A very sketched in idea of how this might work -kmd -->
      <div class="mss_links">
        <strong class="mss_link"><a href="https://whitman-dev.unl.edu/grant_search/search?f%5B%5D=subcategory%7Ctranscriptions&amp;f%5B%5D=date.year%7C1845" target="_blank">MSS</a></strong><br/>
        <strong class="mss_show">Show</strong><br/>
        <div class="mss_links_hide"><br/><xsl:value-of select="$poem_name"/><br/><br/>wwa.00001 <br/>wwa.00002 <br/>wwa.00003 <br/>wwa.00004 <br/>wwa.00005 <br/>wwa.00006 <br/>wwa.00007 <br/>wwa.00008 <br/>wwa.00009 <br/>wwa.00010 <br/>wwa.00011 <br/>wwa.00012 <br/>wwa.00013 <br/>wwa.00014 <br/>wwa.00015 <br/>wwa.00016</div></div>
      <xsl:choose>
        <xsl:when test="@rend = 'italic'">
          <div class="italic">
            <em>
              <xsl:apply-templates/>
            </em>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div>
            <xsl:apply-templates/>
          </div>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="following-sibling::lg[@type = 'poem']">
        <br/>
      </xsl:if>
    </div></xsl:if>
  </xsl:template>
  
  <xsl:template match="//lg[@type = 'linegroup']">
    <xsl:choose>
      <xsl:when test="following-sibling::lg[@type = 'linegroup']">
        <xsl:apply-templates/>
        <br/>
      </xsl:when>
      <xsl:when test="parent::lg[@type = 'section']">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="parent::lg[@type = 'poem']">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="@rend = 'italic'">
        <em>
          <xsl:apply-templates/>
        </em>
      </xsl:when>
      <xsl:otherwise>
        <br/>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="//lg[@type = 'section']">
    <xsl:choose>
      <xsl:when test="following-sibling::lg[@type = 'section']">
        
        <xsl:apply-templates/>
        <br/>
        <br/>
        
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="//l">
    
    <xsl:choose>
      <xsl:when test="ancestor::div1[@type = 'review']">
        <div class="tei_l_review">
          <span class="variorumLine variorumOuter">
            <xsl:if test="@xml:id">
              <xsl:attribute name="id" select="substring-after('l', @xml:id)"/>
            </xsl:if>
            <xsl:apply-templates/>
          </span>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="tei_l">
          <xsl:variable name="line_id" select="@xml:id"/>
          <!--Added to create display tables 8/29/18, nhg-->
          <span class="tei_l_corresp">
            <xsl:call-template name="corresp_table"/>
            <xsl:call-template name="related_mss"/>
          </span>
          <!--<span class="tei_l_related"></span>-->
          <span class="tei_l_xmlid">
            <xsl:variable name="num">
              <xsl:value-of select="number(substring-after($line_id, 'l'))"/>
            </xsl:variable>
            <xsl:value-of select="$num + 1"/>
          </span>
          <span class="variorumLine variorumOuter">
            <xsl:attribute name="id" select="$line_id"/>
            <xsl:apply-templates/>
          </span>
          <span class="tei_l_right">&#160;</span>
        </div>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  <!-- END: POETRY -->
  
  <!-- BEGIN: SEG -->
  <xsl:template match="//seg">
    <div class="tei_seg">
      <!--Added to create display tables 8/29/18, nhg-->
      <span class="tei_seg_corresp">
        <xsl:call-template name="corresp_table"/>
        <xsl:call-template name="related_mss"/>
      </span>
      <!-- <span class="tei_seg_related"><xsl:call-template name="related_mss"/></span>-->
      <span class="tei_seg_xmlid">
        <xsl:if test="@xml:id">
          <xsl:attribute name="id" select="@xml:id"/>
        </xsl:if>
      </span>
      <span class="variorumSeg variorumOuter">
        <xsl:apply-templates/>
      </span>
      <span class="tei_seg_right">&#160;</span>
    </div>
  </xsl:template>
  <!-- END: SEG -->
  
  
  <xsl:template match="ptr">
  <xsl:if test="@target">
   <xsl:text>&#160;</xsl:text>
   <xsl:element name="a">
    <xsl:attribute name="href">
     <xsl:value-of select="$siteroot"/>published/LG/sandbox/<xsl:value-of select="@target"/>
    </xsl:attribute>
    <xsl:attribute name="data-group">gallery</xsl:attribute>
    <xsl:attribute name="class">gallery-image</xsl:attribute>
    <span class="smallcaps">[IMG]</span>
   </xsl:element>
  </xsl:if>
 </xsl:template>

 <!--Added to create display tables 8/29/18, nhg-->

 <xsl:template match="//encodingDesc//title[@level = 'm']">
  <em>
   <xsl:apply-templates/>
  </em>
 </xsl:template>

 <!-- BEGIN: TITLE PAGE AND FRONT MATTER -->
 <xsl:template match="//titlePage">
  <p>
   <xsl:apply-templates/>
  </p>
 </xsl:template>

 <xsl:template match="//titlePart/name">
  <p>
   <xsl:apply-templates/>
  </p>
 </xsl:template>

 <xsl:template match="//titlePart[@type = 'main']">
  <div>
   <xsl:apply-templates/>
  </div>
 </xsl:template>

 <xsl:template match="//titlePart[@type = 'sub']">
  <div>
   <xsl:apply-templates/>
  </div>
 </xsl:template>

 <xsl:template match="//docImprint/date">
  <p>
   <xsl:apply-templates/>
  </p>
 </xsl:template>

 <xsl:template match="//docEdition">
  <p>
   <xsl:apply-templates/>
  </p>
 </xsl:template>

 <xsl:template match="//docImprint">
  <div>
   <xsl:apply-templates/>
  </div>
 </xsl:template>

 <xsl:template match="//docImprint/publisher">
  <div class="teiFigure">
   <xsl:apply-templates/>
  </div>
 </xsl:template>

 <xsl:template match="//docImprint/pubPlace">
  <p>
   <xsl:apply-templates/>
  </p>
 </xsl:template>

 <xsl:template match="//docImprint/docDate">
  <p>
   <xsl:apply-templates/>
  </p>
 </xsl:template>

 <xsl:template match="//docAuthor">
  <p>
   <xsl:apply-templates/>
  </p>
 </xsl:template>

 <xsl:template match="p[@type = 'copyright']/p">
  <p>
   <xsl:apply-templates/>
  </p>
 </xsl:template>

 <xsl:template match="titlePage/byline">
  <p>
   <xsl:apply-templates/>
  </p>
 </xsl:template>
 <!-- END: TITLE PAGE AND FRONT MATTER -->


 <!-- BEGIN: TABLE OF CONTENTS -->
 <xsl:template match="front//table">
  <table class="teiTable">
   <xsl:apply-templates/>
  </table>
 </xsl:template>

 <xsl:template match="back//table">
  <table class="teiTable">
   <xsl:apply-templates/>
  </table>
 </xsl:template>

 <xsl:template match="//row">
  <tr>
   <xsl:apply-templates/>
  </tr>
 </xsl:template>

 <xsl:template match="//cell">

  <td valign="top">
   <br/>
   <xsl:apply-templates/>
  </td>
 </xsl:template>
 <!-- END: CONTENTS -->


 <!-- BEGIN: EPIGRAPHS -->
 <xsl:template match="//epigraph">
  <br/>
  <div>
   <xsl:apply-templates/>
  </div>

  <br/>
 </xsl:template>

 <xsl:template match="epigraph//bibl" priority="1">
  <span>
   <br/>
   <xsl:apply-templates/>
  </span>
 </xsl:template>
 <!-- END: EPIGRAPHS -->


 <!-- BEGIN: FIGURES -->
 <xsl:template match="figDesc"/>

 <xsl:template match="//figure">
  <p>
   <img class="teiFigure">
    <xsl:attribute name="src"><xsl:value-of select="$externalfileroot"
      />published/LG/figures/<xsl:value-of select="@entity"/>.jpg</xsl:attribute>
    <!-- added variable -KMD -->
   </img>
   <xsl:apply-templates/>
  </p>
 </xsl:template>
 <!-- END: FIGURES -->



 <!-- BEGIN: PBS -->

 <xsl:template match="pb">
  <span class="teiFigure">
   <br/>
   <br/> - - - - - - - - - - - - - - - - - - <span class="smalltext"> [page&#160;break]</span> - - -
   - - - - - - - - - - - - - - - <br/>
   <br/>
  </span>
 </xsl:template>

 <!-- END: PBS -->



 <!-- BEGIN: HEADS -->
 <xsl:template match="head">
  <xsl:choose>

   <xsl:when test="@rend = 'right'">
    <p class="rendRight bold">
     <xsl:apply-templates/>
    </p>
   </xsl:when>

   <xsl:when test="@rend = 'left'">
    <p class="rendLeft bold">
     <xsl:apply-templates/>
    </p>
   </xsl:when>

   <xsl:when test="parent::figure">
    <p>
     <xsl:apply-templates/>
    </p>
   </xsl:when>

   <xsl:when test="ancestor::q">
    <xsl:choose>
     <xsl:when test="parent::lg">
      <div class="bold">
       <br/>
       <xsl:apply-templates/>
       <br/>
       <br/>
      </div>
     </xsl:when>
     <xsl:otherwise>
      <span class="bold">
       <blockquote>
        <xsl:apply-templates/>
       </blockquote>
      </span>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:when>

   <xsl:when test="parent::body">
    <div class="padding_left_0">
     <strong>
      <xsl:apply-templates/>
     </strong>
    </div>
   </xsl:when>

   <xsl:when test="parent::lg[@type = 'cluster']">
    <br/>
    <div class="padding_left_10">
     <strong>
      <xsl:apply-templates/>
     </strong>
     <br/>
     <br/>
    </div>
   </xsl:when>

   <xsl:when test="parent::lg[@type = 'poem']">
    <xsl:choose>
     <xsl:when test="@type = 'sub'">

      <div>
       <xsl:apply-templates/>
      </div>
      <br/>
     </xsl:when>
     <xsl:otherwise>
      <xsl:choose>

       <xsl:when test="following-sibling::head">
        <br/>

        <div>
         <strong>
          <xsl:apply-templates/>
         </strong>
        </div>
       </xsl:when>
       <xsl:when test="following-sibling::lg">
        <br/>

        <div>
         <strong>
          <xsl:apply-templates/>
         </strong>
        </div>
        <br/>
       </xsl:when>
       <xsl:when test="following-sibling::l">

        <div>
         <br/>
         <strong>
          <xsl:apply-templates/>
          <br/>
          <br/>
         </strong>
        </div>
       </xsl:when>
       <xsl:otherwise>

        <div>
         <strong>
          <xsl:apply-templates/>
          <br/>
          <br/>
         </strong>
        </div>
       </xsl:otherwise>
      </xsl:choose>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:when>

   <xsl:when test="parent::lg[@type = 'section']">
    <xsl:choose>
     <xsl:when test="following-sibling::lg[@type = 'linegroup']">

      <div>
       <strong>
        <xsl:apply-templates/>
       </strong>
      </div>
      <br/>
     </xsl:when>
     <xsl:when test="following-sibling::l">

      <div>
       <strong>
        <xsl:apply-templates/>
       </strong>
      </div>
      <br/>
     </xsl:when>
     <xsl:otherwise>
      <div class="padding_left_0">
       <strong>
        <xsl:apply-templates/>
       </strong>
       <br/>
       <br/>
      </div>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:when>

   <xsl:when test="parent::lg[@type = 'linegroup']">
    <xsl:choose>
     <xsl:when test="@type = 'sub'">
      <div class="padding_left_0">
       <strong>
        <xsl:apply-templates/>
       </strong>
      </div>
     </xsl:when>
     <xsl:otherwise>
      <div class="padding_left_0">
       <br/>
       <br/>
       <br/>
       <strong>
        <xsl:apply-templates/>
       </strong>
       <br/>
       <br/>
      </div>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:when>



   <xsl:when test="parent::div1">
    <xsl:choose>
     <xsl:when test="@type = 'main-authorial'">
      <div class="padding_left_10">
       <br/>
       <strong>
        <xsl:apply-templates/>
       </strong>
      </div>
     </xsl:when>
     <xsl:when test="@type = 'sub'">
      <div class="padding_left_10">
       <xsl:apply-templates/>
      </div>
     </xsl:when>
     <xsl:otherwise/>
    </xsl:choose>
   </xsl:when>


   <xsl:when test="parent::div2">
    <xsl:choose>
     <xsl:when test="@type = 'main-authorial'">
      <div class="padding_left_10">
       <br/>
       <strong>
        <xsl:apply-templates/>
       </strong>
      </div>
     </xsl:when>
     <xsl:when test="@type = 'sub'">
      <div class="padding_left_10">
       <xsl:apply-templates/>
      </div>
     </xsl:when>
     <xsl:otherwise/>
    </xsl:choose>
   </xsl:when>

   <xsl:when test="parent::div3">
    <p>
     <br/>
     <strong>
      <xsl:apply-templates/>
     </strong>
    </p>
   </xsl:when>

   <xsl:otherwise>
    <div>
     <xsl:apply-templates/>
     <br/>
     <br/>
    </div>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!-- END: HEADS -->


 <!-- BEGIN: BYLINE -->
 <xsl:template match="//byline" priority="1">
  <div class="padding_left_10 smalltext">
   <br/>
   <strong>
    <xsl:apply-templates/>
   </strong>
  </div>
 </xsl:template>
 <!-- END: BYLINE -->

 <!-- BEGIN: DATELINE -->
 <xsl:template match="//dateline">
  <p>
   <xsl:apply-templates/>
  </p>
 </xsl:template>

 <xsl:template match="//salute">
  <p>
   <xsl:apply-templates/>
  </p>
 </xsl:template>

 <xsl:template match="//signed">
  <p>
   <xsl:apply-templates/>
  </p>
 </xsl:template>


 <!-- BEGIN: TRAILER -->
 <xsl:template match="//trailer">
  <p>
   <xsl:apply-templates/>
  </p>
 </xsl:template>

 <!-- BEGIN: QUOTED TEXT -->
 <xsl:template match="//q">
  <xsl:choose>
   <xsl:when test="descendant::lg">
    <br/>
    <span class="teiQuoteLineGroup">
     <xsl:apply-templates/>
    </span>
    <br/>
   </xsl:when>
   <xsl:when test="@rend = 'right'">
    <span class="rendRight">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:when test="@rend = 'left'">
    <span class="rendLeft">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>
 <!-- BEGIN: QUOTED TEXT -->
  
  <!-- BEGIN: ORIG/REG -->
 <!-- added priority -->
 <xsl:template match="//corr"/>
 <xsl:template match="//reg"/>
 <!-- END: ORIG/REG -->


 <!-- BEGIN: LISTS -->
 <xsl:template match="//list">
  <xsl:choose>
   <xsl:when test="ancestor::back">
    <span>
     <ul class="simpleList">
      <xsl:for-each select="item">
       <!--<li class="margin_left_neg_30">-->
       <li>
        <xsl:apply-templates/>
       </li>
       <!--</li>-->
      </xsl:for-each>
     </ul>
    </span>
   </xsl:when>
   <xsl:when test="ancestor::div1">
    <span>
     <ul class="simpleList">
      <xsl:for-each select="item">
       <!--<li class="margin_left_neg_30">-->
       <li>
        <xsl:apply-templates/>
       </li>
       <xsl:if test="following-sibling::note">
        <div class="translations-note-inlist">
         <xsl:apply-templates select="following-sibling::note"/>
        </div>
       </xsl:if>
       <xsl:if test="following-sibling::pb">
        <xsl:apply-templates select="following-sibling::pb"/>
       </xsl:if>
       <!--</li>-->
      </xsl:for-each>
     </ul>
    </span>
   </xsl:when>
   <xsl:otherwise>
    <ul class="simpleList">
     <xsl:for-each select="item">
      <li>
       <xsl:apply-templates/>
      </li>
     </xsl:for-each>
    </ul>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>
 <!-- END: LISTS -->


 <!-- BEGIN: Paragraphs AND FLOATINGTEXT TEXT -->
 <xsl:template match="//p">
  <xsl:choose>
   <xsl:when test="ancestor::q">
    <p class="blockquote">
     <xsl:apply-templates/>
    </p>
   </xsl:when>
   <xsl:when test="parent::encodingDesc">
    <span>
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:otherwise>
    <br/>
    <span>
     <xsl:apply-templates/>
    </span>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>
 <!-- END: PARAGRAPHS AND FLOATINGTEXT TEXT -->


 <!-- BEGIN: REFS AND NOTES -->

 <!-- begin notes -->
 <xsl:template match="//note[@type = 'authorial'] | //body//note[@type = 'editorial']">
  <xsl:choose>
   <xsl:when test="@place = 'inline'">
    <xsl:apply-templates/>
    <br/>
    <br/>
   </xsl:when>

   <xsl:when test="@place = 'bottom'">
    <xsl:choose>
     <xsl:when test="ancestor::floatingText/ancestor::p">
      <p class="translations-footnote translations-footnote-inblockquote">
       <xsl:choose>
        <xsl:when test="attribute::n">
         <sup>
          <xsl:value-of select="attribute::n"/>
          <xsl:if test="ancestor::TEI[@xml:id = 'med.00152']">) </xsl:if>
         </sup>
        </xsl:when>
        <xsl:otherwise>
         <xsl:text>*</xsl:text>
         <xsl:if test="ancestor::TEI[@xml:id = 'med.00152']">) </xsl:if>
        </xsl:otherwise>
       </xsl:choose>
       <xsl:apply-templates/>
      </p>
     </xsl:when>
     <xsl:when test="ancestor::floatingText">
      <p class="translations-footnote translations-notinquote">
       <xsl:choose>
        <xsl:when test="attribute::n">
         <sup>
          <xsl:value-of select="attribute::n"/>
          <xsl:if test="ancestor::TEI[@xml:id = 'med.00152']">) </xsl:if>
         </sup>
        </xsl:when>
        <xsl:otherwise>
         <xsl:text>*</xsl:text>
         <xsl:if test="ancestor::TEI[@xml:id = 'med.00152']">) </xsl:if>
        </xsl:otherwise>
       </xsl:choose>
       <xsl:apply-templates/>
      </p>
     </xsl:when>
     <xsl:when test="child::p">
      <div class="translations-footnote">
       <br/>
       <br/>
       <xsl:choose>
        <xsl:when test="attribute::n">
         <sup>
          <xsl:value-of select="attribute::n"/>
          <xsl:if test="ancestor::TEI[@xml:id = 'med.00152']">) </xsl:if>
         </sup>
        </xsl:when>
        <xsl:otherwise>
         <xsl:text>*</xsl:text>
         <xsl:if test="ancestor::TEI[@xml:id = 'med.00152']">) </xsl:if>
        </xsl:otherwise>
       </xsl:choose>
       <xsl:for-each select="child::p">
        <span>
         <xsl:apply-templates/>
        </span>
        <br/>
        <br/>
       </xsl:for-each>
      </div>
     </xsl:when>
     <xsl:otherwise>
      <p class="translations-footnote">
       <xsl:choose>
        <xsl:when test="attribute::n">
         <sup>
          <xsl:value-of select="attribute::n"/>
          <xsl:if test="ancestor::TEI[@xml:id = 'med.00152']">) </xsl:if>
         </sup>
        </xsl:when>
        <xsl:otherwise>
         <xsl:text>*</xsl:text>
         <xsl:if test="ancestor::TEI[@xml:id = 'med.00152']">) </xsl:if>
        </xsl:otherwise>
       </xsl:choose>
       <xsl:apply-templates/>
      </p>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:when>

  </xsl:choose>
 </xsl:template>
 <!-- end notes -->

 <!-- begin ref -->
 <xsl:template match="//body//ref">
  <span>
   <sup>
    <xsl:value-of select="."/>
   </sup>
  </span>
 </xsl:template>

 <!-- end ref -->
 <!-- END: REFS AND NOTES -->


 <!-- BEGIN: BIBLIOGRAPHIC INFORMATION -->
 <xsl:template match="body//bibl">
  <span>
   <xsl:apply-templates/>
  </span>
 </xsl:template>

 <xsl:template match="front//bibl">
  <span>
   <xsl:apply-templates/>
  </span>
 </xsl:template>

 <xsl:template match="back//bibl/publisher">
  <p>
   <xsl:apply-templates/>
  </p>
 </xsl:template>

 <xsl:template match="back//bibl/pubPlace">
  <p>
   <xsl:apply-templates/>
  </p>
 </xsl:template>
 <!-- END: BIBLIOGRAPHIC INFORMATION -->


 <!-- BEGIN: CLOSER -->
 <xsl:template match="//closer">
  <p>
   <xsl:apply-templates/>
  </p>
 </xsl:template>
 <!-- END: CLOSER -->


 <!-- BEGIN: OTHER FORMATTING -->
 <xsl:template match="//lb">
  <xsl:choose>
   <xsl:when test="ancestor::front">
    <br/>
   </xsl:when>
   <xsl:otherwise>
    <span>
     <br/>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    </span>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="hi[@rend = 'bold']">
  <strong>
   <xsl:value-of select="."/>
  </strong>
 </xsl:template>

 <xsl:template match="hi[@rend = 'italic']">
  <em>
   <xsl:apply-templates/>
  </em>
 </xsl:template>

 <xsl:template match="hi[@rend = 'smallcaps']">
  <span class="smalltext">
   <xsl:apply-templates/>
  </span>
 </xsl:template>

 <xsl:template match="hi[@rend = 'superscript']">
  <span>
   <sup>
    <xsl:apply-templates/>
   </sup>
  </span>
 </xsl:template>
 <!-- END: OTHER FORMATTING -->


 <!-- BEGIN: HORIZONTAL BARS -->
 <xsl:template match="milestone[@rend = 'horbar-short-center']">
  <xsl:choose>
   <xsl:when test="ancestor::back">
    <br/>
    <br/>
    <div class="teiFigure">&#8212;&#8212;&#8212;&#8212;&#8212;</div>
    <br/>
   </xsl:when>
   <xsl:when test="ancestor::front">
    <xsl:choose>
     <xsl:when test="parent::docTitle">
      <br/>
      <div class="teiFigure">&#8212;&#8212;&#8212;&#8212;&#8212;</div>
      <br/>
     </xsl:when>
     <xsl:otherwise>
      <br/>
      <br/>
      <div class="teiFigure">&#8212;&#8212;&#8212;&#8212;&#8212;</div>
      <br/>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:when>
   <xsl:when test="preceding-sibling::lg[@type = 'poem']">
    <br/>
    <div class="teiFigure">&#8212;&#8212;&#8212;&#8212;&#8212;</div>
    <br/>
   </xsl:when>
   <xsl:otherwise>
    <br/>
    <br/>
    <div class="teiFigure">&#8212;&#8212;&#8212;&#8212;&#8212;</div>
    <br/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="milestone[@rend = 'horbar-full-center'] | milestone[@rend = 'horbar-full']">
  <br/>
  <!--<div class="teiFigure"
   >&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;</div>-->
  <hr/>
  <br/>
  <br/>
 </xsl:template>

 <xsl:template match="milestone[@rend = 'horbar-short-left']">
  <div>&#8212;&#8212;&#8212;&#8212;&#8212;</div>
  <br/>
  <br/>
 </xsl:template>
 <!-- END: HORIZONTAL BARS -->

 <!--FW-->
 <xsl:template match="fw">
  <xsl:choose>
   <xsl:when test="following-sibling::*[position() = 1][name() = 'fw']">
    <span class="tei_fw">
     <xsl:text> </xsl:text>
     <xsl:apply-templates/>
    </span>
   </xsl:when>
    <xsl:when test="not(following-sibling::*[position() = 1][name() = 'fw']) and not(preceding-sibling::*[position() = 1][name() = 'fw'])">
      <span class="tei_fw_preface">
        <xsl:apply-templates/>
      </span>
    </xsl:when>
   <xsl:otherwise>
    <span class="tei_fw">
     <xsl:apply-templates/>
    </span>
    <br/>
    <br/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template name="rdg_builder">



  <span>
   <xsl:attribute name="class">
    <xsl:text>tei_rdg</xsl:text>
    <xsl:choose>
     <xsl:when test=".[contains(@wit, 'UI_01')]">
      <xsl:text>variorum_version</xsl:text>
     </xsl:when>
     <xsl:otherwise>
      <xsl:text>hidden_later</xsl:text>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:attribute>
   <xsl:if test=".[contains(@wit, 'UI_01')]">(This Copy)<xsl:text> </xsl:text></xsl:if>
   <xsl:apply-templates/>
   <xsl:if test="normalize-space(.) = ''">[Blank]</xsl:if>
  </span>
  <span class="tei_rdg_wit">
   <xsl:for-each select="tokenize(@wit, ' ')">
    <xsl:value-of select="."/>
    <xsl:text> </xsl:text>
   </xsl:for-each>
  </span>



 </xsl:template>

 <xsl:template match="app">
  <xsl:apply-templates select="rdg[contains(@wit, 'UI_01')]" mode="inline"/>
  <div class="tei_app hide">
   <xsl:attribute name="class">
    <xsl:text>tei_app hide </xsl:text>
    <!-- create class based on rdg xml:id -->
    <xsl:text>var_</xsl:text>
    <xsl:value-of select="replace(rdg[1]/@xml:id, '[^0-9]', '')"/>
   </xsl:attribute>
   <!-- select the rdg from this doc first -->
   <xsl:for-each select="rdg[contains(@wit, 'UI_01')]">
    <xsl:call-template name="rdg_builder"/>
   </xsl:for-each>
   <!-- now iterate throught he rest of the rdg's -->
   <xsl:for-each select="rdg[not(contains(@wit, 'UI_01'))]">
    <xsl:call-template name="rdg_builder"/>
   </xsl:for-each>
  </div>
 </xsl:template>

 <xsl:template match="rdg" mode="inline">
  <span>
   <xsl:attribute name="class">
    <xsl:text>inline_tei_rdg</xsl:text>
   </xsl:attribute>
   <!-- create data-target based on rdg xml:id -->
   <xsl:attribute name="data-target">
    <xsl:text>var_</xsl:text>
    <xsl:value-of select="replace(@xml:id, '[^0-9]', '')"/>
   </xsl:attribute>
   <xsl:apply-templates/>
   <xsl:if test="normalize-space(.) = ''">[Blank]</xsl:if>
  </span>
 </xsl:template>
  
  <xsl:template match="div1[@type = 'review']">
    <div class="tei_div1_type_review">
      <br/>
      <br/>
      <xsl:apply-templates/>
      <br/>
    </div>
  </xsl:template>
  
  <!-- ====================================================================== -->
  <!-- CRITICAL APPARATUS                                                     -->
  <!-- ====================================================================== -->
  
  <xsl:template match="choice" mode="mss">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="orig" mode="mss">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="reg" mode="mss"> </xsl:template>
  
  <xsl:template match="abbr" mode="mss">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="expan" mode="mss"> </xsl:template>
  
  <xsl:template match="sic" mode="mss">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="corr" mode="mss"> </xsl:template>
  
  <!-- ====================================================================== -->
  <!-- ADDITION & DELETION                                                    -->
  <!-- ====================================================================== -->
  
  <xsl:template match="del" mode="mss">
    <xsl:if test="@rend = 'overstrike'">
      <xsl:choose>
        <xsl:when test="descendant::l/seg">
          <xsl:apply-templates/>
        </xsl:when>
        <!--Added this as temporary measure to remove two of three overstrike classes being applied here, but we will need to streamline the deletion treatment(s) at some point, nhg 1/25/17-->
        <xsl:when test="descendant::add[@place = 'interlinear']">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <span class="overstrike">
            <xsl:apply-templates/>
          </span>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <!--<xsl:if test="ancestor::*[@rend = 'overstrike']"><span class="overstrike"><xsl:apply-templates/></span></xsl:if>-->
    <xsl:if test="@rend = 'overwrite'">
      <span class="teiOverwrite">
        <xsl:apply-templates/>
      </span>
    </xsl:if>
    <xsl:if test="@rend = 'hashmark'">
      <span class="overstrike">
        <xsl:apply-templates/>
      </span>
    </xsl:if>
    <xsl:if test="@rend = 'erasure'">
      <span class="erasure">
        <xsl:apply-templates/>
      </span>
    </xsl:if>
    <!--</xsl:otherwise>-->
    <!--</xsl:choose>-->
  </xsl:template>
  
  <xsl:template match="del[@rend = 'overstrike']/add">
    <xsl:if test="@rend = 'insertion'">
      <sub>^</sub>
    </xsl:if>
    <xsl:if test="@rend = 'lasso'">
      <sub>^</sub>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@place = 'supralinear'">
        <xsl:text disable-output-escaping="yes">&lt;/span> &lt;span class="supralinear overstrike"></xsl:text>
        <xsl:apply-templates/>
        <xsl:text disable-output-escaping="yes">&lt;/span> &lt;span class="overstrike"></xsl:text>
      </xsl:when>
      <xsl:when test="@place = 'interlinear'">
        <xsl:text disable-output-escaping="yes">&lt;/span> &lt;span class="interlinear overstrike"></xsl:text>
        <xsl:apply-templates/>
        <xsl:text disable-output-escaping="yes">&lt;/span> &lt;span class="overstrike"></xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="add/del">
    <xsl:if test="@rend = 'overstrike'">
      <span class="overstrike">
        <xsl:apply-templates/>
      </span>
    </xsl:if>
    <xsl:if test="@rend = 'overwrite'">
      <span class="teiOverwrite">
        <xsl:apply-templates/>
      </span>
    </xsl:if>
    <xsl:if test="@rend = 'erasure'">
      <span class="erasure">
        <xsl:apply-templates/>
      </span>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="add" mode="mss">
    <xsl:if test="@rend = 'insertion'">
      <sub>^</sub>
    </xsl:if>
    <xsl:if test="@rend = 'lasso'">
      <sub>^</sub>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@place = 'inline'">
        <span class="inline">
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:when test="@place = 'supralinear'">
        <span class="supralinear">
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:when test="@place = 'interlinear'">
        <span class="interlinear">
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:when test="@place = 'infralinear'">
        <span class="infralinear">
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:when test="@place = 'over'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- ====================================================================== -->
  <!-- OTHER TRANSCRIPTION ELEMENTS                                           -->
  <!-- ====================================================================== -->
  
  <xsl:template match="hi[@rend = 'underline']" mode="mss">
    <span class="underline">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <xsl:template match="gap" mode="mss">
    <span class="unclear">
      <xsl:choose>
        <xsl:when test="@reason = 'cut away'">
          <xsl:text>[cut away]</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>[illegible]</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>
  
  <xsl:template match="supplied" mode="mss">[<span class="supplied"
    ><xsl:apply-templates/></span>]</xsl:template>
  
  <xsl:template match="unclear" mode="mss">
    <span class="unclear">[<xsl:apply-templates/>?]</span>
  </xsl:template>
  
  <!--/MSS styling-->

</xsl:stylesheet>
