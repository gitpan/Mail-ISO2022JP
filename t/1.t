# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

# this code is written in Unicode/UTF-8 character-set
# including Japanese letters.

use strict;
use warnings;

use Test::More tests => 6;

BEGIN { use_ok('Mail::ISO2022JP') };

my $mail = Mail::ISO2022JP->new;
isa_ok( $mail, 'Mail::ISO2022JP' );

# compose a mail containing Japanese characters.
$mail->set('Date', 'Thu, 20 Mar 2003 15:21:18 +0900');
$mail->add_orig('taro@cpan.tld', 'YAMADA, Taro');

# display-name is omitted:
 $mail->add_dest('kaori@cpan.tld');
# with a display-name in the US-ASCII characters:
 $mail->add_dest('sakura@cpan.tld', 'Sakura HARUNO');
# with a display-name containing Japanese characters:
 $mail->add_dest('yuri@cpan.tld', '白百合ゆり');

# mail subject containing Japanese characters.
$mail->set('Subject', '日本語で書かれた題名');
# mail body    containing Japanese characters.
$mail->set('Body'   , '日本語で書かれた本文。');

# output the composed mail
$mail->compose;
my $got = $mail->output;

my $expected = <<'EOF';
Date: Thu, 20 Mar 2003 15:21:18 +0900
From:
 "YAMADA, Taro"
 <taro@cpan.tld>
To:
 kaori@cpan.tld,
 "Sakura HARUNO"
 <sakura@cpan.tld>,
 =?ISO-2022-JP?B?GyRCR3JJNDlnJGYkahsoQg==?=
 <yuri@cpan.tld>
Subject: 
 =?ISO-2022-JP?B?GyRCRnxLXDhsJEc9cSQrJGwkP0JqTD4bKEI=?=
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: base64
X-Mailer: ISO2022JP.pm v0.05_01 (Mail::ISO2022JP http://www.cpan.org/)

GyRCRnxLXDhsJEc9cSQrJGwkP0tcSjghIxsoQg==

EOF

is ( $got, $expected,
	'composing a ISO-2022-JP encoded mail with some encoded headers');

########################################################################
# compose a long subject and body containing Japanese characters.
my $mail_2 = Mail::ISO2022JP->new;
$mail_2->set('Date', 'Thu, 20 Mar 2003 15:21:18 +0900');
$mail_2->add_orig('taro@cpan.tld', 'YAMADA, Taro');

# display-name is omitted:
 $mail_2->add_dest('kaori@cpan.tld');
# with a display-name in the US-ASCII characters:
 $mail_2->add_dest('sakura@cpan.tld', 'Sakura HARUNO');
# with a display-name containing Japanese characters:
 $mail_2->add_dest('yuri@cpan.tld', '白百合ゆり');

# mail subject containing Japanese characters.
$mail_2->set('Subject', '日本語で書かれた題名。とても長い。長い長いお話。ちゃんとエンコードできるのでしょうか？');
# mail body    containing Japanese characters.
$mail_2->set('Body', '日本語で書かれた本文。とても長い。長い長いお話。ちゃんとエンコードできるのでしょうか？');
# output the composed mail
$mail_2->compose;
$got = $mail_2->output;

$expected = <<'EOF';
Date: Thu, 20 Mar 2003 15:21:18 +0900
From:
 "YAMADA, Taro"
 <taro@cpan.tld>
To:
 kaori@cpan.tld,
 "Sakura HARUNO"
 <sakura@cpan.tld>,
 =?ISO-2022-JP?B?GyRCR3JJNDlnJGYkahsoQg==?=
 <yuri@cpan.tld>
Subject: 
 =?ISO-2022-JP?B?GyRCRnxLXDhsJEc9cSQrJGwkP0JqTD4hIyRIJEYkYkQ5JCQhI0Q5GyhC?=
 =?ISO-2022-JP?B?GyRCJCREOSQkJCpPQyEjJEEkYyRzJEglKCVzJTMhPCVJJEckLSRrGyhC?=
 =?ISO-2022-JP?B?GyRCJE4kRyQ3JGckJiQrISkbKEI=?=
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: base64
X-Mailer: ISO2022JP.pm v0.05_01 (Mail::ISO2022JP http://www.cpan.org/)

GyRCRnxLXDhsJEc9cSQrJGwkP0tcSjghIyRIJEYkYkQ5JCQhI0Q5JCREOSQkJCpPQyEjJEEkYyRz
JEglKCVzJTMhPCVJJEckLSRrJE4kRyQ3JGckJiQrISkbKEI=

EOF

is ( $got, $expected,
	'same as above but with longer MIME Base64 encoded subject and body');

########################################################################
# compose a long destination header containing Japanese characters.
my $mail_3 = Mail::ISO2022JP->new;
$mail_3->set('Date', 'Thu, 20 Mar 2003 15:21:18 +0900');
$mail_3->add_orig('taro@cpan.tld', 'YAMADA, Taro');

# with a display-name in the US-ASCII characters:
 $mail_3->add_dest('kaori@cpan.tld', 'RARARARARARARARARARARARARARARARARARARARA RARARARARARARARARARARARARARARARARARARARA');
# with a display-name in the US-ASCII characters:
 $mail_3->add_dest('sakura@cpan.tld', 'RARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARA');
# with a display-name containing Japanese characters:
 $mail_3->add_dest('yuri@cpan.tld', '日本語で書かれた名前。とても長い。長い長いお話。ちゃんとエンコードできるのでしょうか？');

# mail subject containing Japanese characters.
$mail_3->set('Subject', '日本語で書かれた題名。とても長い。長い長いお話。ちゃんとエンコードできるのでしょうか？');
# mail body    containing Japanese characters.
$mail_3->set('Body', '日本語で書かれた本文。とても長い。長い長いお話。ちゃんとエンコードできるのでしょうか？');
# output the composed mail
$mail_3->compose;
$got = $mail_3->output;

$expected = <<'EOF';
Date: Thu, 20 Mar 2003 15:21:18 +0900
From:
 "YAMADA, Taro"
 <taro@cpan.tld>
To:
 RARARARARARARARARARARARARARARARARARARARA
 RARARARARARARARARARARARARARARARARARARARA
 <kaori@cpan.tld>,
 =?US-ASCII?Q?RARARARARARARARARARARARARARARARARARARARARARARARARARARARARARA?=
 =?US-ASCII?Q?RARARARARARARARARARA?=
 <sakura@cpan.tld>,
 =?ISO-2022-JP?B?GyRCRnxLXDhsJEc9cSQrJGwkP0w+QTAhIyRIJEYkYkQ5JCQhI0Q5GyhC?=
 =?ISO-2022-JP?B?GyRCJCREOSQkJCpPQyEjJEEkYyRzJEglKCVzJTMhPCVJJEckLSRrGyhC?=
 =?ISO-2022-JP?B?GyRCJE4kRyQ3JGckJiQrISkbKEI=?=
 <yuri@cpan.tld>
Subject: 
 =?ISO-2022-JP?B?GyRCRnxLXDhsJEc9cSQrJGwkP0JqTD4hIyRIJEYkYkQ5JCQhI0Q5GyhC?=
 =?ISO-2022-JP?B?GyRCJCREOSQkJCpPQyEjJEEkYyRzJEglKCVzJTMhPCVJJEckLSRrGyhC?=
 =?ISO-2022-JP?B?GyRCJE4kRyQ3JGckJiQrISkbKEI=?=
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: base64
X-Mailer: ISO2022JP.pm v0.05_01 (Mail::ISO2022JP http://www.cpan.org/)

GyRCRnxLXDhsJEc9cSQrJGwkP0tcSjghIyRIJEYkYkQ5JCQhI0Q5JCREOSQkJCpPQyEjJEEkYyRz
JEglKCVzJTMhPCVJJEckLSRrJE4kRyQ3JGckJiQrISkbKEI=

EOF

is ( $got, $expected,
	'same as above but with longer encoded display-name of address');

########################################################################
# compose a long various header containing Japanese characters.
my $mail_4 = Mail::ISO2022JP->new;
$mail_4->set('Date', 'Thu, 20 Mar 2003 15:21:18 +0900');
$mail_4->add_orig('taro@cpan.tld', 'YAMADA, Taro');
$mail_4->add_orig('ken@cpan.tld');
$mail_4->add_orig('masaru@cpan.tld', '勝');
$mail_4->sender('taka@cpan.tld', 'チャンピオン鷹');
$mail_4->add_reply('taro@cpan-jp.tld', 'YAMADA, Taro');
$mail_4->add_reply('ken@cpan-jp.tld');
$mail_4->add_reply('masaru@cpan-jp.tld', '勝');

$mail_4->add_dest('kaori@cpan.tld', 'RARARARARARARARARARARARARARARARARARARARA RARARARARARARARARARARARARARARARARARARARA');
$mail_4->add_dest('sakura@cpan.tld', 'RARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARA');
$mail_4->add_dest('yuri@cpan.tld', '日本語で書かれた名前。とても長い。長い長いお話。ちゃんとエンコードできるのでしょうか？');
$mail_4->add_dest_cc('kaori@cpan-jp.tld', 'RARARARARARARARARARARARARARARARARARARARA RARARARARARARARARARARARARARARARARARARARA');
$mail_4->add_dest_cc('sakura@cpan-jp.tld', 'RARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARA');
$mail_4->add_dest_cc('yuri@cpan-jp.tld', '日本語で書かれた名前。とても長い。長い長いお話。ちゃんとエンコードできるのでしょうか？');
$mail_4->add_dest_bcc('kaori@cpan-saitama.tld', 'RARARARARARARARARARARARARARARARARARARARA RARARARARARARARARARARARARARARARARARARARA');
$mail_4->add_dest_bcc('sakura@cpan-saitama.tld', 'RARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARA');
$mail_4->add_dest_bcc('yuri@cpan-saitama.tld', '日本語で書かれた名前。とても長い。長い長いお話。ちゃんとエンコードできるのでしょうか？');

# mail subject containing Japanese characters.
$mail_4->set('Subject', '日本語で書かれた題名。とても長い。長い長いお話。ちゃんとエンコードできるのでしょうか？');
# mail body    containing Japanese characters.
$mail_4->set('Body', '日本語で書かれた本文。とても長い。長い長いお話。ちゃんとエンコードできるのでしょうか？');
# output the composed mail
$mail_4->compose;
$got = $mail_4->output;

$expected = <<'EOF';
Date: Thu, 20 Mar 2003 15:21:18 +0900
From:
 "YAMADA, Taro"
 <taro@cpan.tld>,
 ken@cpan.tld,
 =?ISO-2022-JP?B?GyRCPiEbKEI=?=
 <masaru@cpan.tld>
Sender:
 =?ISO-2022-JP?B?GyRCJUElYyVzJVQlKiVzQmsbKEI=?=
 <taka@cpan.tld>
Reply-To:
 "YAMADA, Taro"
 <taro@cpan-jp.tld>,
 ken@cpan-jp.tld,
 =?ISO-2022-JP?B?GyRCPiEbKEI=?=
 <masaru@cpan-jp.tld>
To:
 RARARARARARARARARARARARARARARARARARARARA
 RARARARARARARARARARARARARARARARARARARARA
 <kaori@cpan.tld>,
 =?US-ASCII?Q?RARARARARARARARARARARARARARARARARARARARARARARARARARARARARARA?=
 =?US-ASCII?Q?RARARARARARARARARARA?=
 <sakura@cpan.tld>,
 =?ISO-2022-JP?B?GyRCRnxLXDhsJEc9cSQrJGwkP0w+QTAhIyRIJEYkYkQ5JCQhI0Q5GyhC?=
 =?ISO-2022-JP?B?GyRCJCREOSQkJCpPQyEjJEEkYyRzJEglKCVzJTMhPCVJJEckLSRrGyhC?=
 =?ISO-2022-JP?B?GyRCJE4kRyQ3JGckJiQrISkbKEI=?=
 <yuri@cpan.tld>
Cc:
 RARARARARARARARARARARARARARARARARARARARA
 RARARARARARARARARARARARARARARARARARARARA
 <kaori@cpan-jp.tld>,
 =?US-ASCII?Q?RARARARARARARARARARARARARARARARARARARARARARARARARARARARARARA?=
 =?US-ASCII?Q?RARARARARARARARARARA?=
 <sakura@cpan-jp.tld>,
 =?ISO-2022-JP?B?GyRCRnxLXDhsJEc9cSQrJGwkP0w+QTAhIyRIJEYkYkQ5JCQhI0Q5GyhC?=
 =?ISO-2022-JP?B?GyRCJCREOSQkJCpPQyEjJEEkYyRzJEglKCVzJTMhPCVJJEckLSRrGyhC?=
 =?ISO-2022-JP?B?GyRCJE4kRyQ3JGckJiQrISkbKEI=?=
 <yuri@cpan-jp.tld>
Bcc:
 RARARARARARARARARARARARARARARARARARARARA
 RARARARARARARARARARARARARARARARARARARARA
 <kaori@cpan-saitama.tld>,
 =?US-ASCII?Q?RARARARARARARARARARARARARARARARARARARARARARARARARARARARARARA?=
 =?US-ASCII?Q?RARARARARARARARARARA?=
 <sakura@cpan-saitama.tld>,
 =?ISO-2022-JP?B?GyRCRnxLXDhsJEc9cSQrJGwkP0w+QTAhIyRIJEYkYkQ5JCQhI0Q5GyhC?=
 =?ISO-2022-JP?B?GyRCJCREOSQkJCpPQyEjJEEkYyRzJEglKCVzJTMhPCVJJEckLSRrGyhC?=
 =?ISO-2022-JP?B?GyRCJE4kRyQ3JGckJiQrISkbKEI=?=
 <yuri@cpan-saitama.tld>
Subject: 
 =?ISO-2022-JP?B?GyRCRnxLXDhsJEc9cSQrJGwkP0JqTD4hIyRIJEYkYkQ5JCQhI0Q5GyhC?=
 =?ISO-2022-JP?B?GyRCJCREOSQkJCpPQyEjJEEkYyRzJEglKCVzJTMhPCVJJEckLSRrGyhC?=
 =?ISO-2022-JP?B?GyRCJE4kRyQ3JGckJiQrISkbKEI=?=
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: base64
X-Mailer: ISO2022JP.pm v0.05_01 (Mail::ISO2022JP http://www.cpan.org/)

GyRCRnxLXDhsJEc9cSQrJGwkP0tcSjghIyRIJEYkYkQ5JCQhI0Q5JCREOSQkJCpPQyEjJEEkYyRz
JEglKCVzJTMhPCVJJEckLSRrJE4kRyQ3JGckJiQrISkbKEI=

EOF

is ( $got, $expected,
	'same as above but with other various headers');
