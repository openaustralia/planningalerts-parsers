#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;
use feature 'say';
use WWW::Mechanize;
use HTML::TreeBuilder::XPath;
use XML::Simple;

our $VERSION = '1.00';

=head1 NAME

moreland_scrape.pl

=head1 SYNOPSIS

  moreland_scrape.pl > moreland.xml

This script will print out the most-recent 15 planning permits advertised
by Moreland council. As long as the script is run every day or few, this will
suffice. (They don't release more than two or three per day)

=cut

# Define the URL we query:
our $GENERALENQUIRY =
    'https://eservices.moreland.vic.gov.au/ePathway/Production/Web/GeneralEnquiry/EnquiryLists.aspx';

# Define the URL to contact Moreland Council
our $contact_us_url = 'http://www.moreland.vic.gov.au/home-contact-us.html';

output_xml(find_results(fetch_doc()));

# Download the HTTP document and parse it with HTML::TreeBuilder
sub fetch_doc {
    my $mech = WWW::Mechanize->new;
    $mech->agent_alias('Windows Mozilla');
    $mech->get($GENERALENQUIRY);

    my %form = (
        'mDataGrid:Column0:Property' =>
            'ctl00$MainBodyContent$mDataList$ctl00$mDataGrid$ctl04$ctl00',
    );

    $mech->submit_form(
        with_fields => \%form,
        button => 'ctl00$MainBodyContent$mContinueButton',
    );

    # say $mech->status;
    die("Bad HTTP status: " . $mech->status . "\n" . $mech->content . "\n")
        unless $mech->status == 200;

    my $content = $mech->content;
    # write_file('enquirylist.html', $content);

    my $doc = HTML::TreeBuilder::XPath->new;
    eval {
        $doc->parse_content($content);
    };
    if ($@) {
        die "Failed to parse HTML, errors were: $@\n";
    }

    return $doc;
}

# Used for testing. Will load a pre-saved HTML file.
#sub doc_from_file {
#    my $doc = HTML::TreeBuilder::XPath->new;
#    use File::Slurp;
#    $doc->parse_content(read_file('enquirylist.html'));
#    return $doc;
#}

# Find the data we're looking for inside the HTML document.
sub find_results {
    my $doc = shift;
    my @results;
    my @nodes = $doc->findnodes(
'//table[@id="Table2"]/tr/td/div/table/tr/td/table/tr[@class="ContentPanel"]'
    );
    foreach my $node (@nodes) {
#        warn "first level node..";
#        warn "XML = " . $node->toString;
        my @href_nodes = $node->findnodes(
            'td/div[@class="ContentText"]/a'
        );
        my @span_nodes = $node->findnodes(
            'td/span[@class="ContentText"]'
        );
#        for my $td (@href_nodes, @span_nodes) {
#            say $td->toString;
#        }

        # Skip nodes that don't appear to be related to the list we want..
        next unless @href_nodes;
        next unless @span_nodes == 3;

        my $council_reference = flatten($href_nodes[0]);

        my $info_url = $href_nodes[0]->attr('href');

        my $date_received = flatten(shift @span_nodes);

        my $description = flatten(shift @span_nodes);

        my $address = flatten(shift @span_nodes);

        push(@results, {
            council_reference => $council_reference,
            info_url => $GENERALENQUIRY,
            date_received => date_to_iso($date_received),
            address => $address,
            description => $description,
            comment_url => $contact_us_url,
            date_scraped => date_scraped(),
        });
    }

    return \@results;
}

# Produce an XML document to STDOUT
sub output_xml {
    my $results = shift;
    my $xml = XML::Simple->new(
        ForceArray => 1,
        NoAttr => 1,
        RootName => 'planning',
    );

    my $doc = {
        authority_name => "Moreland Council, VIC",
        authority_short_name => "Moreland",
        applications => {
            application => $results,
        }
    };

    say '<?xml?>'; # The encoding is undefined; I don't know what Moreland
                   # uses..
    say $xml->XMLout($doc);
}

# Return an ISO8601 date of today.
sub date_scraped {
    my @time = localtime;
    return join('-', $time[5] + 1900, $time[4] + 1, $time[3]);
}

sub flatten {
    my $node = shift;
    my @children = $node->content_list;
    return join('', map { "$_" } @children);
}

sub date_to_iso {
    my $txt = shift;
    if ($txt =~ m{
            ^\s*
            (\d{1,2})
            /
            (\d{1,2})
            /
            (\d{2,4})
            \s*$
        }x
    ) {
        return "$3-$2-$1"
    }
}

=head1 AUTHOR

Toby Corkindale E<lt>tjc@cpan.orgE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

=cut

