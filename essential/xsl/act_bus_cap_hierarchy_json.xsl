<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/ev3_docType.xsl" />
	<xsl:include href="../common/ev3_common_head_content.xsl" />
	<xsl:include href="../common/ev3_header.xsl" />
	<xsl:include href="../common/ev3_footer.xsl" />
	
	
	<xsl:output method="html" />
	<xsl:variable name="hideEmpty">false</xsl:variable>

	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>
	<xsl:param name="reposXML" />
	<!-- END GENERIC CATALOGUE PARAMETERS -->
	
	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name=$targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability')"/>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->
	
	<!-- Get all of the Application Caps in the repository -->
	<xsl:variable name="allBusCaps" select="/node()/simple_instance[type='Business_Capability']" />

	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<!--<xsl:variable name="orgScopeTerm" select="/node()/simple_instance[name=$param4]" />
					<xsl:variable name="orgScopeTermName" select="$orgScopeTerm/own_slot_value[slot_reference='name']/value" />-->
				<xsl:variable name="pageLabel" select="'ACT Business Capability Catalogue by Name'" />
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="pageLabel" select="$pageLabel" />
					<xsl:with-param name="inScopeBusCaps" select="$allBusCaps[own_slot_value[slot_reference='element_classified_by']/value = $viewScopeTerms/name]" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeBusCaps" select="$allBusCaps" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">ACT Business Capability Catalogue by Name</xsl:param>
		<xsl:param name="inScopeBusCaps"/>		
	<xsl:for-each select="$inScopeBusCaps">
          <xsl:variable name="parentCaps" select="current()[own_slot_value[slot_reference='supports_business_capabilities']/value]" />
          <xsl:choose>
          <xsl:when test="string-length($parentCaps) = 0">
            <xsl:call-template name="BuildCap">
	      <xsl:with-param name="aCap" select="current()" />
            </xsl:call-template>
          </xsl:when>
          </xsl:choose>
        </xsl:for-each>
            
	</xsl:template>

        <xsl:template name="BuildCap">
		<xsl:param name="aCap"/>
{"name": "<xsl:value-of select="$aCap/own_slot_value[slot_reference='name']/value" />","size": 1
          <xsl:variable name="childCaps" select="$aCap[own_slot_value[slot_reference='contained_business_capabilities']/value]" />
            <xsl:choose>
            <xsl:when test="string-length($childCaps) > 0">
,"children": [
              <xsl:variable name="inScopeChildren" select="$allBusCaps[own_slot_value[slot_reference='supports_business_capabilities']/value = $aCap/name]" />
              <xsl:for-each select="$inScopeChildren">
               <xsl:call-template name="BuildCap">
	          <xsl:with-param name="aCap" select="current()" />
                </xsl:call-template>
               
                <xsl:choose>
                  <xsl:when test="position() != last()">,</xsl:when>
                </xsl:choose>
              </xsl:for-each> 
]
            </xsl:when>
            </xsl:choose>

                      
}
        </xsl:template>
</xsl:stylesheet>
