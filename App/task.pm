package App::Task;
use vars qw($VERSION);
$VERSION = '1.00';
use 5.016;
use strict;
use warnings;
use Carp;
use XML::Simple qw(:strict);
use Log::Log4perl qw(get_logger);
use Data::Dumper;
use App::Command;
use App::Condition;

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
	$self->{name} = $options->{name};
	$self->{description} = $options->{description};
	$self->{conditions} = []; # conditions that must be met for this task to execute
    $self->{cmds} = []; # ordered list of steps to process
	$self->{next_tasks} = []; # tasks that can logically follow this one
	foreach my $condition_item(@{$options->{condition}}){
		my $condition = App::Condition->new(%{$condition_item});
		push @{$self->{conditions}} , $condition;
	}
	foreach my $cmd_item (@{$options->{cmd}}){
		my $cmd = App::Command->new(%{$cmd_item});
		push @{$self->{cmds}} , $cmd;
	}
	foreach my $next_item(@{$options->{next}}){
		#my $next = {};
		#$next->{name} = $next_item->{name};
		push @{$self->{next_tasks}} , $next_item->{name};
	}
}

sub name{
	my $self = shift;
	my $new_val = shift;
	$self->{name} = $new_val if (defined $new_val);
	return $self->{name};
}

sub description{
	my $self = shift;
	my $option = shift;
	if(defined $option){
		if($option->isa('App::Context')){
			return $option->expand($self->{description}); # expand any variables in description
		}else{
			$self->{description} = $option;
		}
	}
	return $self->{description};
}

sub conditions_met{
	my $self = shift;
	my $option = shift;
	if(defined $option){
		if($option->isa('App::Context')){
			# TODO: test conditions in current context
			return 1;
		}
	}
	return 0;
}

1;