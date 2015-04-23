<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  This stylesheet produces all of the HTML pages for one jatsdoc representation
  of one flavor of the JATS Tag Libraries.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mtl="http://www.mulberrytech.com/taglib"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2000/10/XMLSchema"
                xmlns:f="http://jatspan.org/fn"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:x="http://jatspan.org/ns/tmp"
                exclude-result-prefixes="xs"
                version="2.0">
  
  <xsl:output byte-order-mark="yes" encoding="UTF-8"
     indent="yes" method="xhtml" />

  <!-- If this is not the empty string, then we'll only convert the indicated page.  This is used
    for debugging, so we don't have to convert the whole document every time. -->
  <xsl:param name='page-key' select='""'/>

  <xsl:param name="jatsdoc-url" 
    select='"http://dtd.nlm.nih.gov/ncbi/jatsdoc/0.2.1"'/>
  
  <xsl:param name='profile' select='"Pumpkin1_1"'/>



  <!-- Colors, versions, profiles, and all that stuff -->
  <xsl:variable name='color' select='replace($profile, "\d.*", "")'/>
  <xsl:variable name='full-version-num'
    select='string(mtl:taglib.collective/metadata/vers.history/release/vers.number)'/>
  <xsl:variable name='version-num' 
    select='replace($full-version-num, ".* ", "")'/>

  <xsl:variable name='flavor'>
    <xsl:choose>
      <xsl:when test="$profile = 'Blue1_1'">
        <xsl:value-of select="'publishing'"/>
      </xsl:when>
      <xsl:when test='$profile = "Green1_1"'>
        <xsl:value-of select="'archiving'"/>
      </xsl:when>
      <xsl:when test ='$profile = "Pumpkin1_1"'>
        <xsl:value-of select="'articleauthoring'"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="original-base-url" 
    select="concat('http://jats.nlm.nih.gov/', $flavor, '/tag-library/', $version-num)"/>
  <xsl:variable name='id-prefix'>
    <xsl:choose>
      <xsl:when test="$flavor = 'publishing'">
        <xsl:text>pub-</xsl:text>
      </xsl:when>
      <xsl:when test="$flavor = 'archiving'">
        <xsl:text>arc-</xsl:text>
      </xsl:when>
      <xsl:when test="$flavor = 'articleauthoring'">
        <xsl:text>aut-</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <!-- Read in the examples XML file -->
  <xsl:variable name='root-dir' select='replace(base-uri(), "(.*)/.*", "$1")'/>
  <xsl:variable name="profile-dir" select="concat($root-dir, '/Taglib-', $color)"/>
  <xsl:variable name='examples-filename' 
    select='concat($profile-dir, "/", $profile, "-examples.xml")'/>
  <xsl:variable name='examples' select='document($examples-filename)/mtl:examples.set'/>

  <!-- Read in the schema -->
  <xsl:variable name="schema-filename" 
    select='concat($profile-dir, "/", $profile, "-schema.xml")'/>
  <xsl:variable name='schema' select='document($schema-filename)/xsd:schema'/>
  
  <!-- Read in the models file -->
  <xsl:variable name="models-filename"
    select='concat($profile-dir, "/", $profile, "-english-models.xml")'/>
  <xsl:variable name='models' select='document($models-filename)/modeldescdump'/>
  
  <!-- Some variables to store important sections of the main document -->
  <xsl:variable name='elem-sec'
    select='mtl:taglib.collective/collective/elem.sec'/>
  <xsl:variable name='attr-sec'
    select='mtl:taglib.collective/collective/attr.sec'/>
  <xsl:variable name='pe-sec'
    select='mtl:taglib.collective/collective/pe.sec'/>
  
  <!-- Utility functions -->
  <xsl:function name='f:elem-ref-to-tag'>
    <xsl:param name='ref'/>
    <xsl:variable name='elem-info' select='$elem-sec/elem.info[@name=$ref]'/>
    <xsl:value-of select="string($elem-info/elem.tag)"/>
  </xsl:function>
  <xsl:function name='f:elem-ref-to-name'>
    <xsl:param name='ref'/>
    <xsl:variable name='elem-info' select='$elem-sec/elem.info[@name=$ref]'/>
    <xsl:value-of select='string($elem-info/elem.name)'/>
  </xsl:function>
  <xsl:function name='f:attr-ref-to-tag'>
    <xsl:param name='ref'/>
    <xsl:variable name='attr-info' select='$attr-sec/attr.info[@name=$ref]'/>
    <xsl:value-of select="string($attr-info/attr.tag)"/>
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
  <xsl:function name='f:page-slug'>
    <xsl:param name="id"/>
    <xsl:value-of select="substring-after($id, $id-prefix)"/>
  </xsl:function>
  
  <xsl:template match='/'>
    <!--<xsl:message>
      page-key is <xsl:value-of select="$page-key"/>.
      root-dir is <xsl:value-of select="$root-dir"/>.
      profile-dir is <xsl:value-of select="$profile-dir"/>.
      examples-filename is <xsl:value-of select="$examples-filename"/>.
    </xsl:message>-->



    <xsl:for-each select='//mtl:profile[profile.metadata/shortname = $profile]'>
      <xsl:variable name='title' select='profile.metadata/title'/>
      <xsl:variable name="pub-date" select='profile.metadata/pub.date'/>

      <!-- Generate index.html -->
      <xsl:if test='$page-key = "" or $page-key = "index"'>
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
                    <a class='original' href='{$original-base-url}/'>Original</a>
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
                      The content is from the official <a href='{$original-base-url}/'>JATS
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
      </xsl:if>
      
      <!-- Generate the toc.html -->
      <xsl:if test='$page-key = "" or $page-key = "toc"'>
        <xsl:result-document href='{$flavor}/toc.html'>
          <ul id='categories'>
            <xsl:apply-templates select='*' mode='toc'/>
          </ul>
        </xsl:result-document>
      </xsl:if>

      <!-- Generate all the content pages -->
      <xsl:apply-templates select='*'/>

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
    <xsl:variable name='class'>
      <xsl:text>top-cat</xsl:text>
      <xsl:if test='section[@keep!="yes"]'>
        <xsl:text> has-kids</xsl:text>
      </xsl:if>
    </xsl:variable>
    <li class="{$class}" data-slug="{f:page-slug(@id)}">
      <span class="top-cat-name">
        <xsl:value-of select='title'/>
      </span>
      <xsl:if test='section[@keep!="yes"]'>
        <ul class='entries'>
          <xsl:apply-templates select='section[@keep!="yes"]' mode='toc'/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>
  
  <xsl:template match='section[@keep!="yes"]' mode='toc'>
    <xsl:variable name='li-class'>
      <xsl:choose>
        <xsl:when test="section[@keep!='yes']">
          <xsl:text>sub-cat has-kids</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>entry</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="span-class">
      <xsl:choose>
        <xsl:when test="section[@keep!='yes']">
          <xsl:text>sub-cat-name</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>title</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li class='{$li-class}' data-slug='{f:page-slug(@id)}'>
      <span class='{$span-class}'>
        <xsl:variable name='t'>
          <xsl:apply-templates select='title'/>
        </xsl:variable>
        <xsl:value-of select="$t"/>
      </span>
      <xsl:if test='section[@keep!="yes"]'>
        <ul class='entries'>
          <xsl:apply-templates select='section[@keep!="yes"]' mode='toc'/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>
  
  <xsl:template match="chapter">
    <xsl:variable name="slug" select="f:page-slug(@id)"/>
    <xsl:if test='$page-key = "" or $page-key = $slug'>
      <xsl:result-document href='{$flavor}/entries/{$slug}.html'>
        <div id="entry-wrapper">
          <span class="original">
            <a href="{$original-base-url}/chapter/{$slug}.html">Original</a>
          </span>
          <xsl:apply-templates select='*'/>
        </div>
      </xsl:result-document>
    </xsl:if>
    <xsl:apply-templates select='section[@keep!="yes"]' mode='section'/>
  </xsl:template>

  <xsl:template match="section[@keep!='yes']" mode='section'>
    <xsl:variable name="slug" select="f:page-slug(@id)"/>
    <xsl:if test='$page-key = "" or $page-key = $slug'>
      <xsl:result-document href='{$flavor}/entries/{$slug}.html'>
        <div id="entry-wrapper">
          <span class="original">
            <a href="{$original-base-url}/chapter/{$slug}.html">Original</a>
          </span>
          <xsl:apply-templates select='*'/>
        </div>
      </xsl:result-document>
    </xsl:if>
    <xsl:apply-templates select='section[@keep!="yes"]' mode='section'/>
  </xsl:template>
  
  
  <xsl:template match='intro' mode='toc'>
    <li class="top-cat" data-slug="{f:page-slug(@id)}"> 
      <span class="top-cat-name">General Introduction</span>
    </li>
  </xsl:template>

  <xsl:template match="intro">
    <xsl:variable name="slug" select="f:page-slug(@id)"/>
    <xsl:if test='$page-key = "" or $page-key = $slug'>
      <xsl:result-document href='{$flavor}/entries/{$slug}.html'>
        <div id="entry-wrapper">
          <span class="original">
            <a href="{$original-base-url}/chapter/{$slug}.html">Original</a>
          </span>
          <h1>General Introduction</h1>
          <xsl:apply-templates select='*'/>
        </div>
      </xsl:result-document>
    </xsl:if>
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

  <!-- Generate the intro to elements page, then all the element pages themselves. -->
  <xsl:template match='profile.elem.intro[not(@NISO="yes") and intro]'>
    <xsl:variable name="slug" select="'elements'"/>
    <xsl:if test='$page-key = "" or $page-key = $slug'>
      <xsl:result-document href='{$flavor}/entries/{$slug}.html'>
        <div id="entry-wrapper">
          <span class="original">
            <!-- hard code this anomalous original url -->
            <a href="{$original-base-url}/element/aut-elem-sec-intro.html">Original</a>
          </span>
          <h1>Introduction to Elements</h1>
          <xsl:apply-templates select='intro/*'/>
        </div>
      </xsl:result-document>
    </xsl:if>

    <!-- Generate all the element pages -->
    <xsl:apply-templates
      select='/mtl:taglib.collective/collective/elem.sec/
              elem.info[profile.elem.info/@profile=$profile]'/>
  </xsl:template>
  
  <xsl:template match='profile.attr.intro[not(@NISO="yes") and intro]' mode='toc'>
    <li class="top-cat has-kids" data-slug="attributes">
      <span class="top-cat-name">Attributes</span>
      <ul class='entries'>
        <xsl:apply-templates select='//attr.info' mode='toc'/>
      </ul>
    </li>
  </xsl:template>
  
  <!-- Generate the intro to attributes page, then all the attr pages themselves. -->
  <xsl:template match='profile.attr.intro[not(@NISO="yes") and intro]'>
    <xsl:variable name="slug" select="'attributes'"/>
    <xsl:if test='$page-key = "" or $page-key = $slug'>
      <xsl:result-document href='{$flavor}/entries/{$slug}.html'>
        <div id="entry-wrapper">
          <span class="original">
            <!-- hard-code this anomalous original url -->
            <a href="{$original-base-url}/attribute/aut-attr-sec-intro.html">Original</a>
          </span>
          <h1>Introduction to Attributes</h1>
          <xsl:apply-templates select='intro/*'/>
        </div>
      </xsl:result-document>
    </xsl:if>
    
    <!-- Generate all the attribute pages -->
    <xsl:apply-templates
      select='/mtl:taglib.collective/collective/attr.sec/
              attr.info[profile.attr.info/@profile=$profile]'/>
  </xsl:template>
  
  <xsl:template match='profile.pe.intro[not(@NISO="yes") and intro]' mode='toc'>
    <li class="top-cat has-kids" data-slug="parameter-entities">
      <span class="top-cat-name">Parameter Entities</span>
      <ul class='entries'>
        <xsl:apply-templates select='//pe.info' mode='toc'/>
      </ul>
    </li>
  </xsl:template>
  
  <!-- Generate the intro to parameter entities page, then all the pe pages themselves. -->
  <xsl:template match='profile.pe.intro[not(@NISO="yes") and intro]'>
    <xsl:variable name="slug" select="'parameter-entities'"/>
    <xsl:if test='$page-key = "" or $page-key = $slug'>
      <xsl:result-document href='{$flavor}/entries/{$slug}.html'>
        <div id="entry-wrapper">
          <span class="original">
            <!-- hard-code this anomalous original url -->
            <a href="{$original-base-url}/pe/aut-pe-sec-intro.html">Original</a>
          </span>
          <h1>Introduction to Parameter Entities</h1>
          <xsl:apply-templates select='intro/*'/>
        </div>
      </xsl:result-document>
    </xsl:if>
    
    <!-- Generate all the pe pages -->
    <xsl:apply-templates
      select='/mtl:taglib.collective/collective/pe.sec/
              pe.info[profile.pe.info/@profile=$profile]'/>
  </xsl:template>
  
  <!--
    FIXME: Do we need an element context table?  
  <xsl:template match='insert.ContextTable' mode='toc'>
    <li class="top-cat" data-slug="element-context-table">
      <span class="top-cat-name">Element Context Table</span>
    </li>
  </xsl:template>-->
  
  <!-- 
    FIXME: Do we need an index?
  <xsl:template match='insert.Index' mode='toc'>
    <li class="top-cat" data-slug="index">
      <span class="top-cat-name">Index</span>
    </li>
  </xsl:template>-->
  
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
    <xsl:variable name="ref" select="@name"/>
    <xsl:variable name="tag" select="f:elem-ref-to-tag($ref)"/>
    <xsl:if test='$page-key = "" or $page-key = $ref'>
      <xsl:result-document href='{$flavor}/entries/{$ref}.html'>
        <div id='entry-wrapper'>
          <span class="original">
            <a href="{$original-base-url}/element/{$tag}.html">Original</a>
          </span>
          <h1>
            &lt;<xsl:value-of select="$tag"/>&gt;
            <xsl:value-of select="f:elem-ref-to-name($ref)"/>
          </h1>
          <xsl:apply-templates select='*'/>
          
          <h2>Attributes</h2>
          <xsl:for-each select='$attr-sec/attr.info[
            attr.value.info/elem.value.group/elem.name.group/elem.name.ref/@elem.ref=$ref or
            profile.attr.info[@profile=$profile]/attr.value.info/elem.value.group/elem.name.group/elem.name.ref/@elem.ref=$ref ]'>
            <xsl:call-template name="attr.tag.ref">
              <xsl:with-param name="ref" select="@name"/>
              <xsl:with-param name="autolink" select="'yes'"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
            <xsl:call-template name="attr.name.ref">
              <xsl:with-param name="ref" select="@name"/>
              <xsl:with-param name="autolink" select="'yes'"/>
            </xsl:call-template>
            <br/>
          </xsl:for-each>
          
          <xsl:if test='content.model'>
            <xsl:call-template name="content.model"/>
          </xsl:if>
          
         
          <xsl:variable name='parents' select="$models/elem.info[descendant::elem.name.ref[@elem.ref=$ref]]"/>
          <xsl:choose>
            <xsl:when test="$parents">
              <div class='elementcontext'>
                <h3>This element may be contained in:</h3>
                <xsl:for-each select='$parents'>
                  <xsl:sort select="@elem.ref"/>
                  <xsl:call-template name='elem.tag.ref'>
                    <xsl:with-param name="ref" select="@name"/>
                    <xsl:with-param name="autolink" select="'yes'"/>
                  </xsl:call-template>
                  <xsl:if test='position() != last()'>
                    <xsl:text>, </xsl:text>
                  </xsl:if>
                </xsl:for-each>
              </div>
            </xsl:when>
            <xsl:otherwise>
              <div class='elementcontext'>
                <h3>This top-level element may not be contained in any other elements.</h3>
              </div>
            </xsl:otherwise>
          </xsl:choose>
          
          <xsl:apply-templates select='$examples/elem.examp[@name=$ref]'/>
        </div>
        
      </xsl:result-document>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name='content.model'>
    <xsl:variable name="tag" select="elem.tag"/>
    <xsl:variable name="ref" select="@name"/>
    
    <xsl:variable name="xsd-element" select="$schema/xsd:element[@name=$tag]"/>
    
    <xsl:if test='content.model[@expandedOrUnexpanded="both"] and $xsd-element//mtl:contentModel'>
      <div class='contentmodel'>
        <h2>Content Model</h2>
        <pre class='contentdesc'>
          <xsl:value-of select="concat('&lt;!ELEMENT  ', $tag, '  ')"/>
          <xsl:value-of select='$xsd-element//mtl:contentModel'/>
        </pre>
      </div>
    </xsl:if>
    
    <xsl:if test='$xsd-element//mtl:contentModelNoParm'>
      <div class='contentmodel'>
        <h2>Expanded Content Model</h2>
        <pre class='contentdesc'>
          <xsl:value-of select='$xsd-element//mtl:contentModelNoParm'/>
        </pre>
      </div>
    </xsl:if>
    
    <xsl:variable name="elem-model" select="$models/elem.info[$ref = @name]"/>
    <xsl:if test='$elem-model'>
      <div class='modeldesc'>
        <h2>Description</h2>
        <xsl:apply-templates select="$elem-model/node()">
          <xsl:with-param name="link-elems" tunnel="yes" select='true()'/>
        </xsl:apply-templates>
      </div>
    </xsl:if>
    
  </xsl:template>
  
  
  
  
  
  <xsl:template match="remarks">
    <h3>Remarks</h3>
    <xsl:apply-templates select="*"/>
  </xsl:template>
  
  <xsl:template match="attr.usage">
    <h3>Usage</h3>
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
    <xsl:variable name="ref" select="@name"/>
    <xsl:variable name="tag" select="f:attr-ref-to-tag($ref)"/>
    <xsl:if test='$page-key = "" or $page-key = $ref'>
      <xsl:result-document href='{$flavor}/entries/{$ref}.html'>
        <div id='entry-wrapper'>
          <span class="original">
            <a href="{$original-base-url}/attribute/{$tag}.html">Original</a>
          </span>
          <h1>
            @<xsl:value-of select="$tag"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="f:attr-ref-to-name($ref)"/>
          </h1>
          <xsl:apply-templates select='*'/>
          <xsl:apply-templates select='$examples/attr.examp[@name=$ref]'/>
        </div>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <xsl:template match="profile.elem.info[@profile=$profile]">
    <xsl:apply-templates select="*"/>
  </xsl:template>
  <xsl:template match="profile.attr.info[@profile=$profile]">
    <xsl:apply-templates select="*"/>
  </xsl:template>
  <xsl:template match="profile.pe.info[@profile=$profile]">
    <xsl:apply-templates select="*"/>
  </xsl:template>
  
  <xsl:template match="definition">
    <xsl:apply-templates select="*"/>
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
  
  <xsl:template match="suggested.values">
    <h4>Suggested Usage</h4>
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <xsl:template match="pe.info">
    <xsl:variable name="ref" select="@name"/>
    <xsl:variable name="tag" select="f:pe-ref-to-tag($ref)"/>
    <xsl:if test='$page-key = "" or $page-key = $ref'>
      <xsl:result-document href='{$flavor}/entries/{$ref}.html'>
        <div id='entry-wrapper'>
          <span class="original">
            <a href="{$original-base-url}/pe/{$tag}.html">Original</a>
          </span>
          <h1>
            <xsl:text>%</xsl:text>
            <xsl:value-of select="$tag"/>
            <xsl:text>; </xsl:text>
            <xsl:value-of select="f:pe-ref-to-name($ref)"/>
          </h1>
          <xsl:apply-templates select='*'/>

          <xsl:if test='content.model'>
            <xsl:call-template name="pe.content.model"/>
          </xsl:if>
          
        </div>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name='pe.content.model'>
    <xsl:variable name="tag" select="pe.tag"/>
    <xsl:variable name="ref" select="@name"/>
    <xsl:variable name="xsd-pe" select="$schema/xsd:annotation/xsd:appinfo/mtl:parameterEntity[@name=$tag]"/>


    <xsl:if test='content.model[@expandedOrUnexpanded="both"] and $xsd-pe//mtl:verbatimDeclaration'>
      <div class='contentmodel'>
        <h2>Content Model</h2>
        <pre class='contentdesc'>
          <xsl:value-of select='$xsd-pe//mtl:verbatimDeclaration'/>
        </pre>
      </div>
    </xsl:if>
    
    <xsl:if test='$xsd-pe//mtl:contentModelNoParm'>
      <div class='contentmodel'>
        <h2>Expanded Content Model</h2>
        <pre class='contentdesc'>
          <xsl:value-of select='$xsd-pe//mtl:contentModelNoParm'/>
        </pre>
      </div>
    </xsl:if>
    
    <xsl:variable name="elem-model" select="$models/elem.info[$ref = @name]"/>
    <xsl:if test='$elem-model'>
      <div class='modeldesc'>
        <h2>Description</h2>
        <xsl:apply-templates select="$elem-model/node()">
          <xsl:with-param name="link-elems" tunnel="yes" select='true()'/>
        </xsl:apply-templates>
      </div>
    </xsl:if>
    
    

  </xsl:template>


  <xsl:template match="attr.examp|elem.examp">
    <xsl:apply-templates select='*'/>
  </xsl:template>
  <xsl:template match="examp.group">
    <div class='examp.group'>
      <h3>Example 
        <xsl:if test='preceding-sibling::examp.group or following-sibling::examp.group'>
          <xsl:value-of select="position()"/>
        </xsl:if>
      </h3>
      <xsl:apply-templates select="*"/>
    </div>
  </xsl:template>

  <xsl:template match="tagged.examp">
    <div class='taggedexamp'>
      <pre class='taggedtext'>
        <xsl:apply-templates select='*'/>
      </pre>
    </div>
  </xsl:template>
  
  <xsl:template match='mtl:mksafe'>
    <xsl:variable name="highlight-attr" select="@attribute"/>
    <xsl:variable name="highlight-elem" select="@element"/>
    <xsl:variable name='example-document' 
      select='document(concat($profile-dir, "/", @file))'/>
    <xsl:variable name="example-tokens">
      <xsl:apply-templates select="$example-document" mode='tokenize'>
        <xsl:with-param name="highlight-elem" select="$highlight-elem"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name='elided'>
      <xsl:for-each-group select='$example-tokens/*' 
        group-starting-with="x:start-hellip|x:end-hellip">
        <xsl:choose>
          <xsl:when test="current-group()[1]/self::x:start-hellip">
            <x:hellip/>
          </xsl:when>
          <xsl:when test="current-group()[1]/self::x:end-hellip">
            <xsl:copy-of select='current-group()[position() > 1]'/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select='current-group()'/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each-group>
    </xsl:variable>

    <xsl:for-each-group select="$elided/*"
      group-starting-with="x:start-highlight|x:end-highlight">
      <xsl:choose>
        <xsl:when test="current-group()[1]/self::x:start-highlight">
          <strong>
            <span class='focus'>
              <xsl:apply-templates select='current-group()[position() > 1]' mode='serialize'>
                <xsl:with-param name="highlight-attr" select="$highlight-attr"/>
              </xsl:apply-templates>
            </span>
          </strong>
        </xsl:when>
        <xsl:when test="current-group()[1]/self::x:end-highlight">
          <xsl:apply-templates select='current-group()[position() > 1]' mode='serialize'>
            <xsl:with-param name="highlight-attr" select="$highlight-attr"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select='current-group()' mode='serialize'>
            <xsl:with-param name="highlight-attr" select="$highlight-attr"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:template match="processing-instruction()" mode="tokenize">
    <xsl:choose>
      <xsl:when test="name() = 'mtl' and .='hellip'">
        <x:start-hellip/>
      </xsl:when>
      <xsl:when test="name() = 'mtl' and .='/hellip'">
        <x:end-hellip/>
      </xsl:when>
      <xsl:otherwise>
        <x:pi name='{name()}' value='{string(.)}'/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- 
    Element highlighting is done when we tokenize, because then we can group by these
    highlighting tokens later. Note that attribute highlighting is done during serialization.
  -->
  <xsl:template match="*" mode="tokenize">
    <xsl:param name="highlight-elem"/>
    <xsl:if test='name() = $highlight-elem'>
      <x:start-highlight/>
    </xsl:if>
s    <x:start-tag name='{name()}'>
      <xsl:apply-templates select='@*' mode='tokenize'/>
    </x:start-tag>
    <xsl:apply-templates select="node()" mode='tokenize'>
      <xsl:with-param name="highlight-elem" select="$highlight-elem"/>
    </xsl:apply-templates>
    <x:end-tag name='{name()}'/>
    <xsl:if test='name() = $highlight-elem'>
      <x:end-highlight/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="@*" mode="tokenize">
    <x:attr name='{name()}'><xsl:value-of select="."/></x:attr>
  </xsl:template>
  <xsl:template match="text()" mode="tokenize">
    <x:text><xsl:value-of select="."/></x:text>
  </xsl:template>
  

  <xsl:template match="x:start-tag" mode="serialize">
    <xsl:param name="highlight-attr"/>
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:for-each select='x:attr'>
      <xsl:choose>
        <xsl:when test="@name = $highlight-attr">
          <xsl:text> </xsl:text>
          <strong>
            <span class='focus'>
              <xsl:value-of select="concat(@name, '=&quot;', ., '&quot;')"/>
            </span>
          </strong>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(' ', @name, '=&quot;', ., '&quot;')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>
  <xsl:template match="x:end-tag" mode="serialize">
    <xsl:value-of select="concat('&lt;/', @name, '&gt;')"/>
  </xsl:template>
  <xsl:template match="x:text" mode="serialize">
    <xsl:value-of select="."/>
  </xsl:template>
  <xsl:template match='x:hellip' mode="serialize">
    <xsl:text>...</xsl:text>
  </xsl:template>
  
  <xsl:template match='x:start-highlight' mode='serialize'>
    <xsl:text>[[[</xsl:text>
  </xsl:template>
  <xsl:template match='x:end-highlight' mode='serialize'>
    <xsl:text>]]]</xsl:text>
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
  <xsl:template match="section[@keep='yes']">
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
    <xsl:param name='ref' select='@elem.ref'/>
    <xsl:param name='autolink' select='not(@autolink) or @autolink != "no"'/>
    <xsl:variable name="span">
      <span class='elementtag'>&lt;<xsl:value-of 
        select="f:elem-ref-to-tag($ref)"/>&gt;</span>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$autolink">
        <a href='#p={$ref}' title='{f:elem-ref-to-name($ref)}'>
          <xsl:copy-of select='$span'/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select='$span'/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="elem.name.ref" name='elem.name.ref'>
    <xsl:param name='ref' select='@elem.ref'/>
    <xsl:param name='autolink' select='not(@autolink) or @autolink != "no"'/>
    <xsl:param name='link-elems' tunnel="yes" select='false()'/>
    <!-- In certain contexts (e.g., the "Description" part of the content model of an element), 
      <elem.name.ref>s should be rendered as a fully linked tag+name combination. This context is
      active when $link-elems is true. -->
    <xsl:choose>
      <xsl:when test="$link-elems">
        <xsl:call-template name='elem.tag.ref'>
          <xsl:with-param name="link-elems" tunnel='yes' select='false()'/>
          <xsl:with-param name="autolink" select='"yes"'/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:call-template name='elem.name.ref'>
          <xsl:with-param name="link-elems" tunnel='yes' select='false()'/>
          <xsl:with-param name="autolink" select='"yes"'/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="span">
          <span class='elementname'><xsl:value-of
            select="f:elem-ref-to-name($ref)"/></span>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$autolink">
            <a href='#p={$ref}' title='{concat("&lt;", f:elem-ref-to-tag($ref), "&gt;")}'>
              <xsl:copy-of select='$span'/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select='$span'/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="attr.tag.ref" name='attr.tag.ref'>
    <xsl:param name='ref' select='@attr.ref'/>
    <xsl:param name='autolink' select='@autolink'/>
    <xsl:variable name='span'>
      <span class='attrtag'>@<xsl:value-of select="f:attr-ref-to-tag($ref)"/></span>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$autolink='yes'">
        <a href='#p={$ref}' title='{f:attr-ref-to-name($ref)}'>
          <xsl:copy-of select='$span'/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select='$span'/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="attr.name.ref" name='attr.name.ref'>
    <xsl:param name='ref' select='@attr.ref'/>
    <xsl:param name='autolink' select='@autolink'/>
    <xsl:variable name="span">
      <span class='attrname'><xsl:value-of select="f:attr-ref-to-name($ref)"/></span>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$autolink='yes'">
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
    <xsl:param name='ref' select='@pe.ref'/>
    <xsl:param name='autolink' select='@autolink'/>
    <xsl:variable name='span'>
      <span class='petag'>%<xsl:value-of select="f:pe-ref-to-tag($ref)"/>;</span>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$autolink='yes'">
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
    <xsl:param name='ref' select='@pe.ref'/>
    <xsl:param name='autolink' select='@autolink'/>
    <xsl:variable name="span">
      <span class='pename'><xsl:value-of select="f:pe-ref-to-name($ref)"/></span>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$autolink='yes'">
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
    <!-- FIXME: need to get internal links working, see issue #1. -->
    <strong>
      <xsl:apply-templates select="node()"/>
    </strong>
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
  
  <xsl:template match='codeblock'>
    <pre class='codeblock'>
      <xsl:apply-templates select="*"/>
    </pre>
  </xsl:template>

</xsl:stylesheet>