package App::Context;
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
	# context is just a hash array; it needs to be a class so it can be passed to functions and type-checked
	# the keys should be case-insensitive, which means lowercase all keys and keep a mapping between original and lowercase
	$self->{key_map} = {};
	$self->{items} = {};
	$self->clear_error(); # error information set by callees for callers inspection
}

sub keys{
	my $self = shift;
	return values %{$self->{key_map}};
}

sub values{
	my $self = shift;
	return values %{$self->{items}};
}

sub item{
	my $self = shift;
	my $key = shift;
	my $value = shift;
	# add and modify and return values
	if(defined $value){
		$self->{key_map}{lc $key} = $key if (not defined $self->{key_map}{lc $key});
		$self->{items}{lc $key} = $value;
	}
	return $self->{items}{lc $key};
}

sub delete{
	my $self = shift;
	my $key = shift;
	my $oldkey = $self->{key_map}{lc $key};
	my $oldval = $self->{items}{lc $key};
	delete $self->{key_map}{lc $key};
	delete $self->{items}{lc $key};
	return ($oldkey,$oldval);
}

# TODO: merging params should be localized by pushing changes onto a stack popping changes off the stack

sub merge_params{
	my $self = shift;
	my $params = shift; # {x=>y,i=>j,...}
	
	foreach my $key (CORE::keys %{$params}){
		$self->{key_map}{lc $key} = $key;
		$self->{items}{lc $key} = $params->{$key};
	}
	return $self;
}

sub expand{
	my $self = shift;
	my $text = shift;
	# this is a helper function
	$text =~ s/%(\w+)%/
					exists $self->{items}{lc $1} ? $self->{items}{lc $1} : '???'
					/eg;
	return $text;
}

sub set_error{
	my $self = shift;
	my $err_description = shift;
	$self->{error}{description} = $err_description if defined $err_description;
}
sub get_error{
	my $self = shift;
	return $self->{error}{description};
}
sub clear_error{
	my $self = shift;
	$self->{error} = {};
	$self->{error}{description} = "";
}

use overload 
    '""' => \&stringify;

sub stringify {
    my ($self) = shift;
    return ''. __PACKAGE__ . ' - Params:' . %{$self->{items}};
}

1;