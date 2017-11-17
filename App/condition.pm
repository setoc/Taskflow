package App::Condition;
use vars qw($VERSION);
$VERSION = '1.00';
use 5.016;
use strict;
use warnings;
use Carp;
use XML::Simple qw(:strict);
use Log::Log4perl qw(get_logger);
use Module::Load qw(load);
use Data::Dumper;


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
	$self->{module} = $options->{module};
	$self->{params} = {}; # {x=>y,i=>j,...}
	foreach my $item (@{$options->{param}}){
		$self->{params}{$item->{name}} = $item->{value};
	}
}

sub name{
	my $self = shift;
	my $new_val = shift;
	$self->{name} = $new_val if (defined $new_val);
	return $self->{name};
}

sub test{
	my $self = shift;
	my $context = shift;
	if(defined $context){
		if($context->isa('App::Context')){
			$context->merge_params($self->{params});
			my $module = $self->{module};
			my $sub = $self->{name};
			load $module,$sub;
			my $code = "$module"->can($sub);
			my $result = $code->($context);
			return $result;
		}
	}
	return 0;
}


1;