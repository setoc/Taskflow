package App::Workflow;

use 5.016;
use strict;
use warnings;
use vars qw($VERSION);
$VERSION='1.00';
use Log::Log4perl qw(get_logger);
use Carp;
use App::Workflow::Task;
use App::Workflow::Condition;
use App::Workflow::Context;

=pod

=head1 NAME

Name here

=head1 SYNOPSIS

Synopsis here

=head1 DESCRIPTION

Description here

=head2 Methods

=over 12

=item C<$wf = App::Workflow::new ( arguments ) # exceptions>

Returns result based on arguments. Throws these exceptions.

=cut

sub new {
	my ($class, $params) = @_;
	my $log = get_logger();
	$log->info("Instantiating new $class");
	my $self = bless({},$class);
	$self->{conditions} = {};
	$self->{condition_names} = []; # ordered condtions
	$self->{tasks} = {};
	$self->{task_names} = []; # ordered tasks
	$self->{name} = 'null';
	$self->{description} = 'null';
	$self->{context} = App::Workflow::Context->new();
	return $self;
}

sub add{
	my ($self,$obj) = @_;
	my $log = get_logger();
	if($obj->isa('App::Workflow::Task')){
		$self->add_task($obj);
	}elsif($obj->isa('App::Workflow::Condition')){
		$self->add_condition($obj);
	}else{
		$log->error("unknown object type : $obj");
	}
}

sub reset{
	my $self = shift;
}

=item C<< $wf->add_task($state) >>

self explainatory

=cut

sub add_task {
	my ($self,$obj) = @_;
	my $log = get_logger();
	$log->error( "invalid class: $obj") if (not $obj->isa("App::Workflow::Task"));
	$log->info("Adding $obj->name to $self->name");
	$self->{tasks}{$obj->name} = $obj;
	push @{$self->{task_names}},$obj->name;
}
sub add_condition{
	my ($self,$obj) = @_;
	my $log = get_logger();
	$log->error( "invalid class: $obj") if (not $obj->isa("App::Workflow::Condition"));
	$log->info("Adding $obj->name to $self->name");
	$self->{conditions}{$obj->name} = $obj;
	push @{$self->{condition_names}},$obj->name;
}

=head2 Accessors

=item C<< $name = $wf->name() >>
=item C<< $description = $wf->description() >>
=item C<< $state = $wf->states($state_name) >>

=cut

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
sub task {
	my $self = shift;
	my $name = shift;
	return undef if (not defined $name);
	return $self->{tasks}{$name};
}
sub task_names {
	my $self = shift;
	return $self->{task_names};
}
sub condition{
	my $self = shift;
	my $name = shift;
	return undef if (not defined $name);
	return $self->{conditions}{$name};
}
sub condition_names {
	my $self = shift;
	return $self->{condition_names};
}

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