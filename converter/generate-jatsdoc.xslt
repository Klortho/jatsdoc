<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  This stylesheet produces all of the HTML pages for one jatsdoc representation
  of one flavor of the JATS Tag Libraries.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mtl="http://www.mulberrytech.com/taglib"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:f="http://jatspan.org/fn"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="xs"
                version="2.0">
  
  <xsl:output byte-order-mark="yes" encoding="UTF-8"
     indent="yes" method="xhtml" />
  <xsl:param name="jatsdoc-url" 
    select='"http://dtd.nlm.nih.gov/ncbi/jatsdoc/0.1"'/>
  <xsl:param name='profile' select='"Blue1_1"'/>

  <xsl:variable name='elem-sec'
    select='mtl:taglib.collective/collective/elem.sec'/>
  <xsl:variable name='attr-sec'
    select='mtl:taglib.collective/collective/attr.sec'/>
  <xsl:variable name='pe-sec'
    select='mtl:taglib.collective/collective/pe.sec'/>
  
  <xsl:function name='f:elem-ref-to-tag'>
    <xsl:param name='ref'/>
    <xsl:value-of select="substring-after($ref, 'elem-')"/>
  </xsl:function>
  <xsl:function name='f:elem-ref-to-name'>
    <xsl:param name='ref'/>
    <xsl:variable name='elem-info' select='$elem-sec/elem.info[@name=$ref]'/>
    <xsl:value-of select='string($elem-info/elem.name)'/>
  </xsl:function>
  <xsl:function name='f:attr-ref-to-tag'>
    <xsl:param name='ref'/>
    <xsl:value-of select="substring-after($ref, 'attr-')"/>
  </xsl:function>
  <xsl:function name='f:attr-ref-to-name'>
    <xsl:param name='ref'/>
    <xsl:variable name='attr-info' select='$attr-sec/attr.info[@name=$ref]'/>
    <xsl:value-of select='string($attr-info/attr.name)'/>
  </xsl:function>
  <xsl:function name='f:pe-ref-to-tag'>
    <xsl:param name='ref'/>
    <xsl:value-of select="substring-after($ref, 'pe-')"/>
  </xsl:function>
  <xsl:function name='f:pe-ref-to-name'>
    <xsl:param name='ref'/>
    <xsl:variable name='pe-info' select='$pe-sec/pe.info[@name=$ref]'/>
    <xsl:value-of select='string($pe-info/pe.name)'/>
  </xsl:function>
  
  <xsl:template match='/'>
    <xsl:for-each select='//mtl:profile[profile.metadata/shortname = $profile]'>
      <xsl:variable name='title' select='profile.metadata/title'/>
      <xsl:variable name="version" select="substring-after($title, 'Version ')"/>
      <xsl:variable name='flavor'>
        <xsl:choose>
          <xsl:when test="$profile = 'Blue1_1'">
            <xsl:value-of select="'publishing'"/>
          </xsl:when>
          <xsl:when test='$profile = "Green1_1"'>
            <xsl:value-of select="'archiving'"/>
          </xsl:when>
          <xsl:when test ='$profile = "Pumpkin1_1"'>
            <xsl:value-of select="'authoring'"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="pub-date" select='profile.metadata/pub.date'/>

      <!-- Generate index.html -->
      <xsl:result-document href='{$flavor}/index.html'>
        <html>
          <head>
            <title>
              <xsl:value-of select="$title"/>
            </title>
            <meta content='text/html; charset=utf-8' name='content-type' />
            <meta content='Alternative JATS Tag Library Browser' name='description' />
            <link href='{$jatsdoc-url}/favicon.ico' rel='shortcut icon' type='image/x-icon' />
            <link href='{$jatsdoc-url}/jatsdoc.css' rel='stylesheet' type='text/css' />
            <script src='{$jatsdoc-url}/jatsdoc.js' type='text/javascript'></script>
            <link href='resources/taglib.css' rel='stylesheet' type='text/css' />
          </head>
          <body>
            <div id='sidebar'>
              <div id='search'>
                <input autocomplete='off'
                  autofocus='autofocus'
                  autosave='searchdoc'
                  id='search-field'
                  placeholder='Search'
                  results='0'
                  type='search' />
              </div>
              <div id='sidebar-content'>
                <ul id='categories'>
                  <li class='loader'>Loading...</li>
                </ul>
                <ul class='entries' id='results'>
                  <li class='not-found'>Nothing found.</li>
                </ul>
              </div>
            </div>
            <div id='content'>
              <div id='header'>
                <ul id='signatures-nav'>
                  <li>
                    <xsl:value-of select="$title"/>
                  </li>
                </ul>
                <ul id='navigation'>
                  <li>
                    <a href='.'>
                      <span>Home</span>
                    </a>
                  </li>
                </ul>
              </div>
              <div id='entry'>
                <div id='entry-wrapper'>
                  <a class='original'
                    href='http://jats.nlm.nih.gov/publishing/tag-library/{$version}/'>Original</a>
                  <h1>
                    <xsl:apply-templates select='profile.metadata/title'/>
                  </h1>
                  <p>
                    <xsl:value-of select='$pub-date'/>
                  </p>
                  <h3>What is this about?</h3>
                  <p>
                    This is the JATS Tag Library documentation, being served through 
                    <a href='http://github.com/Klortho/jatsdoc'>jatsdoc</a>, an
                    alternative Javascript/CSS browser, that has been adapted from the
                    excellent <a href='http://github.com/jqapi/jqapi'>jQAPI project</a>.
                    Thanks to <a href='http://mustardamus.com'>Sebastian Senf</a>,
                    and all the people who donated and
                    contributed code for that project, for creating such a nice tool!
                  </p>
                  <p>
                    This documentation framework is being developed on GitHub at
                    <a href='http://github.com/Klortho/jatsdoc'>http://github.com/Klortho/jatsdoc</a>.
                    Suggestions, comments, and bug reports are welcome &#8212; open a GitHub
                    issue there.
                  </p>
                  <p>
                    The content is from the official <a 
                      href='http://jats.nlm.nih.gov/publishing/tag-library/{$version}/'>JATS
                      Tag Library documentation</a>, 
                    downloaded from
                    the NLM FTP site at <a href='ftp://ftp.ncbi.nlm.nih.gov/pub/jats/'>ftp://ftp.ncbi.nlm.nih.gov/pub/jats/</a>.
                    The files were adapted to this framework, using XSLTs that are available
                    on GitHub at <a 
                      href='https://github.com/Klortho/JatsTagLibrary'>https://github.com/Klortho/JatsTagLibrary</a>.
                  </p>
                  <h3>Credits and License</h3>
                  <h4>The jatsdoc framework</h4>
                  <p>
                    The <a href='https://github.com/jqapi/jqapi'>jQAPI software</a> is released under 
                    MIT and GPL licenses, the full text of which is
                    <a href='http://dtd.nlm.nih.gov/ncbi/jatsdoc/0.1/LICENSE'>here</a>
                  </p>
                  <p>
                    Contributions from <a href='https://github.com/Klortho'>Chris Maloney</a> are, to the extent
                    permissible by law, in the <a href='http://creativecommons.org/publicdomain/zero/1.0/'>public domain</a>.
                  </p>
                  <h4>The JATS Tag Library content</h4>
                  <p>
                    The JATS Tag Library documentation was produced for the National Center for 
                    Biotechnology Information (NCBI), National Library of Medicine (NLM), by 
                    Mulberry Technologies, Inc., Rockville, Maryland.
                  </p>
                  <p>
                    The JATS Tag Library is in the public domain.  See the
                    <a href='http://www.ncbi.nlm.nih.gov/About/disclaimer.html'>NCBI Copyright and
                      Disclaimer</a> page for more information.
                  </p>
                </div>
                <div id='footer'>
                  <h2>
                    <xsl:value-of select="$title"/>
                  </h2>
                  <p class='ack'>Rendered with 
                    <a href='http://github.com/Klortho/jatsdoc'>jatsdoc</a>.
                  </p>
                  <p class="pubdate">Version of
                    <xsl:value-of select="$pub-date"/></p>
                </div>
              </div>
            </div>
          </body>
        </html>
      </xsl:result-document>

      <!-- Generate the toc.html -->
      <xsl:result-document href='{$flavor}/toc.html'>
        <ul id='categories'>
          <xsl:apply-templates select='*' mode='toc'/>
        </ul>
      </xsl:result-document>

      <!-- Generate all the content pages -->
      <xsl:apply-templates select='*'>
        <xsl:with-param name="flavor" select="$flavor"/>
      </xsl:apply-templates>

    </xsl:for-each>
  </xsl:template>
  
  <!-- Default template: discard elements -->
  <xsl:template match='*' mode='toc'/>
  
  <!-- Default template: discard elements -->
  <xsl:template match='*'/>
  
  <xsl:template match='mtl:profile' mode='toc'>
    <xsl:apply-templates select='*' mode='toc'/>
  </xsl:template>

  <xsl:template match="mtl:profile">
    <xsl:apply-templates select="*"/>
  </xsl:template>
  
  <xsl:template match='chapter' mode='toc'>
    <li class="top-cat" data-slug="{@id}">
      <span class="top-cat-name">
        <xsl:value-of select='title'/>
      </span>
    </li>
  </xsl:template>
  
  <xsl:template match="chapter">
    <xsl:param name="flavor"/>
    <xsl:result-document href='{$flavor}/entries/{@id}.html'>
      <div id="entry-wrapper">
        <xsl:apply-templates select='*'/>
      </div>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match='intro' mode='toc'>
    <li class="top-cat" data-slug="{@id}"> 
      <span class="top-cat-name">General Introduction</span>
    </li>
  </xsl:template>

  <xsl:template match="intro">
    <xsl:param name="flavor"/>
    <xsl:result-document href='{$flavor}/entries/{@id}.html'>
      <div id="entry-wrapper">
        <h1>General Introduction</h1>
        <xsl:apply-templates select='*'/>
      </div>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match='profile.elem.intro[not(@NISO="yes") and intro]' mode='toc'>
    <li class="top-cat has-kids" data-slug="elements">
      <span class="top-cat-name">Elements</span>
      <ul class='entries'>
        <xsl:apply-templates 
          select='/mtl:taglib.collective/collective/elem.sec/
                  elem.info[profile.elem.info/@profile=$profile]' mode='toc'/>
      </ul>
    </li>
  </xsl:template>

  <xsl:template match='profile.elem.intro[not(@NISO="yes") and intro]'>
    <xsl:param name='flavor'/>
    <xsl:result-document href='{$flavor}/entries/elements.html'>
      <div id="entry-wrapper">
        <h1>Introduction to Elements</h1>
        <xsl:apply-templates select='intro/*'/>
      </div>
    </xsl:result-document>

    <!-- Generate all the element pages -->
    <xsl:apply-templates
      select='/mtl:taglib.collective/collective/elem.sec/
              elem.info[profile.elem.info/@profile=$profile]'>
      <xsl:with-param name="flavor" select='$flavor'/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match='profile.attr.intro[not(@NISO="yes") and intro]' mode='toc'>
    <li class="top-cat has-kids" data-slug="attributes">
      <span class="top-cat-name">Attributes</span>
      <ul class='entries'>
        <xsl:apply-templates select='//attr.info' mode='toc'/>
      </ul>
    </li>
  </xsl:template>
  
  <xsl:template match='profile.attr.intro[not(@NISO="yes") and intro]'>
    <xsl:param name='flavor'/>
    <xsl:result-document href='{$flavor}/entries/attributes.html'>
      <div id="entry-wrapper">
        <h1>Introduction to Attributes</h1>
        <xsl:apply-templates select='intro/*'/>
      </div>
    </xsl:result-document>
    
    <!-- Generate all the attribute pages -->
    <xsl:apply-templates
      select='/mtl:taglib.collective/collective/attr.sec/
              attr.info[profile.attr.info/@profile=$profile]'>
      <xsl:with-param name="flavor" select='$flavor'/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match='profile.pe.intro[not(@NISO="yes") and intro]' mode='toc'>
    <li class="top-cat has-kids" data-slug="parameter-entities">
      <span class="top-cat-name">Parameter Entities</span>
      <ul class='entries'>
        <xsl:apply-templates select='//pe.info' mode='toc'/>
      </ul>
    </li>
  </xsl:template>
  
  <xsl:template match='profile.pe.intro[not(@NISO="yes") and intro]'>
    <xsl:param name='flavor'/>
    <xsl:result-document href='{$flavor}/entries/parameter-entities.html'>
      <div id="entry-wrapper">
        <h1>Introduction to Parameter Entities</h1>
        <xsl:apply-templates select='intro/*'/>
      </div>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match='insert.ContextTable' mode='toc'>
    <li class="top-cat" data-slug="element-context-table">
      <span class="top-cat-name">Element Context Table</span>
    </li>
  </xsl:template>
  
  <xsl:template match='insert.Index' mode='toc'>
    <li class="top-cat" data-slug="index">
      <span class="top-cat-name">Index</span>
    </li>
  </xsl:template>
  
  <xsl:template match='elem.info' mode='toc'>
    <xsl:if test='profile.elem.info/@profile=$profile'>
      <li class='entry' data-slug='{@name}'>
        <span class='title'>
          <xsl:value-of select="concat('&lt;', elem.tag, '&gt;')"/>
        </span>
      </li>
    </xsl:if>
  </xsl:template>

  <xsl:template match="elem.info">
    <xsl:param name='flavor'/>
    <xsl:result-document href='{$flavor}/entries/{@name}.html'>
      <div id='entry-wrapper'>
        <h1>
          &lt;<xsl:value-of select="f:elem-ref-to-tag(@name)"/>&gt;
          <xsl:value-of select="f:elem-ref-to-name(@name)"/>
        </h1>
        <xsl:apply-templates 
          select='definition/* | remarks | related.elem | profile.elem.info[@profile=$profile]/*'/>
      </div>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="remarks">
    <h3>Remarks</h3>
    <xsl:apply-templates select="*"/>
  </xsl:template>
  
  <xsl:template match="related.elem">
    <h3>Related Elements</h3>
    <xsl:apply-templates select="*"/>
  </xsl:template>

  <xsl:template match='attr.info' mode='toc'>
    <xsl:if test='profile.attr.info/@profile=$profile'>
      <li class='entry' data-slug='{@name}'>
        <span class='title'>
          <xsl:value-of select="concat('@', attr.tag)"/>
        </span>
      </li>
    </xsl:if>
  </xsl:template>

  <xsl:template match="attr.info">
    <xsl:param name='flavor'/>
    <xsl:result-document href='{$flavor}/entries/{@name}.html'>
      <div id='entry-wrapper'>
        <h1>
          @<xsl:value-of select="f:attr-ref-to-tag(@name)"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="f:attr-ref-to-name(@name)"/>
        </h1>
        <xsl:apply-templates 
          select='definition/* | remarks | attr.value.info | profile.attr.info[@profile=$profile]/*'/>
      </div>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="attr.value.info">
    <xsl:apply-templates select="*"/>
  </xsl:template>
  
  <xsl:template match="elem.value.group">
    <xsl:apply-templates select="*"/>
  </xsl:template>
  
  <xsl:template match="elem.name.group">
    <h4>Used on elements:
      <!-- It looks like they should use elem.tag.ref as children here, but
        instead they use elem.name.ref. So, we'll call a named template for each, 
        instead of apply-templates. -->
      <xsl:for-each select='elem.name.ref'>
        <xsl:call-template name='elem.tag.ref'/>
        <xsl:if test="position() != last()">, </xsl:if>
      </xsl:for-each>
    </h4>
  </xsl:template>
  
  <xsl:template match="attr.value.group">
    <table class='attrtable'>
      <tbody>
        <tr>
          <th class='attrvalue'>Value</th>
          <th class='attrmeaning'>Meaning</th>
        </tr>
        <xsl:apply-templates select="*"/>
      </tbody>
    </table>
  </xsl:template>
  
  <xsl:template match="value.cluster">
    <tr class='attrrow'>
      <xsl:apply-templates select="*"/>
    </tr>
  </xsl:template>
  
  <xsl:template match="value">
    <td class='attrvalue'>
      <xsl:apply-templates select="node()"/>
    </td>
  </xsl:template>
  <xsl:template match="meaning">
    <td class='attrmeaning'>
      <xsl:apply-templates select="node()"/>
    </td>
  </xsl:template>
  <xsl:template match="default.value">
    <tr>
      <td class='attrrestricthead'>Restriction</td>
      <td class='attrrestrict'>
        <xsl:apply-templates select="node()"/>
      </td>
    </tr>
  </xsl:template>
  


  <xsl:template match='pe.info' mode='toc'>
    <xsl:if test='profile.pe.info/@profile=$profile'>
      <li class='entry' data-slug='{@name}'>
        <span class='title'>
          <xsl:value-of select="concat('%', pe.tag, ';')"/>
        </span>
      </li>
    </xsl:if>
  </xsl:template>

  <!-- content transforms -->
  <xsl:template match='@*|text()'>
    <xsl:copy/>
  </xsl:template>
  <xsl:template match="chapter/title">
    <h1><xsl:apply-templates select="node()"/></h1>
  </xsl:template>
  <xsl:template match="section/title">
    <xsl:variable name="level" select="count(ancestor::section)"/>
    <xsl:element name='{concat("h", $level + 2)}'>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="para">
    <p><xsl:apply-templates select="node()"/></p>
  </xsl:template>
  <xsl:template match='linebrk'>
    <br/>
  </xsl:template>
  <xsl:template match="bul.list">
    <ul><xsl:apply-templates select="node()"/></ul>
  </xsl:template>
  <xsl:template match="num.list">
    <ol><xsl:apply-templates select="node()"/></ol>
  </xsl:template>
  <xsl:template match="item">
    <li><xsl:apply-templates select="node()"/></li>    
  </xsl:template>
  <xsl:template match="section">
    <div class='section'>
      <xsl:apply-templates select="@id|*"/>
    </div>
  </xsl:template>
  <xsl:template match="quoted">
    <xsl:text>“</xsl:text>
    <xsl:apply-templates select="node()"/>
    <xsl:text>”</xsl:text>
  </xsl:template>
  <xsl:template match="graphic">
    <div>
      <img src='{@picfile}'/>
    </div>
  </xsl:template>
  <xsl:template match="inline.graphic">
    <img src='{@picfile}'/>
  </xsl:template>

  <!-- there are only two `type` values for emphasis -->
  <xsl:template match="emphasis[@type='bold']">
    <strong><xsl:apply-templates select="node()"/></strong>
  </xsl:template>
  <xsl:template match="emphasis[@type='ital']">
    <em><xsl:apply-templates select="node()"/></em>
  </xsl:template>
  
  <xsl:template match="def.list">
    <div class='deflist'>
      <table class='deflisttable'>
        <tbody>
          <xsl:apply-templates select="def.item"/>
        </tbody>
      </table>
    </div>
  </xsl:template>
  <xsl:template match="def.item">
    <xsl:variable name="row-class"
      select='concat("row", position() mod 2)'/>
    <tr class='{$row-class}'>
      <xsl:apply-templates select="term|def"/>
    </tr>
  </xsl:template>
  <xsl:template match="term">
    <td class='dterm'>
      <xsl:apply-templates select="node()"/>
    </td>
  </xsl:template>
  <xsl:template match="def">
    <td class='ddef'>
      <xsl:apply-templates select="node()"/>
    </td>
  </xsl:template>

  <xsl:template match="code">
    <tt><xsl:apply-templates select="node()"/></tt>
  </xsl:template>


  <xsl:template match="elem.tag.ref" name='elem.tag.ref'>
    <xsl:variable name='ref' select='@elem.ref'/>
    <xsl:variable name="span">
      <span class='elementtag'>&lt;<xsl:value-of 
        select="f:elem-ref-to-tag($ref)"/>&gt;</span>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@autolink='yes'">
        <a href='#p={$ref}' title='{f:elem-ref-to-name($ref)}'>
          <xsl:copy-of select='$span'/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select='$span'/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="elem.name.ref">
    <xsl:variable name='ref' select='@elem.ref'/>
    <xsl:variable name="span">
      <span class='elementname'><xsl:value-of
        select="f:elem-ref-to-name($ref)"/></span>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@autolink='yes'">
        <a href='#p={$ref}' title='{concat("&lt;", f:elem-ref-to-tag($ref), "&gt;")}'>
          <xsl:copy-of select='$span'/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select='$span'/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="attr.tag.ref">
    <xsl:variable name='ref' select='@attr.ref'/>
    <xsl:variable name='span'>
      <span class='attrtag'>@<xsl:value-of select="f:attr-ref-to-tag($ref)"/></span>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@autolink='yes'">
        <a href='#p={$ref}' title='{f:attr-ref-to-name($ref)}'>
          <xsl:copy-of select='$span'/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select='$span'/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="attr.name.ref">
    <xsl:variable name='ref' select='@attr.ref'/>
    <xsl:variable name="span">
      <span class='attrname'><xsl:value-of select="f:attr-ref-to-name($ref)"/></span>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@autolink='yes'">
        <a href='#p={$ref}' title='{concat("@", f:attr-ref-to-tag($ref))}'>
          <xsl:copy-of select='$span'/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select='$span'/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="pe.tag.ref">
    <xsl:variable name='ref' select='@pe.ref'/>
    <xsl:variable name='span'>
      <span class='petag'>%<xsl:value-of select="f:pe-ref-to-tag($ref)"/>;</span>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@autolink='yes'">
        <a href='#p={$ref}' title='{f:pe-ref-to-name($ref)}'>
          <xsl:copy-of select='$span'/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select='$span'/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="pe.name.ref">
    <xsl:variable name='ref' select='@pe.ref'/>
    <xsl:variable name="span">
      <span class='pename'><xsl:value-of select="f:pe-ref-to-name($ref)"/></span>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@autolink='yes'">
        <a href='#p={$ref}' title='{concat("@", f:pe-ref-to-tag($ref))}'>
          <xsl:copy-of select='$span'/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select='$span'/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  


  <xsl:template match="int.cross.ref">
    <a href='#p={@int.ref}'>
      <xsl:apply-templates select="node()"/>
    </a>
  </xsl:template>
  <xsl:template match="ext.cross.ref">
    <a href='{@ext.ref}'>
      <xsl:apply-templates select="node()"/>
    </a>
  </xsl:template>
  
  <xsl:template match="table|colgroup|col|thead|tbody|tr|th|td">
    <xsl:copy>
      <xsl:apply-templates select='@*' mode='table'/>
      <xsl:apply-templates select='node()'/>
    </xsl:copy>    
  </xsl:template>
  <xsl:template match='@*' mode='table'>
    <xsl:copy/>
  </xsl:template>

</xsl:stylesheet>