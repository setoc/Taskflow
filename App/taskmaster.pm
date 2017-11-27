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

use App::Task;
use App::Context;

=head1 NAME

TaskMaster - shell and perl batcher

=head1 DESCRIPTION

Describe batches in xml using shell commands and perl functions. Step through 
the tasks with the TaskMaster and log the results.
The TaskMaster xml file describes available tasks and parameters. Each Task is
defined in a task xml file where the commands and functions are specified as 
steps.
TASKMASTER
  PARAM *
  TASK_REF *
    PARAM *

TASKS
  TASK *
    CONDITION *
    CMD *
      PARAM *
    NEXT *

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
    $self->{task_refs} = [];
	$self->{tasks} = {};
    $self->{params} = {};
    # state variables
    $self->{current_task} = undef; # name of current task used to find list of next tasks
    $self->{context} = App::Context->new();

	my $taskmaster_xml = $options->{taskmaster_xml};
    $self->_load_taskmaster_config($taskmaster_xml) if defined $taskmaster_xml;
    
    my $tasks_xml = $options->{tasks_xml};
	$self->_load_task_config($tasks_xml) if defined $tasks_xml;
	
	my $conditions_xml = $options->{conditions_xml};
	$self->_load_condition_config($conditions_xml) if defined $conditions_xml;
}

sub _load_taskmaster_config{
	my $self = shift;
	my $xml = shift;
	my $config = XMLin($xml, KeyAttr=>{},ForceArray=>['next','param','task']);
	#TODO: VALIDATE DATA

	#CREATE TASK OBJECTS FOR EACH TASK
	foreach my $item (@{$config->{task}}){
		push @{$self->{task_refs}} , _create_task_ref($item);
	}
    foreach my $item(@{$config->{param}}){
        $self->{params}{$item->{name}} = $item->{value}; # keep list of params for resetting the context
        $self->{context}->item($item->{name} , $item->{value});
    }
}

sub _create_task_ref{
	my $item = shift;
	my $task = {};
	$task->{name} = $item->{name};
    $task->{status} = 'none'; # none, in_progress, successful, failed
	foreach my $param (@{$item->{param}}){
        $task->{params}{$param->{name}} = $param->{value};
    }
	return $task;
}

sub _load_task_config{
	my $self = shift;
	my $xml = shift;
	my $config = XMLin($xml, KeyAttr=>{},ForceArray=>['condition','cmd','next','param','task']);
	#TODO: VALIDATE DATA

	#CREATE TASK OBJECTS FOR EACH TASK
	foreach my $item (@{$config->{task}}){
        my $task = App::Task->new(%{$item});
		$self->{tasks}{$task->name} = $task;
	}
}

sub _load_condition_config{
	my $self = shift;
	my $xml = shift;
	return undef if not defined $xml;
	my $config = XMLin($xml, KeyAttr=>{},ForceArray=>['condition','param']);
	#TODO: VALIDATE DATA

	#CREATE CONDITION OBJECTS FOR EACH CONDITION
	foreach my $item (@{$config->{condition}}){
        my $cond = App::Condition->new(%{$item});
		$self->{conditions}{$cond->name} = $cond;
	}
}

sub available_tasks{
    my $self = shift;
    my $result = [];
    # result should show only tasks in the next queue
    # and only those tasks whose conditions are met
    if(defined $self->{current_task}){
        
    } else {
        # list all task options
        foreach my $tr (@{$self->{task_refs}}){
            my $task = $self->{tasks}{$tr->{name}};
            $self->{context}->merge_params($tr->{params});
            next if (not $task->conditions_met($self->{context}, $self->{conditions}));
            my $item = {name=>$task->name,
                        description=>$task->description($self->{context}),
						status=>$tr->{status}
                        };
            push @{$result} , $item;
        }
    }
    return $result;
}

sub execute_task{
	my $self = shift;
	my $task_ref = shift;
    my $task = $self->{tasks}{$task_ref->{name}};
	my $result = $task->execute($self->{context});
	return $result;
}

use overload 
    '""' => \&stringify;

sub stringify {
    my ($self) = shift;
    return ''. __PACKAGE__ . ' - Tasks:' . @{$self->{task_refs}} . ' - Current:' . ($self->{current_task} || 'undef');
}

1;
