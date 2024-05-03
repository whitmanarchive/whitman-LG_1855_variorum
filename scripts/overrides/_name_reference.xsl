<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0">

  <xsl:template name="poem_by_id">
    <xsl:param name="work_id"/>
    <xsl:choose>
      <xsl:when test="$work_id = 'xxx.00048'">"Song of Myself"</xsl:when>
      <xsl:when test="$work_id = 'xxx.00119'">"A Song for Occupations"</xsl:when>
      <xsl:when test="$work_id = 'xxx.00266'">"To Think of Time"</xsl:when>
      <xsl:when test="$work_id = 'xxx.00264'">"The Sleepers"</xsl:when>
      <xsl:when test="$work_id = 'xxx.00052'">"I Sing the Body Electric"</xsl:when>
      <xsl:when test="$work_id = 'xxx.00271'">"Faces"</xsl:when>
      <xsl:when test="$work_id = 'xxx.00113'">"Song of the Answerer"</xsl:when>
      <xsl:when test="$work_id = 'xxx.00144'">"Europe, the 72d and 73d Years of These
        States"</xsl:when>
      <xsl:when test="$work_id = 'xxx.00143'">"A Boston Ballad"</xsl:when>
      <xsl:when test="$work_id = 'xxx.00226'">"There Was a Child Went Forth"</xsl:when>
      <xsl:when test="$work_id = 'xxx.00250'">"Who Learns My Lesson Complete"</xsl:when>
      <xsl:when test="$work_id = 'xxx.00121'">"Youth, Day, Old Age, and Night"</xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="repository_citation">
    <xsl:if test="contains(@facs, 'loc_nhg.01030') or contains(@facs, 'loc_nhg.01021') or contains(@facs, 'loc_nhg.01400') or contains(@facs, 'loc_nhg.01010') or contains(@facs, 'loc_nhg.01002')">Charles E. Feinberg Collection of Walt Whitman, Library of Congress, Washington, D.C.</xsl:if>
    <xsl:if test="contains(@facs, 'loc_nhg.01207') or contains(@facs, 'loc_nhg.01247') or contains(@facs, 'loc_nhg.01249') or contains(@facs, 'loc_nhg.01251') or contains(@facs, 'loc_nhg.01258') or contains(@facs, 'loc_nhg.01210')">Carolyn Wells Houghton Whitman Collection, Library of Congress, Washington, D.C.</xsl:if>
    <xsl:if test="contains(@facs, 'ppp')">Special Collections, The University of Iowa Libraries</xsl:if>
    <xsl:if test="contains(@facs, 'uva_nhg.00011') or contains(@facs, 'uva_nhg.00009') or contains(@facs, 'uva_nhg.00004') or contains(@facs, 'uva_nhg.00005') or contains(@facs, 'uva_nhg.00012') or contains(@facs, 'uva_nhg.00010')">Clifton Waller Barrett Library of American Literature, Albert and Shirley Small Special Collections Library, University of Virginia</xsl:if>
    <xsl:if test="contains(@facs, 'uva_nhg.00026') or contains(@facs, 'uva_nhg.00029') or contains(@facs, 'uva_nhg.00030') or contains(@facs, 'uva_nhg.00024') or contains(@facs, 'uva_nhg.00036') or contains(@facs, 'uva_nhg.00037') or contains(@facs, 'uva_nhg.00027') or contains(@facs, 'uva_nhg.00028')">Tracy W. McGregor Library of American History, Albert and Shirley Small Special Collections Library, University of Virginia</xsl:if>
    <xsl:if test="contains(@facs, 'wil')">Chapin Library, Williams College</xsl:if>
    <xsl:if test="contains(@facs, 'duk')">David M. Rubenstein Rare Book &amp; Manuscript Library, Duke University</xsl:if>
    <xsl:if test="contains(@facs, 'pra')">Providence Athen&#230;um</xsl:if>
    <xsl:if test="contains(@facs, 'unc')">Rare Book Collection, The Louis Round Wilson Special Collections Library, University of North Carolina at Chapel Hill</xsl:if>
    <xsl:if test="contains(@facs, 'yal')">Yale Collection of American Literature, Beinecke Rare Book and Manuscript Library</xsl:if>
    <xsl:if test="contains(@facs, 'pri')">Department of Rare Books and Special Collections, Princeton University Library</xsl:if>
  </xsl:template>

  <xsl:template name="title_by_id">
    <xsl:param name="work_id"/>
    <xsl:choose>
      <xsl:when test="$work_id = 'xxx.00048'">"Leaves of Grass" [1]</xsl:when>
      <xsl:when test="$work_id = 'xxx.00119'">"Leaves of Grass" [2]</xsl:when>
      <xsl:when test="$work_id = 'xxx.00266'">"Leaves of Grass" [3]</xsl:when>
      <xsl:when test="$work_id = 'xxx.00264'">"Leaves of Grass" [4]</xsl:when>
      <xsl:when test="$work_id = 'xxx.00052'">"Leaves of Grass" [5]</xsl:when>
      <xsl:when test="$work_id = 'xxx.00271'">"Leaves of Grass" [6]</xsl:when>
      <xsl:when test="$work_id = 'xxx.00113'">[Untitled] [1]</xsl:when>
      <xsl:when test="$work_id = 'xxx.00144'">[Untitled] [2]</xsl:when>
      <xsl:when test="$work_id = 'xxx.00143'">[Untitled] [3]</xsl:when>
      <xsl:when test="$work_id = 'xxx.00226'">[Untitled] [4]</xsl:when>
      <xsl:when test="$work_id = 'xxx.00250'">[Untitled] [5]</xsl:when>
      <xsl:when test="$work_id = 'xxx.00121'">[Untitled] [6]</xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
