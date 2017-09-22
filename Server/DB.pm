sub Connect(){
        use DBI;
        use strict;
        my $dbname = "nombre de la base de datos";
        our $dbh = DBI->connect("dbi:Pg:dbname=$dbname", "pgsql", "");
}

sub Query($){
        use Data::Dump qw(dump);
        use XML::Simple;

        my ($SQLsentence) = (@_);

        my $lenth=0;
        $sqlXML = XMLin('<xml/>',ForceArray=>1);
        open(my $fh,'>>', '/var/log/registro.log');   #registro de actividad-------->>>>>>><<<<<<<
        print $fh  'DB.pm: '.$SQLsentence."\n";
        close $fh;
        my $sth = $dbh->prepare($SQLsentence);
        $sth->execute();

        my $fields_names = $sth->{"NAME"};
        my $num_fields = $sth->{"NUM_OF_FIELDS"};

        while (my @row = $sth->fetchrow_array){

                for(my $i = 0; $i < @$fields_names; $i++){
                        $sqlXML->{data}{reg}[$length]{$fields_names->[$i]}[0] = $row[$i];
                }
                $length++;
        }
        $sqlXML->{num_fields}[0] = $num_fields;
        $sqlXML->{columns}{name} = $fields_names;
        $sqlXML->{length}[0] = $length;
        $sqlXML->{error}[0] = $sth->state;
        $sth->finish;
        $length = 0;
        return $sqlXML;
}

sub Do($){
        use XML::Simple;
        use Data::Dump qw(dump);
        my ($SQLsentence) = (@_);
        open(my $fh,'>>', '/var/log/registro.log');   #registro de actividad-------->>>>>>><<<<<<<
        print $fh  'DB.pm: '.$SQLsentence."\n";
        close $fh;
        $row = $dbh->do($SQLsentence);
        $sqlXML = XMLin('<xml/>',ForceArray=>1);
        $sqlXML->{do}[0] = $row;
        # 7 = error
        if ($dbh->err() eq 7){
                $sqlXML->{type}[0]='BAD';
                return $sqlXML;
                exit();
        }

        $sqlXML->{type}[0]='OK';
        return $sqlXML;
}

sub Disconnect(){
        $dbh->disconnect;
}

return 1;