package App::TaskMaster;
use vars qw($VERSION);
$VERSION = '1.00';
use 5.016;
use strict;
use warnings;
use Carp;
use XML::Simple qw(:strict);
use Log::Log4perl qw(get_logger);
use Data::Dumper;

=head1 NAME

TaskMaster - shell and perl batcher

=head1 DESCRIPTION

Describe batches in xml using shell commands and perl functions. Step through 
the tasks with the TaskMaster and log the results.
The TaskMaster xml file describes available tasks and parameters. Each Task is
defined in a task xml file where the commands and functions are specified as 
steps.
TASK
  PARAMETERS

STEP
  CMD|FUNC
    PARAMETERS

=cut

sub new{
	my $class = shift;
	my (%options) = @_;
	my $self = bless({},$class);
	$self->_init(\%options);
	return $self;
}

sub _init{
	my $self = shift;
	my $options = shift;
	$self->{tasks} = [];
    $self->{params} = {};

	my $taskmaster_xml = $options->{'taskmaster_xml'};
    $self->_load_taskmaster_config($taskmaster_xml) if defined $taskmaster_xml;
    
    my $tasks_xml = $options->{tasks_xml};
	$self->_load_task_config($tasks_xml) if defined $tasks_xml;
}
sub _load_taskmaster_config{
	my $self = shift;
	my $xml = shift;
	my $config = XMLin($xml, KeyAttr=>{},ForceArray=>['next','param','task']);
	#TODO: VALIDATE DATA

	#CREATE TASK OBJECTS FOR EACH TASK
	foreach my $item (@{$config->{task}}){
        
		push @{$self->{tasks}} , $item;
	}
    foreach my $item(@{$config->{param}}){
        $self->{params}{$item->{name}} = $item->{value};
    }
    print Dumper($self->{params});
}
sub _load_task_config{
	my $self = shift;
	my $xml = shift;
	my $config = XMLin($xml, KeyAttr=>{},ForceArray=>['step','param','task']);
	#TODO: VALIDATE DATA

	#CREATE TASK OBJECTS FOR EACH TASK
	foreach my $item (@{$config->{task}}){
		push @{$self->{tasks}} , Task->new($item);
	}
}

sub get_task_names{

}





1;
