package Mail::ISO2022JP;

use 5.008;
use strict;
use warnings;

our $VERSION = '0.02'; # 2003-03-10

use Carp;

use Encode;
use MIME::Base64;

sub new {
	my $class = shift;
	my $self = {};
	bless $self, $class;
	$$self{'sendmail'} = 'sendmail';
	return $self;
}

sub sendmail {
	my $self = shift;
	$$self{'sendmail'} = shift;
	return $self;
}

sub post {
	my ($self) = @_;
	open(MAIL, "| $$self{'sendmail'} -t -i") or croak "Could not use sendmail program.\n";
	print MAIL $$self{'mail'};
	close MAIL;
	return $self;
}

sub output {
	my ($self) = @_;
	return $$self{'mail'};
}

sub date {
	my $self = shift;
	$$self{'time'} = shift;
	return $self;
}

sub compose {
	my ($self, $sender_name, $sender_address, $recipient_name, $recipient_address, $subject, $message) = @_;
	
	# Encode (from UTF-8) to ISO-2022-JP
	foreach my $entity ($recipient_name, $sender_name, $subject, $message) {
		$entity = encode( 'iso-2022-jp', decode('utf8', $entity) );
	}
	
	# Encode with MIME-Base64 method
	foreach my $entity ($recipient_name, $sender_name, $subject) {
		$entity = '=?ISO-2022-JP?B?' . encode_base64($entity) . '?=';
		$entity =~ s/\n//;
	}
	
	$$self{'mail'} = <<"EOF";
From: $sender_name <$sender_address>
To: $recipient_name <$recipient_address>
Subject: $subject
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

$message
EOF
	if ($$self{'time'}) {
		$$self{'mail'} = "Date: $$self{'time'}\n$$self{'mail'}";
	}
	return $self;
}

1;
__END__

=head1 NAME

Mail::ISO2022JP - compose ISO-2022-JP encoded email

=head1 SYNOPSIS

  use Mail::ISO2022JP;
  
  $mail = Mail::ISO2022JP->new();
  # compose a mail containing Japanese letters.
  $mail->compose(
    'Yamada Taro', 'taro@cpan.tld',
    'Kawabata Hanako', 'hanako@cpan.tld',
    'Kon-nichi-ha',
    'Ogenki desuka? Senjitsu ha Osewani nari mashita...'
  );
  # output the composed mail
  print $mail->output();

=head1 DESCRIPTION

This module is mainly for Japanese perl programmers. Because of its 7bit/US-ASCII character based regulation, an internet mail is required to compose through some encoding process when it includes non-7bit/US-ASCII characters. ISO-2022-JP is one of Japanese character encoding, which is usually used among Japanese people for the mail encoding. For ISO-2022-JP is 7bit encoding, to use it in mail message body has no problem. But it still has problem to use ISO-2022-JP in mail headers, since mail headers should be expressed only in US-ASCII characters. Then we should encode ISO-2022-JP header data (ex. sender name, recipient name, subject) again with MIME Base64 method. This module automates those kinds of operations.

=head1 METHODS

=over

=item new()

Creates a new object.

=item compose($sender_name, $sender_address, $recipient_name, $recipient_address, $subject, $message)

$sender_address and $recipient_address should be valid as email address. $sender_name, $recipient_name, $subject, $message can contain Japanese characters. Note that this module runs under Unicode/UTF-8 environment, you should input these data in UTF-8 character encoding.

=item date($date_string)

Specifies mail origination date. This method must used before compose() method when you want to specify this value. Of course, date format should be compliant to the format of RFC2822 specification. It is like blow:
     
 Mon, 10 Mar 2003 18:48:06 +0900

Origination date is not a essential information for email (sendmail program will add automatically on posting). Don't forget to quote the string.

=item output()

Outputs already composed mail data.

=item post() *EXPERIMENTAL*

Posts a mail using sendmail program.
At the default setting, it is supposed that sendmail program's name is `sendmail' under the systems's PATH environmental variable. You can specify exact location with sendmail() method.

=item sendmail($path) *EXPERIMENTAL*

Specifies sendmail location. ex. '/usr/bin/sendmail'

=back

=head1 SEE ALSO

=over

=item L<Encode>

=item L<MIME::Base64>

=back

=head1 NOTES

This module runs under Unicode/UTF-8 environment (then Perl5.8 or later is required), you should input data in UTF-8 character encoding.

=head1 AUTHOR

Masanori HATA E<lt>lovewing@geocities.co.jpE<gt> (Saitama, JAPAN)

=head1 COPYRIGHT

Copyright (c) 2003 Masanori HATA. All rights reserved.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut
