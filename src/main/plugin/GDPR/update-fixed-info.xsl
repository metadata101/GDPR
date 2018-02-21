<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0" xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:gmd="http://www.isotc211.org/2005/gmd"   exclude-result-prefixes="#all">
	<xsl:import href="../iso19139/update-fixed-info.xsl" />

	<!-- Dutch profile uses gco:Date instead of gco:DateTime -->
	<xsl:template match="gmd:dateStamp" priority="99">
		<xsl:choose>
			<xsl:when test="/root/env/changeDate">
				<xsl:copy copy-namespaces="no">
					<gco:Date>
						 <xsl:value-of select="tokenize(/root/env/changeDate,'T')[1]" />
					</gco:Date>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."  copy-namespaces="no"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- remove gmd:identifier with gmx:Anchor inside gmd:code
    <xsl:template match="gmd:identifier[name(*/gmd:code/*) = 'gmx:Anchor']" />-->
    <!-- remove gmd:identifier in gmd:thesaurusName with gmx:Anchor inside gmd:code -->
    <!--<xsl:template match="gmd:thesaurusName/*/gmd:identifier[name(*/gmd:code/*) = 'gmx:Anchor']" />-->

    <!-- remove http://www.fao.org/geonetwork namespace
    <xsl:template match="*">
        <xsl:element name="{name()}">
            <xsl:copy-of select="namespace::*[not(. = 'http://www.fao.org/geonetwork')]"/>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*[@xmlns:gn='http://www.fao.org/geonetwork']/@xmlns:gn|@xmlns:geonet='http://www.fao.org/geonetwork']/@xmlns:geonet" /> -->

</xsl:stylesheet>
