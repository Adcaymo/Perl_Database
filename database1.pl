#!/usr/bin/perl -wT

# Program:		Database program
# Author: 		Adrian Caymo
# Description:	The user enters personal information on a mock website which is then 
#				saved to a database.  The user is then redirected to a page displaying
#				the updated database.

#use strict;
use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use DBI;

my $db = "ad660161511";
my $user = "ad660161511"; 
my $pass = "53a56901"; 
my $host = "localhost"; 

# store data from html 
my $firstname = param('firstname');
my $lastname = param('lastname');
my $address = param('address');
my $city = param('city');
my $state = param('state');
my $zipcode = param('zipcode');

my $gender = param('gender');
if ($gender eq "Male") {
	$gender = 0;
} else {
	$gender = 1;
}

my @colors = param('colors');
my $colors = "";
foreach (@colors) {
	$colors = join(", ", @colors);
}

my $sports = "";
my @sports = param('favoritesport');
foreach (@sports) {
	$sports = join(", ", @sports);
}

my $file = param('file');

# generate today's date
my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime();
my $date = (1900 + $year) . "-" . $mon . "-" . $mday . " " . $hour . ":" . $min . ":" . $sec;

# connect to database
my $dbh = DBI->connect("DBI:mysql:$db:$host", $user, $pass) or die $DBI::errstr;

# prepare query statement
my $query = "insert into 
	FormData(FirstName, LastName, Address, City, State, ZipCode, 
	Gender, Color, Sports, FileContents, DateEntered) 
	values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
my $sth = $dbh->prepare($query) or &dbdie;

# execute query statement
$sth->execute($firstname, $lastname, $address, $city, $state, $zipcode, 
			  $gender, $colors, $sports, $file, $date) or &dbdie;

$sth->finish;

$dbh->disconnect;

# redirect to second script
print redirect('https://linuxsandbox.coleman.edu/~ad660161511/cgi-bin/database2.pl');

# Subroutines
sub dbdie {
	my ($package, $filename, $line) = caller;
	my ($errmsg) = "Database error: $DBI::errstr<br>
		called from $package $filename line $line";	
	&dienice($errmsg);
}

sub dienice {
	my($msg) = @_;
	print header;
	print start_html("Error");
	print "<h2>Error</h2>\n";
	print $msg;
	exit;
}