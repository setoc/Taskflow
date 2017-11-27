use 5.016;
use IO::Compress::Gzip qw/gzip $GzipError/;
use JSON;

#say "HTTP/1.1 200 OK";
#say "Date: Mon, 23 May 2005 22:38:34 GMT";
say "Content-Type: application/json; charset=UTF-8";
#say "Content-Encoding: UTF-8";
say "Content-Encoding: gzip";
say ""; # need newline between header and body
#my $obj = ["this","is","a","test","of","perl"];
my $obj = [{name=>'t1',description=>'t1 description',status=>'none',id=>'asdf'},
           {name=>'t2',description=>'t2 stuff',status=>'none',id=>'s1234'}];
my $str = encode_json($obj);
my $gzip_ok = 0;
my $accept_encoding = $ENV{HTTP_ACCEPT_ENCODING};
if ($accept_encoding && $accept_encoding =~ /\bgzip\b/) {
    $gzip_ok = 1;
}
if($gzip_ok){
    my $zstr;
    gzip \$str, \$zstr;
    print $zstr;
}else {
    print $str;
}

