#!/usr/bin/perl

# This script was originally written for http://www.planningalerts.org.au/
# It will attempt to scrape development application from Kogarah City Council,
# filter this based on program arguments, and produces the resulting formatted
# data in an XML format consistant with the example provided at 
# http://www.planningalerts.org.au/brisbane.xml
#
# Copyright status of this code is:
# To the extent possible under law, the person who associated CC0 with this work
# has waived all copyright and related or neighboring rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/
# i.e. "copyright free to the extent possible under law."
#
# The author belives that as per IceTV v Nine Network [2009] HCA 14,
# http://www.austlii.edu.au/cgi-bin/sinodisp/au/cases/cth/HCA/2009/14.html
# that any data that this program produces as output from given input is not 
# subject to the copyright of the original content.


# == ARGUMENTS ==
# We can either take arguments from CGI (like when you execute this script over 
# the web and pass arguments like ?arg1=value2&arg2=value2
#   OR
# We can take them from the command line arguments.

# command line arugments example
# ./file --day 05 --month 12 --year 2009

# cgi paramaters example
# file.cgi?day=05&month=12&year=2009

# if day is ommited we will not place that constrain on the results (all returned)
# but if month or year are ommited we will use the current year and month from
# the system (at the time of writting you could only access this month or last
# month anyway)

# This script also needs to have permission to write in the current directory,
# to save a file to store cookies.

# Check the exit status of this program! If its not 0 then you probably don't 
# have valid data or even valid XML. There is probably an error message in STDOUT.

$main::VERSION = '0.1';

use warnings;
use strict;

use DateTime;
use LWP::Simple qw(!head); # the !head means don't export that function because it clashes with CGI's head function.
use LWP::UserAgent;
use HTTP::Cookies;
use HTTP::Request::Common qw(POST);
use HTML::Element;
use HTML::Parser;
use HTML::Entities;
#use URI::Escape;

my $EXECUTION_METHOD = 'commandline'; #set to either 'cgi' or 'commandline'

#arguments (set below)
my $day;
my $month;
my $year;

my $help;

if ($EXECUTION_METHOD eq 'commandline') {
    use Getopt::Long qw(:config auto_version);
    GetOptions ('day:i' => \$day, # = means required, : means optional (i means int type)
                'month:i' => \$month,
                'year:i' => \$year,
                'help' => \$help);
                
    if ( (defined $day && ($day !~ /^\d+$/)) ||
         (defined $month && ($month !~ /^\d+$/)) || 
         (defined $year && ($year !~ /^\d+$/)) ) {
        die "Arguments not numbers.";
    }
    
    if ($help) {
        print "  --day\t\t(Optional) DA applications only matching --day for their submission date are shown.\n";
        print "  --month\t(Optional) DA applications only matching --month for their submission date are shown.\n";
        print "  --year\t(Optional) DA applications only matching --year for their submission date are shown.\n";
        exit;
    }
    
}elsif ($EXECUTION_METHOD eq 'cgi') {
    use CGI qw/:all/;
    my $cgi = CGI->new;
    $day = $cgi->param('day');
    $month = $cgi->param('month');
    $year = $cgi->param('year');
    
    if ( (defined $day && ($day !~ /^\d+$/)) ||
         (defined $month && ($month !~ /^\d+$/)) || 
         (defined $year && ($year !~ /^\d+$/)) ) {
        die "Arguments not numbers.";
    }
    print "Content-type: text/xml\n\n";
}else{
    die;
}

my $WEB_URL_PREFIX = 'http://www2.kogarah.nsw.gov.au/datracking/modules/applicationmaster/';

# =========================================================
#     SCRAPING
# =========================================================

my $ua = LWP::UserAgent->new;

#we need to save the cookies so lets set up our user agent ($ua) to save cookies
$ua->cookie_jar(HTTP::Cookies->new(file => "${0}_lwpcookies.txt", autosave => 1));

#lets make an initial request
my $tc_req = $ua->request(HTTP::Request->new(GET => "${WEB_URL_PREFIX}default.aspx"));
if (!$tc_req->is_success) { die "Some problem with downloading from the council web site.\n"; }
my $starting_page = $tc_req->as_string;
#a cookie should have been set, and we should have been served the "accept our 
#terms and conditions" page.

#grab the hidden form value that we need to submit with each request
my @html_lines = split /\n/, $starting_page;
@html_lines = grep(/__VIEWSTATE/, @html_lines);
my $viewstate = $html_lines[0]; #the cookie value for __VIEWSTATE
$viewstate =~ s/.*value=\"?//;
$viewstate =~ s/\".*//;

my $in_req = POST "${WEB_URL_PREFIX}default.aspx?page=search",
             ['_ctl2:Button1' => ' I Agree', 
              '__VIEWSTATE' => "$viewstate"];

my $new_address = $ua->request($in_req)->as_string;

my $home_req = $ua->request(HTTP::Request->new(GET => "${WEB_URL_PREFIX}default.aspx?page=search"));
if (!$home_req->is_success) { die "Some problem with downloading from the council web site.\n"; }
my $home = $home_req->as_string;

#okay we are logged in and everything, now start making requests for the data

my $post_url;
$year = DateTime->now->year if (!defined $year);
$month = DateTime->now->month if (!defined $month);
if (($year == DateTime->now->year) &&
    ($month == DateTime->now->month)) {
    $post_url = "${WEB_URL_PREFIX}".'default.aspx?page=found&1=thismonth&4a=9&6=F';
    
}elsif (($year == DateTime->now->subtract(months => 1)->year) && 
        ($month == DateTime->now->subtract(months => 1)->month)) {
    $post_url = "${WEB_URL_PREFIX}".'default.aspx?page=found&1=lastmonth&4a=9&6=F';
    
}else{
    die "Sorry Kogarah Council appears to only supply Development Application records for the last two months.";
}

#make a request for a page listing all the DA's for the specified year and month
my $data_req = POST "$post_url",
               ['_ctl2:ALL' => 'All Wards', 
                #'_ctl3:drDates:txtDay1' => "$day", '_ctl3:drDates:txtDay2' => "$day", #doesn't seem to work. okay, we'll filter them out ourselfs
                '_ctl3:drDates:txtMonth1' => "$month", '_ctl3:drDates:txtMonth2' => "$month", 
                '_ctl3:drDates:txtYear1' => "$year", '_ctl3:drDates:txtYear2' => "$year" ];

my $html_req = $ua->request($data_req);
if (!$html_req->is_success) { die "Some problem with downloading from the council web site.\n"; }

my $html_data = $html_req->as_string;

# =========================================================
#     PARSING/PRINTING
# =========================================================

#the data that we want is in HTML format in $html_data, now we just need to parse it.

my $src = $html_data;

#lets just get the <table> ... </table> section with the data in it
$src =~ s/.*<html>/<html>/s;
$src =~ s/.*<table id=\"_ctl2_pnl\"/<table id=\"_ctl2_pnl\"/s;
$src =~ s/<table id=\"_ctl3_pnlSearch\".*//s;

use HTML::TableExtract qw(tree);
                        
my $te = HTML::TableExtract->new(headers => [ '', 'Application', 'Date', 'Description']); 
                        
$te->parse($src);

print '<?xml version="1.0" encoding="UTF-8"?>
<planning>
  <authority_name>Kogarah City Council, NSW</authority_name>
  <authority_short_name>Kogarah</authority_short_name>
  <applications>
';

foreach my $ts ($te->tables) {
    foreach my $row ($ts->rows) {
        my $da_info_url = @$row[0]->as_HTML();
        $da_info_url =~ /<a href="([^"]*)"/;
        $da_info_url = $1;
        $da_info_url =~ s/ +$//g;
        $da_info_url = "${WEB_URL_PREFIX}$da_info_url";
        #although currently this url appear useless as you need to have a certain
        #the cookie or POST data. otherwise they redirect you to the terms and 
        #conditions and then they never redirect you once you agree
        
        my $da_council_reference = @$row[1]->as_text();
        my $da_date_received = @$row[2]->as_trimmed_text();
        my ($da_description, $da_address) = split /<br *\/?>/, @$row[3]->as_HTML();
        $da_description =~ s/ +$//gs;

        #because the description and address were set with HTML to keep the <br \> 
        #that distinguishes the two, we need to strip out all HTML.
        #this should be enough
        $da_description =~ s/<[^>]*>//gs;
        $da_address =~ s/<[^>]*>//gs;
        $da_address = uc $da_address;
        $da_address =~ s/,//gs;
        $da_address =~ s/ +/ /gs;
        $da_address =~ s/ +$//gs;
        $da_address =~ s/^ +//gs;
        $da_address =~ s/\n//gs;
        $da_date_received =~ /(\d+)\/(\d+)\/(\d+)/;
        my $da_day = $1;
        my $da_month = $2;
        my $da_year = $3;
        if ( ((!defined $day) || ($da_day == $day)) && 
             ((!defined $month) || ($da_month == $month)) && 
             ((!defined $year) || ($da_year == $year)) ) {
            $da_date_received = "$da_year-$da_month-$da_day";
            
            $da_council_reference = encode_entities($da_council_reference);
            $da_address = encode_entities($da_address);
            $da_description = encode_entities($da_description);
            #don't decode $da_info_url. an ampersand should be &amp; in the XML file
            
            #lets do some checking, because scraping like this is risky as it may
            #break if the format or layout of the content changes (this is why
            #kogarah council should provide all this data in an XML format to 
            #begin with. it would be much cheaper!)
            if ($da_council_reference !~ /\d+ \/ \d+ \/ \d+/) {
                die "The parsed council reference looks wrong. This may indicate a problem.\n";
            }elsif ($da_info_url !~ /^http/) {
                die "The parsed more info url doesn't start with http. This may indicate a problem.\n";
            }elsif ($da_date_received !~ /\d+-\d+-\d+/) {
                die "The parsed date recieved looks wrong. This may indicate a problem.\n";
            }
            

print "    <application>
      <council_reference>$da_council_reference</council_reference>
      <address>$da_address NSW</address>
      <description>$da_description</description>
      <info_url>$da_info_url</info_url>
      <comment_url></comment_url>
      <date_received>$da_date_received</date_received>
    </application>
";
            #I was following the example brisbane.xml very closelly here
            #however I don't have the postcode as in brisbane.xml
            #There is no url for comments, but the page that lists more details
            #has an email contact which is linked to in the form,
            #mailto:kmcmail@kogarah.nsw.gov.au?subject=Development%20Application%20Enquiry:%20009/2009/00000362/001%20&Body=
            #where 009/2009/00000362/001 is the council reference
        }
    }
}

print '  </applications>
</planning>
';

exit;
