package App::Custom::Conditions;
use vars qw($VERSION);
$VERSION = '1.00';
use 5.016;
use strict;
use warnings;
use Carp;
use XML::Simple qw(:strict);
use Log::Log4perl qw(get_logger);
use Data::Dumper;


sub is_archive_current{
	my $context = shift;
	my $archive_name = $context->expand("%HABITAT_CASES%\\ets_%OPCO%_scada.zip");

	return 0 if(not -f $archive_name);
	my $epoch_time = (stat($archive_name))[9];
	#QUESTION: get user verification via callback?
	#QUESTION: test against user entered time?
	#QUESTION: default to within last hour or use user entered time-span? DING-DING-DING
	my $threshold = $context->item("old_archive_threshold");
	my $check_time = time - $threshold;
	if($epoch_time > $check_time){
		return 1;
	}
	return 0;
}

sub is_the_answer_42{
	my $context = shift;

	return 1;
}

sub is_host_standby{
	my $context = shift;

	return 0;
}


1;