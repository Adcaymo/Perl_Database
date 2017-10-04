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

print header;
print start_html("Display Query");

my $db = "ad660161511";
my $user = "ad660161511"; 
my $pass = "53a56901"; 
my $host = "localhost"; 

# connect to database
my $dbh = DBI->connect("DBI:mysql:$db:$host", $user, $pass) or die $DBI::errstr;

# prepare query statement
my $query = "Select * From FormData";
my $sth = $dbh->prepare($query) or &dbdie;

# execute query statement
$sth->execute or &dbdie;

print <<TableHeader;
	<table style="table-layout:fixed; width:100%;" border="1">
	<tr>
		<td>ID</td>
		<td>First Name</td>
		<td>Last Name</td>
		<td>Address</td>
		<td>City</td>
		<td>State</td>
		<td>Zipcode</td>
		<td>Gender</td>
		<td>Colors</td>
		<td>Sports</td>
		<td>File Contents</td>
		<td>Date</td>
	</tr>
	</table>
TableHeader

# print query statement to html
while (my($id, $firstname, $lastname, $address, $city, $state, $zipcode, $gender, $colors, 
		$sports, $file, $date) = $sth->fetchrow_array) {
print <<Table;
	<table style="table-layout:fixed; width:100%;" border="1">
	<tr>
		<td>$id</td>
		<td>$firstname</td>
		<td>$lastname</td>
		<td>$address</td>
		<td>$city</td>
		<td>$state</td>
		<td>$zipcode</td>
		<td>$gender</td>
		<td>$colors</td>
		<td>$sports</td>
		<td><img src="$file"></td>
		<td>$date</td>
	</tr>
	</table>
Table
}

print end_html;

$sth->finish;

$dbh->disconnect;

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