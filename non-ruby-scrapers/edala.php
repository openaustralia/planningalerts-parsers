<?php
/**
 * Quick and dirty scraper for EDALA.
 *
 * Requires Net_URL, simplexml, and the tidy extension.
 */
require_once 'Net/URL.php';

function clean($data) {
    $tidy = new tidy();
    $options = array('output-xml' => true, 'clean' => true, 'indent' => true, 'output-xhtml' => true, 'char-encoding' => 'utf8');


    return str_replace("&nbsp;", "", $tidy->repairString($data, $options));
}

function fetch_index($from) {

    $url = new Net_URL("https://www.edala.sa.gov.au/edala/EDALAView.aspx?PageMode=ApplicationSearchResultsView&hdnCoAId=&SearchType=View&ReferenceNumber=&DevelopmentNumber=&ApplicationStatusId=&CoAStageStatusId=&UseAdvancedSearch=1&dLodgedFrom=1+Dec+2009&dLodgedTo=1+Dec+2009&ApplicantFirstName=&ApplicantLastName=&ApplicantOrganisation=&OwnerFirstName=&OwnerLastName=&OwnerOrganisation=&CouncilId=&TitleReferenceTypeId=&Volume=&Folio=&PlanTypeId=&PlanNumber=&ParcelNumber=&Hundred=&ReferenceSection=&HouseNumber=&LotNumber=&AddressStreet=&AddressSuburb=&CoAStageNumber=&DPNumber=&SortBy=LodgementDate");
    $url->querystring['dLodgedFrom'] = urlencode($from);
    $url->querystring['dLodgedTo'] = urlencode($from);

    return $url->getURL();
}

function fetch_individual($id) {
    $url = new Net_URL("https://www.edala.sa.gov.au/edala/EDALAView.aspx?PageMode=ApplicationDisplayView&ApplicationId=" . $id);

    return $url->getURL();
}

$d = !empty($_GET['day'])? $_GET['day'] : date("D");
$m = !empty($_GET['month'])? $_GET['month'] : date("M");
$y = !empty($_GET['year'])? $_GET['year'] : date("Y");

$from = date("d M Y", strtotime("$d $m $y"));

$url = fetch_index($from);

$xml = clean(file_get_contents($url));

$sxe = simplexml_load_string($xml);
$sxe->registerXPathNamespace("xhtml", "http://www.w3.org/1999/xhtml");
$rows = $sxe->xpath('//xhtml:table[@id="General_0"]/xhtml:tbody/xhtml:tr[@class="content"]');


?>
<?xml version="1.0" encoding="UTF-8"?>
<planning>
  <authority_name>Department of Planning and Local Government (SA)</authority_name>
  <authority_short_name>EDALA</authority_short_name>
  <applications>
  <?php
    if (!empty($rows)) {
      foreach ($rows as $tr) {
        $id = trim((string)$tr->td[0]->a[0]);

        $link = fetch_individual($id);

        $date = date("Y-m-d", strtotime(trim((string)$tr->td[2])));

        $xml = str_replace('utf-16', 'utf-8', clean(file_get_contents($link)));


        $another_sxe = simplexml_load_string($xml);
        $another_sxe->registerXPathNamespace("xhtml", "http://www.w3.org/1999/xhtml");

        $summary = $another_sxe->xpath("/xhtml:html/xhtml:body/xhtml:table/xhtml:tbody/xhtml:tr[2]/xhtml:td/xhtml:table[3]/xhtml:tbody/xhtml:tr[3]/xhtml:td[2]");
        $description = trim((string)$summary[0]);

        list($tbody) = $another_sxe->xpath('//xhtml:table[@id="propterydetail1_0"]/xhtml:tbody');

        $house_number = trim((string)$tbody->tr[1]->td[1]);
        $lot_number   = trim((string)$tbody->tr[2]->td[1]);
        $street       = trim((string)$tbody->tr[3]->td[1]);
        $suburb       = trim((string)$tbody->tr[4]->td[1]);


        $parts = array();
        if (!empty($lot_number)) {
            $parts[] = $lot_number;
        }

        if (!empty($house_number)) {
            $parts[] = $house_number;
        }

        $address = trim(implode("/", $parts) . " " . $street . ", " . $suburb);

        ?>
        <application>
          <council_reference><?php print htmlentities($id); ?></council_reference>
          <address><?php print htmlentities($address); ?></address>
          <description><?php print htmlentities($description); ?></description>
          <info_url><?php print htmlentities($link); ?></info_url>

          <comment_url><?php print htmlentities($link); ?></comment_url>
          <date_received><?php print $date; ?></date_received>
        </application>
        <?php } ?>
    <?php } ?>
  </applications>
</planning>