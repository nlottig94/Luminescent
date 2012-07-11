<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  version="2.0">

  <xsl:param name="dir" select="'testing'"/>
  
  <xsl:param name="type" select="''"/>
  
  <xsl:variable name="labels" as="element()*">
    
    <!--<label key="eclix">ECLIX</label>
    <label key="clix">CLIX</label>-->
    <!--<xsl:if test="$dir='sonnets'">
      <label key="snapshot"/>
    </xsl:if>-->
    
    <label key="xLMNL" view="step1">step 1</label>
    <label key="xLMNL" view="step2">step 2</label>
    <label key="xLMNL" view="step3">step 3</label>
    <label key="xLMNL" view="step4">step 4</label>
    <label key="xLMNL" view="step5">step 5</label>
    <label key="xLMNL" view="step6">step 6</label>
    <label key="xLMNL" view="step7">step 7</label>
    <label key="xLMNL" view="step8">step 8</label>
    <label key="xLMNL" view="step9">step 9</label>
    <label key="xLMNL" view="step10">step 10</label>
    <label key="xLMNL" view="step11">step 11</label>
    <label key="xLMNL" view="step12">step 12</label>
    <label key="xLMNL">xLMNL</label>
    
    <label key="XML">XML</label>
    <label type="-analysis.html">Analysis</label>
    <conditional-label type="-graph.svg">Bubble graph</conditional-label>
    <conditional-label type="-lyric-graph.html">Lyric graph</conditional-label>
    <conditional-label type=".html">Demo HTML</conditional-label>
    <conditional-label type="-sonneteer.html">Sonnet bubbles</conditional-label>
    
    <!-- <xsl:choose>
      <xsl:when test="$type='sonnets'">
        <label key="snapshot"/>
        <!-\-<label key="xLMNL" view="structure">Structure</label>
        <label key="xLMNL" view="sentences">Sentences</label>-\->
        <!-\-<label key="xLMNL" view="barsSVG">bars (SVG)</label>-\->
        <label type="-sonnet-arcs.svg">arcs (SVG)</label>
        <label type="-map.svg">map (SVG)</label>
      </xsl:when>
      <xsl:otherwise>
        <label type="-arcs.svg">arcs (SVG)</label>
      </xsl:otherwise>
    </xsl:choose>-->

    <!--<label type=".lmnl">LMNL syntax</label>
    <label key="XMLinduce">XML induction</label>-->
    
  </xsl:variable>

  <xsl:variable name="lyrics" as="element()+">
    <basename>Easter1916</basename>
  </xsl:variable>
  
  <xsl:template match="/">
    <html>
      <body style="background-color: thistle">
        <h1>
          <!--<xsl:value-of select="$dir"/>
          <xsl:text>/*.xml</xsl:text>-->
          <xsl:text>LMNL syntax parsing: a demonstration [</xsl:text>
          <xsl:value-of select="$dir"/>
          <xsl:text>]</xsl:text>
        </h1>
        <table>
          <xsl:apply-templates select="//dir:file/@name[ends-with(.,'lmnl')]"/>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="@name">
    <xsl:variable name="file" select="normalize-space(.)"/>
    <tr style="border-top: thin solid black; border-bottom: thin solid black;">
      <td style="padding-right: 0.5em; padding-left: 0.5em; background-color: aliceblue">
        <xsl:apply-templates select="../*/meta/(@author, @title)"/>
        <p style="margin:0ex;font-family: monospace; ">
          <a href="{$dir}/{$file}">
            <xsl:value-of select="$file"/>
          </a>
          <xsl:text> [</xsl:text>
          <xsl:value-of select="(round(../@size div 100) * 100) div 1000"/>
          <xsl:text>K]</xsl:text>
        </p>
      </td>
      <xsl:apply-templates select="$labels" mode="cell">
        <xsl:with-param name="basename" select="replace($file,'\.lmnl$','')" tunnel="yes"/>
      </xsl:apply-templates>
    </tr>
  </xsl:template>
  
  <xsl:template match="*" mode="cell">
    <td style="font-family: sans-serif; font-size: 80%; font-weight: bold;
      background-color:lavender; margin: 6px; padding: 4px">
      <!--<a href="{ (: http://{$host}:8888 :) }/LMNL/{.}/{$dir}/{$file}">-->
      <xsl:apply-templates select="@key|@type" mode="menu-item"/>
    </td>
  </xsl:template>
  
  <xsl:template match="conditional-label[ends-with(@type,'graph.svg')]" mode="cell">
    <!-- only if a stylesheet customized
         for the particular instance can be found -->
    <xsl:param name="basename" tunnel="yes"/>
    <xsl:variable name="xslt" select="concat('../down/',$basename,'-graph-svg.xsl')"/>
    <xsl:if test="doc-available(resolve-uri($xslt))">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="conditional-label[.='Demo HTML']" mode="cell">
    <xsl:param name="basename" tunnel="yes"/>
    <xsl:if test="$basename='demo'">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="conditional-label[.='Lyric graph']" mode="cell">
    <xsl:param name="basename" tunnel="yes"/>
    <xsl:if test="$basename=$lyrics">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="conditional-label[ends-with(@type,'sonneteer.html')]" mode="cell">
    <xsl:if test="$dir='../sonnets'">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="@author">
    <p style="margin:0ex">
      <xsl:value-of select="."/>
    </p>
  </xsl:template>
  
  <xsl:template match="@title">
    <p style="margin:0ex; font-style:italic; font-size:90%">
      <xsl:value-of select="."/>
    </p>
  </xsl:template>
  
  <xsl:template match="@key" mode="menu-item">
    <xsl:param name="basename" tunnel="yes"/>
    <xsl:variable name="file" select="concat($basename,'.xml')"/>
    <xsl:variable name="href" select="
      concat(
      string-join(($dir,.,$file),'/'),
      for $v in (../@view) return concat('?cocoon-view=',$v))"/>
    <p style="margin:0ex">
      <a href="{$href}">
        <xsl:value-of select=".."/>
      </a>
    </p>
  </xsl:template>
  
  <xsl:template match="@key[.='snapshot']" mode="menu-item">
    <xsl:param name="basename" tunnel="yes"/>
    <img src="{$basename}-snapshot.png"/>
  </xsl:template>
  
  <xsl:template match="@key[.='XML']" mode="menu-item">
    <xsl:param name="basename" tunnel="yes"/>
    <xsl:variable name="file" select="concat($basename,'.xml')"/>
    <xsl:variable name="basename" select="replace($file,'\.xml$','')"/>
    <p style="margin:0ex">
      <a href="{$dir}/{$basename}.xml">
        <xsl:value-of select=".."/>
      </a>
    </p>
    
    <!--<xsl:if test="$type='sonnets'">
      <ul style="margin:0ex">
        <li>
          <a href="{$dir}/XMLinduce/{$basename}-structure.xml">Structure</a>
        </li>
        <li>
          <a href="{$dir}/XMLinduce/{$basename}-phrasing.xml">Phrasing</a>
        </li>
      </ul>
    </xsl:if>-->
  </xsl:template>
  
  <xsl:template match="@type" mode="menu-item">
    <xsl:param name="basename" tunnel="yes"/>
    <xsl:variable name="file" select="concat($basename,'.xml')"/>
    <xsl:variable name="basename" select="replace($file,'\.xml$','')"/>
    <!--<xsl:variable name="href" select="
      concat(
      string-join(($dir,.,$file),'/'),
      for $v in (../@view) return concat('?cocoon-view=',$v))"/>-->
    <p style="margin:0ex">
      <a href="{$dir}/{$basename}{.}">
        <xsl:value-of select=".."/>
      </a>
    </p>
    <!--<xsl:if test=".='XMLinduce'">
      <ul style="margin:0ex">
      <li><a href="{$href}?stack=sonnet octave sestet quatrain tercet couplet line">Structure</a></li>
      <li><a href="{$href}?stack=s phr">Phrasing</a></li>
      </ul>
      </xsl:if>-->
  </xsl:template>
  
  <!--
  <xsl:template match="@key[.='snapshot']" mode="menu-item">
    <xsl:param name="basename" tunnel="yes"/>
    <xsl:variable name="file" select="concat($basename,'.xml')"/>
    <img src="{$dir}/{replace($file,'\.xml$','')}-snapshot.png"/>
  </xsl:template>
  -->
  


</xsl:stylesheet>
