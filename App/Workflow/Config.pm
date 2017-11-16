package App::Workflow::Config;

use 5.010;
use strict;
use warnings;
use vars qw($VERSION);
$VERSION='1.00';

use Exporter qw (import);
our @EXPORT_OK=qw(load_workflow);

use Carp;
use App::Workflow;
use App::Workflow::Task;
use App::Workflow::Condition;

use Data::Dumper;

sub load_workflow{
	my $filename = shift;
	croak "file doesn't exist: $filename" if (not -f $filename);
	open(my $FIN,'<',$filename) or croak "couldn't open file $filename: $!";
	my @lines = <$FIN>;
	close $FIN;
	chomp @lines;
	
	return _process_lines(\@lines);
}

sub _process_lines{
	my $lines = shift;
	my $wf = undef;
	my $current_obj = undef;
	my $line_num = 0;
	foreach my $line (@{$lines}){
		++$line_num;
		#say "$line_num: $line";
		$line =~ s/#.*//; # strip off comments
		if($line =~ /^workflow/){
			croak "$line not expected at this time" if(defined $current_obj);
			$current_obj = $wf = App::Workflow->new();
		}elsif($line=~/^task/){
			croak "$line not expected at this time" if(not defined $wf);
			$wf->add($current_obj) if (defined $current_obj);
			$current_obj = App::Workflow::Task->new();
		}elsif($line=~/^condition/){
			croak "$line not expected at this time" if(not defined $wf);
			$wf->add($current_obj) if (defined $current_obj);
			$current_obj = App::Workflow::Condition->new();
		}elsif($line=~/^\sname/){
			my ($key,@val) = split(/[=;]/,$line);
			$current_obj->name($val[0]);
		}elsif($line=~/^\sclass/){
			my ($key,@val) = split(/[=;]/,$line);
			$current_obj->class($val[0]);
		}elsif($line=~/^\scondition/){
			my ($key,@val) = split(/[=;]/,$line);
			foreach my $v (@val){
				my $condition = $wf->condition($v);
				croak "condtion must be defined before task : $v , $current_obj->name" if (not defined $condition);
				say $condition;
				$current_obj->add_condition($condition);
			}
		}elsif($line=~/^\snext/){
			my ($key,@val) = split(/[=;]/,$line);
			foreach my $v (@val){
				$current_obj->add_next($v);
			}
		}elsif($line=~/^\sparams/){
			my $key,@val) = split(/[=;]/,$line);
			foreach my $v (@val){
				$current_obj->add_params($v);
			}
		}elsif($line=~// or $line=~/^\s*$/){
			#ignore blank line
		}else{
			# line has unknown data
			carp "line not processed: $line";
		}
	}
	$wf->add($current_obj) if (defined $current_obj); # get last object
	# need to re-evaluate condition strings to condition objects in task objects
	
	return $wf;
}

=pod

=head1 NAME

Name here

=head1 SYNOPSIS

Synopsis here

=head1 DESCRIPTION

Description here

=head2 Methods

=over 12

=item C<result = function ( arguments ) # exceptions>

Returns result based on arguments. Throws these exceptions.

=item C<do_something($with_stuff)>

self explainatory

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