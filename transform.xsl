<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:key name="kPersonById" match="people/person" use="@id"/>

  <xsl:param name="personId" select="''"/>
  <xsl:param name="nth" select="1"/>

  <xsl:template match="people/person" mode="display-name">
    <xsl:value-of select="concat(normalize-space(firstName), ' ', normalize-space(familyName))"/>
  </xsl:template>

  <xsl:template name="person-block">
    <xsl:param name="p"/>
    <xsl:param name="title"/>

    <xsl:variable name="fatherP" select="key('kPersonById', $p/@father)"/>
    <xsl:variable name="motherP" select="key('kPersonById', $p/@mother)"/>

    <xsl:variable name="brothers"   select="key('kPersonById', $p/brothers/brother)"/>
    <xsl:variable name="sisters"    select="key('kPersonById', $p/sisters/sister)"/>
    <xsl:variable name="sons"       select="key('kPersonById', $p/sons/son)"/>
    <xsl:variable name="daughters"  select="key('kPersonById', $p/daughters/daughter)"/>

    <xsl:variable name="grandFathers" select="key('kPersonById', $fatherP/@father) | key('kPersonById', $motherP/@father)"/>
    <xsl:variable name="grandMothers" select="key('kPersonById', $fatherP/@mother) | key('kPersonById', $motherP/@mother)"/>

    <xsl:variable name="uncles" select="key('kPersonById', $fatherP/brothers/brother) | key('kPersonById', $motherP/brothers/brother)"/>
    <xsl:variable name="aunts"  select="key('kPersonById', $fatherP/sisters/sister)  | key('kPersonById', $motherP/sisters/sister)"/>

    <section>
      <h2><xsl:value-of select="$title"/></h2>
      <p><strong>Name:</strong> <xsl:apply-templates select="$p" mode="display-name"/> (<xsl:value-of select="$p/gender"/>)</p>

      <p><strong>Father:</strong> <xsl:apply-templates select="$fatherP" mode="display-name"/></p>
      <p><strong>Mother:</strong> <xsl:apply-templates select="$motherP" mode="display-name"/></p>

      <p><strong>Brothers:</strong>
        <xsl:for-each select="$brothers">
          <xsl:if test="position() > 1">, </xsl:if>
          <xsl:apply-templates select="." mode="display-name"/>
        </xsl:for-each>
        <xsl:if test="count($brothers) = 0">—</xsl:if>
      </p>
      <p><strong>Sisters:</strong>
        <xsl:for-each select="$sisters">
          <xsl:if test="position() > 1">, </xsl:if>
          <xsl:apply-templates select="." mode="display-name"/>
        </xsl:for-each>
        <xsl:if test="count($sisters) = 0">—</xsl:if>
      </p>

      <p><strong>Sons:</strong>
        <xsl:for-each select="$sons">
          <xsl:if test="position() > 1">, </xsl:if>
          <xsl:apply-templates select="." mode="display-name"/>
        </xsl:for-each>
        <xsl:if test="count($sons) = 0">—</xsl:if>
      </p>
      <p><strong>Daughters:</strong>
        <xsl:for-each select="$daughters">
          <xsl:if test="position() > 1">, </xsl:if>
          <xsl:apply-templates select="." mode="display-name"/>
        </xsl:for-each>
        <xsl:if test="count($daughters) = 0">—</xsl:if>
      </p>

      <p><strong>Grandfathers:</strong>
        <xsl:for-each select="$grandFathers">
          <xsl:if test="position() > 1">, </xsl:if>
          <xsl:apply-templates select="." mode="display-name"/>
        </xsl:for-each>
        <xsl:if test="count($grandFathers) = 0">—</xsl:if>
      </p>
      <p><strong>Grandmothers:</strong>
        <xsl:for-each select="$grandMothers">
          <xsl:if test="position() > 1">, </xsl:if>
          <xsl:apply-templates select="." mode="display-name"/>
        </xsl:for-each>
        <xsl:if test="count($grandMothers) = 0">—</xsl:if>
      </p>

      <p><strong>Uncles:</strong>
        <xsl:for-each select="$uncles">
          <xsl:if test="position() > 1">, </xsl:if>
          <xsl:apply-templates select="." mode="display-name"/>
        </xsl:for-each>
        <xsl:if test="count($uncles) = 0">—</xsl:if>
      </p>
      <p><strong>Aunts:</strong>
        <xsl:for-each select="$aunts">
          <xsl:if test="position() > 1">, </xsl:if>
          <xsl:apply-templates select="." mode="display-name"/>
        </xsl:for-each>
        <xsl:if test="count($aunts) = 0">—</xsl:if>
      </p>
    </section>
  </xsl:template>

  <xsl:template match="/">
    <html>
      <head>
        <meta charset="UTF-8"/>
        <title>Family Report</title>
        <style>
          body{font-family:system-ui,sans-serif;margin:2rem;}
          section{border:1px solid #ddd;padding:1rem;margin:1rem 0;border-radius:8px;}
          strong{display:inline-block;width:10rem;}
        </style>
      </head>
      <body>
        <h1>Family Report</h1>

        <xsl:variable name="candidate"
          select="/people/person[
            (@mother or @father) and
            ((count(brothers/brother) + count(sisters/sister)) &gt; 0) and
            (
              (@mother and (boolean(key('kPersonById', @mother)/@mother) or boolean(key('kPersonById', @mother)/@father))) or
              (@father and (boolean(key('kPersonById', @father)/@mother) or boolean(key('kPersonById', @father)/@father)))
            )
          ][$nth]"/>

        <xsl:choose>
          <xsl:when test="$candidate">
            <xsl:variable name="fatherNodes" select="key('kPersonById', $candidate/@father)"/>
            <xsl:variable name="motherNodes" select="key('kPersonById', $candidate/@mother)"/>
            <xsl:variable name="brotherNodes" select="key('kPersonById', $candidate/brothers/brother)"/>
            <xsl:variable name="sisterNodes" select="key('kPersonById', $candidate/sisters/sister)"/>
            <xsl:variable name="husbandNodes" select="key('kPersonById', $candidate/@husband)"/>
            <xsl:variable name="wifeNodes" select="key('kPersonById', $candidate/@wife)"/>
            <xsl:variable name="sonNodes" select="key('kPersonById', $candidate/sons/son)"/>
            <xsl:variable name="daughterNodes" select="key('kPersonById', $candidate/daughters/daughter)"/>
            <xsl:variable name="grandFatherNodes"
              select="key('kPersonById', $fatherNodes/@father) | key('kPersonById', $motherNodes/@father)"/>
            <xsl:variable name="grandMotherNodes"
              select="key('kPersonById', $fatherNodes/@mother) | key('kPersonById', $motherNodes/@mother)"/>
            <xsl:variable name="uncleNodes"
              select="key('kPersonById', $fatherNodes/brothers/brother) | key('kPersonById', $motherNodes/brothers/brother)"/>
            <xsl:variable name="auntNodes"
              select="key('kPersonById', $fatherNodes/sisters/sister) | key('kPersonById', $motherNodes/sisters/sister)"/>

            <xsl:call-template name="person-block">
              <xsl:with-param name="p" select="$candidate"/>
              <xsl:with-param name="title" select="'Subject'"/>
            </xsl:call-template>

            <xsl:for-each select="$fatherNodes">
              <xsl:call-template name="person-block">
                <xsl:with-param name="p" select="."/>
                <xsl:with-param name="title" select="'Father'"/>
              </xsl:call-template>
            </xsl:for-each>

            <xsl:for-each select="$motherNodes">
              <xsl:call-template name="person-block">
                <xsl:with-param name="p" select="."/>
                <xsl:with-param name="title" select="'Mother'"/>
              </xsl:call-template>
            </xsl:for-each>

            <xsl:for-each select="$brotherNodes">
              <xsl:call-template name="person-block">
                <xsl:with-param name="p" select="."/>
                <xsl:with-param name="title" select="'Brother'"/>
              </xsl:call-template>
            </xsl:for-each>

            <xsl:for-each select="$sisterNodes">
              <xsl:call-template name="person-block">
                <xsl:with-param name="p" select="."/>
                <xsl:with-param name="title" select="'Sister'"/>
              </xsl:call-template>
            </xsl:for-each>

            <xsl:for-each select="$husbandNodes">
              <xsl:call-template name="person-block">
                <xsl:with-param name="p" select="."/>
                <xsl:with-param name="title" select="'Husband'"/>
              </xsl:call-template>
            </xsl:for-each>

            <xsl:for-each select="$wifeNodes">
              <xsl:call-template name="person-block">
                <xsl:with-param name="p" select="."/>
                <xsl:with-param name="title" select="'Wife'"/>
              </xsl:call-template>
            </xsl:for-each>

            <xsl:for-each select="$sonNodes">
              <xsl:call-template name="person-block">
                <xsl:with-param name="p" select="."/>
                <xsl:with-param name="title" select="'Son'"/>
              </xsl:call-template>
            </xsl:for-each>

            <xsl:for-each select="$daughterNodes">
              <xsl:call-template name="person-block">
                <xsl:with-param name="p" select="."/>
                <xsl:with-param name="title" select="'Daughter'"/>
              </xsl:call-template>
            </xsl:for-each>

            <xsl:for-each select="$grandFatherNodes">
              <xsl:call-template name="person-block">
                <xsl:with-param name="p" select="."/>
                <xsl:with-param name="title" select="'Grandfather'"/>
              </xsl:call-template>
            </xsl:for-each>

            <xsl:for-each select="$grandMotherNodes">
              <xsl:call-template name="person-block">
                <xsl:with-param name="p" select="."/>
                <xsl:with-param name="title" select="'Grandmother'"/>
              </xsl:call-template>
            </xsl:for-each>

            <xsl:for-each select="$uncleNodes">
              <xsl:call-template name="person-block">
                <xsl:with-param name="p" select="."/>
                <xsl:with-param name="title" select="'Uncle'"/>
              </xsl:call-template>
            </xsl:for-each>

            <xsl:for-each select="$auntNodes">
              <xsl:call-template name="person-block">
                <xsl:with-param name="p" select="."/>
                <xsl:with-param name="title" select="'Aunt'"/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <p>No person with parents, siblings and at least one grandparent found.</p>
          </xsl:otherwise>
        </xsl:choose>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
