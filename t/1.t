# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

# this code is written in Unicode/UTF-8 character-set
# including Japanese letters.

use Test::More tests => 4;

BEGIN { use_ok('Mail::ISO2022JP') };

my $mail = Mail::ISO2022JP->new;
isa_ok( $mail, 'Mail::ISO2022JP' );

# compose a mail containing Japanese characters.
$mail->set('Date'     , 'Thu, 20 Mar 2003 15:21:18 +0900');
$mail->set('From_addr', 'taro@cpan.tld');
$mail->set('To_addr'  , 'sakura@cpan.tld, yuri@cpan.tld');
# mail subject containing Japanese characters.
$mail->set('Subject'  , '日本語で書かれた題名');
# mail body    containing Japanese characters.
$mail->set('Body'     , '日本語で書かれた本文。');
# output the composed mail
$mail->compose;
my $got = $mail->output;

my $expected = <<'EOF';
Date: Thu, 20 Mar 2003 15:21:18 +0900
From: taro@cpan.tld
To: sakura@cpan.tld, yuri@cpan.tld
Subject: 
 =?ISO-2022-JP?B?GyRCRnxLXDhsJEc9cSQrJGwkP0JqTD4bKEI=?=
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: base64

GyRCRnxLXDhsJEc9cSQrJGwkP0tcSjghIxsoQg==

EOF

is ( $got, $expected,
	'composing a ISO-2022-JP encoded mail with MIME Base64 encoded headers');

# compose a long header mail containing Japanese characters.
$mail->set('Date'     , 'Thu, 20 Mar 2003 15:21:18 +0900');
$mail->set('From_addr', 'taro@cpan.tld');
$mail->set('To_addr'  , 'sakura@cpan.tld, yuri@cpan.tld');
# mail subject containing Japanese characters.
$mail->set('Subject'  , '日本語で書かれた題名。とても長い。長い長いお話。ちゃんとエンコードできるのでしょうか？');
# mail body    containing Japanese characters.
$mail->set('Body'     , '日本語で書かれた本文。とても長い。長い長いお話。ちゃんとエンコードできるのでしょうか？');
# output the composed mail
$mail->compose;
my $got = $mail->output;

$expected = <<'EOF';
Date: Thu, 20 Mar 2003 15:21:18 +0900
From: taro@cpan.tld
To: sakura@cpan.tld, yuri@cpan.tld
Subject: 
 =?ISO-2022-JP?B?GyRCRnxLXDhsJEc9cSQrJGwkP0JqTD4hIyRIJEYkYkQ5JCQhI0Q5GyhC?= 
 =?ISO-2022-JP?B?GyRCJCREOSQkJCpPQyEjJEEkYyRzJEglKCVzJTMhPCVJJEckLSRrGyhC?= 
 =?ISO-2022-JP?B?GyRCJE4kRyQ3JGckJiQrISkbKEI=?=
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: base64

GyRCRnxLXDhsJEc9cSQrJGwkP0tcSjghIyRIJEYkYkQ5JCQhI0Q5JCREOSQkJCpPQyEjJEEkYyRz
JEglKCVzJTMhPCVJJEckLSRrJE4kRyQ3JGckJiQrISkbKEI=

EOF

is ( $got, $expected,
	'same as above but with longer MIME Base64 encoded subject and body');
