package App::Command;
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
	$self->{description} = $options->{description}; # displayed in user interface
	$self->{type} = $options->{type}; # system or perl
	$self->{run} = $options->{run}; # system command
	$self->{expect} = $options->{expect}; # expected return from system command
	$self->{module} = $options->{module}; # perl module
	$self->{sub} = $options->{sub}; # sub name in perl module; sub should receive context and params; sub should return success or failure
	$self->{params} = {}; # params for perl sub
	foreach my $item (@{$options->{param}}){
		$self->{params}{$item->{name}} = $item->{value};
	}
}

sub execute{
	my $self = shift;
	my $context = shift;
	if(defined $context){
		if($context->isa('App::Context')){
			$context->merge_params($self->{params});
			if($self->{type} eq 'perl'){
				my $module = $self->{module};
				my $sub = $self->{sub};
				load $module,$sub;
				my $code = "$module"->can($sub);
				my $result = 0;
				if($code){
					$result = $code->($context)
				}else{
					$context->set_error("$module can't $sub");
				}
				return $result;
			}elsif($self->{type} eq 'system'){
				my $cmd = $self->{run};
				#TODO:run system cmd, log results, and return success or failure
				return 0;
			}else{
				#TODO:ERROR
				return 0;
			}
		}
	}
}

use overload 
    '""' => \&stringify;

sub stringify {
    my ($self) = shift;
    return ''. __PACKAGE__ . ' - Type:' . $self->{type} . ' - ' . $self->{description};
}

1;