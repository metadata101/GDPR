<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                  xmlns:gco="http://www.isotc211.org/2005/gco"
                  xmlns:gmd="http://www.isotc211.org/2005/gmd"
                  xmlns:gdpr="https://metadata101.github.io/GDPR"
                  exclude-result-prefixes="#all">

  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/root">
    <xsl:apply-templates select="gmd:*"/>
  </xsl:template>

  <!-- Add gco:Boolean to gmd:pass with nilReason to work nicely in the editor,
      update-fixed-info.xsl should removed if empty to avoid xsd errors  -->
  <xsl:template match="gmd:pass[@gco:nilReason and not(gco:Boolean)]">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <gco:Boolean></gco:Boolean>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gdpr:hasSecurity[@gco:nilReason and not(gco:Boolean)]">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <gco:Boolean></gco:Boolean>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gdpr:transmitPrivateNetwork[@gco:nilReason and not(gco:Boolean)]">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <gco:Boolean></gco:Boolean>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gdpr:transmitPublicNetwork[@gco:nilReason and not(gco:Boolean)]">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <gco:Boolean></gco:Boolean>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gdpr:encryptedTransmit[@gco:nilReason and not(gco:Boolean)]">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <gco:Boolean></gco:Boolean>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gdpr:encryptedStorage[@gco:nilReason and not(gco:Boolean)]">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <gco:Boolean></gco:Boolean>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gdpr:pseudonimization[@gco:nilReason and not(gco:Boolean)]">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <gco:Boolean></gco:Boolean>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gdpr:inControl[@gco:nilReason and not(gco:Boolean)]">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <gco:Boolean></gco:Boolean>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gdpr:requiresPIA[@gco:nilReason and not(gco:Boolean)]">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <gco:Boolean></gco:Boolean>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gdpr:outsideEU[@gco:nilReason and not(gco:Boolean)]">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <gco:Boolean></gco:Boolean>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gdpr:appropriateProtectionLevel[@gco:nilReason and not(gco:Boolean)]">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <gco:Boolean></gco:Boolean>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gdpr:hasAutomaticDecisionMaking[@gco:nilReason and not(gco:Boolean)]">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <gco:Boolean></gco:Boolean>
    </xsl:copy>
  </xsl:template>

  <!-- Do a copy of every nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
