<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xpath-default-namespace="http://www.whitmanarchive.org/namespace">

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
    <xsl:if test="contains(@facs, 'loc')">The Charles E. Feinberg Collection of the Papers of Walt
      Whitman, 1839&#8211;1919, Library of Congress, Washington, D.C.</xsl:if>
    <xsl:if test="contains(@facs, 'ppp')">University of Iowa Special Collections and University
      Archives</xsl:if>
    <xsl:if test="contains(@facs, 'uva')">Papers of Walt Whitman (MSS 3829), Clifton Waller Barrett
      Library of American Literature, Albert H. Small Special Collections Library, University of
      Virginia</xsl:if>
    <xsl:if test="contains(@facs, 'wil')">Williams College</xsl:if>
    <xsl:if test="contains(@facs, 'duk')">Trent Collection of Whitmaniana, David M. Rubenstein Rare
      Book &amp; Manuscript Library, Duke University</xsl:if>
    <xsl:if test="contains(@facs, 'pra')">Providence Athan&#230;um</xsl:if>
    <xsl:if test="contains(@facs, 'unc')">Rare Book Collection, Wilson Special Collections Library, UNC-Chapel Hill</xsl:if>
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
      <xsl:when test="$work_id = 'xxx.00113'">[Untitled]</xsl:when>
      <xsl:when test="$work_id = 'xxx.00144'">[Untitled]</xsl:when>
      <xsl:when test="$work_id = 'xxx.00143'">[Untitled]</xsl:when>
      <xsl:when test="$work_id = 'xxx.00226'">[Untitled]</xsl:when>
      <xsl:when test="$work_id = 'xxx.00250'">[Untitled]</xsl:when>
      <xsl:when test="$work_id = 'xxx.00121'">[Untitled]</xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
