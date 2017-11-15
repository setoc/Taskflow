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

print Dumper($wf);

foreach my $task_name (@{$wf->task_names}){
	my $task = $wf->task($task_name);
	if($task->can("execute")){
		say "Executing ".$task->name();
		$task->execute();
	}
}


