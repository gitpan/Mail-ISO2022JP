package Mail::ISO2022JP;

use 5.008;
use strict;
use warnings;
use Carp;

our $VERSION = '0.05'; # 2003-03-25

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
	open(MAIL, "| $$self{'sendmail'} -t -i")
		or croak "Could not use sendmail program.\n";
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

sub set {
	my ($self, $entity, $value) = @_;
	$$self{$entity} = $value;
	return $self;
}

sub add_orig {
	my ($self, $addr_spec, $name) = @_;
	
	my $address;
	if ($name) {
		if ( _check_if_contain_japanese($name) ) {
			my $name = encoded_header( decode('utf8', $name) );
			$address = "$name\n <$addr_spec>";
		}
		else {
			if ( length($name) <= 73) {
				$address = "\"$name\"\n <$addr_spec>";
			}
            else {
				my @name = split(/ /, $name);
				my $too_long_word = 0;
				foreach my $piece (@name) {
					if ( length($piece) > 75 ) {
						$too_long_word = 1;
						last;
					}
				}
				if ($too_long_word) {
					$name = encoded_header_ascii($name);
					$address = "$name\n <$addr_spec>";
				}
				else {
					$name = join("\n ", @name);
					$address = "$name\n <$addr_spec>";
				}
			}
		}
	}
	else {
		$address = $addr_spec;
	}
	
	if ($$self{'From'}) {
		$$self{'From'} = "$$self{'From'},\n $address";
	}
	else {
		$$self{'From'} = $address;
    }
	
	return $self;
}

sub sender {
	my ($self, $addr_spec, $name) = @_;
	
	my $address;
	if ($name) {
		if ( _check_if_contain_japanese($name) ) {
			my $name = encoded_header( decode('utf8', $name) );
			$address = "$name\n <$addr_spec>";
		}
		else {
			if ( length($name) <= 73) {
				$address = "\"$name\"\n <$addr_spec>";
			}
            else {
				my @name = split(/ /, $name);
				my $too_long_word = 0;
				foreach my $piece (@name) {
					if ( length($piece) > 75 ) {
						$too_long_word = 1;
						last;
					}
				}
				if ($too_long_word) {
					$name = encoded_header_ascii($name);
					$address = "$name\n <$addr_spec>";
				}
				else {
					$name = join("\n ", @name);
					$address = "$name\n <$addr_spec>";
				}
			}
		}
	}
	else {
		$address = $addr_spec;
	}
	
	$$self{'Sender'} = $address;
	
	return $self;
}


sub add_reply {
	my ($self, $addr_spec, $name) = @_;
	
	my $address;
	if ($name) {
		if ( _check_if_contain_japanese($name) ) {
			my $name = encoded_header( decode('utf8', $name) );
			$address = "$name\n <$addr_spec>";
		}
		else {
			if ( length($name) <= 73) {
				$address = "\"$name\"\n <$addr_spec>";
			}
            else {
				my @name = split(/ /, $name);
				my $too_long_word = 0;
				foreach my $piece (@name) {
					if ( length($piece) > 75 ) {
						$too_long_word = 1;
						last;
					}
				}
				if ($too_long_word) {
					$name = encoded_header_ascii($name);
					$address = "$name\n <$addr_spec>";
				}
				else {
					$name = join("\n ", @name);
					$address = "$name\n <$addr_spec>";
				}
			}
		}
	}
	else {
		$address = $addr_spec;
	}
	
	if ($$self{'Reply'}) {
		$$self{'Reply'} = "$$self{'Reply'},\n $address";
	}
	else {
		$$self{'Reply'} = $address;
    }
	
	return $self;
}

sub add_dest {
	my ($self, $addr_spec, $name) = @_;
	
	my $address;
	if ($name) {
		if ( _check_if_contain_japanese($name) ) {
			my $name = encoded_header( decode('utf8', $name) );
			$address = "$name\n <$addr_spec>";
		}
		else {
			if ( length($name) <= 73) {
				$address = "\"$name\"\n <$addr_spec>";
			}
            else {
				my @name = split(/ /, $name);
				my $too_long_word = 0;
				foreach my $piece (@name) {
					if ( length($piece) > 75 ) {
						$too_long_word = 1;
						last;
					}
				}
				if ($too_long_word) {
					$name = encoded_header_ascii($name);
					$address = "$name\n <$addr_spec>";
				}
				else {
					$name = join("\n ", @name);
					$address = "$name\n <$addr_spec>";
				}
			}
		}
	}
	else {
		$address = $addr_spec;
	}
	
	if ($$self{'To'}) {
		$$self{'To'} = "$$self{'To'},\n $address";
	}
	else {
		$$self{'To'} = $address;
    }
	
	return $self;
}

sub add_dest_cc {
	my ($self, $addr_spec, $name) = @_;
	
	my $address;
	if ($name) {
		if ( _check_if_contain_japanese($name) ) {
			my $name = encoded_header( decode('utf8', $name) );
			$address = "$name\n <$addr_spec>";
		}
		else {
			if ( length($name) <= 73) {
				$address = "\"$name\"\n <$addr_spec>";
			}
            else {
				my @name = split(/ /, $name);
				my $too_long_word = 0;
				foreach my $piece (@name) {
					if ( length($piece) > 75 ) {
						$too_long_word = 1;
						last;
					}
				}
				if ($too_long_word) {
					$name = encoded_header_ascii($name);
					$address = "$name\n <$addr_spec>";
				}
				else {
					$name = join("\n ", @name);
					$address = "$name\n <$addr_spec>";
				}
			}
		}
	}
	else {
		$address = $addr_spec;
	}
	
	if ($$self{'Cc'}) {
		$$self{'Cc'} = "$$self{'Cc'},\n $address";
	}
	else {
		$$self{'Cc'} = $address;
    }
	
	return $self;
}

sub add_dest_bcc {
	my ($self, $addr_spec, $name) = @_;
	
	my $address;
	if ($name) {
		if ( _check_if_contain_japanese($name) ) {
			my $name = encoded_header( decode('utf8', $name) );
			$address = "$name\n <$addr_spec>";
		}
		else {
			if ( length($name) <= 73) {
				$address = "\"$name\"\n <$addr_spec>";
			}
            else {
				my @name = split(/ /, $name);
				my $too_long_word = 0;
				foreach my $piece (@name) {
					if ( length($piece) > 75 ) {
						$too_long_word = 1;
						last;
					}
				}
				if ($too_long_word) {
					$name = encoded_header_ascii($name);
					$address = "$name\n <$addr_spec>";
				}
				else {
					$name = join("\n ", @name);
					$address = "$name\n <$addr_spec>";
				}
			}
		}
	}
	else {
		$address = $addr_spec;
	}
	
	if ($$self{'Bcc'}) {
		$$self{'Bcc'} = "$$self{'Bcc'},\n $address";
	}
	else {
		$$self{'Bcc'} = $address;
    }
	
	return $self;
}

sub _check_if_contain_japanese {
	my ($string) = @_;
	
	$string = decode('utf8', $string);
	$string =~ s/\n//g; # ignore line-break
	return $string =~
		tr/\x01-\x08\x0B\x0C\x0E-\x1F\x7F\x21\x23-\x5B\x5D-\x7E\x20//c;
	# this tr/// checks if there is other than qtext characters or SPACE.
	# from RFC2822:
	# qtext = NO-WS-CTL / %d33 / %d35-91 / %d93-126
	# qcontent = qtext / quoted-pair
	# quoted-string = [CFWS] DQUOTE *([FWS] qcontent) [FWS] DQUOTE [CFWS]
}

sub compose {
	my ($self) = @_;
	
	my $subject = encoded_header( decode('utf8', $$self{'Subject'}) );
	my $body = encode( 'iso-2022-jp', decode('utf8', $$self{'Body'}) );
	$body = encode_base64($body);
	
	if ($$self{'Sender'}) {
		$$self{'Sender'} = "\nSender:\n $$self{'Sender'}";
	}
	else {
		$$self{'Sender'} = '';
	}
	if ($$self{'Reply'}) {
		$$self{'Reply'} = "\nReply-To:\n $$self{'Reply'}";
	}
	else {
		$$self{'Reply'} = '';
	}
	if ($$self{'Cc'}) {
		$$self{'Cc'} = "\nCc:\n $$self{'Cc'}";
	}
	else {
		$$self{'Cc'} = '';
	}
	if ($$self{'Bcc'}) {
		$$self{'Bcc'} = "\nBcc:\n $$self{'Bcc'}";
	}
	else {
		$$self{'Bcc'} = '';
	}
	
	$$self{'mail'} = <<"EOF";
From:
 $$self{'From'}$$self{'Sender'}$$self{'Reply'}
To:
 $$self{'To'}$$self{'Cc'}$$self{'Bcc'}
Subject: 
 $subject
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: base64
X-Mailer: ISO2022JP.pm v$VERSION (Mail::ISO2022JP http://www.cpan.org/)

$body
EOF
	if ($$self{'Date'}) {
		$$self{'mail'} = "Date: $$self{'Date'}\n$$self{'mail'}";
	}
	
	return $self;
}

########################################################################

# RFC2822 describes about a line length
# Max: 998 = 1000 - (CR + LF)
# Rec:  76 =   78 - (CR + LF)
# RFC2047 describes about an encoded-word length
# Max:  75 =   76 - SPACE

sub encoded_header {
	my ($string) = @_;
	
	my @lines = _encoded_word($string);
	
	my $line = join("\n ", @lines);
	return $line;
}

# an encoded-word is composed of
# 'charset', 'encoding', 'encoded-text' and delimiters.
# Hence an encoded-text's max length is:
# 75 - ('charset', 'encoding' and delimiters)
# 
# charset 'ISO-2022-JP' is 11.
# encoding 'B' is 1.
# delimiters '=?', '?', '?' and '?=' is total 6.
# 75 - (11 + 1 + 6) = 57
# It is said that an encoded-text's max length is 57
# when we use ISO-2022-JP B encoding.

sub _encoded_word {
	my ($string) = @_;
	
	my @words = _encoded_text($string);
	
	foreach my $word (@words) {
		$word = "=?ISO-2022-JP?B?$word?=";
	}
	
	return @words;
}

# Through Base64 encoding, a group of 4 ASCII-6bit characters
# is generated by 3 ASCII-8bit pre-encode characters.
# We can get 14 group of encoded 4 ASCII-6bit characters under
# the encoded-text's 57 characters limit.
# Hence, we may handle max 42 ASCII-8bit characters as
# a pre-encode text.
# So we should split a ISO-2022-JP text that
# each splitted piece's length is within 42
# if it is counted as ASCII-8bit characters.

sub _encoded_text {
	my ($string) = @_;
	
	my @text = _split($string);
	
	foreach my $text (@text) {
		$text = encode_base64($text);
		$text =~ s/\n//g;
	}
	
	return @text;
}

sub _split {
	my ($string) = @_;
	
	my @strings;
	while ($string) {
		(my $piece, $string) = _cut_once($string);
		push(@strings, $piece);
	}
	
	return @strings;
}

sub _cut_once {
	my ($string) = @_;
	
	my $whole = encode('iso-2022-jp', $string);
	if ( length($whole) <= 42 ) {
		return $whole;
		last;
	}
	
	my $letters = length($string);
	for (my $i = 1; $i <= $letters; $i++) {
		my $temp = substr($string, 0, $i);
		$temp = encode('iso-2022-jp', $temp);
		if (length($temp) > 42) {
			my $piece = substr($string, 0, $i - 1);
			$piece = encode('iso-2022-jp', $piece);
			my $rest  = substr($string, $i - 1);
			return ($piece, $rest);
			last;
		}
	}
}
########################################################################
sub encoded_header_ascii {
	my ($string) = @_;
	
	my @lines = _encoded_word_q($string);
	
	my $line = join("\n ", @lines);
	return $line;
}

sub _encoded_word_q {
	my ($string) = @_;
	
	my @words = _encoded_text_q($string);
	
	foreach my $word (@words) {
		$word = "=?US-ASCII?Q?$word?=";
	}
	
	return @words;
}

sub _encoded_text_q {
	my ($string) = @_;
	
	my @text = _split_q($string);
	
	foreach my $text (@text) {
		$text = encode_q($text);
	}
	
	return @text;
}

sub _split_q {
	my ($string) = @_;
	
	my @strings;
	while ($string) {
		(my $piece, $string) = _cut_once_q($string);
		push(@strings, $piece);
	}
	
	return @strings;
}

sub _cut_once_q {
	my ($string) = @_;
	
	my $whole = encode_q($string);
	if ( length($whole) <= 60 ) {
		return $string;
		last;
	}
	
	my $letters = length($string);
	for (my $i = 1; $i <= $letters; $i++) {
		my $temp = substr($string, 0, $i);
		$temp = encode_q($temp);
		if (length($temp) > 60) {
			my $piece = substr($string, 0, $i - 1);
			my $rest  = substr($string, $i - 1);
			return ($piece, $rest);
			last;
		}
	}
}

sub encode_q {
	my ($string) = @_;
	
	$string =~
		s/([^\x21\x23-\x3C\x3E\x40-\x5B\x5D\x5E\x60-\x7E])/uc sprintf("=%02x", ord($1))/eg;
	
	return $string;
}


1;
__END__

=head1 NAME

Mail::ISO2022JP - compose ISO-2022-JP encoded email

=head1 SYNOPSIS

 use Mail::ISO2022JP;
 
 $mail = Mail::ISO2022JP->new;
 
 $mail->add_orig('taro@cpan.tld', 'YAMADA, Taro');
 
 # display-name is omitted:
  $mail->add_dest('kaori@cpan.tld');
 # with a display-name in the US-ASCII characters:
  $mail->add_dest('sakura@cpan.tld', 'Sakura HARUNO');
 # with a display-name containing Japanese characters:
  $mail->add_dest('yuri@cpan.tld', 'NAME CONTAINING JAPANESE CHARS');
 
 # mail subject containing Japanese characters:
  $mail->set('Subject', 'SUBJECT CONTAINING JAPANESE CHARS');
 
 # mail body    containing Japanese characters:
  $mail->set('Body'   , 'BODY CONTAINING JAPANESE CHARS');
 
 # compose
  $mail->compose;
 # output the composed mail
  print $mail->output;

=head1 DESCRIPTION

This module is produced mainly for Japanese Perl programmers those who wants to compose an email via Perl extention.

For some reasons, most Japanese internet users have chosen ISO-2022-JP 7bit character encoding for email rather than the other 8bit encodings (eg. EUC-JP, Shift_JIS).

We can use ISO-2022-JP encoded Japanese text as message body safely in an email.

But we should not use ISO-2022-JP encoded Japanese text as a header. We should escape some reserved C<special> characters before composing a header. To enable it, we encode ISO-2022-JP encoded Japanese text with MIME Base64 encoding. Thus MIME Base64 encoded ISO-2022-JP encoded Japanese text is safely using in a mail header.

This module has developed to intend to automate those kinds of operations.

=head1 METHODS

=over

=item new

Creates a new object.

=item add_orig($addr_spec [, $display_name])

This method specifies a originator address (C<From:> header). The $addr_spec must be valid as an C<addr-spec> in the RFC2822 specification. Be careful, an C<addr-spec> doesn't include the surrounding tokens "<" and ">" (angles).

The $display_name is optional value. It must be valid as an C<display-name> in the RFC2822 specification. It can contain Japanese characters and then it will be encoded with 'B' encoding. When it contains only US-ASCII characters, it will not normaly be encoded. But in the rare case, it might be encoded with 'Q' encoding to shorten line length less than 76 characters (excluding CR LF).

You can use repeatedly this method as much as you wish to specify more than one address. And then you B<must> specify the one C<Sender:> header address.

=item add_reply()

It is basically same as C<add_orig()> but specifies a C<Reply-To:> originator header address.

=item sender($addr_spec [, $display_name])

When you specify multiple C<From:> header address, you must specify the C<Sender:> header address. This address must be one address and multiple addresses are not allowed.

=item add_dest($addr_spec [, $display_name])

This method specifies a destination address (C<To:> header). The $addr_spec must be valid as an C<addr-spec> in the RFC2822 specification. Be careful, an C<addr-spec> doesn't include the surrounding tokens "<" and ">" (angles).

The $display_name is optional value. It must be valid as an C<display-name> in the RFC2822 specification. It can contain Japanese characters and then it will be encoded with 'B' encoding. When it contains only US-ASCII characters, it will not normaly be encoded. But in the rare case, it might be encoded with 'Q' encoding to shorten line length less than 76 characters (excluding CR LF).

You can use repeatedly this method as much as you wish to specify more than one address.

=item add_dest_cc(), add_dext_bcc()

These are basically same as C<add_dest()> but specifies a C<Cc:> or C<Bcc:> destination header address.

=item set('Subject', $subject)

Specify the mail subject. $subject can contain Japanese characters. Note that this module runs under Unicode/UTF-8 environment, you should input these data in UTF-8 character encoding.

=item set('Body', $body)

Specify the mail body. $body can contain Japanese characters. Note that this module runs under Unicode/UTF-8 environment, you should input these data in UTF-8 character encoding.

Note: For the purpose to free from the rule that enforce user to line fold, though ISO-2022-JP is a 7bit encoding, body text is encoded again with Base64 internally.

=item set('Date', $date)

Specify the mail origination date. Note that date-time format should be compliant to the format of RFC2822 specification. It is like blow:
     
 Mon, 10 Mar 2003 18:48:06 +0900

Don't forget to quote the string. If you don't specify date, sendmail program may add automatically on posting. 

=item compose

Compose a formed email.

=item post *EXPERIMENTAL*

Posts a mail using sendmail program.
At the default setting, it is supposed that sendmail program's name is `sendmail' under the systems's PATH environmental variable. You can specify exact location with sendmail() method.

=item sendmail($path) *EXPERIMENTAL*

Specifies sendmail location. ex. '/usr/bin/sendmail'

=back

=head1 SEE ALSO

=over

=item RFC2822: L<http://www.ietf.org/rfc/rfc2822.txt> (Mail)

=item RFC2045: L<http://www.ietf.org/rfc/rfc2045.txt> (MIME)

=item RFC2046: L<http://www.ietf.org/rfc/rfc2046.txt> (MIME)

=item RFC2047: L<http://www.ietf.org/rfc/rfc2047.txt> (MIME)

=item Perl Module: L<MIME::Base64>

=item Perl Module: L<Encode>

=back

=head1 NOTES

This module runs under Unicode/UTF-8 environment (then Perl5.8 or later is required), you should input data in UTF-8 character encoding.


=head1 TO DO

To coodinate with the other existing modules about Mail -- to divide and to transfer to any existants of its own functions as much as it could be. (However, it seems not an easy work because of our Japanese charset encoding's double-byte nature and so on...)

=head1 THANKS TO:

=over

=item Koichi TANIGUCHI for the suggestions.

=back

=head1 AUTHOR

Masanori HATA E<lt>lovewing@geocities.co.jpE<gt> (Saitama, JAPAN)

=head1 COPYRIGHT

Copyright (c) 2003 Masanori HATA. All rights reserved.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut
