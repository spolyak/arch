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
	
	<!-- Get all of the Application Services in the repository -->
	<xsl:variable name="allBusCaps" select="/node()/simple_instance[type='Business_Capability']" />
	<xsl:variable name="allDomains" select="/node()/simple_instance[type='Business_Domain']" />
	<xsl:variable name="allTaxonomyTerms" select="/node()/simple_instance[type='Taxonomy_Term']" />
	<xsl:variable name="anyReports" select="/node()/simple_instance[(type='Report')]" />
	<xsl:variable name="allReportConstants" select="/node()/simple_instance[type='Report_Constant']" />
	<xsl:variable name="homeReportConstant" select="/node()/simple_instance[(type='Report_Constant') and (own_slot_value[slot_reference='name']/value = 'Home Page')]" />
	<xsl:variable name="homeViewScopeTerms" select="$allTaxonomyTerms[name=$homeReportConstant/own_slot_value[slot_reference='report_constant_ea_elements']/value]" />
	<xsl:variable name="relevantTaxonomyTerms" select="$allTaxonomyTerms[own_slot_value[slot_reference='term_in_taxonomy']/value = $viewFilterTaxonomies/name]" />
	<xsl:variable name="viewFilterConstant" select="/node()/simple_instance[(type='Report_Constant') and (own_slot_value[slot_reference='name']/value = 'View Filter Taxonomies')]" />
	<xsl:variable name="viewFilterTaxonomies" select="/node()/simple_instance[name=$viewFilterConstant/own_slot_value[slot_reference='report_constant_ea_elements']/value]" />

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
                                        <xsl:with-param name="inScopeDomains" select="$allDomains[own_slot_value[slot_reference='element_classified_by']/value = $viewScopeTerms/name]" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeBusCaps" select="$allBusCaps" />
                                        <xsl:with-param name="inScopeDomains" select="$allDomains" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">ACT Business Capability Catalogue by Name</xsl:param>
		<xsl:param name="inScopeBusCaps"/>
		<xsl:param name="inScopeDomains"/>
		<!-- <xsl:call-template name="docType" /> -->
{"domains":[

	<xsl:for-each select="$inScopeDomains">
{"name": "<xsl:value-of select="current()/own_slot_value[slot_reference='name']/value" />",
		       "capabilities": [

           <xsl:variable name="thisDomain">
	     <xsl:value-of select="name" />
	   </xsl:variable>

	   <xsl:variable name="theBusCaps" select="$allBusCaps[own_slot_value[slot_reference='belongs_to_business_domain']/value = $thisDomain]" />


           <xsl:for-each select="$theBusCaps">
{"name": "<xsl:value-of select="current()/own_slot_value[slot_reference='name']/value" />",
 "level": "<xsl:value-of select="current()/own_slot_value[slot_reference='business_capability_level']/value" />"
}
             <xsl:choose>
               <xsl:when test="position() != last()">,</xsl:when>
              </xsl:choose>
           </xsl:for-each>
                       
]}
  <xsl:choose>
    <xsl:when test="position() != last()">,</xsl:when>
  </xsl:choose>
</xsl:for-each>
           ]}             
	</xsl:template>

</xsl:stylesheet>
