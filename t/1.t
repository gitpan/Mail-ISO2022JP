# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

# this code is written in Unicode/UTF-8 character-set
# including Japanese letters.

use Test::More tests => 4;

BEGIN { use_ok('Mail::ISO2022JP') };

my $mail = Mail::ISO2022JP->new;
isa_ok( $mail, 'Mail::ISO2022JP' );

# compose a mail containing Japanese characters.
$mail->set('From_addr', 'taro@cpan.tld');
$mail->set('To_addr'  , 'sakura@cpan.tld, yuri@cpan.tld');
# mail subject containing Japanese characters.
$mail->set('Subject'  , '日本語で書かれた題名');
# mail bocy    containing Japanese characters.
$mail->set('Body'     , '日本語で書かれた本文。');
# convert body to ISO-2022-JP (from UTF-8)
$mail->iso2022jp('Body');
# output the composed mail
my $got = $mail->compose;

my $expected = <<'EOF';
From: taro@cpan.tld
To: sakura@cpan.tld, yuri@cpan.tld
Subject: 
 =?ISO-2022-JP?B?GyRCRnxLXDhsJEc9cSQrJGwkP0JqTD4bKEI=?=
 
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

$BF|K\8l$G=q$+$l$?K\J8!#(B
EOF

is ( $got, $expected,
	'composing a ISO-2022-JP encoded mail with MIME Base64 encoded headers');

# compose a long header mail containing Japanese characters.
$mail->set('From_addr', 'taro@cpan.tld');
$mail->set('To_addr'  , 'sakura@cpan.tld, yuri@cpan.tld');
# mail subject containing Japanese characters.
$mail->set('Subject'  , '日本語で書かれた題名。とても長い。長い長いお話。ちゃんとエンコードできるのでしょうか？');
# mail bocy    containing Japanese characters.
$mail->set('Body'     , '日本語で書かれた本文。');
# convert body to ISO-2022-JP (from UTF-8)
$mail->iso2022jp('Body');
# output the composed mail
my $got = $mail->compose;

$expected = <<'EOF';
From: taro@cpan.tld
To: sakura@cpan.tld, yuri@cpan.tld
Subject: 
 =?ISO-2022-JP?B?GyRCRnxLXDhsJEc9cSQrJGwkP0JqTD4hIyRIJEYkYkQ5JCQhI0Q5GyhC?= 
 =?ISO-2022-JP?B?GyRCJCREOSQkJCpPQyEjJEEkYyRzJEglKCVzJTMhPCVJJEckLSRrGyhC?= 
 =?ISO-2022-JP?B?GyRCJE4kRyQ3JGckJiQrISkbKEI=?=
 
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

$BF|K\8l$G=q$+$l$?K\J8!#(B
EOF

is ( $got, $expected,
	'same as above but with longer MIME Base64 encoded header');
