# $Header:$

use strict;

package Petal::CodePerl::Compiler;

use Code::Perl::Expr qw(:easy);
use Petal::CodePerl::Expr qw(:easy);

use Carp qw( confess );

use Data::Dumper qw(Dumper);

use Petal::CodePerl::Parser;

our $root = holder();

my $parser;

# handy for being able alter the grammar during development

if(0)
{
	require Parse::RecDescent;

	my $petales_grammar = do "grammar" || die "No grammar";

	local $Parse::RecDescent::skip = "";
	$::RD_HINT = 1;
	#$::RD_TRACE = 1;

	$parser = Parse::RecDescent->new($petales_grammar) || die "Parser didn't compile";
}
else
{
	$parser = Petal::CodePerl::Parser->new;
}

sub compile
{
	my $self = shift;

	my $expr = shift;

	return $self->compileRule("only_expr", $expr);
}

sub compileRule
{
	my $self = shift;

	my $rule = shift;

	my $expr = shift;

	my $expr_ref = ref($expr) ? $expr : \$expr;

	my $comp = $parser->$rule($expr_ref);

	if (length($$expr_ref))
	{
		confess "'$$expr_ref' was left unparsed";
	}

	return $comp;
}

1;
