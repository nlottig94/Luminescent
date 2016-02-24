<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

  <xsl:param name="invocation" select="''"/>
  
  <xsl:template match="/">
    <xsl:comment>
      <xsl:text>File generated by </xsl:text>
      <xsl:value-of select="system-property('xsl:vendor')"/>
      <xsl:text>, XSLT </xsl:text>
      <xsl:value-of select="system-property('xsl:version')"/>
    </xsl:comment>
    
    <html>
      <head>
        <title>UTF8 testing</title>
      </head>
      <body>
      <p>If all the links work properly, then UTF-8 is being passed successfully
        back and forth.</p>
       <xsl:variable name="deity" select="//figure[(name|name/@*) = $invocation]"/>
        <xsl:apply-templates select="$deity"/>
        <xsl:if test="not($invocation)">
          <h2>Sorry, please summon a deity</h2>
        </xsl:if>
        <xsl:if test="$invocation and not($deity)">
          <h2>Sorry, we have no deity by that name (<xsl:value-of select="$invocation"/>)</h2>
        </xsl:if>
        <xsl:call-template name="links"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="figure/name">
    <h2 style="color:darkred">
      <xsl:apply-templates/>
    </h2>
    <ul style="margin:0em; font-size:smaller">
      <xsl:apply-templates select="@latin,@english,@escaped"/>
    </ul>
    <p>You asked for <xsl:value-of select="string-join((('Greek')[current()=$invocation],@*[.=$invocation]/name()),', ')"/>.</p>
  </xsl:template>
  
  <xsl:template match="@*">
    <li>
      <xsl:value-of select="name()"/>
      <xsl:text>: </xsl:text>
      <xsl:value-of select="."/>
    </li>
  </xsl:template>

  <xsl:template match="figure/description">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template name="links">
    <ul>
      <xsl:apply-templates select="//figure/name" mode="link"/>
    </ul>
  </xsl:template>

  <xsl:template match="figure/name" mode="link">
    <li>
      <a href="?invocation={.}">
        <xsl:value-of select="."/>
      </a>
      <xsl:for-each select="@latin,@english,@escaped">
        <xsl:text> [</xsl:text>
        <a href="?invocation={.}">
          <xsl:value-of select="."/>
        </a>
        <xsl:text>]</xsl:text>
      </xsl:for-each>
    </li>
  </xsl:template>
  
</xsl:stylesheet>