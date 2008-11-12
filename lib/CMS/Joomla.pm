#
# CMS::Joomla - Joomla! CMS configuration and database access Perl module
#
# Copyright (c) 2008 EPIPE Communications <http://epipe.com/>
# 
# This program is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.
#

package CMS::Joomla;

use warnings;
use strict;

use DBI;
use IO::File;

our $VERSION = '0.01';

=head1 NAME

CMS::Joomla - Joomla! CMS configuration and database access Perl module


=head1 SYNOPSIS

Read Joomla! configuration variables:

    use CMS::Joomla;

    my ($joomla) = CMS::Joomla->new("/path/to/joomla/configuration.php");

    print "Site name: " . $joomla->cfg->{'sitename'} . "\n";


Access Joomla! database:

    my ($jdb) = $joomla->dbhandle(undef);
    my ($sth) = $jdb->prepare("SELECT introtext "
	. "FROM " . $joomla->cfg->{'dbprefix'} . "content "
	. "WHERE title=?");

    $sth->execute("about");

    while (my ($introtext) = $sth->fetchrow_array) {
      print "$introtext\n";
    }

    ...

=head1 DESCRIPTION

This module provides an interface for reading Joomla! CMS configuration
variables and connecting to the Joomla! database from Perl script.

=head1 CONSTRUCTOR

=head2 new(I<CFGFILE>)

Creates C<CMS::Joomla> object. The I<CFGFILE> parameter should be a 
file name of a valid readable Joomla! F<configuration.php> file. 
Returns undef in case of error.

=cut

sub new ($$) {
  my $type = shift;
  my $cfgname = shift;
  my $self = {};
  bless $self, $type;
  $self->{'_cfgname'} = $cfgname;
  $self->{'_phptype'} = undef;
  $self->{'cfg'} = $self->_jcfgread($cfgname);
  return defined($self->{'cfg'}) ? $self : undef;
}

=head1 METHODS

=head2 cfg(I<>)

Return a reference to a hash containing all Joomla! configuration
variables in this C<CMS::Joomla> object. 

=cut

sub cfg ($) {
  my $self = shift;

  return $self->{'cfg'};
}

=head2 dbhandle(I<ARGS>)

Returns a C<DBI> database handle object which is connected to the
corresponding Joomla! database. See L<DBI> for more information
on how to use the returned database handle. Consecutive calls to
this function will return the same C<DBI> handle instead of opening
a new connection each time.

I<ARGS> is passed directly to the C<DBI> handle constructor. 

Returns undef in case of error.

=cut

sub dbhandle ($$) {
  my $self = shift;
  my $opt = shift;
  my $dbtype = $self->{'cfg'}->{'dbtype'};

  $dbtype =~ s/mysqli/mysql/;

  return $self->{'_dbhandle'} if defined($self->{'_dbhandle'});

  $self->{'_dbhandle'} = DBI->connect("dbi:$dbtype:"
      . 'database=' . $self->{'cfg'}->{'db'} 
      . ';host=' . $self->{'cfg'}->{'host'},
      $self->{'cfg'}->{'user'}, $self->{'cfg'}->{'password'}, $opt);

  return $self->{'_dbhandle'};
}


=head1 SEE ALSO

L<DBI>, L<DBD::mysql>, L<http://dist.epipe.com/joomla/perl/>


=head1 AUTHOR

EPIPE Communications E<lt>epipe at cpan.orgE<gt> L<http://epipe.com/>


=head1 COPYRIGHT & LICENSE

Copyright (c) 2008 EPIPE Communications L<http://epipe.com/>

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

sub _probephp {
  my ($r) = `php -v`;
  if (defined($r) && $r =~ /PHP/) {
    # have php command-line binary
    return 1;
  }
  # no have
  return 0;
}

sub _jcfgread_cmdline ($$) {
  my $self = shift;
  my $cfgname = shift;
  my %cfg;

  return undef unless defined($cfgname);

  my ($php) = '
      require_once("' . $cfgname . '");
      $c = new JConfig();
      foreach ($c as $key => $value) {
        echo "$key: \"$value\"\n";
      }';

  
  my $r = `php -r '$php'`;

  return undef unless $r;

  while ($r =~ /^(\w+): \"([^\"]*?)\"$/m) {
    $cfg{$1} = $2;
    $r = $';
  }
  return \%cfg;
}

sub _jcfgread_kludge ($$) {
  my $self = shift;
  my $cfgname = shift;
  my %cfg;
  my $str;

  return undef unless defined($cfgname);

  my $fh = IO::File->new($cfgname, '<');

  return undef unless defined($fh);

  $str = join('', $fh->getlines());

  while ($str =~ /^\s*var\s+\$(\w+)\s+=\s+\'([^\']*?)\'\;\s*$/m) {
    $cfg{$1} = $2;
    $str = $';
  }
  return \%cfg;
}

sub _jcfgread ($$) {
  my $self = shift;
  my $cfgname = shift;

  if (!defined($self->{'_phptype'})) {
    $self->{'_phptype'} = $self->_probephp();
  }

  if ($self->{'_phptype'} == 1) {
    # use command-line php binary
    return $self->_jcfgread_cmdline($cfgname);
  } else {
    # phptype is 0 or unknown, use internal parser kludge
    return $self->_jcfgread_kludge($cfgname);
  }

}

1; # End of CMS::Joomla
