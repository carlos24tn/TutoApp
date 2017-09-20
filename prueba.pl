use Data::Dump qw(dump);

@a = (1, [2, 3], {4 => 5});
dump(@a);
print "\nfin";