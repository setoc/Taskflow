use 5.016;
use strict;
use warnings;
use Getopt::Long qw(GetOptions);
use Log::Log4perl qw(get_logger);
use Carp;
use Data::Dumper;

use App::Workflow::Config qw(load_workflow);

my $LOG_FILE = 'dbupdate_workflow.log';
if(-f $LOG_FILE){
	my $mtime = (stat $LOG_FILE)[9];
	if(time-$mtime>600){#10 minutes
		unlink($LOG_FILE);
	}
}
Log::Log4perl::init('log4perl.conf');
my $log = get_logger();

$log->info("Starting: ",scalar(localtime));

my ($OPT_db_init, $OPT_db_type);
GetOptions('db'=>\$OPT_db_init,
		   'dbtype=s'=>\$OPT_db_type);
$OPT_db_type||='sqlite';
my $DB_FILE = 'dbupdate.db';
if($OPT_db_init){
	#TestDBUtil::create_tables({db_type=>$OPT_db_type,db_file=>$DB_FILE});
	say "Created database and tables ok\n";
	exit();
}

my $wf = load_workflow('cfg/workflow.txt');

while(1){
	
	my $tasks = $wf->next_task;
	my $i = 0;
	foreach my $task_name (@{$tasks}){
		++$i;
		say "$i) $task_name";
	}
	say "q) quit";
	my $full_response = get_response("option? ");
	next unless ($full_response);
	exit 0 if ($full_response eq 'q');
	next if ($full_response <1 || $full_response>$i);
	my $task_name = $tasks->[$full_response-1];
	say "\nselected $task_name\n" ;
	if($wf->execute_task($task_name)){
		say "$task_name executed successfully";
	}else{
		say "$task_name failed to execute";
	}
}

# Generic routine to read a response from the command-line (defaults,
# etc.) Note that return value has whitespace at the end/beginning of
# the routine trimmed.

sub get_response {
    my ( $msg ) = @_;
    print $msg;
    my $response = <STDIN>;
    chomp $response;
    $response =~ s/^\s+//;
    $response =~ s/\s+$//;
    return $response;
}