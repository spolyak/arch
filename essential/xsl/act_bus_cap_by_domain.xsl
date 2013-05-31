<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/ev3_docType.xsl" />
	<xsl:include href="../common/ev3_common_head_content.xsl" />
	<xsl:include href="../common/ev3_header.xsl" />
	<xsl:include href="../common/ev3_footer.xsl" />
	
	
	<xsl:output method="html" />
	<xsl:variable name="hideEmpty">false</xsl:variable>

	<!--
		* Copyright (c)2008-2011 Enterprise Architecture Solutions ltd.
	 	* This file is part of Essential Architecture Manager, 
	 	* the Essential Architecture Meta Model and The Essential Project.
		*
		* Essential Architecture Manager is free software: you can redistribute it and/or modify
		* it under the terms of the GNU General Public License as published by
		* the Free Software Foundation, either version 3 of the License, or
		* (at your option) any later version.
		*
		* Essential Architecture Manager is distributed in the hope that it will be useful,
		* but WITHOUT ANY WARRANTY; without even the implied warranty of
		* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		* GNU General Public License for more details.
		*
		* You should have received a copy of the GNU General Public License
		* along with Essential Architecture Manager.  If not, see <http://www.gnu.org/licenses/>.
		* 
	-->
	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- May 2011 Updated to support Essential Viewer version 3-->
	
	


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
		<xsl:call-template name="docType" />
		<html>
			<head>
				<xsl:call-template name="commonHeadContent" />
				<link rel="stylesheet" href="css/essential_home.css" type="text/css" />
				<title><xsl:value-of select="$pageLabel"></xsl:value-of></title>
				<script type="text/javascript">
				$('document').ready(function(){
					 $(".jumpBoxKey").vAlign();
					 $(".jumpBoxElement").vAlign();
					 $(".filterKey").vAlign();
					 $(".filterElement").vAlign();
					 $("#viewFilterButton").vAlign();
					 $("#clearFilterButton").vAlign();
					 $(".viewElementCap").vAlign();
					 $(".rightColTab").vAlign();
					 
				});
				</script>

				<script type="text/javascript" src="js/jquery.columnizer.js" />
				<!--script to turn the app providers list into columns-->
				<script>
						$(function(){
							$('.bus_domains').columnize({columns: 2});
						});
				</script>
				<!--script to support smooth scroll back to top of page-->
				<script type="text/javascript">
					$(document).ready(function() {
					    $('a[href=#top]').click(function(){
					        $('html, body').animate({scrollTop:0}, 'slow');
					        return false;
					    });
					});
				</script>
			</head>
			<body>
				<!-- ADD JAVASCRIPT FOR CONTEXT POP-UP MENUS, WHERE REQUIRED -->
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading" />

				<!--ADD THE CONTENT-->
				<a id="top" />
				<div class="pageWidthContainer">
					<div id="mainContentContainer">
						<div>
							<span id="viewName">
								<span class="textColour1"><xsl:value-of select="eas:i18n('View')"/>: </span>
								<span class="textColour6"><xsl:value-of select="$pageLabel"/></span>
							</span>
						</div>
						<div id="filterSectionContainer">
							<div id="componentFilterKey">
								<span id="componentFilterKeyLabel"><xsl:value-of select="eas:i18n('Filter')"/>:</span>
							</div>
							<div id="componentFilterElementsContainer">

								<!--start script to control the show hide of individual sections - requires jquery-->
								<script type="text/javascript">
								   $(document).ready(function(){   
									      $("#component_About").click(function(){
									        if ($("#component_About").is(":checked"))
									        {
									            $("#sectionAbout").show("slow");
									        }
									        else
									        {      
									            $("#sectionAbout").hide("slow");
									        }
									      });
									      
									      
									      $("#component_Catalogue").click(function(){
									       if ($("#component_Catalogue").is(":checked"))
									       {
									           $("#sectionApplicationServiceCatalogue").show("slow");
									       }
									       else
									       {      
									           $("#sectionApplicationServiceCatalogue").hide("slow");
									       }
									     });
									     
									   				   	
								   });
								    </script>

								<div class="componentFilterElement">
									<form class="checkbox">
										<input type="checkbox" id="component_About" />
										<span class="componentFilterElementLabel">
											<a href="#sectionAbout"><xsl:value-of select="eas:i18n('About This View')"/></a>
										</span>
									</form>
								</div>
								<div class="componentFilterElement">
									<form class="checkbox">
										<input type="checkbox" id="component_Catalogue" checked="checked" />
										<span class="componentFilterElementLabel">
											<a href="#sectionApplicationServiceCatalogue">Catalogue</a>
										</span>
									</form>
								</div>
							</div>
						</div>
						<div class="sectionDividerHorizontal" />
						<div class="clear" />

						<!--Setup About This View Section-->
						<div id="sectionAbout" class="hidden">
							<div class="sectionContainerFullWidth">
								<div class="sectionIcon" id="image_questionMark" />
								<div class="sectionHeader">
									<h1><xsl:value-of select="eas:i18n('About This View')"/></h1>
								</div>
								<div class="sectionBasicTextFullWidth">This ACT view shows all the business capabilities for the enterprise</div>
							</div>
							<div class="sectionDividerHorizontal" />
							<div class="clear" />
						</div>

						<!--Setup Definition Section-->
						<div id="sectionApplicationServiceCatalogue">
							<div class="sectionContainerFullWidth">
								<!--<div class="sectionIcon" id="image_catalog" />
								<xsl:variable name="view_url">
									<xsl:text>report?XML=reportXML.xml&amp;XSL=business/busToAppSvc_bus_cap_list_by_alpha.xsl&amp;PMA2=</xsl:text>
									<xsl:value-of select="$hideEmpty" />
									<xsl:text>&amp;PMA=</xsl:text>
									<xsl:text>&amp;LABEL=ACT Business Capability to Application Service Mapping - Alphabetical Business Domains</xsl:text>
								</xsl:variable>
								<div class="sectionHeader">
									<h1>Supporting Application Services - by Business Domain <a href="{$view_url}">or Business Capability</a></h1>
								</div>


								<div class="sectionBasicTextFullWidth">
									<xsl:variable name="allDomainsURL">
										<xsl:text>report?XML=reportXML.xml&amp;XSL=business/core_bus_cap_appSvc_analysis_by_allDomain.xsl&amp;PMA2=</xsl:text>
										<xsl:value-of select="$hideEmpty" /><xsl:text>&amp;PMA=</xsl:text><xsl:text>&amp;LABEL=Business Capability to Application Service Mapping - All Business Domains</xsl:text>
									</xsl:variable> Choose one of the Business Areas below to view the supporting application services analysis for it or <a href="{$allDomainsURL}">SELECT ALL</a>
								</div>
								<div class="clear" />
								<br />-->
								<div class="sectionIcon" id="image_catalog" />
								<div class="sectionHeader">
									<h1><xsl:value-of select="eas:i18n('Domains')"/></h1>
								</div>
								<div class="sectionBasicTextFullWidth">

<xsl:apply-templates select="$inScopeDomains" mode="BusinessDomain">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value" />
				</xsl:apply-templates>

								</div>
								<div class="clear" />

								</div>
							</div>
							<div class="clear" />
						</div>
					</div>

				<div class="clear" />



				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer" />
<script>
				$(document).ready(function() {				
					// initialize tooltip
					$(".viewElement").tooltip({					
					   // tweak the position
					   offset: [-10, -140],
					   predelay: '500',
					   delay: '30',					   
					   relative: 'true',					   
					   position: 'bottom',					   
					   opacity: '0.9',					
					   // use the "fade" effect
					   effect: 'fade'					
					// add dynamic plugin with optional configuration for bottom edge
					}).dynamic({ bottom: { direction: 'down', bounce: true } });
				});
				</script>
				<script language="JavaScript">
					window.onunload = $(".viewElementDescription").hide();
				</script>
			</body>
		</html>
	</xsl:template>



	<xsl:template name="Index">
		<xsl:param name="letter" />
		<xsl:param name="letterLow" />
		<xsl:param name="inScopeInstances"/>
		<div class="alphabetSectionHeader">
			<h1>
				<xsl:value-of select="$letter" />
			</h1>
		</div>
		<xsl:text disable-output-escaping="yes">&lt;a id="section_</xsl:text>
		<xsl:value-of select="$letter" />
		<xsl:text disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
		<!-- Business Capabilities START HERE -->
		<div class="bus_domains">
			<ul>
				<xsl:apply-templates select="$inScopeInstances[((starts-with(own_slot_value[slot_reference='name']/value, $letter)) or (starts-with(own_slot_value[slot_reference='name']/value, $letterLow)))]" mode="BusinessCapability">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value" />
				</xsl:apply-templates>
			</ul>
			<!-- Business Capabilities END HERE -->
		</div>
		<div class="jumpToTopLink">
			<a href="#top"><xsl:value-of select="eas:i18n('Back to Top')"/></a>
		</div>
		<div class="clear" />
		<div class="sectionDividerHorizontal" />
	</xsl:template>


	<xsl:template match="node()" mode="BusinessDomain">
               
                <!-- stp -->

                       <div class="viewElement small hubElementColour5" style="width:290px;height:320px;max-height:320px">
                         <div style="padding-top:10px;padding-bottom:10px;"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value" /></div>
                        

		       <xsl:variable name="thisDomain">
			<xsl:value-of select="name" />
		       </xsl:variable>

	               <xsl:variable name="theBusCaps" select="$allBusCaps[own_slot_value[slot_reference='belongs_to_business_domain']/value = $thisDomain]" />
                       <xsl:apply-templates select="$theBusCaps" mode="BusinessCapability">
			  <xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value" />
		       </xsl:apply-templates>			

		       </div>

	</xsl:template>

	<xsl:template match="node()" mode="BusinessCapability">

                       <div class="viewElement viewElementCap small hubElementColour4" style="margin-left:10px;valign;width:100px;height:75px;max-height:75px">
                         <div style="padding-top:10px;"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value" /></div>
		       </div>

	</xsl:template>

	<!--<xsl:template match="node()" mode="Application_Providers">
		<xsl:variable name="thisAP">
			<xsl:value-of select="name" />
		</xsl:variable>
		<xsl:variable name="ap_name">
			<xsl:value-of select="own_slot_value[slot_reference='name']/value" />
		</xsl:variable>
		<xsl:variable name="xurl">
			<xsl:text>report?XML=reportXML.xml&amp;XSL=application/core_app_def.xsl&amp;PMA=</xsl:text>
			<xsl:value-of select="$thisAP" />
			<xsl:text>&amp;LABEL=Application Provider - </xsl:text>
			<xsl:value-of select="$ap_name" />
		</xsl:variable>
		<a class="subText">
			<xsl:attribute name="href">
				<xsl:value-of select="$xurl" />
			</xsl:attribute>
			<xsl:value-of select="$ap_name" />
		</a>
	</xsl:template>-->

</xsl:stylesheet>
