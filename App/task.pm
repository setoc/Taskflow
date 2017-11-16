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
    $self->{cmds} = []; # ordered list of steps to process
	print Dumper($options);
	foreach my $cmd_item (@{$options->{cmd}}){
		my $cmd = App::Command->new(%{$cmd_item});
		push @{$self->{cmds}} , $cmd;
	}
}

1;