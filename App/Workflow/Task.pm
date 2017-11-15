package App::Workflow::Task;

use 5.016;
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
	$self->{class} = "App::Workflow::Task::Null";
	$self->{description} = "null";
	$self->{conditions} = [];
	$self->{next} = [];
	return $self;
}

sub add_condition{
	my $self = shift;
	my $obj = shift;
	my $log = get_logger();
	$log->info("Adding $obj to $self->name");
	push @{$self->{conditions}} , $obj;
}
sub add_next{
	my ($self,$obj) = @_;
	my $log = get_logger();
	$log->info("Adding $obj to $self->name");
	push @{$self->{next}} , $obj;
}

sub execute {
	my $self = shift;
	my $context = shift;
	if(not $self->_test_conditions($context)){
		return 0;
	}
	
}

sub _test_conditions{
	my $self = shift;
	my $context = shift;
	foreach my $condition (@{$self->{conditions}}){
		if(not $condition->execute($context)){
			return 0;
		}
	}
	return 1;
}

sub _execute_class{
	my $self = shift;
	my $context = shift;
	my $class = $self->{class};
	eval "require $class";
	if($@){
		croak "couldn't load $class : $@";
	}
	if($class->can("execute")){
		$class->execute($context);
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