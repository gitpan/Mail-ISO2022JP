use 5.008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
	'NAME'         => 'Mail::ISO2022JP',
	'VERSION_FROM' => 'ISO2022JP.pm',
	'PREREQ_PM'    => {
		'Encode'       => '1.83',
		'MIME::Base64' => '2.12',
	},
	($] >= 5.005 ? (
		'ABSTRACT' => 'compose ISO-2022-JP encoded email',
		'AUTHOR'   => 'Masanori HATA <lovewing@geocities.co.jp>',
	) : ()),
);
