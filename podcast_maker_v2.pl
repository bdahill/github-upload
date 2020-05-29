my @titles;
my @MP3s;
my @args;

open(ARGS_FILE, "custom_files/args_file.txt");
while(<ARGS_FILE>) {
 chop:
  push(@args, $_);
}

my $title = @args[0];
my $link = @args[1];
my $description = @args[2];
my $author = @args[3];
my $link_dir = @args[4];

chop $link;
chop $link_dir;
chop $author;

close(ARGS_FILE);

open(TITLES_FILE, "custom_files/titles.txt");
  while(<TITLES_FILE>){
    chop;
    push(@titles, $_);
  }
close(TITLES_FILE);

open(MP3s_FILE, "custom_files/mp3s.txt");
  while(<MP3s_FILE>){
    chop;
    push(@MP3s, $_);
  }
close(MP3s_FILE);

my $len_mp3s = @MP3s;
my $len_titles = @titles;
if ($len_mp3s != $len_titles) {
  die "NUMBER OF MP3s AND TITLES DOESN'T MATCH\n";
}
my $podcast_len = $len_titles;

##--WRITING THE PODCAST HEADER
open(OUTFILE, ">xml_output/podcast.xml");
print OUTFILE "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n";
print OUTFILE "<rss version=\"0.91\">\n";
print OUTFILE "\n";
print OUTFILE "<channel>\n";
print OUTFILE "<title>$title</title>\n";
print OUTFILE "<link>$link</link>\n";
print OUTFILE "<description>$description</description><itunes:author>$author</itunes:author>\n";
print OUTFILE "<language>en-us</language>\n";
print OUTFILE "\n\n";

##--WRITING THE PODCAST EPISODES
print OUTFILE "<!-- AUDIO FILES -->\n\n";

my $time = 59;
for ($i = 0; $i < $podcast_len; $i++) {
  print OUTFILE "<item>\n";
  print OUTFILE "<title>@titles[$i]</title>\n";
  print OUTFILE "<link>$link_dir@MP3s[$i]</link>\n";
  print OUTFILE "<pubDate>Tue, 27 Nov 2007 10:00:$time -0400</pubDate>\n";
  print OUTFILE "<description>\n";
  print OUTFILE "<p>@titles[$i]</p>\n";
  print OUTFILE "</description>\n";
  print OUTFILE "<itunes:author>$author</itunes:author>\n";
  print OUTFILE "<enclosure url=\"$link_dir@MP3s[$i]\" length=\"437000\" type=\"audio/mpeg\" />\n";
  print OUTFILE "</item>\n";
  print OUTFILE "\n\n";
  
  $time--;
}

##--WRITING THE PODCAST FOOTER
print OUTFILE "\n\n";
print OUTFILE "</channel>\n";
print OUTFILE "</rss>\n";

close(OUTFILE) || die "can't close OUTFILE";

