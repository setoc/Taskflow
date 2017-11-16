package App::Command;
use vars qw($VERSION);
$VERSION = '1.00';
use 5.016;
use strict;
use warnings;
use Carp;
use XML::Simple qw(:strict);
use Log::Log4perl qw(get_logger);
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
	$self->{description} = $options->{description};
	$self->{type} = $options->{type};
	$self->{run} = $options->{run};
	$self->{module} = $options->{module};
	$self->{sub} = $options->{sub};
	$self->{params} = {};
	foreach my $item (@{$options->{param}}){
		$self->{params}{$item->{name}} = $item->{value};
	}
}


1;