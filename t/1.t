# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

# this code is written in Unicode/UTF-8 character-set
# including Japanese letters.

use Test::More tests => 4;

BEGIN { use_ok('Mail::ISO2022JP') };

my $mail = Mail::ISO2022JP->new();
isa_ok( $mail, 'Mail::ISO2022JP' );

# compose a mail containing Japanese characters.
$mail->date('Mon, 10 Mar 2003 18:48:06 +0900')->compose(
	'山田 太郎', 'taro@cpan.tld',
	'川畑 花子', 'hanako@cpan.tld',
	'今日は',
	'お元気ですか？　先日はお世話になりました…'
);

# output the composed mail
my $got = $mail->output();

my $expected = <<'EOF';
Date: Mon, 10 Mar 2003 18:48:06 +0900
From: =?ISO-2022-JP?B?
	GyRCOzNFRBsoQiAbJEJCQE86GyhC
	?= <taro@cpan.tld>
To: =?ISO-2022-JP?B?
	GyRCQG5IKhsoQiAbJEIyVjtSGyhC
	?= <hanako@cpan.tld>
Subject: =?ISO-2022-JP?B?
	GyRCOiNGfCRPGyhC
	?=
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

$B$*855$$G$9$+!)!!@hF|$O$*@$OC$K$J$j$^$7$?!D(B
EOF

is ( $got, $expected,
	'composing a ISO-2022-JP encoded mail with MIME Base64 encoded headers');

# compose a long header mail containing Japanese characters.
$mail->date('Mon, 10 Mar 2003 18:48:06 +0900')->compose(
	'山田 太郎', 'taro@cpan.tld',
	'川畑 花子', 'hanako@cpan.tld',
	'今日は。お元気ですか？　先日はお世話になりました。また会えるといいですね。',
	'さて、実はこのたび…'
);

# output the composed mail
$got = $mail->output();

$expected = <<'EOF';
Date: Mon, 10 Mar 2003 18:48:06 +0900
From: =?ISO-2022-JP?B?
	GyRCOzNFRBsoQiAbJEJCQE86GyhC
	?= <taro@cpan.tld>
To: =?ISO-2022-JP?B?
	GyRCQG5IKhsoQiAbJEIyVjtSGyhC
	?= <hanako@cpan.tld>
Subject: =?ISO-2022-JP?B?
	GyRCOiNGfCRPISMkKjg1NSQkRyQ5JCshKSEhQGhGfCRPJCpAJE9DJEskSiRqJF4kNyQ/ISMkXiQ/
	MnEkKCRrJEgkJCQkJEckOSRNISMbKEI=
	?=
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

$B$5$F!"<B$O$3$N$?$S!D(B
EOF

is ( $got, $expected,
	'same as above but with longer MIME Base64 encoded header');
