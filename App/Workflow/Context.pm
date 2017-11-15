package App::Workflow::Context;

use 5.016;
use strict;
use warnings;
use Log::Log4perl qw(get_logger);
use vars qw($VERSION);
$VERSION='1.00';

sub new {
	my ($class, $params) = @_;
	my $log = get_logger();
	$log->info("Instantiating new $class");
	my $self = bless({},$class);
	return $self;
}


sub add{
	my $self = shift;
	my $key = shift;
	my $value = shift;
	return undef if (defined $self->{$key});
	$self->{$key} = $value;
	return $value;
}
sub modify{
	my $self = shift;
	my $key = shift;
	my $value = shift;
	return undef if (not defined $self->{$key});
	$self->{$key} = $value;
	return $value;
}
sub get{
	my $self = shift;
	my $key = shift;
	return $self->{$key}
}
sub remove{
	my $self = shift;
	my $key = shift;
	my $value = $self->{$key};
	delete $self->{$key};
	return $value;
}

1;
