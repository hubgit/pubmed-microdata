<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output
        encoding="UTF-8"
        indent="yes"
        method="xml"
        omit-xml-declaration="yes"
        standalone="yes"
        doctype-system="about:legacy-compat"/>

    <xsl:template match="PubmedArticleSet">
        <html>
            <head>
                <meta charset="utf-8"/>
                <title>
                    <xsl:value-of select="PubmedArticle/MedlineCitation/Article/ArticleTitle/text()"/>
                </title>
                <xsl:apply-templates select="PubmedArticle/PubmedData/ArticleIdList/ArticleId"/>
            </head>
            <body>
                <article itemscope="itemscope" itemtype="http://schema.org/medicalscholarlyarticle">
                    <header>
                        <xsl:apply-templates select="PubmedArticle/MedlineCitation/Article"/>
                    </header>

                    <footer>
                        <a href="http://pubmed.gov/{PubmedArticle/PubmedData/ArticleIdList/ArticleId[@IdType='pubmed']}">
                            View at PubMed
                        </a>
                    </footer>
                </article>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="Article">
        <xsl:apply-templates select="ArticleTitle"/>
        <xsl:apply-templates select="AuthorList"/>
        <xsl:apply-templates select="Journal"/>

        <h2>Abstract</h2>
        <div itemprop="description">
            <xsl:apply-templates select="Abstract/AbstractText"/>
        </div>
    </xsl:template>

    <xsl:template match="AuthorList">
        <h2>Authors</h2>
        <ul>
            <xsl:apply-templates select="Author"/>
        </ul>
    </xsl:template>

    <xsl:template match="Journal">
        <xsl:apply-templates select="JournalIssue/PubDate"/>
    </xsl:template>

    <xsl:template match="ArticleTitle">
        <h1 itemprop="name">
            <xsl:value-of select="."/>
        </h1>
    </xsl:template>

    <xsl:template match="Author">
        <li itemprop="author" itemscope="itemscope" itemtype="http://schema.org/person">
            <span itemprop="name">
                <xsl:choose>
                    <xsl:when test="ForeName">
                        <xsl:apply-templates select="ForeName"/>
                    </xsl:when>
                    <xsl:when test="Initials">
                        <xsl:apply-templates select="Initials"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="Name"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text> </xsl:text>
                <xsl:apply-templates select="LastName"/>
            </span>
        </li>
    </xsl:template>

    <xsl:template match="ForeName">
        <span itemprop="givenName">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>

    <xsl:template match="LastName">
        <span itemprop="familyName">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>

    <xsl:template match="Initials">
        <span>
            <xsl:value-of select="."/>
        </span>
    </xsl:template>

    <xsl:template match="Name">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="@Label" mode="abstract">
        <span class="label">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>

    <xsl:template match="AbstractText">
        <p>
            <xsl:apply-templates select="@Label" mode="abstract"/>
            <xsl:apply-templates select="node()"/>
        </p>
    </xsl:template>

    <xsl:template match="PubDate">
        <h2>Date Published</h2>
        <div itemprop="datePublished">
            <xsl:if test="Year">
                <xsl:if test="Month">
                    <xsl:value-of select="Month"/>
                    <xsl:if test="Day">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="Day"/>
                        <xsl:text>,</xsl:text>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="Year"/>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template match="ArticleId[@IdType='pubmed']">
        <link rel="canonical" href="http://pubmed.gov/{.}"/>
    </xsl:template>

    <xsl:template match="ArticleId[@IdType='doi']">
        <link rel="canonical" href="http://dx.doi.org/{.}"/>
    </xsl:template>

    <xsl:template match="*"> </xsl:template>
</xsl:stylesheet>