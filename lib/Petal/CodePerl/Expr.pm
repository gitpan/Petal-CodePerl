use strict;

package Petal::CodePerl::Expr;

require Exporter;
use base 'Exporter';

use Petal::CodePerl::Expr::DerefTAL;
use Petal::CodePerl::Expr::PathExists;
use Petal::CodePerl::Expr::Alternate;

our %EXPORT_TAGS = (
	easy => [qw( dereft pathexists alternate )],
);

our @EXPORT_OK = @{$EXPORT_TAGS{"easy"}};

=head1 NAME

Code::Perl::Expr - Extra Code::Perl classes for Petal

=head1 DESCRIPTION

These are some extra L<Code::Perl> Expression classes that are specific to
Petal

=head1 EXPRESSION CLASSES

C<Petal::CodePerl::Expr> has been removed from the front of the class names,
so for example C<Alternate> is really C<Petal::CodePerl::Expr::Alternate>.

=cut

=head2 Alternate

  $class->new(Paths => \@paths);

  alternate(@paths);

@paths - an array of Expression objects

Alternate will try each expression in turn, looking for the first one which
evaluates without dieing.

=cut

sub alternate
{
	return Petal::CodePerl::Expr::Alternate->new(
		Paths => [@_],
	);
}

=head2 

  $class->new(Expr => $path);

  pathexists($path);

$path - an Expression object

PathExists will return true if the $path can be followed without dieing,
false otherwise

=cut

sub pathexists
{
	my $expr = shift;

	return Petal::CodePerl::Expr::PathExists->new(
		Expr => $expr,
	);
}

=head2 DerefTAL

  $class->new(Ref => $ref, Key => $key);

  dereft($ref, $key);

$ref - an Expression object
$key - a string

DerefTAL will attempt to dereference the object returned by $ref in the TAL
style, using the $key. This means if $ref yields a blessed reference the
$key will used as a method name if possible. If $key cannot be used as a
method name or $ref yielded an unblessed reference then DerefTAL tries to
dereference $ref as an array or a hash, using $key. If $ref doesn't yield a
reference then we die.

=cut

sub dereft
{
	my $ref = shift;
	my $key = shift;
	my $strict = shift || 0;

	return Petal::CodePerl::Expr::DerefTAL->new(
		Ref => $ref,
		Key => $key,
		Strict => $strict,
	);
}

1;

__END__

=head1 AUTHOR

Written by Fergal Daly <fergal@esatclear.ie>.

=head1 COPYRIGHT

Copyright 2003 by Fergal Daly E<lt>fergal@esatclear.ieE<gt>.

This program is free software and comes with no warranty. It is distributed
under the LGPL license

See the file F<LGPL> included in this distribution or
F<http://www.fsf.org/licenses/licenses.html>.

=cut

