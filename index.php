<?php

if ($_GET['pmid']):

	$params = array(
		'db' => 'pubmed',
		'rettype' => 'xml',
		'id' => $_GET['pmid'],
	);

	$xml = new DOMDocument;
	$xml->load('http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?' . http_build_query($params));

	$xsl = new DOMDocument;
	$xsl->load(__DIR__ . '/convert.xsl');

	$processor = new XSLTProcessor;
	$processor->importStyleSheet($xsl);

	header('Content-Type: text/html; charset=UTF-8');
	print $processor->transformToXML($xml);
	exit();

endif;
?>

<form>
	<input type="text" name="pmid">
	<button type="submit">fetch</button>
</form>
