#!/usr/local/bin/perl

use strict;
use DBI;

my $dbh = DBI->connect($ARGV[0], $ENV{'DBI_USER'}, $ENV{'DBI_PASS'},
                       { AutoCommit => 0, PrintError => 1, RaiseError => 1});

my $sth = $dbh->prepare("SELECT max(dmltrace_oid) FROM audit.dmltrace");
$sth->execute;
my $maxoid = $sth->fetchrow_arrayref()->[0];

my $sql = "UPDATE femalefertilityinterval SET starttype = ? WHERE animid = ?";
$sth = $dbh->prepare($sql);
my $rv = $sth->execute($ARGV[2], $ARGV[1]);

print "Executed with parameters $ARGV[2] and $ARGV[1]. Result value: $rv\n";

$sth = $dbh->prepare("SELECT dmltrace_oid, tablename, rowkey, optype, usr, tstamp FROM audit.dmltrace WHERE dmltrace_oid > ?");
$sth->execute($maxoid);
while (my $row = $sth->fetchrow_arrayref) {
    print join("\t",map { defined($_) ? $_ : "\\N" } @$row),"\n";
}

$dbh->rollback();
$dbh->disconnect();
