package App::Workflow::Condition;

use 5.010;
use strict;
use warnings;
use Log::Log4perl qw(get_logger);
use Carp;
use vars qw($VERSION);
$VERSION='1.00';


=pod

=head1 NAME

Name here

=head1 SYNOPSIS

Synopsis here

=head1 DESCRIPTION

Description here

=head2 Methods

=over 12

=item C<result = function ( arguments ) # exceptions>

Returns result based on arguments. Throws these exceptions.

=cut

sub new {
	my ($class, $params) = @_;
	my $log = get_logger();
	$log->info("Instantiating new $class");
	my $self = bless({},$class);
	$self->{name} = "null";
	$self->{class} = "App::Workflow::Condition::Null";
	$self->{description} = "null";
	return $self;
}

sub execute{
	my $self = shift;
	my $context = shift;
	my $func_name = $self->{name};
	my $class_name = $self->{class};
	
	eval "require $class_name";
	if($@){
		croak "couldn't load $class_name : $@";
	}
	if($class_name->can($func_name)){
		$class_name->$func_name($context);
	}else{
		carp "class can't perform function : $class_name , $func_name";
	}
}

sub name {
	my $self = shift;
	my $new_val = shift;
	$self->{name} = $new_val if (defined $new_val);
	return $self->{name};
}
sub description {
	my $self = shift;
	my $new_val = shift;
	$self->{description} = $new_val if (defined $new_val);
	return $self->{description};
}
sub class {
	my $self = shift;
	my $new_val = shift;
	$self->{class} = $new_val if (defined $new_val);
	return $self->{class};
}

=item C<do_something($with_stuff)>

self explainatory

=back

=head1 CAVEATS

Caveats or bugs here

=head1 ACKNOWLEDGEMENTS

Acknowledgements here

=head1 COPYRIGHT

Copyright My Company 2017

=head1 AVAILABILITY

location on the interwebs

=head1 AUTHOR
 
 Yours Truly, yt@example.com
 
=head1 SEE ALSO
 
 This other amazing documentation
 L<name/sec>
 https://example.com

=cut




1;