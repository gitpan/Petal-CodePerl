use strict;

package Petal::CodePerl;

our $VERSION = '0.03';

use Petal;

$Petal::CodeGenerator = 'Petal::CodePerl::CodeGenerator';

use Scalar::Util;

# we will need to access these routines from insides Petal's Safe
# compartment

*Petal::CPT::Petal::XML_Encode_Decode::encode = \&Petal::XML_Encode_Decode::encode;
*Petal::CPT::Scalar::Util::blessed = \&Scalar::Util::blessed;
*Petal::CPT::Scalar::Util::reftype = \&Scalar::Util::reftype;
*Petal::CPT::UNIVERSAL::can = \&UNIVERSAL::can;

1;

__END__

=head1 NAME

Petal::CodePerl - Make Petal go faster by compiling the expressions

=head1 SYNOPSIS

  use Petal::CodePerl;

  # contnue as you would normally use Petal

or

  use Petal;
	$Petal::CodeGenerator = 'Petal::CodePerl::CodeGenerator';
	
  # contnue as you would normally use Petal

=head1 DESCRIPTION

This module provides a CodeGenerator for L<Petal> that inherits almost
everything from L<Petal::CodeGenerator> but modifies how expressions are
dealt with. Petal normally includes code like this

  $hash->get( "not:user" )

in the compiled template. This means the path has to be parsed and
interpreted at runtime. Using Petal::CodePerl, Petal will now produce this

  ! ($hash->{"user"})

which will be much faster.

It uses L<Parse::RecDescent> to parse the PETALES expressions which makes it
a bit slow to load the module but this won't matter much unless you have
turned off caching. It won't matter at all for something like Apache's
mod_perl.

=head1 USAGE

You have two choices, you can replace C<use Petal> with C<use
Petal::CodePerl> in all your scripts or you can do C<$Petal::CodeGenerator =
'Petal::CodePerl::CodeGenerator'>. Either of these will cause Petal to use
the expression compiling version of the CodeGenerator.

=head1 EXTRA BONUSES

Using L<Parse::RecDescent> makes it easier to expand the PETALES grammar. I
have made the following enhancements.

=over 2

=item *

alternators work as in TAL, so you can do

  petal:content="a/name|b/name|string:no name"

=item *

you can explicitly ask for hash, array or method in a path

=over 2

=item *

user{name} is $hash->{"user"}->{"name"}

=item *

user[1] is $hash->{"user"}->[1]

=item *

user/method() is $hash->{"user"}->method()

using these will make your template even faster although you need to be
certain of your data types.

=back

=item *

method arguments can be any expression for example

  user/purchase cookie{basket}
  
will give

  $hash->{"user"}->purchase($hash->{"cookie"}->{"basket"})

=item *

you can do more complex defines, like the followiing

  petal:define="a{b}[1] string:hello"

which will give

  $hash->{"a"}->[1] = "hello"

=item *

some other stuff that I can't remember just now.

=back

=head1 STATUS

Petal::CodePerl is in development. There are no known bugs and Petal passes
it's full test suite using this code generator. However there are probably
some differences between it's grammar and Petal's current grammar. Please
let me know if you find anything that works differently with
Petal::CodePerl.

=head1 PROBLEMS

One slight problem is the handling of non-standard modifers. It is not
possible to use modifiers AND compiled expressions together, so expressions
that use modifiers will not be compiled at all, they will be evaluated at
runtime by Petal using C<$hash-E<gt>get( $expression )>. So basically
expressions that start with anything other than "string:", "not:", "path:",
"exists:", "perl:" will not gain any speedup.

Your templates may now generate "undefined value" warnings if you try to use
an undefined value. Previously, Petal prevented many of these from
occurring. As always, the best thing to do is not to avoid using undefined
values in your templates.

=head1 AUTHOR

Written by Fergal Daly <fergal@esatclear.ie>.

=head1 COPYRIGHT

Copyright 2003 by Fergal Daly E<lt>fergal@esatclear.ieE<gt>.

This program is free software and comes with no warranty. It is distributed
under the LGPL license

See the file F<LGPL> included in this distribution or
F<http://www.fsf.org/licenses/licenses.html>.

=cut
